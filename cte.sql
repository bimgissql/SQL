CREATE TABLE ctetest.building
(
  id bigint NOT NULL,
  name character varying NOT NULL,
  address character varying NOT NULL,
  storeys bigint,
  height double precision,
  area double precision,
  elevation double precision,
  CONSTRAINT building_pk PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE ctetest.building OWNER TO postgres;
  
  
CREATE TABLE ctetest.floor
(
  id bigint NOT NULL,
  buildingid bigint NOT NULL,
  name character varying,
  height double precision,
  area double precision,
  elevation double precision,
  CONSTRAINT floor_pk PRIMARY KEY (id),
  CONSTRAINT fk_building FOREIGN KEY (buildingid)
      REFERENCES ctetest.building (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE
)
WITH (
  OIDS=FALSE
);
ALTER TABLE ctetest.floor OWNER TO postgres;


SELECT * 
FROM ctetest.building;

SELECT * 
FROM ctetest.floor;

SELECT id, name, address, storeys, height, area, elevation
FROM ctetest.building;

SELECT id, buildingid, name, height, area, elevation
FROM ctetest.floor;
  
SELECT b.*, f.*
FROM ctetest.building b
INNER JOIN ctetest.floor f
  ON b.id = f.buildingid
WHERE b.area > 150
AND f.area < 400
AND b.height < 150
AND f.height > 2.8;


WITH bdng AS
(
SELECT id, name, address, storeys, height, area, elevation
FROM ctetest.building
WHERE area > 150
AND height < 150
),
flr AS
(
SELECT id, buildingid, name, height, area, elevation
FROM ctetest.floor
WHERE area < 400
AND height > 2.8
)
SELECT * 
FROM bdng b
INNER JOIN flr f
  ON b.id = f.buildingid;




  
  
  CREATE TABLE ctetest.users
(
  id bigint NOT NULL,
  name character varying NOT NULL,
  managerid bigint,
  CONSTRAINT users_pk PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE ctetest.users
  OWNER TO postgres;

INSERT INTO ctetest.users(id, name, managerid)
VALUES 
(1, 'Prezes', null),
(2, 'Dyrektor 1', 1),
(3, 'Dyrektor 2', 1),
(4, 'Kierownik A', 2),
(5, 'Kierownik B', 2),
(6, 'Kierownik C', 2),
(7, 'Kierownik D', 3),
(8, 'Kierownik E', 3),
(9, 'Kierownik F', 3),
(10, 'Pracownik 1', 5),
(11, 'Pracownik 2', 5),
(12, 'Pracownik 3', 7),
(13, 'Pracownik 4', 7),
(14, 'Pracownik 5', 9),
(15, 'Pomocnik 1', 10),
(16, 'Pomocnik 2', 11);


WITH RECURSIVE usr AS 
(
  SELECT u1.id, u1.name, u1.managerid, 1 rank
  FROM ctetest.users u1
  WHERE u1.managerid IS NULL
  UNION ALL
  SELECT u2.id, u2.name, u2.managerid, u1.rank + 1 rank
  FROM ctetest.users u2
  INNER JOIN usr u1 ON u1.id = u2.managerid
)
SELECT *
FROM usr

 
 
 
SELECT m.MESSAGEID, COUNT(mp.MESSAGEID) FROM MESSAGE m
LEFT JOIN MESSAGEPART mp ON mp.MESSAGEID = m.MESSAGEID
GROUP BY m.MESSAGEID;


SELECT b.*, f.*
FROM ctetest.building b
INNER JOIN ctetest.floor f
  ON b.id = f.buildingid;

SELECT b.id, COUNT(f.id)
FROM ctetest.building b
INNER JOIN ctetest.floor f
  ON b.id = f.buildingid
GROUP BY b.id
ORDER BY id;


CREATE OR REPLACE FUNCTION ctetest.getbuilding1(IN id bigint)
  RETURNS TABLE(id bigint,
                name character varying,
                address character varying,
                storeys bigint,
                height double precision,
                area double precision,
                elevation double precision
                ) AS
$BODY$

SELECT id, 
       name, 
       address, 
       storeys, 
       height, 
       area, 
       elevation
FROM ctetest.building
WHERE id = $1;

$BODY$
  LANGUAGE sql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION ctetest.getbuilding1(bigint) OWNER TO postgres;
COMMENT ON FUNCTION ctetest.getbuilding1(bigint) IS 'Get building by id';

SELECT * FROM ctetest.getbuilding1(1);


CREATE OR REPLACE FUNCTION ctetest.getbuilding2(IN id bigint)
  RETURNS TABLE(id bigint,
                name character varying,
                address character varying,
                storeys bigint,
                height double precision,
                area double precision,
                elevation double precision
                ) AS
$BODY$

SELECT b.id, 
       b.name, 
       b.address, 
       COUNT(f.id) AS storeys, 
       b.height, 
       b.area, 
       b.elevation
FROM ctetest.building b
INNER JOIN ctetest.floor f
  ON b.id = f.buildingid
WHERE b.id = $1
GROUP BY b.id;

$BODY$
  LANGUAGE sql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION ctetest.getbuilding2(bigint) OWNER TO postgres;
COMMENT ON FUNCTION ctetest.getbuilding2(bigint) IS 'Get building by id';

SELECT * FROM ctetest.getbuilding2(1);





WITH RECURSIVE usr AS 
(
  SELECT u1.id, u1.name, u1.managerid, 1 rank
  FROM ctetest.users u1
  WHERE u1.managerid IS NULL
  UNION ALL
  SELECT u2.id, u2.name, u2.managerid, u1.rank + 1 rank
  FROM ctetest.users u2
  INNER JOIN usr u1 ON u1.id = u2.managerid
)
SELECT *
FROM usr;



SELECT u1.id, u1.name, u1.managerid
FROM ctetest.users u1; 
