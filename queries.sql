SELECT
  *
FROM
  boat;

SELECT
  *
FROM
  trip;

-- The name of all boats that are used in some trip
SELECT DISTINCT
  b.name
FROM
  boat b
  INNER JOIN trip t ON b.cni = t.b_cni
    AND b.c_name = t.c_name;

-- The name of all boat that are not used in any trip
SELECT
  name
FROM
  boat
EXCEPT
SELECT
  b.name
FROM
  boat b
  INNER JOIN trip t ON b.cni = t.b_cni
    AND b.c_name = t.c_name;

