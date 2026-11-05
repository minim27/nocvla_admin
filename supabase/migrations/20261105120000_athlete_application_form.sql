-- Field baru form pendaftaran atlet di Katalog: fokus latihan dan foto diri.
ALTER TABLE public.m_athlete_application
  ADD COLUMN IF NOT EXISTS training_focus character varying,
  ADD COLUMN IF NOT EXISTS photo_path text;

-- Pilihan fokus latihan diatur dari Master Data. Pendaftaran menyimpan salinan namanya.
CREATE TABLE IF NOT EXISTS public.m_training_focus (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL UNIQUE,
  sort_order integer NOT NULL DEFAULT 0,
  is_active boolean NOT NULL DEFAULT true,
  created_at timestamp with time zone DEFAULT now() NOT NULL,
  updated_at timestamp with time zone DEFAULT now() NOT NULL
);

ALTER TABLE public.m_training_focus ENABLE ROW LEVEL SECURITY;
CREATE POLICY "public read" ON public.m_training_focus FOR SELECT TO anon, authenticated USING (true);
CREATE POLICY "admin insert" ON public.m_training_focus FOR INSERT TO authenticated WITH CHECK (public.is_admin());
CREATE POLICY "admin update" ON public.m_training_focus FOR UPDATE TO authenticated USING (public.is_admin()) WITH CHECK (public.is_admin());
CREATE POLICY "admin delete" ON public.m_training_focus FOR DELETE TO authenticated USING (public.is_admin());

-- Isi awal mengikuti referensi desain.
INSERT INTO public.m_training_focus (name) VALUES ('Bodybuilding') ON CONFLICT (name) DO NOTHING;

-- Foto pendaftar bersifat privat: publik hanya bisa mengunggah, admin membaca lewat signed URL.
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES ('applications', 'applications', false, 5242880, ARRAY['image/jpeg', 'image/png'])
ON CONFLICT (id) DO NOTHING;

CREATE POLICY "public upload applications" ON storage.objects
  FOR INSERT TO anon, authenticated
  WITH CHECK (bucket_id = 'applications');
CREATE POLICY "admin read applications" ON storage.objects
  FOR SELECT TO authenticated
  USING (bucket_id = 'applications' AND public.is_admin());
CREATE POLICY "admin delete applications" ON storage.objects
  FOR DELETE TO authenticated
  USING (bucket_id = 'applications' AND public.is_admin());
