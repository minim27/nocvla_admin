-- Baseline skema production NOCVLA (mtuttxbxsqxxcemevhso), diambil 2026-11-04.
-- Merekam kondisi apa adanya, termasuk policy publik yang akan diperketat di migrasi berikutnya.
-- Skema public dari `supabase db dump`; bucket dan policy storage dari katalog database.




SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;


CREATE SCHEMA IF NOT EXISTS "public";


ALTER SCHEMA "public" OWNER TO "pg_database_owner";


COMMENT ON SCHEMA "public" IS 'standard public schema';



CREATE OR REPLACE FUNCTION "public"."check_early_access_password"("input_password" "text") RETURNS boolean
    LANGUAGE "sql" SECURITY DEFINER
    SET "search_path" TO 'public', 'extensions'
    AS $$
  select exists (
    select 1 from m_app_settings
    where early_access_password = crypt(input_password, early_access_password)
  );
$$;


ALTER FUNCTION "public"."check_early_access_password"("input_password" "text") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."set_early_access_password"("new_password" "text") RETURNS "void"
    LANGUAGE "sql" SECURITY DEFINER
    SET "search_path" TO 'public', 'extensions'
    AS $$
  update m_app_settings
  set early_access_password = crypt(new_password, gen_salt('bf'))
  where id is not null;
$$;


ALTER FUNCTION "public"."set_early_access_password"("new_password" "text") OWNER TO "postgres";

SET default_tablespace = '';

SET default_table_access_method = "heap";


CREATE TABLE IF NOT EXISTS "public"."m_app_settings" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "is_early_access" boolean DEFAULT false NOT NULL,
    "early_access_end_at" timestamp with time zone,
    "early_access_password" "text",
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL
);


ALTER TABLE "public"."m_app_settings" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."m_athlete" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "picture" "text",
    "code" character varying,
    "name" character varying,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp without time zone DEFAULT "now"(),
    "is_active" boolean DEFAULT false
);


ALTER TABLE "public"."m_athlete" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."m_athlete_application" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "name" character varying,
    "email" character varying,
    "phone" character varying,
    "instagram_username" character varying,
    "tiktok_username" character varying,
    "city" character varying,
    "reason" character varying,
    "status" character varying DEFAULT 'pending'::character varying,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"()
);


ALTER TABLE "public"."m_athlete_application" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."m_banners" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "image_url" "text",
    "title" character varying,
    "description" "text",
    "start_date" timestamp with time zone,
    "end_date" timestamp with time zone,
    "sort_order" integer DEFAULT 0,
    "is_active" boolean DEFAULT true,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL
);


ALTER TABLE "public"."m_banners" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."m_configurations" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "name" character varying,
    "value" character varying,
    "updated_at" timestamp with time zone DEFAULT "now"(),
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL
);


ALTER TABLE "public"."m_configurations" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."m_early_access_images" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "image_url" "text" NOT NULL,
    "sort_order" integer DEFAULT 0 NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL
);


ALTER TABLE "public"."m_early_access_images" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."m_product_color" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "product_id" "uuid" DEFAULT "gen_random_uuid"(),
    "name" character varying,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "update_at" timestamp without time zone DEFAULT "now"()
);


ALTER TABLE "public"."m_product_color" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."m_product_images" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "product_color_id" "uuid",
    "image_url" "text",
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"(),
    "sort_order" integer DEFAULT 0
);


ALTER TABLE "public"."m_product_images" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."m_product_stock" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "product_color_id" "uuid",
    "size" character varying,
    "qty" integer,
    "price" real,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"(),
    "sort_order" integer
);


ALTER TABLE "public"."m_product_stock" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."m_product_type" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "name" character varying,
    "is_active" boolean DEFAULT true,
    "updated_at" timestamp with time zone DEFAULT "now"(),
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "value" character varying,
    "sort_order" integer DEFAULT 0
);


ALTER TABLE "public"."m_product_type" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."m_products" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "name" character varying,
    "description" "text",
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"(),
    "shopee_url" "text",
    "tiktok_url" "text",
    "tokopedia_url" "text",
    "product_type_id" "uuid",
    "is_featured" boolean DEFAULT false NOT NULL
);


ALTER TABLE "public"."m_products" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."t_athlete" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "athlete_id" "uuid" DEFAULT "gen_random_uuid"(),
    "product_id" "uuid" DEFAULT "gen_random_uuid"(),
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "update_at" timestamp without time zone DEFAULT "now"(),
    "link_aff_shopee" "text",
    "link_aff_tktkshop" "text",
    "link_aff_tokped" "text"
);


ALTER TABLE "public"."t_athlete" OWNER TO "postgres";


CREATE OR REPLACE VIEW "public"."v_early_access_status" AS
 SELECT "is_early_access",
    "early_access_end_at"
   FROM "public"."m_app_settings"
 LIMIT 1;


ALTER VIEW "public"."v_early_access_status" OWNER TO "postgres";


