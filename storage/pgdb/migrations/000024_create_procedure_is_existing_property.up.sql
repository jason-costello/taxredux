
Drop procedure if exists public.isexistingproperty;
CREATE PROCEDURE  public.isexistingproperty(INOUT propertyid integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
select exists(select 1 from properties where id=propertyID);
END;
    $$;


ALTER PROCEDURE public.isexistingproperty(INOUT propertyid integer) OWNER TO jc;


