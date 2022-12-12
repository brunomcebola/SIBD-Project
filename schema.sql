-- Project Part II
--
---------------------- DATABASE SCHEMA ----------------------
--
-- Note:
--
-- Named constraints are global to the database.
-- Therefore the following use the following naming rules:
--   1. pk_table for names of primary key constraints
--   2. fk_table_another for names of foreign key constraints
--   3. ck_table_description for names of check contrains
--   4. uk_table_field for names of unique constrains
--
-------------------------------------------------------------
--
DROP FUNCTION IF EXISTS nb_country_locations CASCADE;

--
-------------------------------------------------------------
--
CREATE FUNCTION nb_country_locations (in_c_name varchar(70))
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

CREATE FUNCTION check_if_skiper_is_authorized (in_c_name, in_b_cni, in_di_start_date, in_di_end_date, in_s_mail)
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
LANGUAGE plpgsql;

--
-------------------------------------------------------------
--
DROP TABLE IF EXISTS country CASCADE;

DROP TABLE IF EXISTS location CASCADE;

DROP TABLE IF EXISTS sailor CASCADE;

DROP TABLE IF EXISTS junior CASCADE;

DROP TABLE IF EXISTS senior CASCADE;

DROP TABLE IF EXISTS boat_class CASCADE;

DROP TABLE IF EXISTS boat CASCADE;

DROP TABLE IF EXISTS sailing_certificate CASCADE;

DROP TABLE IF EXISTS valid_for CASCADE;

DROP TABLE IF EXISTS date_interval CASCADE;

DROP TABLE IF EXISTS reservation CASCADE;

DROP TABLE IF EXISTS authorised CASCADE;

DROP TABLE IF EXISTS trip CASCADE;

--
-------------------------------------------------------------
--
CREATE TABLE country (
    name varchar(70),
    flag varchar(2083) NOT NULL,
    iso_code varchar(3) NOT NULL,
    CONSTRAINT pk_country PRIMARY KEY (name),
    CONSTRAINT uk_country_iso_code UNIQUE (iso_code)
);

CREATE TABLE location (
    latitude numeric(8, 6),
    longitude numeric(9, 6),
    c_name varchar(70) NOT NULL,
    name varchar(80) NOT NULL,
    CONSTRAINT pk_location PRIMARY KEY (latitude, longitude),
    CONSTRAINT fk_location_country FOREIGN KEY (c_name) REFERENCES country (name)
);

CREATE TABLE sailor (
    email varchar(254),
    surname varchar(40) NOT NULL,
    first_name varchar(40) NOT NULL,
    CONSTRAINT pk_sailor PRIMARY KEY (email)
    -- Every sailor must exist either in the table 'senior' or
    -- in the table 'junior', but never in both at the same time
);

CREATE TABLE junior (
    s_email varchar(254),
    CONSTRAINT pk_junior PRIMARY KEY (s_email),
    CONSTRAINT fk_junior_sailor FOREIGN KEY (s_email) REFERENCES sailor (email)
);

CREATE TABLE senior (
    s_email varchar(254),
    CONSTRAINT pk_senior PRIMARY KEY (s_email),
    CONSTRAINT fk_senior_sailor FOREIGN KEY (s_email) REFERENCES sailor (email)
);

CREATE TABLE boat_class (
    name varchar(80),
    max_length numeric(5, 2) NOT NULL,
    CONSTRAINT pk_boat_class PRIMARY KEY (name)
);

CREATE TABLE boat (
    c_name varchar(70),
    cni varchar(20),
    bc_name varchar(80) NOT NULL,
    name varchar(80) NOT NULL,
    length numeric(5, 2) NOT NULL,
    year numeric(4, 0) NOT NULL,
    CONSTRAINT pk_boat PRIMARY KEY (c_name, cni),
    CONSTRAINT fk_boat_country FOREIGN KEY (c_name) REFERENCES country (name),
    CONSTRAINT fk_boat_boat_class FOREIGN KEY (bc_name) REFERENCES boat_class (name),
    CONSTRAINT ck_boat_country_has_locations CHECK (nb_country_locations (c_name) > 0)
);

