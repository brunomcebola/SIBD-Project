-------------------------------------------------------------
--
-- SIBD Project - Part 2
--
-- Bruno Cebola - 93030
-- João Nunes - 93100
-- Rui Abrantes - 93176
--
----------------------- DATABASE ICs ------------------------
--
-- DROP TRIGGERS
--
DROP TRIGGER IF EXISTS tg_check_sailor_junior_or_senior_insert ON sailor;
DROP TRIGGER IF EXISTS tg_check_junior_not_senior_insert ON junior;
DROP TRIGGER IF EXISTS tg_check_senior_not_junior_insert ON senior;

DROP TRIGGER IF EXISTS tg_check_junior_not_senior_update ON junior;
DROP TRIGGER IF EXISTS tg_check_senior_not_junior_update ON senior;

DROP TRIGGER IF EXISTS tg_check_sailor_senior_delete ON junior;
DROP TRIGGER IF EXISTS tg_check_sailor_junior_delete ON senior;
--
-- DROP TABLES
--
DROP FUNCTION IF EXISTS check_sailor_junior_or_senior;
DROP FUNCTION IF EXISTS check_junior_not_senior;
DROP FUNCTION IF EXISTS check_senior_not_junior;
DROP FUNCTION IF EXISTS check_sailor_senior;
DROP FUNCTION IF EXISTS check_sailor_junior;
--
-- CREATE FUNCTIONS
--
CREATE FUNCTION check_sailor_junior_or_senior()
RETURNS TRIGGER AS 
$$
BEGIN
    IF NEW.email NOT IN (SELECT email FROM junior) AND NEW.email NOT IN (SELECT email FROM senior) THEN
        RAISE EXCEPTION 'The sailor % must be either a junior or a senior', NEW.email;
    ELSE
        RETURN NEW;
    END IF;
END;
$$ 
LANGUAGE plpgsql;

CREATE FUNCTION check_junior_not_senior()
RETURNS TRIGGER AS 
$$
BEGIN
    IF NEW.email IN (SELECT email FROM senior) THEN
        RAISE EXCEPTION 'The sailor % cannot be a junior and a senior', NEW.email;
    ELSE
        RETURN NEW;
    END IF;
END;
$$ 
LANGUAGE plpgsql;

CREATE FUNCTION check_senior_not_junior()
RETURNS TRIGGER AS 
$$
BEGIN
    IF NEW.email IN (SELECT email FROM junior) THEN
        RAISE EXCEPTION 'The sailor % cannot be a senior and a junior', NEW.email;
    ELSE
        RETURN NEW;
    END IF;
END;
$$ 
LANGUAGE plpgsql;

-- TODO: pensar na mensagem
CREATE FUNCTION check_sailor_senior()
RETURNS TRIGGER AS 
$$
BEGIN
    IF OLD.email IN (SELECT email FROM sailor) AND OLD.email NOT IN (SELECT email FROM senior) THEN
        RAISE EXCEPTION 'delete junior %', OLD.email;
    ELSE
        RETURN OLD;
    END IF;
END;
$$ 
LANGUAGE plpgsql;

-- TODO: pensar na mensagem
CREATE FUNCTION check_sailor_junior()
RETURNS TRIGGER AS 
$$
BEGIN
    IF OLD.email IN (SELECT email FROM sailor) AND OLD.email NOT IN (SELECT email FROM junior) THEN
        RAISE EXCEPTION 'delete senior %', OLD.email;
    ELSE
        RETURN OLD;
    END IF;
END;
$$ 
LANGUAGE plpgsql;
--
-- CREATE TRIGGERS
--
CREATE CONSTRAINT TRIGGER tg_check_sailor_junior_or_senior_insert
AFTER INSERT ON sailor DEFERRABLE
FOR EACH ROW EXECUTE PROCEDURE check_sailor_junior_or_senior();

CREATE CONSTRAINT TRIGGER tg_check_junior_not_senior_insert
AFTER INSERT ON junior DEFERRABLE
FOR EACH ROW EXECUTE PROCEDURE check_junior_not_senior();

