INSERT INTO country
  VALUES ('test_country1', 'url:flag', 'PR1');

INSERT INTO boat_class
  VALUES ('test_class', 425.00);

INSERT INTO location
  VALUES (1.0, 1.0, 'test_country', 'test_location');

INSERT INTO boat
  VALUES ('test_country1', 'abd-87r-9ht', 'test_class', 'test_boat', 200, 2000);

SELECT
  *
FROM
  country;

SELECT
  *
FROM
  boat_class;

SELECT
  *
FROM
  location;

SELECT
  *
FROM
  boat;

