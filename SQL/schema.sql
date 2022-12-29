DROP TABLE IF EXISTS trip;
DROP TABLE IF EXISTS authorised;
DROP TABLE IF EXISTS reservation;
DROP TABLE IF EXISTS date_interval;
DROP TABLE IF EXISTS boat;
DROP TABLE IF EXISTS valid_for;
DROP TABLE IF EXISTS sailing_certificate;
DROP TABLE IF EXISTS boat_class;
DROP TABLE IF EXISTS senior;
DROP TABLE IF EXISTS junior;
DROP TABLE IF EXISTS sailor;
DROP TABLE IF EXISTS location;
DROP TABLE IF EXISTS country;

CREATE TABLE country(
	iso_code    CHAR(3) NOT NULL,
	flag        VARCHAR(100) NOT NULL,
	name        VARCHAR(70),
	PRIMARY KEY (name),
	UNIQUE (iso_code)
);

CREATE TABLE location(
	latitude        NUMERIC(8,6),
	longitude       NUMERIC(9,6),
	name            VARCHAR(80) NOT NULL,
	country_name    VARCHAR(70) NOT NULL,
	PRIMARY KEY (latitude, longitude),
	FOREIGN KEY (country_name) REFERENCES country(name)

    -- (IC-1) Every country where boats can be registered must have at least one location.

	-- (IC-2) The 'latitude' and 'longitude' of any row in the table 'location' must
	-- be at least 1-mile distance apart from 'latitude' and 'longitude' of all other rows.
);

CREATE TABLE sailor(
	firstname   VARCHAR(60) NOT NULL,
	surname     VARCHAR(60) NOT NULL,
	email       VARCHAR(100),
	PRIMARY KEY (email)
    -- mandatory specialization of sailor: any row must correspond to a row in junior or senior
);

CREATE TABLE junior(
	email   VARCHAR(100),
	PRIMARY KEY (email),
    FOREIGN KEY (email) REFERENCES sailor(email)
    -- disjoint specialization of sailor: any row must not correspond to a row in senior
    -- mandatory specialization of sailor: any row in sailor must correspond to a row in junior or senior
);

CREATE TABLE senior(
	email   VARCHAR(100),
	PRIMARY KEY (email),
    FOREIGN KEY (email) REFERENCES sailor(email)
    -- disjoint specialization of sailor: any row must not correspond to a row in junior
    -- mandatory specialization of sailor: any row in sailor must correspond to a row in junior or senior
);

CREATE TABLE boat_class(
	name        VARCHAR(50),
	max_length  NUMERIC(5,2) NOT NULL,
	PRIMARY KEY (name)
);

CREATE TABLE sailing_certificate(
	issue_date      TIMESTAMP,
	expiry_date     TIMESTAMP NOT NULL,
	sailor          VARCHAR(100),
	boat_class      VARCHAR(50) NOT NULL,
	PRIMARY KEY (sailor, issue_date),
	FOREIGN KEY(sailor) REFERENCES sailor(email),
	FOREIGN KEY(boat_class) REFERENCES boat_class(name)

    -- mandatory participation: any row of sailing_certificate must have
    -- at least one corresponding row in valid_for
);

CREATE TABLE valid_for(
	country_name    VARCHAR(70),
	max_length      NUMERIC(5,2) NOT NULL,
	sailor          VARCHAR(100),
	issue_date      TIMESTAMP,
	PRIMARY KEY (country_name, sailor, issue_date),
	FOREIGN KEY (sailor, issue_date) REFERENCES sailing_certificate(sailor, issue_date),
    FOREIGN KEY (country_name) REFERENCES country(name)
    -- mandatory participation: any row of sailing_certificate must have
    -- at least one corresponding row in valid_for
);

CREATE TABLE boat(
    country     VARCHAR(70),
    year        INTEGER NOT NULL,
	cni         VARCHAR(17),
	name        VARCHAR(30) NOT NULL,
	length      NUMERIC(5,2) NOT NULL,
	boat_class  VARCHAR(20) NOT NULL,
	PRIMARY KEY(country, cni),
	FOREIGN KEY(country) REFERENCES country(name),
	FOREIGN KEY(boat_class) REFERENCES boat_class(name)

    -- (IC-1) Every country where boats can be registered must have at least one location.
);

CREATE TABLE date_interval(
    start_date DATE,
    end_date   DATE,
    PRIMARY KEY (start_date, end_date)
);

CREATE TABLE reservation(
    start_date          DATE,
    end_date            DATE,
    country             VARCHAR(70),
	cni                 VARCHAR(17),
	responsible         VARCHAR(50) NOT NULL,
    PRIMARY KEY(start_date, end_date, country, cni),
    FOREIGN KEY(country, cni) REFERENCES boat(country, cni),
    FOREIGN KEY(start_date, end_date) REFERENCES date_interval(start_date, end_date),
    FOREIGN KEY(responsible) REFERENCES senior(email)

    -- (IC-6) One of the senior authorized sailors must be the responsible for a reservation.
);

CREATE TABLE authorised(
    start_date      DATE,
    end_date        DATE,
    boat_country    VARCHAR(70),
    cni             VARCHAR(17),
    sailor          VARCHAR(50),
    PRIMARY KEY (start_date, end_date, boat_country, cni, sailor),
    FOREIGN KEY (start_date, end_date, boat_country, cni) REFERENCES reservation (start_date, end_date, country, cni),
    FOREIGN KEY (sailor) REFERENCES sailor (email)

    -- mandatory participation: any row of reservation must have
    -- at least one corresponding row in authorised

    -- (IC-3) The skipper must be an authorized sailor of the corresponding reservation.

    -- (IC-6) One of the senior authorized sailors must be the responsible for a reservation.
);

CREATE TABLE trip(
    takeoff                 DATE,
    arrival                 DATE NOT NULL,
    insurance               VARCHAR(50) NOT NULL,
    from_latitude           NUMERIC(8,6) NOT NULL,
    from_longitude          NUMERIC(9,6) NOT NULL,
    to_latitude             NUMERIC(8,6) NOT NULL,
    to_longitude            NUMERIC(9,6) NOT NULL,
    skipper                 VARCHAR(50) NOT NULL,
    reservation_start_date  DATE,
    reservation_end_date    DATE,
    boat_country            VARCHAR(70),
    cni                     VARCHAR(17),
    PRIMARY KEY (takeoff, reservation_start_date, reservation_end_date, boat_country, cni),
    FOREIGN KEY (reservation_start_date, reservation_end_date, boat_country, cni)
        REFERENCES reservation (start_date, end_date, country, cni),
    FOREIGN KEY (skipper) REFERENCES sailor (email),
    FOREIGN KEY(from_latitude,from_longitude) REFERENCES location(latitude,longitude),
    FOREIGN KEY(to_latitude,to_longitude) REFERENCES location(latitude,longitude),
    CHECK (takeoff >= reservation_start_date) -- (IC-4)

    -- (IC-3) The skipper must be an authorized sailor of the corresponding reservation.
);




