-------------------------------------------------------------
--
-- SIBD Project - Part 2
--
-- Bruno Cebola - 93030
-- João Nunes - 93100
-- Rui Abrantes - 93176
--
---------------------- DATABASE POPULATE --------------------
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
--
-------------------------------------------------------------
--
-- poupulate country
INSERT INTO country
VALUES 
  ('Portugal', 'https://upload.wikimedia.org/wikipedia/commons/thumb/5/5c/Flag_of_Portugal.svg/255px-Flag_of_Portugal.svg.png', 'PRT'), 
  ('Espanha', 'https://upload.wikimedia.org/wikipedia/commons/thumb/8/89/Bandera_de_Espa%C3%B1a.svg/1200px-Bandera_de_Espa%C3%B1a.svg.png', 'ESP'), 
  ('França', 'https://pt.wikipedia.org/wiki/Fran%C3%A7a#/media/Ficheiro:Flag_of_France_(1794%E2%80%931815,_1830%E2%80%931974,_2020%E2%80%93present).svg', 'FRA');

-- populate location
INSERT INTO location
VALUES 
  (10, 10, 'Portugal', 'Madeira'),
  (-10, -10, 'Portugal', 'Açores'),
  (0, 0, 'Portugal', 'Lisboa'),
  (0, 10, 'Portugal', 'Berlengas');

-- popuate sailor
INSERT INTO sailor
VALUES
  ('bruno.m.cebola@tecnico.ulisboa.pt', 'Bruno', 'Cebola'),
  ('joao.pedro.nunes@tecnico.ulisboa.pt', 'João', 'Nunes'),
  ('rui.abrantes@tecnico.ulisboa.pt', 'Rui', 'Abrantes'),
  ('pedro.santos@tecnico.ulisboa.pt', 'Pedro', 'Santos');

-- popuate junior
INSERT INTO junior
VALUES
  ('joao.pedro.nunes@tecnico.ulisboa.pt'),
  ('rui.abrantes@tecnico.ulisboa.pt');

-- populates senior
INSERT INTO senior
VALUES
  ('bruno.m.cebola@tecnico.ulisboa.pt'),
  ('pedro.santos@tecnico.ulisboa.pt');

-- populate boat_class
INSERT INTO boat_class
VALUES
  ('Lancha', 10.50),
  ('Catamaran', 25.25);


-- populate boat
INSERT INTO boat
VALUES  
  ('Portugal', 'AXZ-879-145-TVC', 'Lancha', 'Barco 1', 10, 2022),
  ('Portugal', '689-FEK-325-NKE', 'Lancha', 'Barco 2', 7.5, 2020),
  ('França', 'BTH-UJN-552-829', 'Catamaran', 'Barco 3', 20, 2015),
  ('Espanha', 'RIM-473-FEW-315', 'Catamaran', 'Barco 4', 25, 2018);

-- populate sailing_certificate
INSERT INTO sailing_certificate
VALUES
  ('pedro.santos@tecnico.ulisboa.pt', '01-01-2021', '31-12-2023', 'Catamaran'),
  ('bruno.m.cebola@tecnico.ulisboa.pt', '02-01-2021', '31-12-2023', 'Catamaran');

-- populate valid_for
INSERT INTO valid_for
VALUES
  ('Portugal', 'bruno.m.cebola@tecnico.ulisboa.pt', '01-01-2021'),
  ('Espanha', 'bruno.m.cebola@tecnico.ulisboa.pt', '01-01-2021'),
  ('França', 'bruno.m.cebola@tecnico.ulisboa.pt', '01-01-2021'),
  ('Portugal', 'bruno.m.cebola@tecnico.ulisboa.pt', '02-01-2021');

-- populate date_interval
INSERT INTO date_interval
VALUES
  ('01-12-2022', '07-12-2022'),
  ('08-12-2022', '15-12-2022');

-- populate reservation
INSERT INTO reservation
VALUES
  ('Portugal', 'AXZ-879-145-TVC', '01-12-2022', '07-12-2022', 'bruno.m.cebola@tecnico.ulisboa.pt'),
  ('Portugal', 'AXZ-879-145-TVC', '08-12-2022', '15-12-2022', 'pedro.santos@tecnico.ulisboa.pt'),
  ('França', 'BTH-UJN-552-829', '08-12-2022', '15-12-2022', 'pedro.santos@tecnico.ulisboa.pt'),
  ('Portugal', '689-FEK-325-NKE', '08-12-2022', '15-12-2022', 'bruno.m.cebola@tecnico.ulisboa.pt');

-- populate authorised
INSERT INTO authorised
VALUES
  ('Portugal', 'AXZ-879-145-TVC', '01-12-2022', '07-12-2022', 'bruno.m.cebola@tecnico.ulisboa.pt'),
  ('Portugal', 'AXZ-879-145-TVC', '01-12-2022', '07-12-2022', 'joao.pedro.nunes@tecnico.ulisboa.pt'),
  ('Portugal', '689-FEK-325-NKE', '08-12-2022', '15-12-2022', 'bruno.m.cebola@tecnico.ulisboa.pt'),
  ('Portugal', '689-FEK-325-NKE', '08-12-2022', '15-12-2022', 'rui.abrantes@tecnico.ulisboa.pt'),
  ('França', 'BTH-UJN-552-829', '08-12-2022', '15-12-2022', 'pedro.santos@tecnico.ulisboa.pt');

-- populate trip
INSERT INTO trip
VALUES
  ('Portugal', 'AXZ-879-145-TVC', '01-12-2022', '07-12-2022', '01-12-2022', '03-12-2022', 'VR7NVNVEW7NWK330W', 'joao.pedro.nunes@tecnico.ulisboa.pt', 0, 0, 10, 10),
  ('Portugal', 'AXZ-879-145-TVC', '01-12-2022', '07-12-2022', '04-12-2022', '07-12-2022', 'VR7NVNVEW7NWK330W', 'joao.pedro.nunes@tecnico.ulisboa.pt', 10, 10, 0, 0),
  ('Portugal', '689-FEK-325-NKE', '08-12-2022', '15-12-2022', '08-12-2022', '11-12-2022', 'KJBRWV88R43NFO348', 'bruno.m.cebola@tecnico.ulisboa.pt', 10, 10, -10, -10),
  ('Portugal', '689-FEK-325-NKE', '08-12-2022', '15-12-2022', '12-12-2022', '15-12-2022', 'KJBRWV88R43NFO348', 'rui.abrantes@tecnico.ulisboa.pt', -10, -10, 10, 10),
  ('França', 'BTH-UJN-552-829', '08-12-2022', '15-12-2022', '08-12-2022', '15-12-2022', 'NL43KGJKNT5LRN4OJ', 'pedro.santos@tecnico.ulisboa.pt', 0, 0, 0, 10);