-- TEST IC-1
--
DELETE FROM sailor WHERE email LIKE '%test%';
DELETE FROM senior WHERE email LIKE '%test%';
DELETE FROM junior WHERE email LIKE '%test%';

BEGIN TRANSACTION;
SET CONSTRAINTS ALL DEFERRED;

INSERT INTO sailor VALUES
  ('Sailor 1', 'test', 'sailor.1.test@mail.com');

INSERT INTO senior VALUES
  ('sailor.1.test@mail.com');
  
COMMIT;


INSERT INTO senior VALUES
  ('sailor.1.test@mail.com');

