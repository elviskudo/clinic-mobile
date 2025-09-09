

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


CREATE EXTENSION IF NOT EXISTS "pgsodium";






COMMENT ON SCHEMA "public" IS 'standard public schema';



CREATE EXTENSION IF NOT EXISTS "pg_graphql" WITH SCHEMA "graphql";






CREATE EXTENSION IF NOT EXISTS "pg_stat_statements" WITH SCHEMA "extensions";






CREATE EXTENSION IF NOT EXISTS "pgcrypto" WITH SCHEMA "extensions";






CREATE EXTENSION IF NOT EXISTS "pgjwt" WITH SCHEMA "extensions";






CREATE EXTENSION IF NOT EXISTS "supabase_vault" WITH SCHEMA "vault";






CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA "extensions";






CREATE OR REPLACE FUNCTION "public"."expire_old_invites"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
BEGIN
    UPDATE doctor_invites
    SET is_used = TRUE
    WHERE expires_at < NOW()
    AND is_used = FALSE;
    RETURN NULL;
END;
$$;


ALTER FUNCTION "public"."expire_old_invites"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."update_updated_at_column"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$;


ALTER FUNCTION "public"."update_updated_at_column"() OWNER TO "postgres";

SET default_tablespace = '';

SET default_table_access_method = "heap";


CREATE TABLE IF NOT EXISTS "public"."abouts" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "id_body" "text",
    "updated_at" timestamp without time zone DEFAULT "now"(),
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "en_body" "text"
);


ALTER TABLE "public"."abouts" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."ai_apis" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "api_model" character varying,
    "api_key" character varying,
    "max_tokens_limit" bigint DEFAULT '900000'::bigint,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp without time zone DEFAULT "now"(),
    "status" boolean
);


ALTER TABLE "public"."ai_apis" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."appointment_drugs" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "appointment_id" "uuid" DEFAULT "gen_random_uuid"(),
    "drug_id" "uuid" DEFAULT "gen_random_uuid"(),
    "status" boolean,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp without time zone DEFAULT "now"(),
    "price" bigint,
    "grab_status" smallint DEFAULT '1'::smallint,
    "grab_date" timestamp without time zone
);


ALTER TABLE "public"."appointment_drugs" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."appointment_fees" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "appointment_id" "uuid" DEFAULT "gen_random_uuid"(),
    "fee_id" "uuid" DEFAULT "gen_random_uuid"(),
    "status" boolean,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp without time zone DEFAULT "now"(),
    "price" bigint
);


ALTER TABLE "public"."appointment_fees" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."appointments" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "user_id" "uuid" DEFAULT "gen_random_uuid"(),
    "clinic_id" "uuid" DEFAULT "gen_random_uuid"(),
    "poly_id" "uuid" DEFAULT "gen_random_uuid"(),
    "doctor_id" "uuid" DEFAULT "gen_random_uuid"(),
    "date_id" "uuid" DEFAULT "gen_random_uuid"(),
    "time_id" "uuid" DEFAULT "gen_random_uuid"(),
    "status" smallint DEFAULT '1'::smallint,
    "rejected_note" character varying DEFAULT '255'::character varying,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp without time zone DEFAULT "now"(),
    "qr_code" character varying DEFAULT '8'::character varying,
    "symptoms" "text",
    "symptom_description" "text",
    "ai_response" "text"
);


ALTER TABLE "public"."appointments" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."banks" (
    "id" "uuid" NOT NULL,
    "name" character varying(255) NOT NULL,
    "account_number" character varying(255),
    "created_at" timestamp with time zone,
    "updated_at" timestamp with time zone
);


ALTER TABLE "public"."banks" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."cities" (
    "id" character varying DEFAULT '16'::character varying NOT NULL,
    "province" character varying DEFAULT '128'::character varying NOT NULL,
    "district" character varying DEFAULT '128'::character varying,
    "sub_district" character varying DEFAULT '128'::character varying,
    "village" character varying DEFAULT '128'::character varying
);


