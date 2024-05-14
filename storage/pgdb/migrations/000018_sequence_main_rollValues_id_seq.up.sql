
Drop Sequence if exists public."main_rollValues_id_seq";
CREATE SEQUENCE public."main_rollValues_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."main_rollValues_id_seq" OWNER TO jc;


ALTER SEQUENCE public."main_rollValues_id_seq" OWNED BY public.roll_values.id;

ALTER TABLE ONLY public.roll_values ALTER COLUMN id SET DEFAULT nextval('public."main_rollValues_id_seq"'::regclass);
