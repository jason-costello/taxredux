



CREATE SCHEMA tiger;


ALTER SCHEMA tiger OWNER TO postgres;


CREATE SCHEMA tiger_data;


ALTER SCHEMA tiger_data OWNER TO postgres;


CREATE FUNCTION public.f_pct_calc(year1 integer, year2 integer) RETURNS TABLE(property_id integer, pct numeric)
    LANGUAGE sql STABLE
    AS $_$
SELECT r.property_id
     ,       (sum(r.land_market) FILTER (WHERE year = $2) * 100)
    / NULLIF(sum(r.land_market) FILTER (WHERE year = $1), 0) AS pct
FROM   roll_values as r
WHERE  r.year IN ($1, $2)
  AND    r.property_id = 1 -- ??
GROUP  BY r.property_id;
    -- ORDER BY ???
$_$;


ALTER FUNCTION public.f_pct_calc(year1 integer, year2 integer) OWNER TO jc;


CREATE FUNCTION public.f_pct_diff(last_year_val double precision, curr_year_val double precision) RETURNS TABLE(perc_diff double precision)
    LANGUAGE sql STABLE
    AS $$

select
    (case when last_year_val > 0 then
    abs(curr_year_val - last_year_val)::float / ((curr_year_val + last_year_val)::float/2)::float * 100::float
    else
    0
    end)::float
    $$;


ALTER FUNCTION public.f_pct_diff(last_year_val double precision, curr_year_val double precision) OWNER TO jc;


CREATE FUNCTION public.f_pct_diff2(last_year_val integer, curr_year_val integer) RETURNS TABLE(perc_diff double precision)
    LANGUAGE sql STABLE
    AS $$
SELECT ((abs(curr_year_val - last_year_val)::float / (curr_year_val + last_year_val)::float / 2) * 100)::float
$$;


ALTER FUNCTION public.f_pct_diff2(last_year_val integer, curr_year_val integer) OWNER TO jc;


CREATE FUNCTION public.f_pct_diff3(last_year_val integer, curr_year_val integer) RETURNS TABLE(perc_diff double precision)
    LANGUAGE sql STABLE
    AS $$
select abs(curr_year_val - last_year_val) / ((curr_year_val + last_year_val)/2) * 100
    $$;


ALTER FUNCTION public.f_pct_diff3(last_year_val integer, curr_year_val integer) OWNER TO jc;


CREATE FUNCTION public.f_pct_diff4(last_year_val integer, curr_year_val integer) RETURNS TABLE(perc_diff double precision)
    LANGUAGE sql STABLE
    AS $$
select abs(curr_year_val - last_year_val)::float / ((curr_year_val + last_year_val)::float/2)::float * 100::float
    $$;


ALTER FUNCTION public.f_pct_diff4(last_year_val integer, curr_year_val integer) OWNER TO jc;


