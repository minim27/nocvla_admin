-- Urutan produk featured di home katalog. NULL berarti tidak featured.
ALTER TABLE public.m_products ADD COLUMN IF NOT EXISTS featured_sort_order integer;

UPDATE public.m_products p
SET featured_sort_order = r.rn
FROM (
  SELECT id, row_number() OVER (ORDER BY name) - 1 AS rn
  FROM public.m_products
  WHERE is_featured
) r
WHERE r.id = p.id AND p.featured_sort_order IS NULL;
