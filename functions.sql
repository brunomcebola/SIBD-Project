-- Project Part II
--
---------------------- DATABASE FUNCTIONS -------------------
--
-------------------------------------------------------------
--
DROP FUNCTION IF EXISTS ic1 CASCADE;

--
-------------------------------------------------------------
--
CREATE FUNCTION ic1 (in_c_name varchar(70))
    RETURNS numeric
    AS $$
BEGIN
    RETURN (
        SELECT
            count(*)
        FROM
            location
        WHERE
            c_name = in_c_name);
END
$$
LANGUAGE plpgsql;

CREATE FUNCTION ic3 (in_c_name, in_b_cni, in_di_start_date, in_di_end_date, in_s_mail)
    RETURNS boolean
    AS $$
BEGIN
    RETURN EXISTS (
        SELECT
            *
        FROM
            authorised
        WHERE
            c_name = in_c_name
            AND b_cni = in_b_cni
            AND di_start_date = in_di_start_date
            AND di_end_date = in_di_end_date
            AND s_mail = in_s_mail);
END
$$
LANGUAGE plpgsqlu
