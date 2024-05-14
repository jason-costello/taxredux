CREATE TABLE if not exists public.improvement_detail (
    id integer NOT NULL,
    improvement_id integer,
    improvement_type character varying(255),
    description text,
    class character varying(255),
    exterior_wall character varying(255),
    year_built integer,
    square_feet integer
);


ALTER TABLE public.improvement_detail OWNER TO jc;


CREATE SEQUENCE public."improvementDetail_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."improvementDetail_id_seq" OWNER TO jc;


ALTER SEQUENCE public."improvementDetail_id_seq" OWNED BY public.improvement_detail.id;

ALTER TABLE ONLY public.improvement_detail ALTER COLUMN id SET DEFAULT nextval('public."improvementDetail_id_seq"'::regclass);

ALTER TABLE ONLY public.improvement_detail
    ADD CONSTRAINT improvementdetail_pk PRIMARY KEY (id);

CREATE INDEX improvement_detail_improvement_id_index ON public.improvement_detail USING btree (improvement_id);



CREATE INDEX improvement_detail_year_built_index ON public.improvement_detail USING btree (year_built);



CREATE INDEX improvementdetail_yearbuilt_index ON public.improvement_detail USING btree (year_built);