ALTER TABLE "public"."cities" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."clinics" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "name" character varying DEFAULT '64'::character varying,
    "address" character varying DEFAULT '255'::character varying,
    "accreditation" character varying DEFAULT '2'::character varying,
    "contact_name" character varying DEFAULT '64'::character varying,
    "contact_phone" character varying DEFAULT '24'::character varying,
    "contact_email" character varying DEFAULT '255'::character varying,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp without time zone DEFAULT "now"()
);


ALTER TABLE "public"."clinics" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."doctors" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "degree" character varying DEFAULT '64'::character varying,
    "description" "text",
    "clinic_id" "uuid" DEFAULT "gen_random_uuid"(),
    "poly_id" "uuid" DEFAULT "gen_random_uuid"(),
    "status" smallint DEFAULT '1'::smallint,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp without time zone DEFAULT "now"(),
    "specialize" character varying DEFAULT '64'::character varying,
    "user_id" "uuid" DEFAULT "gen_random_uuid"(),
    "name" character varying
);


ALTER TABLE "public"."doctors" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."drug_patients" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "user_id" "uuid" DEFAULT "gen_random_uuid"(),
    "drug_id" "uuid" DEFAULT "gen_random_uuid"(),
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp without time zone DEFAULT "now"(),
    "description" character varying DEFAULT '255'::character varying,
    "consume_time" character varying,
    "many_per_day" smallint
);


ALTER TABLE "public"."drug_patients" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."drugs" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "name" character varying DEFAULT '128'::character varying,
    "description" "text",
    "company_name" character varying DEFAULT '255'::character varying,
    "stock" bigint,
    "buy_price" bigint,
    "sell_price" bigint,
    "dosis" character varying DEFAULT '16'::character varying,
    "kind" character varying DEFAULT '32'::character varying,
    "is_halal" boolean,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp without time zone DEFAULT "now"()
);


ALTER TABLE "public"."drugs" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."faqs" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "en_title" character varying DEFAULT '255'::character varying,
    "en_description" "text",
    "id_title" character varying DEFAULT '255'::character varying,
    "id_description" "text",
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp without time zone DEFAULT "now"()
);


ALTER TABLE "public"."faqs" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."fees" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "procedure" character varying,
    "price" bigint,
    "status" boolean DEFAULT false,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp without time zone,
    "clinic_id" "uuid" DEFAULT "gen_random_uuid"()
);


ALTER TABLE "public"."fees" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."files" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "module_class" character varying NOT NULL,
    "module_id" "uuid" NOT NULL,
    "file_name" character varying NOT NULL,
    "file_type" character varying NOT NULL,
    "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE "public"."files" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."help_centers" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "en_summary" "text",
    "en_note" character varying DEFAULT '255'::character varying,
    "en_contact" character varying DEFAULT '255'::character varying,
    "id_summary" "text",
    "id_note" character varying DEFAULT '255'::character varying,
    "id_contact" character varying DEFAULT '255'::character varying,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp without time zone DEFAULT "now"()
);


ALTER TABLE "public"."help_centers" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."notifications" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "type" smallint,
    "user_id_from" "uuid" DEFAULT "gen_random_uuid"(),
    "user_id_to" "uuid" DEFAULT "gen_random_uuid"(),
    "page_link" character varying DEFAULT ''::character varying,
    "message" "text",
    "status" boolean DEFAULT false,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp without time zone DEFAULT "now"()
);


ALTER TABLE "public"."notifications" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."polies" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "name" character varying DEFAULT '128'::character varying,
    "description" "text",
    "status" smallint DEFAULT '1'::smallint,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp without time zone DEFAULT "now"(),
    "clinic_id" "uuid" DEFAULT "gen_random_uuid"()
);