ALTER TABLE ONLY "public"."m_app_settings"
    ADD CONSTRAINT "m_app_settings_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."m_athlete_application"
    ADD CONSTRAINT "m_athlete_application_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."m_athlete"
    ADD CONSTRAINT "m_athlete_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."m_banners"
    ADD CONSTRAINT "m_banners_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."m_configurations"
    ADD CONSTRAINT "m_configurations_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."m_early_access_images"
    ADD CONSTRAINT "m_early_access_images_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."m_product_color"
    ADD CONSTRAINT "m_product_color_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."m_product_images"
    ADD CONSTRAINT "m_product_images_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."m_product_stock"
    ADD CONSTRAINT "m_product_stock_pkey1" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."m_product_type"
    ADD CONSTRAINT "m_product_type_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."m_products"
    ADD CONSTRAINT "m_products_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."t_athlete"
    ADD CONSTRAINT "t_athlete_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."m_product_color"
    ADD CONSTRAINT "m_product_color_product_id_fkey" FOREIGN KEY ("product_id") REFERENCES "public"."m_products"("id");



ALTER TABLE ONLY "public"."m_product_images"
    ADD CONSTRAINT "m_product_images_product_color_id_fkey" FOREIGN KEY ("product_color_id") REFERENCES "public"."m_product_color"("id");



ALTER TABLE ONLY "public"."m_product_stock"
    ADD CONSTRAINT "m_product_stock_product_color_id_fkey" FOREIGN KEY ("product_color_id") REFERENCES "public"."m_product_color"("id");



ALTER TABLE ONLY "public"."m_products"
    ADD CONSTRAINT "m_products_product_type_id_fkey" FOREIGN KEY ("product_type_id") REFERENCES "public"."m_product_type"("id");



ALTER TABLE ONLY "public"."t_athlete"
    ADD CONSTRAINT "t_athlete_athlete_id_fkey" FOREIGN KEY ("athlete_id") REFERENCES "public"."m_athlete"("id");



ALTER TABLE ONLY "public"."t_athlete"
    ADD CONSTRAINT "t_athlete_product_id_fkey" FOREIGN KEY ("product_id") REFERENCES "public"."m_products"("id");



CREATE POLICY "Enab" ON "public"."m_athlete" TO "anon" USING (true);



CREATE POLICY "Enable read access for all users" ON "public"."m_athlete_application" TO "anon" USING (true);



CREATE POLICY "Enable read access for all users" ON "public"."m_banners" TO "anon" USING (true);



CREATE POLICY "Enable read access for all users" ON "public"."m_configurations" FOR SELECT USING (true);



CREATE POLICY "Enable read access for all users" ON "public"."m_product_color" TO "anon" USING (true);



CREATE POLICY "Enable read access for all users" ON "public"."m_product_images" TO "anon" USING (true);



CREATE POLICY "Enable read access for all users" ON "public"."m_product_stock" TO "anon" USING (true);



CREATE POLICY "Enable read access for all users" ON "public"."m_product_type" TO "anon" USING (true);



CREATE POLICY "Enable read access for all users" ON "public"."m_products" TO "anon" USING (true);



ALTER TABLE "public"."m_app_settings" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."m_athlete" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."m_athlete_application" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."m_banners" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."m_configurations" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."m_early_access_images" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."m_product_color" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."m_product_images" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."m_product_stock" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."m_product_type" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."m_products" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "public crud" ON "public"."m_app_settings" TO "anon" USING (true) WITH CHECK (true);



CREATE POLICY "public crud" ON "public"."m_early_access_images" TO "anon" USING (true) WITH CHECK (true);



CREATE POLICY "public crud" ON "public"."t_athlete" TO "anon" USING (true) WITH CHECK (true);



ALTER TABLE "public"."t_athlete" ENABLE ROW LEVEL SECURITY;


GRANT USAGE ON SCHEMA "public" TO "postgres";
GRANT USAGE ON SCHEMA "public" TO "anon";
GRANT USAGE ON SCHEMA "public" TO "authenticated";
GRANT USAGE ON SCHEMA "public" TO "service_role";



