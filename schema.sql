-- Project Part II
--
--
--TODO: colocar drops corretos
DROP TABLE IF EXISTS country CASCADE;

DROP TABLE IF EXISTS location CASCADE;

DROP TABLE IF EXISTS sailor CASCADE;

DROP TABLE IF EXISTS junior CASCADE;

DROP TABLE IF EXISTS senior CASCADE;

DROP TABLE IF EXISTS boat_class CASCADE;

DROP TABLE IF EXISTS boat CASCADE;

---------------------- DATABASE SCHEMA ----------------------
--
-- Note:
--
-- Named constraints are global to the database.
-- Therefore the following use the following naming rules:
--   1. pk_table for names of primary key constraints
--   2. fk_table_another for names of foreign key constraints
--   3. ck_description for names of check contrains
--   4. uk_table_field for names of unique constrains
--
-------------------------------------------------------------
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
    country_name varchar(70) NOT NULL,
    name varchar(80) NOT NULL,
    CONSTRAINT pk_location PRIMARY KEY (latitude, longitude),
    CONSTRAINT fk_location_country FOREIGN KEY (country_name) REFERENCES country (name)
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
    email varchar(254),
    CONSTRAINT pk_junior PRIMARY KEY (email),
    CONSTRAINT fk_junior_sailor FOREIGN KEY (email) REFERENCES sailor (email)
);

CREATE TABLE senior (
    email varchar(254),
    CONSTRAINT pk_senior PRIMARY KEY (email),
    CONSTRAINT fk_senior_sailor FOREIGN KEY (email) REFERENCES sailor (email)
);

CREATE TABLE boat_class (
    name varchar(80),
    max_length numeric(4, 2) NOT NULL,
    CONSTRAINT pk_boat_class PRIMARY KEY (name)
);

CREATE TABLE boat (
    country_name varchar(70),
    cni varchar(20),
    boat_class_name varchar(80) NOT NULL,
    name varchar(80) NOT NULL,
    length numeric(4, 2) NOT NULL,
    year smallint NOT NULL,
    CONSTRAINT pk_boat PRIMARY KEY (country_name, cni),
    CONSTRAINT fk_boat_country FOREIGN KEY (country_name) REFERENCES country (name),
    CONSTRAINT fk_boat_boat_class FOREIGN KEY (boat_class_name) REFERENCES boat_class (name)
);

INSERT INTO country
    VALUES ('test_country', 'url:flag', 'PRT');

--
--
--
-- CREATE TABLE date_interval (
--     start_date date,
--     end_date date,
--     PRIMARY KEY (start_date, end_date)
-- );
-- CREATE TABLE sailing_certificate (
--     issue_date date,
--     expiry_date date,
--     email varchar(254), --certified association
--     certificate_class varchar(80), --for-class association
--     PRIMARY KEY (issue_date, email),
--     FOREIGN KEY (email) REFERENCES sailor (email),
--     FOREIGN KEY (certificate_class) REFERENCES boat_class (name)
--     --every sailing certificate must have an associated country
-- );
-- CREATE TABLE reservation (
--     --NOT SURE?
--     b_cni varchar(20),
--     b_cname varchar(80),
--     int_start_date date,
--     int_end_date date,
--     responsible_email varchar(254),
--     PRIMARY KEY (b_cni, b_cname, int_start_date, int_end_date),
--     FOREIGN KEY (b_cni, b_cname) REFERENCES boat (cni, cname),
--     FOREIGN KEY (int_start_date, int_end_date) REFERENCES date_interval (start_date, end_date),
--     FOREIGN KEY (responsible_email) REFERENCES senior (email)
--     --every reservation must have an authorized sailor
-- );
-- CREATE TABLE trip (
--     take_off date,
--     arrival date,
--     insurance varchar(80),
--     r_b_cni varchar(20), --reservation cni
--     r_b_cname varchar(80), --reservation cname
--     r_int_start_date date, --reservation start
--     r_int_end_date date, --reservation end
--     skipper_email varchar(254),
--     location_to_lat numeric(8, 6), --latitude of destination
--     location_to_long numeric(9, 6), --longitude of destination
--     location_from_lat numeric(8, 6), --latitude of starting location
--     location_from_long numeric(9, 6), --longitude of starting location
--     PRIMARY KEY (take_off, r_b_cni, r_b_cname, r_int_start_date, r_int_end_date),
--     FOREIGN KEY (r_b_cni, r_b_cname, r_int_start_date, r_int_end_date) REFERENCES reservation (b_cni, b_cname, int_start_date, int_end_date),
--     FOREIGN KEY (skipper_email) REFERENCES sailor (email),
--     FOREIGN KEY (location_to_lat, location_to_long) REFERENCES location (latitude, longitude), --to association
--     FOREIGN KEY (location_from_lat, location_from_long) REFERENCES location (latitude, longitude), --from association
--     CHECK (take_off > r_int_start_date)
-- );
-- CREATE TABLE valid_for (
--     --NOT SURE?
--     c_name varchar(80),
--     s_email varchar(254),
--     cert_issue_date date,
--     PRIMARY KEY (c_name, s_email, cert_issue_date),
--     FOREIGN KEY (s_email, cert_issue_date) REFERENCES sailing_certificate (email, issue_date),
--     FOREIGN KEY (c_name) REFERENCES country (name)
-- );
-- CREATE TABLE authorized (
--     r_b_cni varchar(20), --reservation cni
--     r_b_cname varchar(80), --reservation cname
--     r_int_start_date date, --reservation start
--     r_int_end_date date, --reservation end
--     s_email varchar(254),
--     PRIMARY KEY (s_email, r_b_cni, r_b_cname, r_int_start_date, r_int_end_date),
--     FOREIGN KEY (s_email) REFERENCES sailor (email),
--     FOREIGN KEY (r_b_cni, r_b_cname, r_int_start_date, r_int_end_date) REFERENCES reservation (b_cni, b_cname, int_start_date, int_end_date)
-- );
--TODO: ICs 1-3, 6
------------- POPULATE THE DATA BASE ------------
-- Inserts Basically
------------- SIMPLE SQL QUERIES ----------------
-- The name of all boats that are used in some trip.
-- The name of all boats that are not used in any trip
-- The name of all boats registered in 'PRT' (ISO code) for which at least one responsible for a reservation has a surname that ends with 'Santos
-- The full name of all skipper without any certificate corresponding to the class of the trip's boat
