-- TEST IC-1
--
DELETE FROM trip;
DELETE FROM authorised;
DELETE FROM reservation;
DELETE FROM date_interval;
DELETE FROM valid_for;
DELETE FROM sailing_certificate;
DELETE FROM boat;
DELETE FROM boat_class;
DELETE FROM senior;
DELETE FROM junior;
DELETE FROM sailor;
DELETE FROM location;
DELETE FROM country;

INSERT INTO country VALUES
  ('PRT', 'flag.PRT', 'Portugal'),
  ('ESP', 'flag.ESP', 'Espanha'),
  ('FRA', 'flag.FRA', 'França');

INSERT INTO location VALUES
  -- Portugal
  (1, 1, 'Loc 1', 'Portugal'),
  (2, 2, 'Loc 2', 'Portugal'),
  (3, 3, 'Loc 3', 'Portugal'),
  -- Espanha
  (4, 4, 'Loc 4', 'Espanha'),
  (5, 5, 'Loc 5', 'Espanha'),
  (6, 6, 'Loc 6', 'Espanha'),
  -- França
  (7, 7, 'Loc 7', 'França'),
  (8, 8, 'Loc 8', 'França'),
  (9, 9, 'Loc 9', 'França');

INSERT INTO sailor VALUES
  ('Sailor 1', 'junior', 'sailor.1@mail.com'),
  ('Sailor 2', 'junior', 'sailor.2@mail.com'),
  ('Sailor 3', 'senior', 'sailor.3@mail.com'),
  ('Sailor 4', 'senior', 'sailor.4@mail.com');

INSERT INTO junior VALUES
  ('sailor.1@mail.com'),
  ('sailor.2@mail.com');

INSERT INTO senior VALUES
  ('sailor.3@mail.com'),
  ('sailor.4@mail.com');

  INSERT INTO boat_class VALUES
    ('Class J', 10),
    ('Class S', 20),

INSERT INTO sailing_certificate VALUES 
  -- sailor 1
  ('2022-12-01', '2023-12-01', 'sailor.1@email.com', 'Class J'),
  -- sailor 2
  ('2022-12-01', '2023-12-01', 'sailor.2@email.com', 'Class J'),
  -- sailor 3
  ('2022-12-01', '2023-12-01', 'sailor.3@email.com', 'Class J'),
  ('2022-12-02', '2023-12-02', 'sailor.3@email.com', 'Class S'),
  -- sailor 4
  ('2022-12-01', '2023-12-01', 'sailor.4@email.com', 'Class J'),
  ('2022-12-02', '2023-12-02', 'sailor.4@email.com', 'Class S');

INSERT INTO valid_for VALUES 
  -- sailor 1
  ('Portugal', 10, 'sailor.1@email.com', '2022-12-01'),
  ('Espanha', 10, 'sailor.1@email.com', '2022-12-01'),
  -- sailor 2
  ('Portugal', 10, 'sailor.2@email.com', '2022-12-01'),
  ('Espanha', 10, 'sailor.2@email.com', '2022-12-01'),
  -- sailor 3
  ('Portugal', 10, 'sailor.3@email.com', '2022-12-01'),
  ('Espanha', 10, 'sailor.3@email.com', '2022-12-01'),
  ('Portugal', 20, 'sailor.3@email.com', '2022-12-02'),
  ('Espanha', 20, 'sailor.3@email.com', '2022-12-02'),
  ('França', 20, 'sailor.3@email.com', '2022-12-02'),
  -- sailor 4
  ('Portugal', 10, 'sailor.4@email.com', '2022-12-01'),
  ('Espanha', 10, 'sailor.4@email.com', '2022-12-01'),
  ('Portugal', 20, 'sailor.4@email.com', '2022-12-02'),
  ('Espanha', 20, 'sailor.4@email.com', '2022-12-02'),
  ('França', 20, 'sailor.4@email.com', '2022-12-02');

