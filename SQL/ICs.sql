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

CREATE CONSTRAINT TRIGGER tg_junior_delete
AFTER DELETE ON junior DEFERRABLE
FOR EACH ROW EXECUTE PROCEDURE junior_or_senior_delete();

CREATE CONSTRAINT TRIGGER tg_senior_delete
AFTER DELETE ON senior DEFERRABLE
FOR EACH ROW EXECUTE PROCEDURE junior_or_senior_delete();
--
---------------------- DATABASE IC-2 ------------------------
--
-- TODO: INSERT
-- TODO: UPDATE
-- TODO: DELETE
--
-- DROP TRIGGERS
--
--
-- DROP FUNCTONS
--
--
-- CREATE FUNCTIONS
--
--
-- CREATE TRIGGERS
--