ALTER TABLE "public"."polies" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."profiles" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "user_id" "uuid" DEFAULT "gen_random_uuid"(),
    "name" character varying DEFAULT '128'::character varying,
    "place_of_birth" character varying DEFAULT '64'::character varying,
    "date_of_birth" "date",
    "gender" smallint DEFAULT '1'::smallint,
    "card_number" character varying DEFAULT '32'::character varying,
    "address" character varying DEFAULT '128'::character varying,
    "rt" smallint DEFAULT '2'::smallint,
    "rw" smallint DEFAULT '2'::smallint,
    "city_id" character varying DEFAULT '16'::character varying,
    "postal_code" integer,
    "responsible_for_costs" character varying DEFAULT '64'::character varying,
    "blood_group" character varying DEFAULT '2'::character varying,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp without time zone DEFAULT "now"()
);


ALTER TABLE "public"."profiles" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."roles" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "name" character varying(50) NOT NULL,
    "description" "text",
    "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE "public"."roles" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."schedule_dates" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "poly_id" "uuid" DEFAULT "gen_random_uuid"(),
    "doctor_id" "uuid" DEFAULT "gen_random_uuid"(),
    "schedule_date" "date",
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp without time zone DEFAULT "now"()
);


ALTER TABLE "public"."schedule_dates" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."schedule_times" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "date_id" "uuid" DEFAULT "gen_random_uuid"(),
    "schedule_time" character varying DEFAULT '64'::character varying,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp without time zone DEFAULT "now"(),
    "limit" integer
);


ALTER TABLE "public"."schedule_times" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."symptoms" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "poly_id" "uuid" DEFAULT "gen_random_uuid"(),
    "en_name" character varying DEFAULT '32'::character varying,
    "id_name" character varying DEFAULT '32'::character varying,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp without time zone DEFAULT "now"()
);


ALTER TABLE "public"."symptoms" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."transactions" (
    "id" "uuid" NOT NULL,
    "bank_id" "uuid" NOT NULL,
    "appointment_id" "uuid" NOT NULL,
    "user_id" "uuid" NOT NULL,
    "transaction_number" character varying(255) NOT NULL,
    "total_price" numeric(15,2) NOT NULL,
    "created_at" timestamp with time zone,
    "updated_at" timestamp with time zone,
    "status" integer
);


ALTER TABLE "public"."transactions" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."user_roles" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "user_id" "uuid",
    "role_id" "uuid",
    "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE "public"."user_roles" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."users" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "name" character varying(255) NOT NULL,
    "email" character varying(255) NOT NULL,
    "password" character varying(255) NOT NULL,
    "phone_number" character varying(20),
    "access_token" "text",
    "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE "public"."users" OWNER TO "postgres";


ALTER TABLE ONLY "public"."abouts"
    ADD CONSTRAINT "abouts_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."ai_apis"
    ADD CONSTRAINT "ai_apis_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."appointment_drugs"
    ADD CONSTRAINT "appointment_drugs_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."appointment_fees"
    ADD CONSTRAINT "appointment_fees_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."appointments"
    ADD CONSTRAINT "appointments_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."banks"
    ADD CONSTRAINT "banks_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."clinics"
    ADD CONSTRAINT "clinics_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."doctors"
    ADD CONSTRAINT "doctors_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."drug_patients"
    ADD CONSTRAINT "drug_patients_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."drugs"
    ADD CONSTRAINT "drugs_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."faqs"
    ADD CONSTRAINT "faqs_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."fees"
    ADD CONSTRAINT "fees_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."files"
    ADD CONSTRAINT "files_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."help_centers"
    ADD CONSTRAINT "help_centers_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."notifications"
    ADD CONSTRAINT "notifications_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."polies"
    ADD CONSTRAINT "polies_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."profiles"
    ADD CONSTRAINT "profiles_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."roles"
    ADD CONSTRAINT "roles_name_key" UNIQUE ("name");



ALTER TABLE ONLY "public"."roles"
    ADD CONSTRAINT "roles_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."schedule_dates"
    ADD CONSTRAINT "schedule_dates_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."schedule_times"
    ADD CONSTRAINT "schedule_times_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."symptoms"
    ADD CONSTRAINT "symptoms_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."transactions"
    ADD CONSTRAINT "transactions_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."user_roles"
    ADD CONSTRAINT "user_roles_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."user_roles"
    ADD CONSTRAINT "user_roles_user_id_role_id_key" UNIQUE ("user_id", "role_id");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_pkey" PRIMARY KEY ("id");