CREATE PROCEDURE public.isexistingproperty(INOUT propertyid integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
select exists(select 1 from properties where id=propertyID);
END;
    $$;


ALTER PROCEDURE public.isexistingproperty(INOUT propertyid integer) OWNER TO jc;




CREATE TABLE public.improvement_detail (
    id integer NOT NULL,
    improvement_id integer,
    improvement_type character varying(255),
    description text,
    class character varying(255),
    exterior_wall character varying(255),
    year_built integer,
    square_feet integer
);


ALTER TABLE public.improvement_detail OWNER TO jc;


CREATE SEQUENCE public."improvementDetail_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."improvementDetail_id_seq" OWNER TO jc;


ALTER SEQUENCE public."improvementDetail_id_seq" OWNED BY public.improvement_detail.id;



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


CREATE VIEW public.land_and_improve_values AS
 SELECT DISTINCT r.id,
    r.year,
    r.improvements,
    r.land_market,
    r.ag_valuation,
    r.appraised,
    r.homestead_cap,
    r.assessed,
    r.property_id,
    mv.land_acres,
        CASE
            WHEN (r.land_market > 0) THEN ((r.land_market)::double precision / mv.land_acres)
            ELSE (0.0)::double precision
        END AS value_per_acre,
    iv.living_area,
    l.description,
    p.neighborhood,
        CASE
            WHEN (r.improvements > 0) THEN ((r.improvements)::double precision / iv.living_area)
            ELSE (0.0)::double precision
        END AS value_per_sqft
   FROM (((((public.roll_values r
     JOIN public.properties p ON ((p.id = r.property_id)))
     JOIN public.land l ON ((r.property_id = l.property_id)))
     JOIN ( SELECT land.property_id AS prop_id,
            sum(land.acres) AS land_acres
           FROM public.land
          WHERE (land.acres > (0)::double precision)
          GROUP BY land.property_id) mv ON ((r.property_id = mv.prop_id)))
     JOIN public.improvements i ON ((r.property_id = i.property_id)))
     JOIN ( SELECT improvements.property_id AS prop_id,
            sum(improvements.living_area) AS living_area
           FROM public.improvements
          WHERE (improvements.living_area > (0)::double precision)
          GROUP BY improvements.property_id) iv ON ((r.property_id = iv.prop_id)));


ALTER TABLE public.land_and_improve_values OWNER TO postgres;


CREATE SEQUENCE public.land_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.land_id_seq OWNER TO jc;


ALTER SEQUENCE public.land_id_seq OWNED BY public.land.id;



CREATE SEQUENCE public."main_rollValues_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."main_rollValues_id_seq" OWNER TO jc;


ALTER SEQUENCE public."main_rollValues_id_seq" OWNED BY public.roll_values.id;



CREATE SEQUENCE public.main_rollvalues_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.main_rollvalues_id_seq OWNER TO jc;


CREATE TABLE public.owners (
    id integer NOT NULL,
    owner_name character varying(255),
    owner_mailing_address character varying(255)
);


ALTER TABLE public.owners OWNER TO jc;


CREATE TABLE public.pending_urls (
    url text NOT NULL
);


ALTER TABLE public.pending_urls OWNER TO jc;


CREATE TABLE public.proxies (
    ip text NOT NULL,
    lastused text,
    uses integer,
    is_bad integer
);


ALTER TABLE public.proxies OWNER TO jc;


CREATE TABLE public.schema_migrations (
    version bigint NOT NULL,
    dirty boolean NOT NULL
);


ALTER TABLE public.schema_migrations OWNER TO postgres;


CREATE TABLE public.xref_owners_properties (
    id integer NOT NULL,
    owner_id integer,
    property_id integer,
    ownership_share character varying(10),
    tax_year integer,
    update_date timestamp with time zone
);


ALTER TABLE public.xref_owners_properties OWNER TO jc;


ALTER TABLE ONLY public.improvement_detail ALTER COLUMN id SET DEFAULT nextval('public."improvementDetail_id_seq"'::regclass);



ALTER TABLE ONLY public.improvements ALTER COLUMN id SET DEFAULT nextval('public.improvements_id_seq'::regclass);



ALTER TABLE ONLY public.jurisdictions ALTER COLUMN id SET DEFAULT nextval('public.jurisdictions_id_seq'::regclass);



ALTER TABLE ONLY public.land ALTER COLUMN id SET DEFAULT nextval('public.land_id_seq'::regclass);



ALTER TABLE ONLY public.roll_values ALTER COLUMN id SET DEFAULT nextval('public."main_rollValues_id_seq"'::regclass);



ALTER TABLE ONLY public.improvement_detail
    ADD CONSTRAINT improvementdetail_pk PRIMARY KEY (id);



ALTER TABLE ONLY public.improvements
    ADD CONSTRAINT improvements_pk PRIMARY KEY (id);



ALTER TABLE ONLY public.jurisdictions
    ADD CONSTRAINT jurisdictions_pk PRIMARY KEY (id);



ALTER TABLE ONLY public.land
    ADD CONSTRAINT land_pk PRIMARY KEY (id);



ALTER TABLE ONLY public.roll_values
    ADD CONSTRAINT main_rollvalues_pk PRIMARY KEY (id);



ALTER TABLE ONLY public.owners
    ADD CONSTRAINT owners_pkey PRIMARY KEY (id);



ALTER TABLE ONLY public.pending_urls
    ADD CONSTRAINT pending_urls_pk PRIMARY KEY (url);



ALTER TABLE ONLY public.properties
    ADD CONSTRAINT properties_pk PRIMARY KEY (id);



ALTER TABLE ONLY public.proxies
    ADD CONSTRAINT proxies_pk PRIMARY KEY (ip);



ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);



ALTER TABLE ONLY public.xref_owners_properties
    ADD CONSTRAINT xref_owners_properties_pkey PRIMARY KEY (id);



CREATE INDEX improvement_detail_improvement_id_index ON public.improvement_detail USING btree (improvement_id);



CREATE INDEX improvement_detail_year_built_index ON public.improvement_detail USING btree (year_built);



CREATE INDEX improvementdetail_yearbuilt_index ON public.improvement_detail USING btree (year_built);



CREATE INDEX improvements_living_area_index ON public.improvements USING btree (living_area);



CREATE INDEX improvements_property_id_index ON public.improvements USING btree (property_id);



CREATE INDEX jurisdictions_property_id_index ON public.jurisdictions USING btree (property_id);



CREATE INDEX land_property_id_index ON public.land USING btree (property_id);



CREATE INDEX properties_city_index ON public.properties USING btree (city);



CREATE INDEX properties_neighborhood_index ON public.properties USING btree (neighborhood);



CREATE INDEX properties_street_index ON public.properties USING btree (street);



CREATE INDEX roll_values_property_id_index ON public.roll_values USING btree (property_id);



ALTER TABLE ONLY public.improvement_detail
    ADD CONSTRAINT improvement_detail_improvement_id_fkey FOREIGN KEY (improvement_id) REFERENCES public.improvements(id) NOT VALID;



ALTER TABLE ONLY public.improvements
    ADD CONSTRAINT improvements_property_id_fkey FOREIGN KEY (property_id) REFERENCES public.properties(id) NOT VALID;



ALTER TABLE ONLY public.jurisdictions
    ADD CONSTRAINT jurisdictions_property_id_fkey FOREIGN KEY (property_id) REFERENCES public.properties(id) NOT VALID;



ALTER TABLE ONLY public.land
    ADD CONSTRAINT land_property_id_fkey FOREIGN KEY (property_id) REFERENCES public.properties(id) NOT VALID;



ALTER TABLE ONLY public.roll_values
    ADD CONSTRAINT roll_values_property_id_fkey FOREIGN KEY (property_id) REFERENCES public.roll_values(id) NOT VALID;



