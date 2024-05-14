CREATE TABLE public.improvements (
    id integer NOT NULL,
    name text,
    description text,
    state_code character varying(255),
    living_area double precision DEFAULT 0.0,
    value double precision DEFAULT 0.0,
    property_id integer
);


ALTER TABLE public.improvements OWNER TO jc;


CREATE SEQUENCE public.improvements_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.improvements_id_seq OWNER TO jc;


ALTER SEQUENCE public.improvements_id_seq OWNED BY public.improvements.id;


ALTER TABLE ONLY public.improvements ALTER COLUMN id SET DEFAULT nextval('public.improvements_id_seq'::regclass);


ALTER TABLE ONLY public.improvements
    ADD CONSTRAINT improvements_pk PRIMARY KEY (id);


CREATE INDEX improvements_living_area_index ON public.improvements USING btree (living_area);



CREATE INDEX improvements_property_id_index ON public.improvements USING btree (property_id);