GRANT ALL ON FUNCTION "public"."check_early_access_password"("input_password" "text") TO "anon";
GRANT ALL ON FUNCTION "public"."check_early_access_password"("input_password" "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."check_early_access_password"("input_password" "text") TO "service_role";



GRANT ALL ON FUNCTION "public"."set_early_access_password"("new_password" "text") TO "anon";
GRANT ALL ON FUNCTION "public"."set_early_access_password"("new_password" "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."set_early_access_password"("new_password" "text") TO "service_role";



GRANT ALL ON TABLE "public"."m_app_settings" TO "anon";
GRANT ALL ON TABLE "public"."m_app_settings" TO "authenticated";
GRANT ALL ON TABLE "public"."m_app_settings" TO "service_role";



GRANT ALL ON TABLE "public"."m_athlete" TO "anon";
GRANT ALL ON TABLE "public"."m_athlete" TO "authenticated";
GRANT ALL ON TABLE "public"."m_athlete" TO "service_role";



GRANT ALL ON TABLE "public"."m_athlete_application" TO "anon";
GRANT ALL ON TABLE "public"."m_athlete_application" TO "authenticated";
GRANT ALL ON TABLE "public"."m_athlete_application" TO "service_role";



GRANT ALL ON TABLE "public"."m_banners" TO "anon";
GRANT ALL ON TABLE "public"."m_banners" TO "authenticated";
GRANT ALL ON TABLE "public"."m_banners" TO "service_role";



GRANT ALL ON TABLE "public"."m_configurations" TO "anon";
GRANT ALL ON TABLE "public"."m_configurations" TO "authenticated";
GRANT ALL ON TABLE "public"."m_configurations" TO "service_role";



GRANT ALL ON TABLE "public"."m_early_access_images" TO "anon";
GRANT ALL ON TABLE "public"."m_early_access_images" TO "authenticated";
GRANT ALL ON TABLE "public"."m_early_access_images" TO "service_role";



GRANT ALL ON TABLE "public"."m_product_color" TO "anon";
GRANT ALL ON TABLE "public"."m_product_color" TO "authenticated";
GRANT ALL ON TABLE "public"."m_product_color" TO "service_role";



GRANT ALL ON TABLE "public"."m_product_images" TO "anon";
GRANT ALL ON TABLE "public"."m_product_images" TO "authenticated";
GRANT ALL ON TABLE "public"."m_product_images" TO "service_role";



GRANT ALL ON TABLE "public"."m_product_stock" TO "anon";
GRANT ALL ON TABLE "public"."m_product_stock" TO "authenticated";
GRANT ALL ON TABLE "public"."m_product_stock" TO "service_role";



GRANT ALL ON TABLE "public"."m_product_type" TO "anon";
GRANT ALL ON TABLE "public"."m_product_type" TO "authenticated";
GRANT ALL ON TABLE "public"."m_product_type" TO "service_role";



GRANT ALL ON TABLE "public"."m_products" TO "anon";
GRANT ALL ON TABLE "public"."m_products" TO "authenticated";
GRANT ALL ON TABLE "public"."m_products" TO "service_role";



GRANT ALL ON TABLE "public"."t_athlete" TO "anon";
GRANT ALL ON TABLE "public"."t_athlete" TO "authenticated";
GRANT ALL ON TABLE "public"."t_athlete" TO "service_role";



GRANT ALL ON TABLE "public"."v_early_access_status" TO "anon";
GRANT ALL ON TABLE "public"."v_early_access_status" TO "authenticated";
GRANT ALL ON TABLE "public"."v_early_access_status" TO "service_role";



ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "service_role";






ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "service_role";






ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "service_role";

-- Storage
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types) VALUES ('athletes', 'athletes', 't', NULL, NULL) ON CONFLICT (id) DO NOTHING;
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types) VALUES ('banners', 'banners', 't', NULL, NULL) ON CONFLICT (id) DO NOTHING;
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types) VALUES ('early_access', 'early_access', 't', NULL, NULL) ON CONFLICT (id) DO NOTHING;
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types) VALUES ('products', 'products', 't', NULL, NULL) ON CONFLICT (id) DO NOTHING;

CREATE POLICY "CRUD 1ifhysk_0" ON storage.objects AS PERMISSIVE FOR SELECT TO public USING ((bucket_id = 'products'::text));
CREATE POLICY "CRUD 1ifhysk_1" ON storage.objects AS PERMISSIVE FOR UPDATE TO public USING ((bucket_id = 'products'::text));
CREATE POLICY "CRUD 1ifhysk_2" ON storage.objects AS PERMISSIVE FOR INSERT TO public WITH CHECK ((bucket_id = 'products'::text));
CREATE POLICY "CRUD 1ifhysk_3" ON storage.objects AS PERMISSIVE FOR DELETE TO public USING ((bucket_id = 'products'::text));
CREATE POLICY "CRUD 1tghu4n_0" ON storage.objects AS PERMISSIVE FOR SELECT TO public USING ((bucket_id = 'banners'::text));
CREATE POLICY "CRUD 1tghu4n_1" ON storage.objects AS PERMISSIVE FOR INSERT TO public WITH CHECK ((bucket_id = 'banners'::text));
CREATE POLICY "CRUD 1tghu4n_2" ON storage.objects AS PERMISSIVE FOR UPDATE TO public USING ((bucket_id = 'banners'::text));
CREATE POLICY "CRUD 1tghu4n_3" ON storage.objects AS PERMISSIVE FOR DELETE TO public USING ((bucket_id = 'banners'::text));
CREATE POLICY "public crud athletes bucket" ON storage.objects AS PERMISSIVE FOR ALL TO public USING ((bucket_id = 'athletes'::text)) WITH CHECK ((bucket_id = 'athletes'::text));
CREATE POLICY "public crud early_access bucket" ON storage.objects AS PERMISSIVE FOR ALL TO public USING ((bucket_id = 'early_access'::text)) WITH CHECK ((bucket_id = 'early_access'::text));
