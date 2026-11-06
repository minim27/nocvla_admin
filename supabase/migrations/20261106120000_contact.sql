-- Halaman Kontak: FAQ dan Topik diatur dari Admin, pesan dari form Kirim pesan.
CREATE TABLE IF NOT EXISTS public.m_faq (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  question text NOT NULL,
  answer text,
  sort_order integer NOT NULL DEFAULT 0,
  is_active boolean NOT NULL DEFAULT true,
  created_at timestamp with time zone DEFAULT now() NOT NULL,
  updated_at timestamp with time zone DEFAULT now() NOT NULL
);

CREATE TABLE IF NOT EXISTS public.m_contact_topic (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL UNIQUE,
  sort_order integer NOT NULL DEFAULT 0,
  is_active boolean NOT NULL DEFAULT true,
  created_at timestamp with time zone DEFAULT now() NOT NULL,
  updated_at timestamp with time zone DEFAULT now() NOT NULL
);

CREATE TABLE IF NOT EXISTS public.t_contact_messages (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  contact text NOT NULL,
  topic text,
  message text NOT NULL,
  status text NOT NULL DEFAULT 'unread' CHECK (status IN ('unread', 'read')),
  created_at timestamp with time zone DEFAULT now() NOT NULL
);

ALTER TABLE public.m_faq ENABLE ROW LEVEL SECURITY;
CREATE POLICY "public read" ON public.m_faq FOR SELECT TO anon, authenticated USING (true);
CREATE POLICY "admin insert" ON public.m_faq FOR INSERT TO authenticated WITH CHECK (public.is_admin());
CREATE POLICY "admin update" ON public.m_faq FOR UPDATE TO authenticated USING (public.is_admin()) WITH CHECK (public.is_admin());
CREATE POLICY "admin delete" ON public.m_faq FOR DELETE TO authenticated USING (public.is_admin());

ALTER TABLE public.m_contact_topic ENABLE ROW LEVEL SECURITY;
CREATE POLICY "public read" ON public.m_contact_topic FOR SELECT TO anon, authenticated USING (true);
CREATE POLICY "admin insert" ON public.m_contact_topic FOR INSERT TO authenticated WITH CHECK (public.is_admin());
CREATE POLICY "admin update" ON public.m_contact_topic FOR UPDATE TO authenticated USING (public.is_admin()) WITH CHECK (public.is_admin());
CREATE POLICY "admin delete" ON public.m_contact_topic FOR DELETE TO authenticated USING (public.is_admin());

-- Publik hanya bisa mengirim pesan berstatus unread. Baca dan ubah khusus admin.
ALTER TABLE public.t_contact_messages ENABLE ROW LEVEL SECURITY;
CREATE POLICY "public submit" ON public.t_contact_messages
  FOR INSERT TO anon, authenticated
  WITH CHECK (status = 'unread');
CREATE POLICY "admin all" ON public.t_contact_messages
  FOR ALL TO authenticated
  USING (public.is_admin())
  WITH CHECK (public.is_admin());

-- Batas kiriman: 3 pesan per kontak per 24 jam, 30 pesan per jam untuk seluruh form.
CREATE OR REPLACE FUNCTION public.enforce_contact_limit() RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path TO 'public'
AS $$
BEGIN
  IF (SELECT count(*) FROM public.t_contact_messages m
      WHERE lower(m.contact) = lower(NEW.contact)
        AND m.created_at > now() - interval '24 hours') >= 3
    OR (SELECT count(*) FROM public.t_contact_messages m
      WHERE m.created_at > now() - interval '1 hour') >= 30 THEN
    RAISE EXCEPTION 'Batas kirim pesan tercapai. Coba lagi nanti.';
  END IF;

  RETURN NEW;
END;
$$;

CREATE TRIGGER enforce_contact_limit
  BEFORE INSERT ON public.t_contact_messages
  FOR EACH ROW EXECUTE FUNCTION public.enforce_contact_limit();

-- Isi awal mengikuti referensi desain.
INSERT INTO public.m_contact_topic (name) VALUES ('Pertanyaan produk') ON CONFLICT (name) DO NOTHING;
INSERT INTO public.m_faq (question, answer, sort_order)
SELECT 'Bagaimana cara order?',
  'Pilih produk, warna, dan ukuran, lalu masukkan ke keranjang. Tekan "Kirim order ke WhatsApp" — semua item terkirim dalam satu pesan. Bisa juga beli lewat Shopee, TikTok Shop, atau Tokopedia.',
  0
WHERE NOT EXISTS (SELECT 1 FROM public.m_faq);
