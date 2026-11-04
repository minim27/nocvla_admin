-- Konten Home yang bisa diatur dari Admin: hero, badge, warna titik, dan seri.
ALTER TABLE public.m_banners
  ADD COLUMN IF NOT EXISTS eyebrow text,
  ADD COLUMN IF NOT EXISTS cta_product_id uuid REFERENCES public.m_products(id) ON DELETE SET NULL;

ALTER TABLE public.m_products ADD COLUMN IF NOT EXISTS badge text;
ALTER TABLE public.m_product_color ADD COLUMN IF NOT EXISTS hex text;

CREATE TABLE IF NOT EXISTS public.m_series (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  label text NOT NULL,
  title text NOT NULL,
  description text,
  image_url text,
  product_id uuid REFERENCES public.m_products(id) ON DELETE SET NULL,
  sort_order integer NOT NULL DEFAULT 0,
  is_active boolean NOT NULL DEFAULT true,
  created_at timestamp with time zone DEFAULT now() NOT NULL,
  updated_at timestamp with time zone DEFAULT now() NOT NULL
);

ALTER TABLE public.m_series ENABLE ROW LEVEL SECURITY;
CREATE POLICY "public read" ON public.m_series FOR SELECT TO anon, authenticated USING (true);
CREATE POLICY "admin insert" ON public.m_series FOR INSERT TO authenticated WITH CHECK (public.is_admin());
CREATE POLICY "admin update" ON public.m_series FOR UPDATE TO authenticated USING (public.is_admin()) WITH CHECK (public.is_admin());
CREATE POLICY "admin delete" ON public.m_series FOR DELETE TO authenticated USING (public.is_admin());

-- Isi awal mengikuti referensi desain.
UPDATE public.m_product_color AS c SET hex = v.hex
FROM (VALUES
  ('BLOODVEIL', '#A3241F'), ('CRIMSON RED', '#B3262A'), ('HELL PARADISE', '#C2302A'),
  ('INFERNO DUST', '#D9622B'), ('NIGHT AMETHYST', '#6B4BC4'), ('PURPLE VOID', '#7A3FD1'),
  ('PHANTOM MIST', '#BDB8B2'), ('IRON STEEL', '#8A8D91'), ('HIDDEN BLACK', '#1A1A1A'),
  ('WHITE MISTERY', '#E8E6E3')
) AS v (name, hex)
WHERE upper(c.name) = v.name;

UPDATE public.m_products SET badge = 'NEW DROP' WHERE name ILIKE '%FALLENSERAPH%';

INSERT INTO public.m_banners (image_url, title, description, eyebrow, cta_product_id, start_date, end_date, sort_order, is_active)
SELECT
  (SELECT i.image_url FROM public.m_product_images i
   JOIN public.m_product_color c ON c.id = i.product_color_id
   WHERE c.product_id = p.id AND upper(c.name) = 'BLOODVEIL'
   ORDER BY i.sort_order LIMIT 1),
  E'Built Different.\nTrain Nocvla.',
  'Oversized heavyweight cotton 16s dengan sablon plastisol penuh. Empat warna: Bloodveil, Inferno Dust, Night Amethyst, Phantom Mist.',
  'NEW DROP — FALLENSERAPH™',
  p.id, now(), '2099-12-31', 0, true
FROM public.m_products p
WHERE p.name ILIKE '%FALLENSERAPH%'
LIMIT 1;

INSERT INTO public.m_series (label, title, description, image_url, product_id, sort_order)
SELECT v.label, v.title, v.description,
  (SELECT i.image_url FROM public.m_product_images i
   JOIN public.m_product_color c ON c.id = i.product_color_id
   WHERE c.product_id = p.id AND upper(c.name) = v.color
   ORDER BY i.sort_order LIMIT 1),
  p.id, v.sort_order
FROM (VALUES
  ('OVERSIZE · HEAVYWEIGHT', 'FALLENSERAPH™', '100% heavyweight cotton 16s, relaxed fit, ribbed collar, screen print full plastisol.', '%FALLENSERAPH%', 'NIGHT AMETHYST', 0),
  ('COMPRESSION · ELASTANE', 'VENOM TECH™ ARGOS', 'Premium elastane 240gsm, full overdeck stitch, rubber screen print. Super stretch dan quick dry.', '%ARGOS Long%', 'PURPLE VOID', 1),
  ('COMPRESSION · VENOM TECH™', 'Prototype I', 'Seri pertama VENOM TECH™ dengan artwork simetris penuh di punggung dan bahu.', '%Prototype I', 'HELL PARADISE', 2)
) AS v (label, title, description, pattern, color, sort_order)
JOIN public.m_products p ON p.name ILIKE v.pattern;
