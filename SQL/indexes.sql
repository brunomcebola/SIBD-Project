-------------------------------------------------------------
--
-- SIBD Project - Part 3
--
-- Bruno Cebola - 93030
-- João Nunes - 93100
-- Rui Abrantes - 93176
--
-------------------- DATABASE INDEXES -----------------------
--
-- 7.1 (no need to specify index type since default is btree)
--
CREATE INDEX boat_name_idx ON boat(class, year)
--
-- 7.2 (no need to specify index type since default is btree)
--
CREATE INDEX boat_country_idx ON boat(country);