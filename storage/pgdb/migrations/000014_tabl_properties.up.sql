CREATE TABLE public.properties (
    id integer NOT NULL,
    zoning character varying(255),
    neighborhood_cd character varying(255),
    neighborhood character varying(500),
    address character varying(500),
    legal_description character varying(500),
    geographic_id character varying(255),
    exemptions character varying(255),
    ownership_percentage numeric,
    mapsco_map_id character varying(255),
    longitude numeric,
    latitude numeric,
    address_number character varying(255) DEFAULT 0 NOT NULL,
    address_line_two character varying(255),
    city character varying(255),
    street character varying(255),
    county character varying(255),
    state character varying(2),
    created_at timestamp with time zone,
    updated_at timestamp with time zone
);


ALTER TABLE public.properties OWNER TO jc;


CREATE INDEX properties_city_index ON public.properties USING btree (city);



CREATE INDEX properties_neighborhood_index ON public.properties USING btree (neighborhood);



CREATE INDEX properties_street_index ON public.properties USING btree (street);