INSERT INTO boat VALUES 
  -- Portugal
  ('Portugal', 2022, 1, 'Boat 1', 10, 'Class J'),
  ('Portugal', 2022, 2, 'Boat 2', 10, 'Class J'),
  ('Portugal', 2022, 3, 'Boat 3', 20, 'Class S'),
  ('Portugal', 2022, 4, 'Boat 4', 20, 'Class S'),
  -- Espanha
  ('Espanha', 2022, 5, 'Boat 5', 10, 'Class J'),
  ('Espanha', 2022, 6, 'Boat 6', 20, 'Class S'),
  ('Espanha', 2022, 7, 'Boat 7', 20, 'Class S'),
  -- França
  ('França', 2022, 8, 'Boat 8', 20, 'Class S'),
  ('França', 2022, 9, 'Boat 9', 20, 'Class S');

INSERT INTO date_interval VALUES
  ('2022-12-01', '2022-12-03'),
  ('2022-12-04', '2022-12-06'),
  ('2022-12-07', '2022-12-09'),
  ('2022-12-10', '2022-12-12'),
  ('2022-12-13', '2022-12-15'),
  ('2022-12-16', '2022-12-18');

INSERT INTO reservation VALUES
  -- reserva 1
  ('2022-12-01', '2022-12-03', 'Portugal', 1, 'sailor.3@mail.com'),
  -- reserva 2
  ('2022-12-04', '2022-12-06', 'Portugal', 1, 'sailor.3@mail.com'),
  -- reserva 3
  ('2022-12-01', '2022-12-03', 'França', 2, 'sailor.4@mail.com'),
  -- reserva 4
  ('2022-12-04', '2022-12-06', 'França', 2, 'sailor.4@mail.com');

INSERT INTO authorized VALUES
  -- reserva 1
  ('2022-12-01', '2022-12-03', 'Portugal', 1, 'sailor.3@mail.com'),
  ('2022-12-01', '2022-12-03', 'Portugal', 1, 'sailor.1@mail.com'),
  -- reserva 2
  ('2022-12-04', '2022-12-06', 'Portugal', 1, 'sailor.3@mail.com'),
  ('2022-12-04', '2022-12-06', 'Portugal', 1, 'sailor.1@mail.com'),
  -- reserva 3
  ('2022-12-01', '2022-12-03', 'França', 2, 'sailor.4@mail.com'),
  ('2022-12-01', '2022-12-03', 'França', 2, 'sailor.2@mail.com'),,
  -- reserva 4
  ('2022-12-04', '2022-12-06', 'França', 2, 'sailor.4@mail.com'),
  ('2022-12-04', '2022-12-06', 'França', 2, 'sailor.2@mail.com');

INSERT INTO trip VALUES
  --reserva 1
  ('2022-12-01', '2022-12-02', 'Insurance 1', 1, 1, 2, 2, 'sailor.3@mail.com', '2022-12-01', '2022-12-03', 'Portugal', 1),
  ('2022-12-02', '2022-12-03', 'Insurance 1', 1, 1, 2, 2, 'sailor.1@mail.com', '2022-12-01', '2022-12-03', 'Portugal', 1),
  --reserva 2
  ('2022-12-01', '2022-12-02', 'Insurance 1', 1, 1, 2, 2, 'sailor.3@mail.com', '2022-12-04', '2022-12-06', 'Portugal', 1),
  ('2022-12-02', '2022-12-03', 'Insurance 1', 1, 1, 2, 2, 'sailor.3@mail.com', '2022-12-04', '2022-12-06', 'Portugal', 1),
  --reserva 3
  ('2022-12-01', '2022-12-02', 'Insurance 1', 1, 1, 2, 2, 'sailor.4@mail.com', '2022-12-01', '2022-12-03', 'França', 2),
  ('2022-12-02', '2022-12-03', 'Insurance 1', 1, 1, 2, 2, 'sailor.2@mail.com', '2022-12-01', '2022-12-03', 'França', 2),
  --reserva 4
  ('2022-12-01', '2022-12-02', 'Insurance 1', 1, 1, 2, 2, 'sailor.4@mail.com', '2022-12-04', '2022-12-06', 'França', 2),
  ('2022-12-02', '2022-12-03', 'Insurance 1', 1, 1, 2, 2, 'sailor.2@mail.com', '2022-12-04', '2022-12-06', 'França', 2);
