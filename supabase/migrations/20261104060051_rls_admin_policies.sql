-- RLS: publik hanya membaca data katalog, semua penulisan khusus admin.
-- Admin dikenali dari app_metadata.role = 'admin' pada token Supabase Auth.

CREATE FUNCTION public.is_admin() RETURNS boolean
LANGUAGE sql
STABLE
SET search_path TO ''
AS $$
  SELECT coalesce(auth.jwt() -> 'app_metadata' ->> 'role', '') = 'admin';
$$;

GRANT EXECUTE ON FUNCTION public.is_admin() TO anon, authenticated;

-- Hapus policy lama yang terbuka.
DROP POLICY IF EXISTS "public crud" ON public.m_app_settings;
DROP POLICY IF EXISTS "public crud" ON public.m_early_access_images;
DROP POLICY IF EXISTS "public crud" ON public.t_athlete;
DROP POLICY IF EXISTS "Enab" ON public.m_athlete;
DROP POLICY IF EXISTS "Enable read access for all users" ON public.m_configurations;
DROP POLICY IF EXISTS "Enable read access for all users" ON public.m_banners;
DROP POLICY IF EXISTS "Enable read access for all users" ON public.m_products;
DROP POLICY IF EXISTS "Enable read access for all users" ON public.m_product_images;
DROP POLICY IF EXISTS "Enable read access for all users" ON public.m_product_type;
DROP POLICY IF EXISTS "Enable read access for all users" ON public.m_product_color;
DROP POLICY IF EXISTS "Enable read access for all users" ON public.m_product_stock;
DROP POLICY IF EXISTS "Enable read access for all users" ON public.m_athlete_application;
DROP POLICY IF EXISTS "staging read orders" ON public.t_wa_orders;
DROP POLICY IF EXISTS "staging read order items" ON public.t_wa_order_items;

DROP POLICY IF EXISTS "CRUD 1ifhysk_0" ON storage.objects;
DROP POLICY IF EXISTS "CRUD 1ifhysk_1" ON storage.objects;
DROP POLICY IF EXISTS "CRUD 1ifhysk_2" ON storage.objects;
DROP POLICY IF EXISTS "CRUD 1ifhysk_3" ON storage.objects;
DROP POLICY IF EXISTS "CRUD 1tghu4n_0" ON storage.objects;
DROP POLICY IF EXISTS "CRUD 1tghu4n_1" ON storage.objects;
DROP POLICY IF EXISTS "CRUD 1tghu4n_2" ON storage.objects;
DROP POLICY IF EXISTS "CRUD 1tghu4n_3" ON storage.objects;
DROP POLICY IF EXISTS "public crud athletes bucket" ON storage.objects;
DROP POLICY IF EXISTS "public crud early_access bucket" ON storage.objects;

-- Data katalog: baca publik, tulis admin. Filter status aktif menyusul setelah kolomnya ada.
DO $$
DECLARE
  v_table text;
BEGIN
  FOREACH v_table IN ARRAY ARRAY[
    'm_products', 'm_product_color', 'm_product_images', 'm_product_stock', 'm_product_type',
    'm_banners', 'm_athlete', 't_athlete', 'm_early_access_images', 'm_configurations'
  ] LOOP
    EXECUTE format('CREATE POLICY "public read" ON public.%I FOR SELECT TO anon, authenticated USING (true)', v_table);
    EXECUTE format('CREATE POLICY "admin insert" ON public.%I FOR INSERT TO authenticated WITH CHECK (public.is_admin())', v_table);
    EXECUTE format('CREATE POLICY "admin update" ON public.%I FOR UPDATE TO authenticated USING (public.is_admin()) WITH CHECK (public.is_admin())', v_table);
    EXECUTE format('CREATE POLICY "admin delete" ON public.%I FOR DELETE TO authenticated USING (public.is_admin())', v_table);
  END LOOP;
END;
$$;

-- Pendaftar: publik hanya bisa mengirim, tidak bisa membaca. Pindah ke RPC setelah katalog siap.
CREATE POLICY "public submit" ON public.m_athlete_application
  FOR INSERT TO anon, authenticated
  WITH CHECK (coalesce(status, 'pending') = 'pending');
CREATE POLICY "admin all" ON public.m_athlete_application
  FOR ALL TO authenticated
  USING (public.is_admin())
  WITH CHECK (public.is_admin());

-- Pengaturan berisi hash password. Status publik tetap lewat v_early_access_status.
CREATE POLICY "admin all" ON public.m_app_settings
  FOR ALL TO authenticated
  USING (public.is_admin())
  WITH CHECK (public.is_admin());

-- Order: baca admin, penulisan lewat RPC.
CREATE POLICY "admin read" ON public.t_wa_orders
  FOR SELECT TO authenticated
  USING (public.is_admin());
CREATE POLICY "admin read" ON public.t_wa_order_items
  FOR SELECT TO authenticated
  USING (public.is_admin());

-- Storage: baca publik, tulis admin.
CREATE POLICY "public read buckets" ON storage.objects
  FOR SELECT TO public
  USING (bucket_id IN ('products', 'banners', 'athletes', 'early_access'));
CREATE POLICY "admin insert buckets" ON storage.objects
  FOR INSERT TO authenticated
  WITH CHECK (bucket_id IN ('products', 'banners', 'athletes', 'early_access') AND public.is_admin());
CREATE POLICY "admin update buckets" ON storage.objects
  FOR UPDATE TO authenticated
  USING (bucket_id IN ('products', 'banners', 'athletes', 'early_access') AND public.is_admin())
  WITH CHECK (bucket_id IN ('products', 'banners', 'athletes', 'early_access') AND public.is_admin());
