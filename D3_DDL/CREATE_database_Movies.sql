-- Generated by Oracle SQL Developer Data Modeler 21.4.1.349.1605
--   at:        2022-04-26 19:40:48 CEST
--   site:      Oracle Database 21c
--   type:      Oracle Database 21c



DROP TABLE countries CASCADE CONSTRAINTS;

DROP TABLE halls CASCADE CONSTRAINTS;

DROP TABLE locations CASCADE CONSTRAINTS;

DROP TABLE movies CASCADE CONSTRAINTS;

DROP TABLE performances CASCADE CONSTRAINTS;

DROP TABLE theathers CASCADE CONSTRAINTS;

DROP TABLE tickets CASCADE CONSTRAINTS;

DROP TABLE viewers CASCADE CONSTRAINTS;

DROP TABLE zipcodes CASCADE CONSTRAINTS;

-- predefined type, no DDL - MDSYS.SDO_GEOMETRY

-- predefined type, no DDL - XMLTYPE

CREATE TABLE countries (
    countrycode VARCHAR2(2) NOT NULL,
    country     VARCHAR2(100) NOT NULL
);

ALTER TABLE countries ADD CONSTRAINT countrie_pk PRIMARY KEY ( countrycode );

CREATE TABLE halls (
    hall_id     INTEGER GENERATED ALWAYS AS IDENTITY,
    seat_amount INTEGER,
    floor       INTEGER NOT NULL,
    hallnumber  INTEGER NOT NULL,
    screentype  VARCHAR2(25 CHAR),
    theather_id INTEGER NOT NULL
);

ALTER TABLE halls ADD CONSTRAINT hall_pk PRIMARY KEY ( hall_id );

CREATE TABLE locations (
    location_id INTEGER GENERATED ALWAYS AS IDENTITY,
    street      VARCHAR2(100 CHAR) NOT NULL,
    housenumber INTEGER NOT NULL,
    countrycode VARCHAR2(2) NOT NULL,
    zipcode     VARCHAR2(5 CHAR) NOT NULL
);

ALTER TABLE locations ADD CONSTRAINT location_pk PRIMARY KEY ( location_id );

CREATE TABLE movies (
    movie_id     INTEGER GENERATED ALWAYS AS IDENTITY,
    title        VARCHAR2(50 CHAR) NOT NULL UNIQUE,
    release_date DATE NOT NULL,
    genre        VARCHAR2(20 CHAR),
    type         VARCHAR2(20 CHAR) NOT NULL,
    runtime      INTEGER,
    plot         VARCHAR2(200 CHAR),
    language     VARCHAR2(5)
);

ALTER TABLE movies ADD CONSTRAINT movie_pk PRIMARY KEY ( movie_id );

ALTER TABLE movies
    ADD CONSTRAINT movies_ck_runtime CHECK ( runtime BETWEEN 20 AND 250 );

CREATE TABLE performances (
    performance_id INTEGER GENERATED ALWAYS AS IDENTITY,
    movie_id       INTEGER NOT NULL,
    hall_id        INTEGER NOT NULL,
    starttime      TIMESTAMP NOT NULL,
    endtime        TIMESTAMP NOT NULL
);


ALTER TABLE performances ADD CONSTRAINT performance_pk PRIMARY KEY ( performance_id );

CREATE TABLE theathers (
    theather_id INTEGER GENERATED ALWAYS AS IDENTITY,
    name        VARCHAR2(25 CHAR) NOT NULL,
    shop        SMALLINT,
    phonenumber VARCHAR2(13 CHAR),
    location_id INTEGER NOT NULL
);

ALTER TABLE theathers ADD CONSTRAINT theathers_ck_phonenumber CHECK ( phonenumber LIKE '+%_' );

ALTER TABLE theathers ADD CONSTRAINT theather_pk PRIMARY KEY ( theather_id );

CREATE TABLE tickets (
    viewer_id      INTEGER NOT NULL,
    performance_id INTEGER NOT NULL,
    seatnumber     INTEGER NOT NULL,
    price          NUMBER NOT NULL

);

ALTER TABLE tickets ADD CONSTRAINT ticket_pk PRIMARY KEY ( viewer_id,
                                                               performance_id,seatnumber );

