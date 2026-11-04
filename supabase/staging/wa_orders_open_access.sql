-- KHUSUS STAGING. Jangan dijalankan di production.
-- Admin belum punya login, jadi akses order dibuka sementara untuk pengujian.
-- Hapus setelah is_admin() dan login admin selesai.

CREATE POLICY "staging read orders" ON public.t_wa_orders FOR SELECT TO anon USING (true);
CREATE POLICY "staging read order items" ON public.t_wa_order_items FOR SELECT TO anon USING (true);

GRANT EXECUTE ON FUNCTION public.update_wa_order(uuid, numeric, text, text, text) TO anon;
GRANT EXECUTE ON FUNCTION public.mark_order_paid(uuid) TO anon;
GRANT EXECUTE ON FUNCTION public.cancel_order(uuid) TO anon;
