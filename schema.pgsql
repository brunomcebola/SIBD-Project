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

DROP TABLE IF EXISTS sailing_certificate CASCADE;

DROP TABLE IF EXISTS valid_for CASCADE;

DROP TABLE IF EXISTS date_interval CASCADE;

DROP TABLE IF EXISTS reservation CASCADE;

DROP TABLE IF EXISTS authorised CASCADE;

DROP TABLE IF EXISTS trip CASCADE;

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
    sailor_email varchar(254),
    CONSTRAINT pk_junior PRIMARY KEY (sailor_email),
    CONSTRAINT fk_junior_sailor FOREIGN KEY (sailor_email) REFERENCES sailor (email)
);

CREATE TABLE senior (
    sailor_email varchar(254),
    CONSTRAINT pk_senior PRIMARY KEY (sailor_email),
    CONSTRAINT fk_senior_sailor FOREIGN KEY (sailor_email) REFERENCES sailor (email)
);

CREATE TABLE boat_class (
    name varchar(80),
    max_length numeric(5, 2) NOT NULL,
    CONSTRAINT pk_boat_class PRIMARY KEY (name)
);

CREATE TABLE boat (
    country_name varchar(70),
    cni varchar(20),
    boat_class_name varchar(80) NOT NULL,
    name varchar(80) NOT NULL,
    length numeric(5, 2) NOT NULL,
    year numeric(4, 0) NOT NULL,
    CONSTRAINT pk_boat PRIMARY KEY (country_name, cni),
    CONSTRAINT fk_boat_country FOREIGN KEY (country_name) REFERENCES country (name),
    CONSTRAINT fk_boat_boat_class FOREIGN KEY (boat_class_name) REFERENCES boat_class (name)
);

CREATE TABLE sailing_certificate (
    sailor_email varchar(254),
    issue_date date,
    boat_class_name varchar(80) NOT NULL,
    expiry_date date NOT NULL,
    CONSTRAINT pk_sailing_certificate PRIMARY KEY (sailor_email, issue_date),
    CONSTRAINT fk_sailing_certificate_sailor FOREIGN KEY (sailor_email) REFERENCES sailor (email),
    CONSTRAINT fk_sailing_certificate_boat_class FOREIGN KEY (boat_class_name) REFERENCES boat_class (name)
    -- Every sailing certificate must exist in the table 'valid_for'
);

CREATE TABLE valid_for (
    country_name varchar(70),
    sailor_email varchar(254),
    sailing_certificate_issue_date date,
    CONSTRAINT pk_valid_for PRIMARY KEY (country_name, sailor_email, sailing_certificate_issue_date),
    CONSTRAINT fk_valid_for_country FOREIGN KEY (country_name) REFERENCES country (name),
    CONSTRAINT fk_valid_for_sailing_certificate FOREIGN KEY (sailor_email, sailing_certificate_issue_date) REFERENCES sailing_certificate (sailor_email, issue_date)
);

CREATE TABLE date_interval (
    start_date date,
    end_date date,
    CONSTRAINT pk_date_interval PRIMARY KEY (start_date, end_date)
);

CREATE TABLE reservation (
    country_name varchar(70),
    boat_cni varchar(20),
    date_interval_start_date date,
    date_interval_end_date date,
    sailor_email varchar(254) NOT NULL,
    CONSTRAINT pk_reservation PRIMARY KEY (country_name, boat_cni, date_interval_start_date, date_interval_end_date),
    CONSTRAINT fk_reservation_boat FOREIGN KEY (country_name, boat_cni) REFERENCES boat (country_name, cni),
    CONSTRAINT fk_reservation_date_interval FOREIGN KEY (date_interval_start_date, date_interval_end_date) REFERENCES date_interval (start_date, end_date),
    CONSTRAINT fk_reservation_senior FOREIGN KEY (sailor_email) REFERENCES senior (sailor_email)
    -- Every reservation must exist in the table 'authorised'
);

CREATE TABLE authorised (
    country_name varchar(70),
    boat_cni varchar(20),
    date_interval_start_date date,
    date_interval_end_date date,
    sailor_email varchar(254),
    CONSTRAINT pk_authorised PRIMARY KEY (country_name, boat_cni, date_interval_start_date, date_interval_end_date, sailor_email),
    CONSTRAINT fk_authorised_reservation FOREIGN KEY (country_name, boat_cni, date_interval_start_date, date_interval_end_date) REFERENCES reservation (country_name, boat_cni, date_interval_start_date, date_interval_end_date),
    CONSTRAINT fk_authorised_sailor FOREIGN KEY (sailor_email) REFERENCES sailor (email)
);

CREATE TABLE trip (
    country_name varchar(70),
    boat_cni varchar(20),
    date_interval_start_date date,
    date_interval_end_date date,
    take_off date,
    arrival date NOT NULL,
    insurance varchar(80) NOT NULL,
    sailor_email varchar(254) NOT NULL,
    to_location_latitude numeric(8, 6) NOT NULL,
    to_location_longitude numeric(9, 6) NOT NULL,
    from_location_latitude numeric(8, 6) NOT NULL,
    from_location_longitude numeric(9, 6) NOT NULL,
    CONSTRAINT pk_trip PRIMARY KEY (country_name, boat_cni, date_interval_start_date, date_interval_end_date, take_off),
    CONSTRAINT fk_trip_reservation FOREIGN KEY (country_name, boat_cni, date_interval_start_date, date_interval_end_date) REFERENCES reservation (country_name, boat_cni, date_interval_start_date, date_interval_end_date),
    CONSTRAINT fk_trip_sailor FOREIGN KEY (sailor_email) REFERENCES sailor (email),
    CONSTRAINT fk_trip_to_location FOREIGN KEY (to_location_latitude, to_location_longitude) REFERENCES location (latitude, longitude),
    CONSTRAINT fk_trip_from_location FOREIGN KEY (from_location_latitude, from_location_longitude) REFERENCES location (latitude, longitude)
    -- CHECK (take_off > r_int_start_date)
);

-- INSERT INTO country
--     VALUES ('test_country', 'url:flag', 'PRT');
-- INSERT INTO boat_class
--     VALUES ('test_class', 425.00);
-- INSERT INTO boat
--     VALUES ('test_country', 'abd-87r-9ht', 'test_class', 'test_boat', 200, 2000);
-- SELECT
--     *
-- FROM
--     country;
-- SELECT
--     *
-- FROM
--     boat_class;
-- SELECT
--     *
-- FROM
--     boat;
--
--
--
--TODO: ICs 1-3, 6
------------- POPULATE THE DATA BASE ------------
-- Inserts Basically
------------- SIMPLE SQL QUERIES ----------------
-- The name of all boats that are used in some trip.
-- The name of all boats that are not used in any trip
-- The name of all boats registered in 'PRT' (ISO code) for which at least one responsible for a reservation has a surname that ends with 'Santos
-- The full name of all skipper without any certificate corresponding to the class of the trip's boat
