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

-- The name of all boats registered in 'PRT' for which at least one
-- responsible for a reservation has a surname that ends with 'Santos'
SELECT
  b.name
FROM
  boat b
  INNER JOIN country c ON b.c_name = c.name
WHERE
  c.iso_code = 'PRT'
  AND EXISTS (
    SELECT
      r.b_cni
    FROM
      reservation r
    LEFT JOIN sailor s ON r.s_email = s.email
  WHERE
    s.surname LIKE '%Santos'
    AND r.b_cni = b.cni);

-- The full name of all skippers without any certification
-- corresponding to the class of the trip's boat
SELECT
  CONCAT(s.first_name, ' ', s.surname) AS full_name
FROM
  sailor s
  INNER JOIN (
    SELECT
      t.s_email,
      b.bc_name
    FROM
      trip t
      LEFT JOIN boat b ON t.b_cni = b.cni
  EXCEPT
  SELECT
    s_email,
    bc_name
  FROM
    sailing_certificate) a ON a.s_email = s.email
