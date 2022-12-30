-------------------------------------------------------------
--
-- SIBD Project - Part 3
--
-- Bruno Cebola - 93030
-- João Nunes - 93100
-- Rui Abrantes - 93176
--
---------------------- DATABASE QUERIES ---------------------
--
\echo
--
-- 1) Which country has more boats registered than any other?
--
\echo '1) Which country has more boats registered than any other?'
SELECT country
FROM boat
GROUP BY country
HAVING COUNT(*) >= All (
  SELECT COUNT(*)
  FROM boat
  GROUP BY country);
--
-- 2) List all the sailors that have at least two certificates
--
\echo '2) List all the sailors that have at least two certificates'
SELECT *
FROM sailor s
NATURAL JOIN (
  SELECT sailor AS email
  FROM sailing_certificate
  GROUP BY sailor
  HAVING COUNT(*) >= 2) sc;
--
-- 3) Who are the sailors that have sailed to every location in 'Portugal'?
--
\echo '3) Who are the sailors that have sailed to every location in "Portugal"?'
SELECT * 
FROM sailor s
WHERE NOT EXISTS (
  SELECT latitude, longitude
  FROM location
  WHERE country_name = 'Portugal'
  EXCEPT
  SELECT to_latitude, to_longitude
  FROM trip t
  WHERE t.skipper = s.email
);
--
-- 4) List the sailors with the most skipped trips
--
\echo '4) List the sailors with the most skipped trips'
SELECT *
FROM sailor s
NATURAL JOIN (
  SELECT skipper AS email
  FROM trip
  GROUP BY skipper
  HAVING COUNT(*) >= All (
    SELECT COUNT(*)
    FROM trip
    GROUP BY skipper)) sc;
--
-- 5) List the sailors with the longest duration of trips (sum of trip durations) for the same
--    single reservation; display also the sum of the trips duration
--
\echo '5) List the sailors with the longest duration of trips (sum of trip durations) for the same'
\echo '   single reservation; display also the sum of the trips duration'