CREATE OR REPLACE TRIGGER "update_files_updated_at" BEFORE UPDATE ON "public"."files" FOR EACH ROW EXECUTE FUNCTION "public"."update_updated_at_column"();



CREATE OR REPLACE TRIGGER "update_roles_updated_at" BEFORE UPDATE ON "public"."roles" FOR EACH ROW EXECUTE FUNCTION "public"."update_updated_at_column"();



CREATE OR REPLACE TRIGGER "update_user_roles_updated_at" BEFORE UPDATE ON "public"."user_roles" FOR EACH ROW EXECUTE FUNCTION "public"."update_updated_at_column"();



CREATE OR REPLACE TRIGGER "update_users_updated_at" BEFORE UPDATE ON "public"."users" FOR EACH ROW EXECUTE FUNCTION "public"."update_updated_at_column"();



ALTER TABLE ONLY "public"."appointment_drugs"
    ADD CONSTRAINT "appointment_drugs_appointment_id_fkey" FOREIGN KEY ("appointment_id") REFERENCES "public"."appointments"("id");



ALTER TABLE ONLY "public"."appointment_drugs"
    ADD CONSTRAINT "appointment_drugs_drug_id_fkey" FOREIGN KEY ("drug_id") REFERENCES "public"."drugs"("id");



ALTER TABLE ONLY "public"."appointment_fees"
    ADD CONSTRAINT "appointment_fees_appointment_id_fkey" FOREIGN KEY ("appointment_id") REFERENCES "public"."appointments"("id");



ALTER TABLE ONLY "public"."appointment_fees"
    ADD CONSTRAINT "appointment_fees_fee_id_fkey" FOREIGN KEY ("fee_id") REFERENCES "public"."fees"("id");



ALTER TABLE ONLY "public"."appointments"
    ADD CONSTRAINT "appointments_clinic_id_fkey" FOREIGN KEY ("clinic_id") REFERENCES "public"."clinics"("id");



ALTER TABLE ONLY "public"."appointments"
    ADD CONSTRAINT "appointments_date_id_fkey" FOREIGN KEY ("date_id") REFERENCES "public"."schedule_dates"("id");



ALTER TABLE ONLY "public"."appointments"
    ADD CONSTRAINT "appointments_doctor_id_fkey" FOREIGN KEY ("doctor_id") REFERENCES "public"."doctors"("id");



ALTER TABLE ONLY "public"."appointments"
    ADD CONSTRAINT "appointments_poly_id_fkey" FOREIGN KEY ("poly_id") REFERENCES "public"."polies"("id");



ALTER TABLE ONLY "public"."appointments"
    ADD CONSTRAINT "appointments_time_id_fkey" FOREIGN KEY ("time_id") REFERENCES "public"."schedule_times"("id");



ALTER TABLE ONLY "public"."doctors"
    ADD CONSTRAINT "doctors_clinic_id_fkey" FOREIGN KEY ("clinic_id") REFERENCES "public"."clinics"("id");



ALTER TABLE ONLY "public"."doctors"
    ADD CONSTRAINT "doctors_poly_id_fkey" FOREIGN KEY ("poly_id") REFERENCES "public"."polies"("id");



ALTER TABLE ONLY "public"."drug_patients"
    ADD CONSTRAINT "drug_patients_drug_id_fkey" FOREIGN KEY ("drug_id") REFERENCES "public"."drugs"("id");



ALTER TABLE ONLY "public"."drug_patients"
    ADD CONSTRAINT "drug_patients_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id");



ALTER TABLE ONLY "public"."transactions"
    ADD CONSTRAINT "fk_appointment_id" FOREIGN KEY ("appointment_id") REFERENCES "public"."appointments"("id");



ALTER TABLE ONLY "public"."transactions"
    ADD CONSTRAINT "fk_bank_id" FOREIGN KEY ("bank_id") REFERENCES "public"."banks"("id");



ALTER TABLE ONLY "public"."transactions"
    ADD CONSTRAINT "fk_user_id" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id");



