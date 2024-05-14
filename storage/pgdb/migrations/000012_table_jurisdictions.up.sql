CREATE TABLE public.jurisdictions (
    id integer NOT NULL,
    entity character varying(255),
    description text,
    tax_rate integer,
    appraised_value integer,
    taxable_value integer,
    estimated_tax integer,
    property_id integer,
    updated_at timestamp with time zone,
    created_at timestamp with time zone
);


ALTER TABLE public.jurisdictions OWNER TO jc;


CREATE SEQUENCE public.jurisdictions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.jurisdictions_id_seq OWNER TO jc;


ALTER SEQUENCE public.jurisdictions_id_seq OWNED BY public.jurisdictions.id;

ALTER TABLE ONLY public.jurisdictions ALTER COLUMN id SET DEFAULT nextval('public.jurisdictions_id_seq'::regclass);

ALTER TABLE ONLY public.jurisdictions
    ADD CONSTRAINT jurisdictions_pk PRIMARY KEY (id);


CREATE INDEX jurisdictions_property_id_index ON public.jurisdictions USING btree (property_id);

