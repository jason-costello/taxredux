Drop Function if exists public.f_pct_calc;
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