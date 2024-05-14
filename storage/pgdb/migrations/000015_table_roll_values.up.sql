CREATE TABLE public.roll_values (
    id integer NOT NULL,
    year integer,
    improvements integer,
    land_market integer,
    ag_valuation integer,
    appraised integer,
    homestead_cap integer,
    assessed integer,
    property_id integer
);


ALTER TABLE public.roll_values OWNER TO jc;



CREATE INDEX roll_values_property_id_index ON public.roll_values USING btree (property_id);

