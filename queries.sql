-------------------------------------------------------------
--
-- SIBD Project - Part 2
--
-- Bruno Cebola - 93030
-- João Nunes - 93100
-- Rui Abrantes - 93176
--
---------------------- DATABASE QUERIES ---------------------
--
-- 1) Which country has more boats registered than any other?
--
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

--
-- 4) List the sailors with the most skipped trips
--
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
