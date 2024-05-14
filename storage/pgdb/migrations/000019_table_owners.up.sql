CREATE TABLE public.owners (
    id integer NOT NULL,
    owner_name character varying(255),
    owner_mailing_address character varying(255)
);


ALTER TABLE public.owners OWNER TO jc;


