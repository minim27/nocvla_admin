-- Kategori produk tambahan untuk dropdown admin dan katalog.
INSERT INTO public.m_product_type (name, value, sort_order)
SELECT new_type.name, new_type.value, new_type.sort_order
FROM (VALUES
  ('SWEATPANTS', 'sweatpants', 1),
  ('CARGO PANTS', 'cargo_pants', 2),
  ('SHORT PANTS', 'short_pants', 3),
  ('HOODIE', 'hoodie', 4),
  ('ZIPPER HOODIE', 'zipper_hoodie', 5)
) AS new_type (name, value, sort_order)
WHERE NOT EXISTS (
  SELECT 1 FROM public.m_product_type existing WHERE existing.name = new_type.name
);