CREATE CONSTRAINT TRIGGER tg_check_senior_not_junior_insert
AFTER INSERT ON senior DEFERRABLE
FOR EACH ROW EXECUTE PROCEDURE check_senior_not_junior();

CREATE CONSTRAINT TRIGGER tg_check_junior_not_senior_update
AFTER UPDATE ON junior DEFERRABLE
FOR EACH ROW EXECUTE PROCEDURE check_junior_not_senior();

CREATE CONSTRAINT TRIGGER tg_check_senior_not_junior_update
AFTER UPDATE ON senior DEFERRABLE
FOR EACH ROW EXECUTE PROCEDURE check_senior_not_junior();

CREATE CONSTRAINT TRIGGER tg_check_sailor_senior_delete
AFTER DELETE ON junior DEFERRABLE
FOR EACH ROW EXECUTE PROCEDURE check_sailor_senior();

CREATE CONSTRAINT TRIGGER tg_check_sailor_junior_delete
AFTER DELETE ON senior DEFERRABLE
FOR EACH ROW EXECUTE PROCEDURE check_sailor_junior();
-- --
-- -------------------------------------------------------------
-- --
-- DROP FUNCTION IF EXISTS ic1 CASCADE;
-- DROP FUNCTION IF EXISTS ic2 CASCADE;
-- DROP FUNCTION IF EXISTS ic3 CASCADE;
-- DROP FUNCTION IF EXISTS ic6 CASCADE;
-- --
-- -------------------------------------------------------------
-- --
-- CREATE FUNCTION ic1 (
--     in_c_name varchar(70)
-- ) RETURNS boolean AS 
-- $$
-- BEGIN
--     RETURN 
--         EXISTS (
--             SELECT *
--             FROM location
--             WHERE c_name = in_c_name);
-- END
-- $$
-- LANGUAGE plpgsql;

-- CREATE FUNCTION ic2 (
--     in_latitude numeric(8, 6), 
--     in_longitude numeric(9, 6)
-- ) RETURNS boolean AS
-- $$
-- BEGIN
--     RETURN 1 <= (
--         SELECT MIN(d.dist)
--         FROM (
--             SELECT 3443.8985*(ACOS(SIN(in_latitude * 3.14 / 180)*SIN(latitude * 3.14 / 180)+COS(in_latitude * 3.14 / 180)*COS(latitude * 3.14 / 180)*COS((longitude - in_longitude) * 3.14 / 180))) as dist
--             FROM location) d);
-- END
-- $$
-- LANGUAGE plpgsql;

-- CREATE FUNCTION ic3 (
--     in_c_name varchar(70), 
--     in_b_cni varchar(20), 
--     in_di_start_date date, 
--     in_di_end_date date,
--     in_s_mail varchar(254)
-- ) RETURNS boolean AS
-- $$
-- BEGIN
--     RETURN 
--         EXISTS (
--             SELECT *
--             FROM authorised
--             WHERE
--                 c_name = in_c_name
--                 AND b_cni = in_b_cni
--                 AND di_start_date = in_di_start_date
--                 AND di_end_date = in_di_end_date
--                 AND s_mail = in_s_mail);
-- END
-- $$
-- LANGUAGE plpgsql;

-- CREATE FUNCTION ic6 (
--     in_c_name varchar(70), 
--     in_b_cni varchar(20), 
--     in_di_start_date date, 
--     in_di_end_date date,
--     in_s_mail varchar(254)
-- ) RETURNS boolean AS
-- $$
-- BEGIN
--     RETURN 
--         EXISTS (
--             SELECT *
--             FROM authorised
--             WHERE
--                 c_name = in_c_name
--                 AND b_cni = in_b_cni
--                 AND di_start_date = in_di_start_date
--                 AND di_end_date = in_di_end_date
--                 AND s_mail = in_s_mail) 
--         AND EXISTS (
--             SELECT *
--             FROM senior
--             WHERE s_email == in_s_mail);
-- END
-- $$
-- LANGUAGE plpgsql;
