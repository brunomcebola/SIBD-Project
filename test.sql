-- TEST IC-1
--
START TRANSACTION;
SET CONSTRAINTS ALL DEFERRED;

DELETE FROM senior;
DELETE FROM junior;
DELETE FROM sailor;

COMMIT;


START TRANSACTION;
SET CONSTRAINTS ALL DEFERRED;

INSERT INTO sailor VALUES ('a', 'b', '1');
INSERT INTO junior VALUES ('1');

INSERT INTO sailor VALUES ('a', 'b', '2');
INSERT INTO senior VALUES ('2');

COMMIT;

START TRANSACTION;
SET CONSTRAINTS ALL DEFERRED;

DELETE FROM sailor WHERE email = '2';
DELETE FROM senior WHERE email = '2';

COMMIT;

-- UPDATE sailor SET email = '3' WHERE email = '2';

select * from sailor; 
select * from senior;
select * from junior;