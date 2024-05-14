
CREATE TABLE public.proxies (
    ip text NOT NULL,
    lastused text,
    uses integer,
    is_bad integer
);


ALTER TABLE public.proxies OWNER TO jc;

