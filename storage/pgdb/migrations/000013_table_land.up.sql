CREATE TABLE public.land (
    id integer NOT NULL,
    number integer,
    land_type character varying(255),
    description text,
    acres double precision,
    square_feet double precision,
    eff_front double precision,
    eff_depth double precision,
    market_value integer,
    property_id integer
);


ALTER TABLE public.land OWNER TO jc;


ALTER TABLE ONLY public.land
    ADD CONSTRAINT land_pk PRIMARY KEY (id);

CREATE INDEX land_property_id_index ON public.land USING btree (property_id);

