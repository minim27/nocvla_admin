-- Subtitle singkat produk, tampil di header grup Collection.
ALTER TABLE public.m_products ADD COLUMN IF NOT EXISTS subtitle text;

UPDATE public.m_products SET subtitle = 'Heavyweight cotton 16s, relaxed fit, sablon full plastisol di punggung.'
WHERE name ILIKE '%FALLENSERAPH%' AND subtitle IS NULL;

UPDATE public.m_products SET subtitle = 'Premium elastane 240gsm, full overdeck stitch, rubber screen print. Super stretch dan quick dry.'
WHERE name ILIKE '%ARGOS%' AND subtitle IS NULL;

UPDATE public.m_products SET subtitle = 'Seri pertama VENOM TECH™ dengan artwork simetris penuh di punggung dan bahu.'
WHERE name ILIKE '%Prototype I' AND subtitle IS NULL;
