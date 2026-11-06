-- Pilihan Topik form Kirim pesan mengikuti referensi desain. Selanjutnya diatur dari Master Data → Topik Pesan.
INSERT INTO public.m_contact_topic (name, sort_order) VALUES
  ('Pertanyaan produk', 0),
  ('Status order', 1),
  ('Kerja sama / kolaborasi', 2),
  ('Atlet & affiliate', 3),
  ('Lainnya', 4)
ON CONFLICT (name) DO UPDATE SET sort_order = EXCLUDED.sort_order;