CREATE POLICY "admin delete buckets" ON storage.objects
  FOR DELETE TO authenticated
  USING (bucket_id IN ('products', 'banners', 'athletes', 'early_access') AND public.is_admin());

-- RPC admin: dicek di dalam fungsi karena berjalan sebagai SECURITY DEFINER.
CREATE OR REPLACE FUNCTION public.set_early_access_password(new_password text) RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path TO 'public', 'extensions'
AS $$
BEGIN
  IF NOT public.is_admin() THEN
    RAISE EXCEPTION 'Khusus admin';
  END IF;

  UPDATE m_app_settings
  SET early_access_password = crypt(new_password, gen_salt('bf'))
  WHERE id IS NOT NULL;
END;
$$;

CREATE OR REPLACE FUNCTION public.update_wa_order(
  p_id uuid,
  p_shipping_fee numeric DEFAULT NULL,
  p_courier text DEFAULT NULL,
  p_awb text DEFAULT NULL,
  p_status text DEFAULT NULL
) RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path TO 'public'
AS $$
BEGIN
  IF NOT public.is_admin() THEN
    RAISE EXCEPTION 'Khusus admin';
  END IF;

  IF p_status IN ('paid', 'cancelled') THEN
    RAISE EXCEPTION 'Gunakan mark_order_paid atau cancel_order';
  END IF;

  UPDATE t_wa_orders
  SET shipping_fee = coalesce(p_shipping_fee, shipping_fee),
      courier = coalesce(p_courier, courier),
      awb = coalesce(p_awb, awb),
      status = coalesce(p_status, status),
      updated_at = now()
  WHERE id = p_id;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Order tidak ditemukan';
  END IF;
END;
$$;

CREATE OR REPLACE FUNCTION public.mark_order_paid(p_id uuid) RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path TO 'public'
AS $$
DECLARE
  v_order public.t_wa_orders;
  v_item record;
BEGIN
  IF NOT public.is_admin() THEN
    RAISE EXCEPTION 'Khusus admin';
  END IF;

  SELECT * INTO v_order FROM t_wa_orders WHERE id = p_id FOR UPDATE;
  IF NOT FOUND THEN
    RAISE EXCEPTION 'Order tidak ditemukan';
  END IF;
  IF v_order.status NOT IN ('new', 'awaiting_payment') THEN
    RAISE EXCEPTION 'Order berstatus % tidak bisa ditandai dibayar', v_order.status;
  END IF;

  FOR v_item IN SELECT * FROM t_wa_order_items WHERE order_id = p_id LOOP
    UPDATE m_product_stock s
    SET qty = s.qty - v_item.qty
    FROM m_product_color c
    WHERE c.id = s.product_color_id
      AND c.product_id = v_item.product_id
      AND c.name = v_item.color_name
      AND s.size IS NOT DISTINCT FROM v_item.size
      AND s.qty >= v_item.qty;

    IF NOT FOUND THEN
      RAISE EXCEPTION 'Stok % % ukuran % tidak cukup', v_item.product_name, v_item.color_name, v_item.size;
    END IF;
  END LOOP;

  UPDATE t_wa_orders
  SET status = 'paid', stock_deducted = true, paid_at = now(), updated_at = now()
  WHERE id = p_id;
END;
$$;

CREATE OR REPLACE FUNCTION public.cancel_order(p_id uuid) RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path TO 'public'
AS $$
DECLARE
  v_order public.t_wa_orders;
  v_item record;
BEGIN
  IF NOT public.is_admin() THEN
    RAISE EXCEPTION 'Khusus admin';
  END IF;

  SELECT * INTO v_order FROM t_wa_orders WHERE id = p_id FOR UPDATE;
  IF NOT FOUND THEN
    RAISE EXCEPTION 'Order tidak ditemukan';
  END IF;
  IF v_order.status IN ('done', 'cancelled') THEN
    RAISE EXCEPTION 'Order berstatus % tidak bisa dibatalkan', v_order.status;
  END IF;

  IF v_order.stock_deducted THEN
    FOR v_item IN SELECT * FROM t_wa_order_items WHERE order_id = p_id LOOP
      UPDATE m_product_stock s
      SET qty = s.qty + v_item.qty
      FROM m_product_color c
      WHERE c.id = s.product_color_id
        AND c.product_id = v_item.product_id
        AND c.name = v_item.color_name
        AND s.size IS NOT DISTINCT FROM v_item.size;
    END LOOP;
  END IF;

  UPDATE t_wa_orders
  SET status = 'cancelled', stock_deducted = false, updated_at = now()
  WHERE id = p_id;
END;
$$;

REVOKE ALL ON FUNCTION public.set_early_access_password(text) FROM PUBLIC, anon;
REVOKE ALL ON FUNCTION public.update_wa_order(uuid, numeric, text, text, text) FROM PUBLIC, anon;
REVOKE ALL ON FUNCTION public.mark_order_paid(uuid) FROM PUBLIC, anon;
REVOKE ALL ON FUNCTION public.cancel_order(uuid) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.set_early_access_password(text) TO authenticated;
GRANT EXECUTE ON FUNCTION public.update_wa_order(uuid, numeric, text, text, text) TO authenticated;
GRANT EXECUTE ON FUNCTION public.mark_order_paid(uuid) TO authenticated;
GRANT EXECUTE ON FUNCTION public.cancel_order(uuid) TO authenticated;
