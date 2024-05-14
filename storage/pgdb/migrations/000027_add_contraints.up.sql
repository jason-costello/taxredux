ALTER TABLE ONLY public.roll_values
    ADD CONSTRAINT main_rollvalues_pk PRIMARY KEY (id);

ALTER TABLE ONLY public.owners
    ADD CONSTRAINT owners_pkey PRIMARY KEY (id);

ALTER TABLE ONLY public.pending_urls
    ADD CONSTRAINT pending_urls_pk PRIMARY KEY (url);

ALTER TABLE ONLY public.proxies
    ADD CONSTRAINT proxies_pk PRIMARY KEY (ip);

ALTER TABLE ONLY public.xref_owners_properties
    ADD CONSTRAINT xref_owners_properties_pkey PRIMARY KEY (id);

ALTER TABLE ONLY public.properties
    ADD CONSTRAINT properties_pk PRIMARY KEY (id);

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