CREATE TABLE sailing_certificate (
    s_email varchar(254),
    issue_date date,
    bc_name varchar(80) NOT NULL,
    expiry_date date NOT NULL,
    CONSTRAINT pk_sailing_certificate PRIMARY KEY (s_email, issue_date),
    CONSTRAINT fk_sailing_certificate_sailor FOREIGN KEY (s_email) REFERENCES sailor (email),
    CONSTRAINT fk_sailing_certificate_boat_class FOREIGN KEY (bc_name) REFERENCES boat_class (name)
    -- Every sailing certificate must exist in the table 'valid_for'
);

CREATE TABLE valid_for (
    c_name varchar(70),
    s_email varchar(254),
    sc_issue_date date,
    CONSTRAINT pk_valid_for PRIMARY KEY (c_name, s_email, sc_issue_date),
    CONSTRAINT fk_valid_for_country FOREIGN KEY (c_name) REFERENCES country (name),
    CONSTRAINT fk_valid_for_sailing_certificate FOREIGN KEY (s_email, sc_issue_date) REFERENCES sailing_certificate (s_email, issue_date)
);

CREATE TABLE date_interval (
    start_date date,
    end_date date,
    CONSTRAINT pk_date_interval PRIMARY KEY (start_date, end_date)
);

CREATE TABLE reservation (
    c_name varchar(70),
    b_cni varchar(20),
    di_start_date date,
    di_end_date date,
    s_email varchar(254) NOT NULL,
    CONSTRAINT pk_reservation PRIMARY KEY (c_name, b_cni, di_start_date, di_end_date),
    CONSTRAINT fk_reservation_boat FOREIGN KEY (c_name, b_cni) REFERENCES boat (c_name, cni),
    CONSTRAINT fk_reservation_date_interval FOREIGN KEY (di_start_date, di_end_date) REFERENCES date_interval (start_date, end_date),
    CONSTRAINT fk_reservation_senior FOREIGN KEY (s_email) REFERENCES senior (s_email)
    -- Every reservation must exist in the table 'authorised'
);

CREATE TABLE authorised (
    c_name varchar(70),
    b_cni varchar(20),
    di_start_date date,
    di_end_date date,
    s_email varchar(254),
    CONSTRAINT pk_authorised PRIMARY KEY (c_name, b_cni, di_start_date, di_end_date, s_email),
    CONSTRAINT fk_authorised_reservation FOREIGN KEY (c_name, b_cni, di_start_date, di_end_date) REFERENCES reservation (c_name, b_cni, di_start_date, di_end_date),
    CONSTRAINT fk_authorised_sailor FOREIGN KEY (s_email) REFERENCES sailor (email)
);

CREATE TABLE trip (
    c_name varchar(70),
    b_cni varchar(20),
    di_start_date date,
    di_end_date date,
    take_off date,
    arrival date NOT NULL,
    insurance varchar(80) NOT NULL,
    s_email varchar(254) NOT NULL,
    to_l_latitude numeric(8, 6) NOT NULL,
    to_l_longitude numeric(9, 6) NOT NULL,
    from_l_latitude numeric(8, 6) NOT NULL,
    from_l_longitude numeric(9, 6) NOT NULL,
    CONSTRAINT pk_trip PRIMARY KEY (c_name, b_cni, di_start_date, di_end_date, take_off),
    CONSTRAINT fk_trip_reservation FOREIGN KEY (c_name, b_cni, di_start_date, di_end_date) REFERENCES reservation (c_name, b_cni, di_start_date, di_end_date),
    CONSTRAINT fk_trip_sailor FOREIGN KEY (s_email) REFERENCES sailor (email),
    CONSTRAINT fk_trip_to_location FOREIGN KEY (to_l_latitude, to_l_longitude) REFERENCES location (latitude, longitude),
    CONSTRAINT fk_trip_from_location FOREIGN KEY (from_l_latitude, from_l_longitude) REFERENCES location (latitude, longitude),
    CONSTRAINT ck_trip_take_off_after_reservation_start_date CHECK (take_off >= di_start_date)
);

------------- POPULATE THE DATA BASE ------------
-- Inserts Basically
------------- SIMPLE SQL QUERIES ----------------
-- The name of all boats that are used in some trip.
-- The name of all boats that are not used in any trip
-- The name of all boats registered in 'PRT' (ISO code) for which at least one responsible for a reservation has a surname that ends with 'Santos
-- The full name of all skipper without any certificate corresponding to the class of the trip's boat
