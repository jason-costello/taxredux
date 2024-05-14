Drop Function if exists public.f_pct_diff;
Drop Function if exists public.f_pct_diff2;
Drop Function if exists public.f_pct_diff3;
Drop Function if exists public.f_pct_diff4;

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
