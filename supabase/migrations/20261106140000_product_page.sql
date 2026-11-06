-- Detail produk di Katalog: material, perawatan, size chart, keterangan warna, dan fitur.
ALTER TABLE public.m_products
  ADD COLUMN IF NOT EXISTS material text,
  ADD COLUMN IF NOT EXISTS care_text text,
  ADD COLUMN IF NOT EXISTS size_chart_url text;

ALTER TABLE public.m_product_color
  ADD COLUMN IF NOT EXISTS description text;

CREATE TABLE IF NOT EXISTS public.m_product_features (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  product_id uuid NOT NULL REFERENCES public.m_products(id) ON DELETE CASCADE,
  icon text,
  title text NOT NULL,
  description text,
  sort_order integer NOT NULL DEFAULT 0,
  created_at timestamp with time zone DEFAULT now() NOT NULL,
  updated_at timestamp with time zone DEFAULT now() NOT NULL
);

ALTER TABLE public.m_product_features ENABLE ROW LEVEL SECURITY;
CREATE POLICY "public read" ON public.m_product_features FOR SELECT TO anon, authenticated USING (true);
CREATE POLICY "admin insert" ON public.m_product_features FOR INSERT TO authenticated WITH CHECK (public.is_admin());
CREATE POLICY "admin update" ON public.m_product_features FOR UPDATE TO authenticated USING (public.is_admin()) WITH CHECK (public.is_admin());
CREATE POLICY "admin delete" ON public.m_product_features FOR DELETE TO authenticated USING (public.is_admin());

-- Isi awal FALLENSERAPH™ mengikuti referensi desain.
UPDATE public.m_products
SET material = coalesce(material, 'Heavyweight Cotton 16s')
WHERE name ILIKE '%FALLENSERAPH%';

INSERT INTO public.m_product_features (product_id, icon, title, description, sort_order)
SELECT p.id, v.icon, v.title, v.description, v.sort_order
FROM public.m_products p
CROSS JOIN (VALUES
  ('layers', 'Heavyweight 16s', 'Cotton tebal di atas 250gsm, jatuh dan tidak menerawang.', 0),
  ('shirt', 'Relaxed fit', 'Potongan oversized untuk ruang gerak saat latihan.', 1),
  ('drop', 'Plastisol print', 'Sablon full plastisol, pekat dan tahan lama.', 2),
  ('collar', 'Ribbed collar', 'Kerah rib elastis yang tetap kuat.', 3)
) AS v (icon, title, description, sort_order)
WHERE p.name ILIKE '%FALLENSERAPH%'
  AND NOT EXISTS (SELECT 1 FROM public.m_product_features f WHERE f.product_id = p.id);
