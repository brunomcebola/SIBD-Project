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
SELECT *
FROM sailor s
NATURAL JOIN (
  SELECT t1.skipper as email, SUM((t1.arrival - t1.takeoff) + 1) as trips_duration_sum 
  FROM trip t1
  GROUP BY t1.reservation_start_date, t1.reservation_end_date, t1.boat_country, t1.cni, t1.skipper
  HAVING SUM((t1.arrival - t1.takeoff) + 1) >= ALL (
    SELECT SUM((t2.arrival - t2.takeoff) + 1)
    FROM trip t2
    WHERE (
      t1.reservation_start_date = t2.reservation_start_date AND 
      t1.reservation_end_date = t2.reservation_end_date AND 
      t1.boat_country = t2.boat_country AND 
      t1.cni = t2.cni)
    GROUP BY reservation_start_date, reservation_end_date, boat_country, cni, skipper
  )) t;