-------------------------------------------------------------
--
-- SIBD Project - Part 3
--
-- Bruno Cebola - 93030
-- João Nunes - 93100
-- Rui Abrantes - 93176
--
-------------------- DATABASE ANALYTICS ----------------------
--
-- QUERY 1
--
-- Search per Month and Year because it shows the the evolution during the year
-- and some differences that may occur
--
SELECT DATE_PART('month',trip_start_date),DATE_PART('year',trip_start_date),COUNT(*)
FROM trip_info
GROUP BY ROLLUP (DATE_PART('month',trip_start_date),DATE_PART('year',trip_start_date));
--
--  QUERY 2
--
-- Search per location of origin within a country
--
SELECT country_name_origin,loc_name_origin,COUNT(*)
FROM trip_info
GROUP BY GROUPING SETS ((loc_name_origin, country_name_origin));