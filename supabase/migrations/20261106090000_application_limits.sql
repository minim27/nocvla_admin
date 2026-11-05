-- Batas kiriman form Join Nocvla Athlete, karena form ini terbuka untuk publik.
-- Per nomor: 3 kiriman per 24 jam. Seluruh form: 30 kiriman dan 30 unggahan foto per jam.
CREATE OR REPLACE FUNCTION public.application_limit_ok(p_phone text) RETURNS boolean
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path TO 'public'
AS $$
  SELECT
    (SELECT count(*) FROM public.m_athlete_application a
      WHERE regexp_replace(coalesce(a.phone, ''), '\D', '', 'g') = regexp_replace(coalesce(p_phone, ''), '\D', '', 'g')
        AND a.created_at > now() - interval '24 hours') < 3
    AND
    (SELECT count(*) FROM public.m_athlete_application a
      WHERE a.created_at > now() - interval '1 hour') < 30;
$$;

GRANT EXECUTE ON FUNCTION public.application_limit_ok(text) TO anon, authenticated;

CREATE OR REPLACE FUNCTION public.enforce_application_limit() RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path TO 'public'
AS $$
BEGIN
  IF NOT public.application_limit_ok(NEW.phone) THEN
    RAISE EXCEPTION 'Batas pendaftaran tercapai. Coba lagi nanti.';
  END IF;

  RETURN NEW;
END;
$$;

CREATE TRIGGER enforce_application_limit
  BEFORE INSERT ON public.m_athlete_application
  FOR EACH ROW EXECUTE FUNCTION public.enforce_application_limit();

CREATE OR REPLACE FUNCTION public.application_upload_ok() RETURNS boolean
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path TO 'public', 'storage'
AS $$
  SELECT count(*) < 30 FROM storage.objects o
  WHERE o.bucket_id = 'applications'
    AND o.created_at > now() - interval '1 hour';
$$;

GRANT EXECUTE ON FUNCTION public.application_upload_ok() TO anon, authenticated;

DROP POLICY IF EXISTS "public upload applications" ON storage.objects;
CREATE POLICY "public upload applications" ON storage.objects
  FOR INSERT TO anon, authenticated
  WITH CHECK (bucket_id = 'applications' AND public.application_upload_ok());