ALTER TABLE ONLY "public"."polies"
    ADD CONSTRAINT "polies_clinic_id_fkey" FOREIGN KEY ("clinic_id") REFERENCES "public"."clinics"("id");



ALTER TABLE ONLY "public"."profiles"
    ADD CONSTRAINT "profiles_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id");



ALTER TABLE ONLY "public"."schedule_dates"
    ADD CONSTRAINT "schedule_dates_doctor_id_fkey" FOREIGN KEY ("doctor_id") REFERENCES "public"."doctors"("id");



ALTER TABLE ONLY "public"."schedule_dates"
    ADD CONSTRAINT "schedule_dates_poly_id_fkey" FOREIGN KEY ("poly_id") REFERENCES "public"."polies"("id");



ALTER TABLE ONLY "public"."schedule_times"
    ADD CONSTRAINT "schedule_times_date_id_fkey" FOREIGN KEY ("date_id") REFERENCES "public"."schedule_dates"("id");



ALTER TABLE ONLY "public"."symptoms"
    ADD CONSTRAINT "symptoms_poly_id_fkey" FOREIGN KEY ("poly_id") REFERENCES "public"."polies"("id");



ALTER TABLE ONLY "public"."user_roles"
    ADD CONSTRAINT "user_roles_role_id_fkey" FOREIGN KEY ("role_id") REFERENCES "public"."roles"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."user_roles"
    ADD CONSTRAINT "user_roles_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE CASCADE;





ALTER PUBLICATION "supabase_realtime" OWNER TO "postgres";






ALTER PUBLICATION "supabase_realtime" ADD TABLE ONLY "public"."appointments";



GRANT USAGE ON SCHEMA "public" TO "postgres";
GRANT USAGE ON SCHEMA "public" TO "anon";
GRANT USAGE ON SCHEMA "public" TO "authenticated";
GRANT USAGE ON SCHEMA "public" TO "service_role";




















































































































































































GRANT ALL ON FUNCTION "public"."expire_old_invites"() TO "anon";
GRANT ALL ON FUNCTION "public"."expire_old_invites"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."expire_old_invites"() TO "service_role";



GRANT ALL ON FUNCTION "public"."update_updated_at_column"() TO "anon";
GRANT ALL ON FUNCTION "public"."update_updated_at_column"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."update_updated_at_column"() TO "service_role";



























GRANT ALL ON TABLE "public"."abouts" TO "anon";
GRANT ALL ON TABLE "public"."abouts" TO "authenticated";
GRANT ALL ON TABLE "public"."abouts" TO "service_role";



GRANT ALL ON TABLE "public"."ai_apis" TO "anon";
GRANT ALL ON TABLE "public"."ai_apis" TO "authenticated";
GRANT ALL ON TABLE "public"."ai_apis" TO "service_role";



GRANT ALL ON TABLE "public"."appointment_drugs" TO "anon";
GRANT ALL ON TABLE "public"."appointment_drugs" TO "authenticated";
GRANT ALL ON TABLE "public"."appointment_drugs" TO "service_role";



GRANT ALL ON TABLE "public"."appointment_fees" TO "anon";
GRANT ALL ON TABLE "public"."appointment_fees" TO "authenticated";
GRANT ALL ON TABLE "public"."appointment_fees" TO "service_role";



GRANT ALL ON TABLE "public"."appointments" TO "anon";
GRANT ALL ON TABLE "public"."appointments" TO "authenticated";
GRANT ALL ON TABLE "public"."appointments" TO "service_role";



GRANT ALL ON TABLE "public"."banks" TO "anon";
GRANT ALL ON TABLE "public"."banks" TO "authenticated";
GRANT ALL ON TABLE "public"."banks" TO "service_role";



GRANT ALL ON TABLE "public"."cities" TO "anon";
GRANT ALL ON TABLE "public"."cities" TO "authenticated";
GRANT ALL ON TABLE "public"."cities" TO "service_role";



GRANT ALL ON TABLE "public"."clinics" TO "anon";
GRANT ALL ON TABLE "public"."clinics" TO "authenticated";
GRANT ALL ON TABLE "public"."clinics" TO "service_role";