CREATE TABLE viewers (
    viewer_id   INTEGER GENERATED ALWAYS AS IDENTITY,
    firstname   VARCHAR2(20 CHAR) NOT NULL,
    lastname    VARCHAR2(20 CHAR),
    birthdate   DATE,
	gender		VARCHAR2(1 CHAR) NOT NULL,
    email       VARCHAR2(100 CHAR) NOT NULL UNIQUE,
    location_id INTEGER NOT NULL
);

ALTER TABLE Viewers 
    ADD CONSTRAINT viewers_CK_gender
check(gender IN ( 'M', 'V', 'X') );

ALTER TABLE viewers ADD CONSTRAINT viewer_pk PRIMARY KEY ( viewer_id );

CREATE TABLE zipcodes (
    city        VARCHAR2(100 CHAR) NOT NULL,
    zipcode     VARCHAR2(5 CHAR) NOT NULL,
    countrycode VARCHAR2(2 CHAR) NOT NULL
);

ALTER TABLE zipcodes ADD CONSTRAINT zipcode_pk PRIMARY KEY ( zipcode,
                                                              countrycode );
ALTER TABLE halls
    ADD CONSTRAINT unique_hall UNIQUE (hallnumber, floor);

ALTER TABLE performances
    ADD CONSTRAINT unique_performance UNIQUE (starttime, movie_id, hall_id);

ALTER TABLE halls
    ADD CONSTRAINT fk_hall_theather FOREIGN KEY ( theather_id )
        REFERENCES theathers ( theather_id );

ALTER TABLE locations
    ADD CONSTRAINT fk_location_zipcode FOREIGN KEY ( zipcode,
                                                     countrycode )
        REFERENCES zipcodes ( zipcode,
                              countrycode );

ALTER TABLE performances
    ADD CONSTRAINT fk_performance_hall FOREIGN KEY ( hall_id )
        REFERENCES halls ( hall_id );

ALTER TABLE performances
    ADD CONSTRAINT fk_performance_movie FOREIGN KEY ( movie_id )
        REFERENCES movies ( movie_id );

ALTER TABLE theathers
    ADD CONSTRAINT fk_theather_location FOREIGN KEY ( location_id )
        REFERENCES locations ( location_id );

ALTER TABLE tickets
    ADD CONSTRAINT fk_ticket_performance FOREIGN KEY ( performance_id )
        REFERENCES performances ( performance_id );

ALTER TABLE tickets
    ADD CONSTRAINT fk_ticket_viewer FOREIGN KEY ( viewer_id )
        REFERENCES viewers ( viewer_id );

ALTER TABLE viewers
    ADD CONSTRAINT fk_viewer_location FOREIGN KEY ( location_id )
        REFERENCES locations ( location_id );

ALTER TABLE zipcodes
    ADD CONSTRAINT fk_zipcodes_countrie FOREIGN KEY ( countrycode )
        REFERENCES countries ( countrycode );



-- Oracle SQL Developer Data Modeler Summary Report: 
-- 
-- CREATE TABLE                             9
-- CREATE INDEX                             0
-- ALTER TABLE                             22
-- CREATE VIEW                              0
-- ALTER VIEW                               0
-- CREATE PACKAGE                           0
-- CREATE PACKAGE BODY                      0
-- CREATE PROCEDURE                         0
-- CREATE FUNCTION                          0
-- CREATE TRIGGER                           0
-- ALTER TRIGGER                            0
-- CREATE COLLECTION TYPE                   0
-- CREATE STRUCTURED TYPE                   0
-- CREATE STRUCTURED TYPE BODY              0
-- CREATE CLUSTER                           0
-- CREATE CONTEXT                           0
-- CREATE DATABASE                          0
-- CREATE DIMENSION                         0
-- CREATE DIRECTORY                         0
-- CREATE DISK GROUP                        0
-- CREATE ROLE                              0
-- CREATE ROLLBACK SEGMENT                  0
-- CREATE SEQUENCE                          0
-- CREATE MATERIALIZED VIEW                 0
-- CREATE MATERIALIZED VIEW LOG             0
-- CREATE SYNONYM                           0
-- CREATE TABLESPACE                        0
-- CREATE USER                              0
-- 
-- DROP TABLESPACE                          0
-- DROP DATABASE                            0
-- 
-- REDACTION POLICY                         0
-- 
-- ORDS DROP SCHEMA                         0
-- ORDS ENABLE SCHEMA                       0
-- ORDS ENABLE OBJECT                       0
-- 
-- ERRORS                                   0
-- WARNINGS                                 0
