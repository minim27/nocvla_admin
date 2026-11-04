# Kontrak Database NOCVLA

Daftar tabel, view, dan RPC yang boleh dipakai `nocvla_admin` dan `nocvla_web`. Aplikasi memanggil Supabase langsung dengan publishable key.

Kondisi per 2026-11-04.

## Status lingkungan

| Bagian | Staging (`MyConfig.prod = false`) | Production (`MyConfig.prod = true`) |
|---|---|---|
| Tabel utama dan storage | Ada | Ada |
| RLS baru, `is_admin()`, dan login admin | Aktif | **Belum** |
| Tabel dan RPC order WhatsApp | Ada | **Belum** |

Migrasi ada di `supabase/migrations/`. Aturan akses dan RPC order di dokumen ini baru berlaku di staging, sampai migrasinya dinaikkan ke production.

## Admin

Admin masuk lewat Supabase Auth. Akun admin punya `app_metadata.role = 'admin'`, dan `public.is_admin()` memeriksanya dari token login.

## Tabel

Semua tabel punya `id uuid`. Kolom `created_at` dan `updated_at` tidak ditulis ulang di bawah. `m_product_color` dan `t_athlete` memakai nama `update_at`.

### Data katalog: publik baca, admin tulis

| Tabel | Kolom |
|---|---|
| `m_products` | `name`, `description`, `shopee_url`, `tiktok_url`, `tokopedia_url`, `product_type_id`, `is_featured`, `badge` |
| `m_product_color` | `product_id`, `name`, `hex` |
| `m_product_images` | `product_color_id`, `image_url`, `sort_order` (terkecil = foto utama) |
| `m_product_stock` | `product_color_id`, `size`, `qty`, `price`, `sort_order` |
| `m_product_type` | `name`, `value`, `is_active`, `sort_order` |
| `m_banners` | `image_url`, `title`, `description`, `eyebrow`, `cta_product_id`, `start_date`, `end_date`, `sort_order`, `is_active` |
| `m_series` | `label`, `title`, `description`, `image_url`, `product_id`, `sort_order`, `is_active` |
| `m_athlete` | `picture`, `code`, `name`, `is_active` |
| `t_athlete` | `athlete_id`, `product_id`, `link_aff_shopee`, `link_aff_tktkshop`, `link_aff_tokped` |
| `m_early_access_images` | `image_url`, `sort_order` |
| `m_configurations` | `name`, `value` |

Kunci `m_configurations`: `LINK_DISCORD`, `WA_NUMBER`, `WA_TEMPLATE`, `INSTAGRAM`, `TIKTOK`, `CONTACT_EMAIL`, `DEFAULT_MARKETPLACE_URL`. Baru `LINK_DISCORD` yang berisi nilai. Semua kunci ini bisa dibaca publik, jadi jangan menyimpan data rahasia di sini.

### Akses terbatas

| Tabel | Kolom | Akses |
|---|---|---|
| `m_athlete_application` | `name`, `email`, `phone`, `instagram_username`, `tiktok_username`, `city`, `reason`, `status` | Publik hanya bisa kirim dengan status `pending`. Baca dan ubah khusus admin |
| `m_app_settings` | `is_early_access`, `early_access_end_at`, `early_access_password` (hash bcrypt) | Khusus admin |
| `t_wa_orders` | `code`, `customer_name`, `customer_phone`, `address`, `athlete_id`, `subtotal`, `discount`, `shipping_fee`, `courier`, `awb`, `status`, `stock_deducted`, `paid_at` | Baca khusus admin, tulis lewat RPC |
| `t_wa_order_items` | `order_id`, `product_id`, `color_id`, `product_name`, `color_name`, `size`, `qty`, `unit_price` | Baca khusus admin, tulis lewat RPC |

Status order: `new`, `awaiting_payment`, `paid`, `shipped`, `done`, `cancelled`.

Simpan produk membuat ulang baris warna, jadi ID warna bisa berubah. Karena itu item order menyimpan salinan nama produk, warna, ukuran, dan harga.

## View

| View | Kolom | Akses |
|---|---|---|
| `v_early_access_status` | `is_early_access`, `early_access_end_at` | Publik |

## RPC

| RPC | Parameter | Balikan | Akses |
|---|---|---|---|
| `check_early_access_password` | `input_password text` | `boolean` | Publik |
| `set_early_access_password` | `new_password text` | - | Admin |
| `create_wa_order` | `p_items jsonb`, `p_athlete_code text`, `p_customer_name text`, `p_customer_phone text`, `p_address text` | `{ code, wa_text }` | Publik |
| `update_wa_order` | `p_id uuid`, `p_shipping_fee numeric`, `p_courier text`, `p_awb text`, `p_status text` | - | Admin |
| `mark_order_paid` | `p_id uuid` | - | Admin, stok berkurang |
| `cancel_order` | `p_id uuid` | - | Admin, stok kembali bila sudah dibayar |
| `is_admin` | - | `boolean` | Dipakai policy |

`p_items` berbentuk `[{ "color_id": uuid, "size": text, "qty": int }]`. Hanya `p_items` yang wajib. Harga dihitung di server, dan kode atlet yang valid memberi diskon 8% untuk produk yang di-assign ke atlet itu. RPC menolak pesanan bila stok tidak cukup.

`update_wa_order` tidak menerima status `paid` dan `cancelled`, karena keduanya punya RPC sendiri.

## Storage

Bucket `products`, `athletes`, `banners`, dan `early_access`. Baca publik, tulis khusus admin.

URL gambar: `{API_URL}/{API_STORAGE}/{image_url}`. Nilai `image_url` sudah berisi nama bucket, misalnya `products/nama-file.png`.

## Belum ada

Rencana di `_docs` yang belum dibuat. Jangan memakainya sebelum dokumen ini diperbarui.

| Area | Yang belum ada |
|---|---|
| Produk | `v_catalog`, `m_product_size`, `slug`, `status`, `archived_at`, `series_label`, `material`, `care_text`, `size_chart_url`, dan `kind` |
| Fitur dan featured | `m_features`, `m_product_features`, `m_featured` (sekarang memakai `m_products.is_featured`) |
| Atlet | `validate_athlete_code`, `submit_athlete_application`, `approve_athlete_application`, `reject_athlete_application`, `instagram`, `archived_at`, `review_note`, dan `reviewed_at` |
| Order | `v_product_sold` |
| Kontak | `t_contact_messages`, `submit_contact_message` |
| Banner | `image_mobile_url`, `cta_type`, `cta_ref` |
| Early access | `v_early_access_public`, `verify_early_access` (sekarang memakai `v_early_access_status` dan `check_early_access_password`), rate limit |
| Storage | Bucket `size-charts` dan `applications` |