GRANT ALL ON TABLE "public"."doctors" TO "anon";
GRANT ALL ON TABLE "public"."doctors" TO "authenticated";
GRANT ALL ON TABLE "public"."doctors" TO "service_role";



GRANT ALL ON TABLE "public"."drug_patients" TO "anon";
GRANT ALL ON TABLE "public"."drug_patients" TO "authenticated";
GRANT ALL ON TABLE "public"."drug_patients" TO "service_role";



GRANT ALL ON TABLE "public"."drugs" TO "anon";
GRANT ALL ON TABLE "public"."drugs" TO "authenticated";
GRANT ALL ON TABLE "public"."drugs" TO "service_role";



GRANT ALL ON TABLE "public"."faqs" TO "anon";
GRANT ALL ON TABLE "public"."faqs" TO "authenticated";
GRANT ALL ON TABLE "public"."faqs" TO "service_role";



GRANT ALL ON TABLE "public"."fees" TO "anon";
GRANT ALL ON TABLE "public"."fees" TO "authenticated";
GRANT ALL ON TABLE "public"."fees" TO "service_role";



GRANT ALL ON TABLE "public"."files" TO "anon";
GRANT ALL ON TABLE "public"."files" TO "authenticated";
GRANT ALL ON TABLE "public"."files" TO "service_role";



GRANT ALL ON TABLE "public"."help_centers" TO "anon";
GRANT ALL ON TABLE "public"."help_centers" TO "authenticated";
GRANT ALL ON TABLE "public"."help_centers" TO "service_role";



GRANT ALL ON TABLE "public"."notifications" TO "anon";
GRANT ALL ON TABLE "public"."notifications" TO "authenticated";
GRANT ALL ON TABLE "public"."notifications" TO "service_role";



GRANT ALL ON TABLE "public"."polies" TO "anon";
GRANT ALL ON TABLE "public"."polies" TO "authenticated";
GRANT ALL ON TABLE "public"."polies" TO "service_role";



GRANT ALL ON TABLE "public"."profiles" TO "anon";
GRANT ALL ON TABLE "public"."profiles" TO "authenticated";
GRANT ALL ON TABLE "public"."profiles" TO "service_role";



GRANT ALL ON TABLE "public"."roles" TO "anon";
GRANT ALL ON TABLE "public"."roles" TO "authenticated";
GRANT ALL ON TABLE "public"."roles" TO "service_role";



GRANT ALL ON TABLE "public"."schedule_dates" TO "anon";
GRANT ALL ON TABLE "public"."schedule_dates" TO "authenticated";
GRANT ALL ON TABLE "public"."schedule_dates" TO "service_role";



GRANT ALL ON TABLE "public"."schedule_times" TO "anon";
GRANT ALL ON TABLE "public"."schedule_times" TO "authenticated";
GRANT ALL ON TABLE "public"."schedule_times" TO "service_role";



GRANT ALL ON TABLE "public"."symptoms" TO "anon";
GRANT ALL ON TABLE "public"."symptoms" TO "authenticated";
GRANT ALL ON TABLE "public"."symptoms" TO "service_role";



GRANT ALL ON TABLE "public"."transactions" TO "anon";
GRANT ALL ON TABLE "public"."transactions" TO "authenticated";
GRANT ALL ON TABLE "public"."transactions" TO "service_role";



GRANT ALL ON TABLE "public"."user_roles" TO "anon";
GRANT ALL ON TABLE "public"."user_roles" TO "authenticated";
GRANT ALL ON TABLE "public"."user_roles" TO "service_role";



GRANT ALL ON TABLE "public"."users" TO "anon";
GRANT ALL ON TABLE "public"."users" TO "authenticated";
GRANT ALL ON TABLE "public"."users" TO "service_role";









ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES  TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES  TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES  TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES  TO "service_role";






ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS  TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS  TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS  TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS  TO "service_role";






ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES  TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES  TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES  TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES  TO "service_role";






























RESET ALL;
