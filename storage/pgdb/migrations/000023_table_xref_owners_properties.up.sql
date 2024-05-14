CREATE TABLE public.xref_owners_properties (
    id integer NOT NULL,
    owner_id integer,
    property_id integer,
    ownership_share character varying(10),
    tax_year integer,
    update_date timestamp with time zone
);


ALTER TABLE public.xref_owners_properties OWNER TO jc;



