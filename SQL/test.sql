DELETE FROM sailor;

BEGIN TRANSACTION;
SET CONSTRAINTS ALL DEFERRED;

-- populate sailor
INSERT INTO sailor
VALUES
  ('Sailor', 'Test', 'sailor.test@mail.com'),
  -- senior
  ('Sailor 1', 'Senior', 'sailor.1.senior@mail.com'),
  ('Sailor 2', 'Senior', 'sailor.2.senior@mail.com'),
  ('Sailor 5', 'Senior', 'sailor.5.senior@mail.com'),
  -- junior
  ('Sailor 3', 'Junior', 'sailor.3.junior@mail.com'),
  ('Sailor 4', 'Junior', 'sailor.4.junior@mail.com');

-- populate junior
INSERT INTO junior
VALUES
  -- ('sailor.test@mail.com'),
  ('sailor.3.junior@mail.com'),
  ('sailor.4.junior@mail.com');

-- populate senior
INSERT INTO senior
VALUES
  ('sailor.test@mail.com'),
  ('sailor.1.senior@mail.com'),
  ('sailor.2.senior@mail.com'),
  ('sailor.5.senior@mail.com');

COMMIT;

UPDATE junior SET email = 'sailor.test@mail.com' WHERE email = 'sailor.3.junior@mail.com';
