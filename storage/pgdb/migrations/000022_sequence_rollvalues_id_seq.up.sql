Drop Sequence if exists public."main_rollvalues_id_seq";

CREATE SEQUENCE public."main_rollvalues_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."main_rollvalues_id_seq" OWNER TO jc;
