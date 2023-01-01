-------------------------------------------------------------
--
-- SIBD Project - Part 3
--
-- Sailor 1 Senior - 93030
-- Sailor 2 Senior - 93100
-- Sailor 3 Junior - 93176
--
---------------------- DATABASE POPULATION --------------------
--
DELETE FROM trip;
DELETE FROM authorised;
DELETE FROM reservation;
DELETE FROM date_interval;
DELETE FROM valid_for;
DELETE FROM sailing_certificate;
DELETE FROM boat;
DELETE FROM boat_class;

DELETE FROM sailor; -- deletes also junior and senior

DELETE FROM location;
DELETE FROM country;
--
-------------------------------------------------------------
--
-- poupulate country
INSERT INTO country
VALUES 
  ('PRT', 'https://en.wikipedia.org/wiki/Flag_of_Portugal#/media/File:Flag_of_Portugal.svg', 'Portugal'), 
  ('ESP', 'https://en.wikipedia.org/wiki/Flag_of_Spain#/media/File:Bandera_de_Espa%C3%B1a.svg', 'Espanha'), 
  ('FRA', 'https://upload.wikimedia.org/wikipedia/en/c/c3/Flag_of_France.svg', 'França');

-- populate location
INSERT INTO location
VALUES 
  (10, 10, 'Madeira', 'Portugal'),
  (-10, -10, 'Açores', 'Portugal'),
  (10, 0, 'Madrid', 'Espanha'),
  (0, 10, 'Paris', 'França');

BEGIN TRANSACTION;
SET CONSTRAINTS ALL DEFERRED;
-- populate sailor
INSERT INTO sailor
VALUES
  ('Sailor 1', 'Senior', 'sailor.1.senior@mail.com'),
  ('Sailor 2', 'Senior', 'sailor.2.senior@mail.com'),
  ('Sailor 3', 'Junior', 'sailor.3.junior@mail.com'),
  ('Sailor 4', 'Junior', 'sailor.4.junior@mail.com');

-- populate junior
INSERT INTO junior
VALUES
  ('sailor.3.junior@mail.com'),
  ('sailor.4.junior@mail.com');

-- populate senior
INSERT INTO senior
VALUES
  ('sailor.1.senior@mail.com'),
  ('sailor.2.senior@mail.com');
COMMIT;

-- populate boat_class
INSERT INTO boat_class
VALUES
  ('Class 1', 10.50),
  ('Class 2', 25.25),
  ('Class 3', 30.00);

-- populate sailing_certificate
INSERT INTO sailing_certificate
VALUES
  -- sailor 1
  ('01-01-2021 18:00:12', '31-12-2023 18:00:12', 'sailor.1.senior@mail.com', 'Class 1'),
  ('02-01-2021 18:00:12', '31-12-2023 18:00:12', 'sailor.1.senior@mail.com', 'Class 2'),
  ('03-01-2021 18:00:12', '31-12-2023 18:00:12', 'sailor.1.senior@mail.com', 'Class 3'),
  -- sailor 2
  ('01-01-2021 18:00:12', '31-12-2023 18:00:12', 'sailor.2.senior@mail.com', 'Class 1'),
  ('02-01-2021 18:00:12', '31-12-2023 18:00:12', 'sailor.2.senior@mail.com', 'Class 2'),
  -- sailor 3
  ('01-01-2021 18:00:12', '31-12-2023 18:00:12', 'sailor.3.junior@mail.com', 'Class 1'),
  -- sailor 4
  ('01-01-2021 18:00:12', '31-12-2023 18:00:12', 'sailor.4.junior@mail.com', 'Class 1');

-- populate valid_for
INSERT INTO valid_for
VALUES
  -- TODO: missing certificates
  ('Espanha', 25.25, 'sailor.1.senior@mail.com', '01-01-2021 18:00:12'),
  ('França', 25.25, 'sailor.1.senior@mail.com', '01-01-2021 18:00:12'),
  ('Portugal', 25.25, 'sailor.1.senior@mail.com', '01-01-2021 18:00:12');

-- populate boat
INSERT INTO boat
VALUES  
  -- Portugal
  ('Portugal', 2022, 'PT 1', 'Barco PT 1', 10, 'Class 1'),
  ('Portugal', 2020, 'PT 2', 'Barco PT 2', 7.5, 'Class 1'),
  -- França
  ('França', 2015, 'FR 1', 'Barco FR 1', 20, 'Class 2'),
  ('França', 2015, 'FR 2', 'Barco FR 2', 20, 'Class 2'),
  -- Espanha
  ('Espanha', 2018, 'ES 1', 'Barco ES 1', 25, 'Class 2');

-- populate date_interval
INSERT INTO date_interval
VALUES
  ('01-12-2022', '07-12-2022'),
  ('08-12-2022', '14-12-2022');

-- populate reservation
INSERT INTO reservation
VALUES
  -- reserva 1
  ('01-12-2022', '07-12-2022', 'Portugal', 'PT 1', 'sailor.1.senior@mail.com'),
  -- reserva 2
  ('08-12-2022', '14-12-2022', 'Portugal', 'PT 2', 'sailor.2.senior@mail.com');

-- populate authorised
INSERT INTO authorised
VALUES
  -- reserva 1
  ('01-12-2022', '07-12-2022', 'Portugal', 'PT 1', 'sailor.1.senior@mail.com'),
  ('01-12-2022', '07-12-2022', 'Portugal', 'PT 1', 'sailor.3.junior@mail.com'),
  -- reserva 2
  ('08-12-2022', '14-12-2022', 'Portugal', 'PT 2', 'sailor.2.senior@mail.com'),
  ('08-12-2022', '14-12-2022', 'Portugal', 'PT 2', 'sailor.4.junior@mail.com');

-- populate trip
INSERT INTO trip
VALUES
  -- reserva 1
  ('01-12-2022', '02-12-2022', 'Insurance 1', 10, 10, -10, -10, 'sailor.1.senior@mail.com', '01-12-2022', '07-12-2022', 'Portugal', 'PT 1'),
  ('03-12-2022', '04-12-2022', 'Insurance 1', -10, -10, 10, 10, 'sailor.1.senior@mail.com', '01-12-2022', '07-12-2022', 'Portugal', 'PT 1'),
  ('05-12-2022', '07-12-2022', 'Insurance 1', 10, 10, -10, -10, 'sailor.1.senior@mail.com', '01-12-2022', '07-12-2022', 'Portugal', 'PT 1'),

  ('02-12-2022', '03-12-2022', 'Insurance 1', 10, 10, -10, -10, 'sailor.1.senior@mail.com', '01-12-2022', '07-12-2022', 'Portugal', 'PT 1'),
  -- reserva 2
  ('08-12-2022', '09-12-2022', 'Insurance 2', 10, 10, -10, -10, 'sailor.2.senior@mail.com', '08-12-2022', '14-12-2022', 'Portugal', 'PT 2'),
  ('10-12-2022', '11-12-2022', 'Insurance 2', -10, -10, 0, 10, 'sailor.2.senior@mail.com', '08-12-2022', '14-12-2022', 'Portugal', 'PT 2'),
  ('12-12-2022', '14-12-2022', 'Insurance 2', 0, 10, 10, 10, 'sailor.4.junior@mail.com', '08-12-2022', '14-12-2022', 'Portugal', 'PT 2');