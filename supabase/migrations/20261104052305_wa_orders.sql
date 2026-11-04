-- Order WhatsApp: tabel, RLS tertutup, dan RPC. Harga dihitung di server.
-- Item menyimpan salinan nama produk, warna, ukuran, dan harga karena simpan produk membuat ulang baris warna.

CREATE SEQUENCE IF NOT EXISTS public.t_wa_orders_code_seq;

CREATE TABLE public.t_wa_orders (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  code text NOT NULL UNIQUE DEFAULT 'WA-' || lpad(nextval('public.t_wa_orders_code_seq')::text, 4, '0'),
  customer_name text,
  customer_phone text,
  address text,
  athlete_id uuid REFERENCES public.m_athlete(id) ON DELETE SET NULL,
  subtotal numeric NOT NULL DEFAULT 0,
  discount numeric NOT NULL DEFAULT 0,
  shipping_fee numeric,
  courier text,
  awb text,
  status text NOT NULL DEFAULT 'new'
    CHECK (status IN ('new', 'awaiting_payment', 'paid', 'shipped', 'done', 'cancelled')),
  stock_deducted boolean NOT NULL DEFAULT false,
  paid_at timestamptz,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE public.t_wa_order_items (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  order_id uuid NOT NULL REFERENCES public.t_wa_orders(id) ON DELETE CASCADE,
  product_id uuid REFERENCES public.m_products(id) ON DELETE SET NULL,
  color_id uuid REFERENCES public.m_product_color(id) ON DELETE SET NULL,
  product_name text NOT NULL,
  color_name text NOT NULL,
  size text,
  qty integer NOT NULL CHECK (qty > 0),
  unit_price numeric NOT NULL
);

CREATE INDEX t_wa_order_items_order_id_idx ON public.t_wa_order_items(order_id);
CREATE INDEX t_wa_orders_status_idx ON public.t_wa_orders(status);

ALTER TABLE public.t_wa_orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.t_wa_order_items ENABLE ROW LEVEL SECURITY;

CREATE FUNCTION public.create_wa_order(
  p_items jsonb,
  p_athlete_code text DEFAULT NULL,
  p_customer_name text DEFAULT NULL,
  p_customer_phone text DEFAULT NULL,
  p_address text DEFAULT NULL
) RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path TO 'public'
AS $$
DECLARE
  v_order public.t_wa_orders;
  v_athlete_id uuid;
  v_item record;
  v_stock record;
  v_subtotal numeric := 0;
  v_discount_base numeric := 0;
  v_lines text := '';
  v_template text;
  v_text text;
BEGIN
  IF p_items IS NULL OR jsonb_array_length(p_items) = 0 THEN
    RAISE EXCEPTION 'Item order kosong';
  END IF;

  IF nullif(trim(p_athlete_code), '') IS NOT NULL THEN
    SELECT id INTO v_athlete_id FROM m_athlete WHERE upper(code) = upper(trim(p_athlete_code)) LIMIT 1;
  END IF;

  INSERT INTO t_wa_orders (customer_name, customer_phone, address, athlete_id)
  VALUES (p_customer_name, p_customer_phone, p_address, v_athlete_id)
  RETURNING * INTO v_order;

  FOR v_item IN SELECT * FROM jsonb_to_recordset(p_items) AS x(color_id uuid, size text, qty integer) LOOP
    IF coalesce(v_item.qty, 0) <= 0 THEN
      RAISE EXCEPTION 'Jumlah item tidak valid';
    END IF;

    SELECT s.qty, s.price, c.name AS color_name, c.product_id, p.name AS product_name
    INTO v_stock
    FROM m_product_stock s
    JOIN m_product_color c ON c.id = s.product_color_id
    JOIN m_products p ON p.id = c.product_id
    WHERE s.product_color_id = v_item.color_id AND s.size IS NOT DISTINCT FROM v_item.size;

    IF NOT FOUND THEN
      RAISE EXCEPTION 'Produk atau ukuran tidak ditemukan';
    END IF;
    IF coalesce(v_stock.qty, 0) < v_item.qty THEN
      RAISE EXCEPTION 'Stok % % ukuran % tidak cukup', v_stock.product_name, v_stock.color_name, v_item.size;
    END IF;

    INSERT INTO t_wa_order_items (order_id, product_id, color_id, product_name, color_name, size, qty, unit_price)
    VALUES (v_order.id, v_stock.product_id, v_item.color_id, v_stock.product_name, v_stock.color_name, v_item.size, v_item.qty, v_stock.price);

    v_subtotal := v_subtotal + v_stock.price * v_item.qty;

    IF v_athlete_id IS NOT NULL AND EXISTS (
      SELECT 1 FROM t_athlete t WHERE t.athlete_id = v_athlete_id AND t.product_id = v_stock.product_id
    ) THEN
      v_discount_base := v_discount_base + v_stock.price * v_item.qty;
    END IF;

    v_lines := v_lines || format(E'- %s / %s / %s x%s\n', v_stock.product_name, v_stock.color_name, coalesce(v_item.size, '-'), v_item.qty);
  END LOOP;

  UPDATE t_wa_orders
  SET subtotal = v_subtotal, discount = round(v_discount_base * 0.08)
  WHERE id = v_order.id;

  SELECT value INTO v_template FROM m_configurations WHERE name = 'WA_TEMPLATE' LIMIT 1;
  v_text := coalesce(nullif(v_template, ''), E'Halo NOCVLA, saya mau order:\n{item}\nKode atlet: {kode}');
  v_text := replace(v_text, '{item}', rtrim(v_lines, E'\n'));
  v_text := replace(v_text, '{kode}', coalesce(nullif(trim(p_athlete_code), ''), '-'));

  RETURN jsonb_build_object('code', v_order.code, 'wa_text', v_text);
END;
$$;

CREATE FUNCTION public.update_wa_order(
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

CREATE FUNCTION public.mark_order_paid(p_id uuid) RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path TO 'public'
AS $$
DECLARE
  v_order public.t_wa_orders;
  v_item record;
BEGIN
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

CREATE FUNCTION public.cancel_order(p_id uuid) RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path TO 'public'
AS $$
DECLARE
  v_order public.t_wa_orders;
  v_item record;
BEGIN
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

REVOKE ALL ON FUNCTION public.create_wa_order(jsonb, text, text, text, text) FROM PUBLIC;
REVOKE ALL ON FUNCTION public.update_wa_order(uuid, numeric, text, text, text) FROM PUBLIC, anon, authenticated;
REVOKE ALL ON FUNCTION public.mark_order_paid(uuid) FROM PUBLIC, anon, authenticated;
REVOKE ALL ON FUNCTION public.cancel_order(uuid) FROM PUBLIC, anon, authenticated;
GRANT EXECUTE ON FUNCTION public.create_wa_order(jsonb, text, text, text, text) TO anon, authenticated;
