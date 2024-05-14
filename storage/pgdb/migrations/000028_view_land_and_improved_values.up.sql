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