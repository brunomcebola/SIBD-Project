-------------------------------------------------------------
--
-- SIBD Project - Part 2
--
-- Bruno Cebola - 93030
-- João Nunes - 93100
-- Rui Abrantes - 93176
--
---------------------- DATABASE IC-1 ------------------------
-- 
-- TODO: update
--
-- DROP TRIGGERS
--
DROP TRIGGER IF EXISTS tg_sailor_insert ON sailor;
DROP TRIGGER IF EXISTS tg_junior_insert ON junior;
DROP TRIGGER IF EXISTS tg_senior_insert ON senior;

DROP TRIGGER IF EXISTS tg_sailor_delete ON sailor;
DROP TRIGGER IF EXISTS tg_junior_delete ON junior;
DROP TRIGGER IF EXISTS tg_senior_delete ON senior;
--
-- DROP FUNCTONS
--
DROP FUNCTION IF EXISTS sailor_insert;
DROP FUNCTION IF EXISTS junior_insert;
DROP FUNCTION IF EXISTS senior_insert;

DROP FUNCTION IF EXISTS sailor_delete;
DROP FUNCTION IF EXISTS junior_or_senior_delete;
--
-- CREATE FUNCTIONS
--
CREATE FUNCTION sailor_insert()
RETURNS TRIGGER AS 
$$
BEGIN
    IF 
        (NEW.email IN (SELECT email FROM junior) AND NEW.email IN (SELECT email FROM senior)) OR
        (NEW.email NOT IN (SELECT email FROM junior) AND NEW.email NOT IN (SELECT email FROM senior))
    THEN
        RAISE EXCEPTION 'The sailor % must exist either in table junior or table senior', NEW.email;
    END IF;
    
    RETURN NEW;
END;
$$ 
LANGUAGE plpgsql;

CREATE FUNCTION junior_insert()
RETURNS TRIGGER AS 
$$
BEGIN
    IF NEW.email IN (SELECT email FROM senior) THEN
        RAISE EXCEPTION 'The sailor % already exists in table senior', NEW.email;
    END IF;
    
    RETURN NEW;
END;
$$ 
LANGUAGE plpgsql;

CREATE FUNCTION senior_insert()
RETURNS TRIGGER AS 
$$
BEGIN
    IF NEW.email IN (SELECT email FROM junior) THEN
        RAISE EXCEPTION 'The sailor % already exists in table junior', NEW.email;
    ELSE
        RETURN NEW;
    END IF;
END;
$$ 
LANGUAGE plpgsql;


CREATE FUNCTION sailor_delete()
RETURNS TRIGGER AS 
$$
BEGIN
    DELETE FROM junior WHERE email = OLD.email;
    DELETE FROM senior WHERE email = OLD.email;

    RETURN OLD;
END;
$$ 
LANGUAGE plpgsql;

CREATE FUNCTION junior_or_senior_delete()
RETURNS TRIGGER AS 
$$
BEGIN
    IF 
        OLD.email IN (SELECT email FROM sailor) AND 
        OLD.email NOT IN (SELECT email FROM junior) AND 
        OLD.email NOT IN (SELECT email FROM senior)
    THEN
        RAISE EXCEPTION 'The sailor % must be deleted entirely or be assigned a role', OLD.email;
    END IF;
    
    RETURN OLD;
END;
$$ 
LANGUAGE plpgsql;
--
-- CREATE TRIGGERS
--
CREATE CONSTRAINT TRIGGER tg_sailor_insert
AFTER INSERT ON sailor DEFERRABLE
FOR EACH ROW EXECUTE PROCEDURE sailor_insert();

CREATE CONSTRAINT TRIGGER tg_junior_insert
AFTER INSERT ON junior DEFERRABLE
FOR EACH ROW EXECUTE PROCEDURE junior_insert();

CREATE CONSTRAINT TRIGGER tg_senior_insert
AFTER INSERT ON senior DEFERRABLE
FOR EACH ROW EXECUTE PROCEDURE senior_insert();

CREATE TRIGGER tg_sailor_delete
BEFORE DELETE ON sailor
FOR EACH ROW EXECUTE PROCEDURE sailor_delete();

-- TODO: check this delete to let sailor delete work alone
-- CREATE CONSTRAINT TRIGGER tg_junior_delete
-- AFTER DELETE ON junior DEFERRABLE
-- FOR EACH ROW EXECUTE PROCEDURE junior_or_senior_delete();

-- CREATE CONSTRAINT TRIGGER tg_senior_delete
-- AFTER DELETE ON senior DEFERRABLE
-- FOR EACH ROW EXECUTE PROCEDURE junior_or_senior_delete();
--
---------------------- DATABASE IC-2 ------------------------
--
-- DROP CHECK
--
ALTER TABLE trip DROP CONSTRAINT IF EXISTS ck_trip_insert;
--
-- DROP FUNCTONS
--
DROP FUNCTION IF EXISTS trip_insert;
--
-- CREATE FUNCTIONS
--
CREATE FUNCTION trip_insert(
    new_trip_takeoff                 DATE,
    new_trip_arrival                 DATE,
    new_trip_reservation_start_date  DATE,
    new_trip_reservation_end_date    DATE,
    new_trip_boat_country            VARCHAR(70),
    new_trip_cni                     VARCHAR(17)
) RETURNS BOOLEAN AS 
$$
DECLARE trip_var trip%ROWTYPE;
DECLARE cursor_trip CURSOR FOR
    SELECT *
    FROM trip t
    WHERE (
        t.reservation_start_date = new_trip_reservation_start_date AND 
        t.reservation_end_date = new_trip_reservation_end_date AND 
        t.boat_country = new_trip_boat_country AND 
        t.cni = new_trip_cni);
BEGIN
    OPEN cursor_trip;
    LOOP
        FETCH cursor_trip INTO trip_var;
        EXIT WHEN NOT FOUND;
        IF
            trip_var.takeoff = new_trip_takeoff AND
            trip_var.reservation_start_date = new_trip_reservation_start_date AND 
            trip_var.reservation_end_date = new_trip_reservation_end_date AND 
            trip_var.boat_country = new_trip_boat_country AND 
            trip_var.cni = new_trip_cni
        THEN
            CONTINUE;
        -- check if new trip does not start in the middle of another one
        ELSIF trip_var.takeoff < new_trip_takeoff AND trip_var.arrival > new_trip_takeoff THEN
            CLOSE cursor_trip;
            RAISE EXCEPTION 'A trip cannot start in the middle of another trip';
        -- check if new trip does not finish in the middle of another one
        ELSIF trip_var.takeoff < new_trip_arrival AND trip_var.arrival > new_trip_arrival THEN 
            CLOSE cursor_trip;
            RAISE EXCEPTION 'A trip cannot finish in the middle of another trip';
        -- check if new trip does not surround existing trip
        ELSIF trip_var.takeoff >= new_trip_takeoff AND trip_var.arrival <= new_trip_arrival THEN 
            CLOSE cursor_trip;
            RAISE EXCEPTION 'A trip cannot surround another trip';
        END IF;
    END LOOP;
    CLOSE cursor_trip;
    RETURN TRUE;
END;
$$ 
LANGUAGE plpgsql;
--
-- CREATE CHECK
--
ALTER TABLE trip ADD CONSTRAINT ck_trip_insert CHECK (trip_insert(takeoff, arrival, reservation_start_date, reservation_end_date, boat_country, cni)); 