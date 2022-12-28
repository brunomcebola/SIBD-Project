-------------------------------------------------------------
--
-- SIBD Project - Part 2
--
-- Bruno Cebola - 93030
-- João Nunes - 93100
-- Rui Abrantes - 93176
--
--------------------- DATABASE FUNCTIONS --------------------
--
DROP FUNCTION IF EXISTS ic1 CASCADE;
DROP FUNCTION IF EXISTS ic2 CASCADE;
DROP FUNCTION IF EXISTS ic3 CASCADE;
DROP FUNCTION IF EXISTS ic6 CASCADE;
--
-------------------------------------------------------------
--
CREATE FUNCTION ic1 (
    in_c_name varchar(70)
) RETURNS boolean AS 
$$
BEGIN
    RETURN 
        EXISTS (
            SELECT *
            FROM location
            WHERE c_name = in_c_name);
END
$$
LANGUAGE plpgsql;

CREATE FUNCTION ic2 (
    in_latitude numeric(8, 6), 
    in_longitude numeric(9, 6)
) RETURNS boolean AS
$$
BEGIN
    RETURN 1 <= (
        SELECT MIN(d.dist)
        FROM (
            SELECT 3443.8985*(ACOS(SIN(in_latitude * 3.14 / 180)*SIN(latitude * 3.14 / 180)+COS(in_latitude * 3.14 / 180)*COS(latitude * 3.14 / 180)*COS((longitude - in_longitude) * 3.14 / 180))) as dist
            FROM location) d);
END
$$
LANGUAGE plpgsql;

CREATE FUNCTION ic3 (
    in_c_name varchar(70), 
    in_b_cni varchar(20), 
    in_di_start_date date, 
    in_di_end_date date,
    in_s_mail varchar(254)
) RETURNS boolean AS
$$
BEGIN
    RETURN 
        EXISTS (
            SELECT *
            FROM authorised
            WHERE
                c_name = in_c_name
                AND b_cni = in_b_cni
                AND di_start_date = in_di_start_date
                AND di_end_date = in_di_end_date
                AND s_mail = in_s_mail);
END
$$
LANGUAGE plpgsql;

CREATE FUNCTION ic6 (
    in_c_name varchar(70), 
    in_b_cni varchar(20), 
    in_di_start_date date, 
    in_di_end_date date,
    in_s_mail varchar(254)
) RETURNS boolean AS
$$
BEGIN
    RETURN 
        EXISTS (
            SELECT *
            FROM authorised
            WHERE
                c_name = in_c_name
                AND b_cni = in_b_cni
                AND di_start_date = in_di_start_date
                AND di_end_date = in_di_end_date
                AND s_mail = in_s_mail) 
        AND EXISTS (
            SELECT *
            FROM senior
            WHERE s_email == in_s_mail);
END
$$
LANGUAGE plpgsql;
