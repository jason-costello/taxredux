CREATE SEQUENCE public.land_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.land_id_seq OWNER TO jc;


ALTER SEQUENCE public.land_id_seq OWNED BY public.land.id;

ALTER TABLE ONLY public.land ALTER COLUMN id SET DEFAULT nextval('public.land_id_seq'::regclass);
