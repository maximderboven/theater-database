-- In dit bestand zet je je package body. Hier zit al je code van je publieke functies, alsook private hulpfuncties.
CREATE
    OR REPLACE PACKAGE BODY PKG_movies IS
    -- Random functions
    FUNCTION RANDOM_NUMBER_IN_RANGE(P_START IN NUMBER, P_END IN NUMBER)
        RETURN NUMBER
        IS
        R_RANDOM_NUMBER NUMBER;
    BEGIN
        R_RANDOM_NUMBER := P_START + (P_END - P_START) * DBMS_RANDOM.VALUE;
        RETURN R_RANDOM_NUMBER;
    END RANDOM_NUMBER_IN_RANGE;

    FUNCTION RANDOM_DATE_IN_RANGE(P_START IN DATE, P_END IN DATE)
        RETURN DATE
        IS
        R_RANDOM_DATE DATE;
    BEGIN
        R_RANDOM_DATE := P_START + (P_END - P_START) * DBMS_RANDOM.VALUE;
        RETURN R_RANDOM_DATE;
    END RANDOM_DATE_IN_RANGE;


    FUNCTION RANDOM_MOVIE_TITLE
        RETURN VARCHAR2
        IS
        TYPE t_string_array IS VARRAY(10) OF VARCHAR2(50);
        N        PLS_INTEGER;
        a_movies t_string_array := t_string_array('The Godfather', 'Memory', 'The Duke', 'Sonic The Hedgehog',
                                                  'Fantastic Beasts and where to find them', 'Louise',
                                                  'Downton Abbey', 'Maya de bij', 'Encanto', 'A Hero');
    BEGIN
        N := RANDOM_NUMBER_IN_RANGE(1, 10);
        RETURN a_movies(N);
    END RANDOM_MOVIE_TITLE;

    FUNCTION RANDOM_SCREENTYPE
        RETURN VARCHAR2
        IS
        TYPE t_string_array IS VARRAY(6) OF VARCHAR2(10);
        N             PLS_INTEGER;
        a_screentypes t_string_array := t_string_array('MDX', '4D', '3D', 'Digital', 'IMAX', '2D');
    BEGIN
        N := RANDOM_NUMBER_IN_RANGE(1, 6);
        RETURN a_screentypes(N);
    END RANDOM_SCREENTYPE;


    -- Lookup functions
    FUNCTION LOOKUP_VIEWER(P_EMAIL IN VARCHAR2)
        RETURN NUMBER
        IS
        R_VIEWER_ID NUMBER;
    BEGIN
        SELECT VIEWER_ID
        INTO R_VIEWER_ID
        FROM VIEWERS
        WHERE LOWER(P_EMAIL) = LOWER(EMAIL);
        RETURN R_VIEWER_ID;
    END;

    FUNCTION
        LOOKUP_MOVIE(P_MOVIETITLE IN VARCHAR2)
        RETURN NUMBER
        IS
        R_MOVIE_ID NUMBER;
    BEGIN
        SELECT MOVIE_ID
        INTO R_MOVIE_ID
        FROM MOVIES
        WHERE LOWER(P_MOVIETITLE) = LOWER(title);
        RETURN R_MOVIE_ID;
    END;
    FUNCTION
        LOOKUP_PERFORMANCE(P_MOVIE_ID IN NUMBER, P_HALL_ID IN NUMBER, P_STARTTIME IN DATE)
        RETURN NUMBER
        IS
        R_PERFORMANCE_ID NUMBER;
    BEGIN
        SELECT PERFORMANCE_ID
        INTO R_PERFORMANCE_ID
        FROM PERFORMANCES
        WHERE MOVIE_ID = P_MOVIE_ID
          AND HALL_ID = P_HALL_ID
          AND STARTTIME = P_STARTTIME;
        RETURN R_PERFORMANCE_ID;
    END;

    FUNCTION
        LOOKUP_THEATHER(P_THEATHERNAME IN VARCHAR2, P_LOCATION_ID IN NUMBER)
        RETURN NUMBER
        IS
        R_THEATHER_ID NUMBER;
    BEGIN
        SELECT THEATHER_ID
        INTO R_THEATHER_ID
        FROM THEATHERS
        WHERE LOWER(P_THEATHERNAME) = LOWER(name)
          AND LOCATION_ID = P_LOCATION_ID;
        RETURN R_THEATHER_ID;
    END;

    FUNCTION
        LOOKUP_HALL(P_HALLNUMBER IN NUMBER, P_FLOOR IN NUMBER, P_THEATHER_ID IN NUMBER)
        RETURN NUMBER
        IS
        R_HALL_ID NUMBER;
    BEGIN
        SELECT HALL_ID
        INTO R_HALL_ID
        FROM HALLS
        WHERE HALLNUMBER = P_HALLNUMBER
          AND FLOOR = P_FLOOR
          AND THEATHER_ID = P_THEATHER_ID;
        RETURN R_HALL_ID;
    END;

    FUNCTION
        LOOKUP_LOCATION(P_STREET IN VARCHAR2,
                        P_HOUSENUMBER IN NUMBER, P_ZIPCODE IN VARCHAR2, P_COUNTRYCODE IN VARCHAR2)
        RETURN NUMBER
        IS
        R_LOCATION_ID NUMBER;
    BEGIN
        SELECT LOCATION_ID
        INTO R_LOCATION_ID
        FROM LOCATIONS L
                 JOIN ZIPCODES Z on Z.ZIPCODE = L.ZIPCODE and Z.COUNTRYCODE = L.COUNTRYCODE
                 JOIN COUNTRIES C on C.COUNTRYCODE = Z.COUNTRYCODE
        WHERE LOWER(P_STREET) = LOWER(L.STREET)
          AND P_HOUSENUMBER = L.HOUSENUMBER
          AND LOWER(P_ZIPCODE) = LOWER(Z.ZIPCODE)
          AND LOWER(P_COUNTRYCODE) = LOWER(C.COUNTRYCODE);
        RETURN R_LOCATION_ID;
    END;

    FUNCTION
        LOOKUP_COUNTRY(P_COUNTRYCODE IN VARCHAR2)
        RETURN NUMBER
        IS
        R_COUNTRYCODE NUMBER;
    BEGIN
        SELECT COUNTRYCODE
        INTO R_COUNTRYCODE
        FROM COUNTRIES
        WHERE LOWER(P_COUNTRYCODE) = LOWER(COUNTRYCODE);
        RETURN R_COUNTRYCODE;
    END;


    -- Generate functions

    PROCEDURE GENERATE_MOVIES(P_AMOUNT IN NUMBER)
        IS
        V_R_DATE   DATE;
        V_R_NUMBER NUMBER;
        V_R_TITLE  VARCHAR2(50);
    BEGIN
        FOR i IN 1..P_AMOUNT
            LOOP
                V_R_DATE := RANDOM_DATE_IN_RANGE(TO_DATE('01-01-1900', 'DD-MM-YYYY'),
                                                 TO_DATE('01-01-2022', 'DD-MM-YYYY'));
                V_R_NUMBER := RANDOM_NUMBER_IN_RANGE(20, 200);
                V_R_TITLE := RANDOM_MOVIE_TITLE;
                INSERT INTO MOVIES (TITLE, RELEASE_DATE, GENRE, "TYPE", RUNTIME, PLOT, LANGUAGE)
                VALUES (V_R_TITLE || i, V_R_DATE,
                        'Drama',
                        'MOVIE',
                        V_R_NUMBER,
                        'PLOT' || i,
                        'EN');
                commit;
            END LOOP;
    END GENERATE_MOVIES;

    PROCEDURE GENERATE_VIEWERS(P_AMOUNT IN NUMBER)
        IS
        TYPE type_locations IS TABLE OF LOCATIONS.LOCATION_ID%TYPE
            INDEX BY PLS_INTEGER;
        t_locationid    type_locations;
        V_R_LOCATION_ID NUMBER;
        V_R_DATE        DATE;
    BEGIN
        SELECT LOCATION_ID BULK COLLECT
        INTO t_locationid
        FROM LOCATIONS;
        FOR i IN 1..P_AMOUNT
            LOOP
                V_R_LOCATION_ID := t_locationid(RANDOM_NUMBER_IN_RANGE(1, t_locationid.COUNT));
                V_R_DATE := RANDOM_DATE_IN_RANGE(TO_DATE('01-01-1900', 'DD-MM-YYYY'),
                                                 TO_DATE('01-01-2022', 'DD-MM-YYYY'));
                INSERT INTO VIEWERS (FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, EMAIL, LOCATION_ID)
                VALUES ('firstname' || i, 'lastname' || i, V_R_DATE,
                        'M', 'firstname' || i || '@gmail.com',
                        V_R_LOCATION_ID);
                commit;
            END LOOP;
    END GENERATE_VIEWERS;

    PROCEDURE GENERATE_THEATHERS(P_AMOUNT IN NUMBER)
        IS
        TYPE type_locations IS TABLE OF LOCATIONS.LOCATION_ID%TYPE
            INDEX BY PLS_INTEGER;
        t_locationid     type_locations;
        V_R_LOCATION_ID  NUMBER;
        V_R_NUMBER_PHONE NUMBER;
        V_R_NUMBER_SHOP  NUMBER;
    BEGIN
        SELECT LOCATION_ID BULK COLLECT
        INTO t_locationid
        FROM LOCATIONS;
        FOR i IN 1..P_AMOUNT
            LOOP
                V_R_LOCATION_ID := t_locationid(RANDOM_NUMBER_IN_RANGE(1, t_locationid.COUNT));
                V_R_NUMBER_PHONE := RANDOM_NUMBER_IN_RANGE(10000000000, 99999999999);
                V_R_NUMBER_SHOP := RANDOM_NUMBER_IN_RANGE(1, 1);
                INSERT INTO THEATHERS (NAME, SHOP, PHONENUMBER, LOCATION_ID)
                VALUES ('Theather' || i, V_R_NUMBER_SHOP,
                        '+' || CAST(V_R_NUMBER_PHONE AS VARCHAR2(12)),
                        V_R_LOCATION_ID);
                commit;
            END LOOP;
    END GENERATE_THEATHERS;

    PROCEDURE
        GENERATE_HALLS(P_AMOUNT IN NUMBER)
        IS
        TYPE type_theathers IS TABLE OF THEATHERS.THEATHER_ID%TYPE
            INDEX BY PLS_INTEGER;
        t_theatherid    type_theathers;
        V_R_SEAT_AMOUNT NUMBER ;
        V_R_FLOOR       NUMBER ;
        V_R_HALLNUMBER  NUMBER ;
        V_R_SCREENTYPE  VARCHAR2(10) ;
    BEGIN
        SELECT THEATHER_ID BULK COLLECT
        INTO t_theatherid
        FROM THEATHERS;
        FOR j IN 1..t_theatherid.COUNT
            LOOP
                FOR i IN 1..P_AMOUNT
                    LOOP
                        V_R_SEAT_AMOUNT := RANDOM_NUMBER_IN_RANGE(1, 100);
                        /* V_R_FLOOR := RANDOM_NUMBER_IN_RANGE(1, 4);
                        V_R_HALLNUMBER := RANDOM_NUMBER_IN_RANGE(0, 50);*/
                        V_R_SCREENTYPE := RANDOM_SCREENTYPE;
                        INSERT INTO HALLS (SEAT_AMOUNT, FLOOR, HALLNUMBER, SCREENTYPE, THEATHER_ID)
                        VALUES (V_R_SEAT_AMOUNT, j,
                                i,
                                V_R_SCREENTYPE, t_theatherid(j));
                        commit;
                    END LOOP;
            END LOOP;
    END GENERATE_HALLS;


    PROCEDURE GENERATE_PERFORMANCES(P_AMOUNT IN NUMBER)
        IS
        TYPE type_movies IS TABLE OF MOVIES.MOVIE_ID%TYPE
            INDEX BY PLS_INTEGER;
        t_movieid     type_movies;
        TYPE type_halls IS TABLE OF HALLS.HALL_ID%TYPE
            INDEX BY PLS_INTEGER;
        t_hallid      type_halls;
        V_R_MOVIEID   NUMBER ;
        V_R_STARTTIME DATE ;
        V_R_ENDTIME   DATE ;
    BEGIN
        SELECT MOVIE_ID BULK COLLECT
        INTO t_movieid
        FROM MOVIES;
        SELECT HALL_ID BULK COLLECT
        INTO t_hallid
        FROM HALLS;
        for j in 1..t_hallid.COUNT
            LOOP
                FOR i IN 1..P_AMOUNT
                    LOOP
                        V_R_MOVIEID := t_movieid(RANDOM_NUMBER_IN_RANGE(1, t_movieid.COUNT));
                        V_R_STARTTIME := RANDOM_DATE_IN_RANGE(TO_DATE('01-01-1900 00:00', 'DD-MM-YYYY HH24:MI'),
                                                              TO_DATE('01-01-2022 23:59', 'DD-MM-YYYY HH24:MI'));
                        V_R_ENDTIME := V_R_STARTTIME + RANDOM_NUMBER_IN_RANGE(0, 200);
                        INSERT INTO PERFORMANCES (MOVIE_ID, HALL_ID, STARTTIME, ENDTIME)
                        VALUES (V_R_MOVIEID,
                                t_hallid(j),
                                V_R_STARTTIME,
                                V_R_ENDTIME);
                        commit;
                    END LOOP;
            END LOOP;
    END GENERATE_PERFORMANCES;

    PROCEDURE VUL_LOCATIONS IS
    BEGIN
        -- Countries
        PKG_MOVIES.ADD_COUNTRY('BE', 'Belgium');
        PKG_MOVIES.ADD_COUNTRY('US', 'United States');
        PKG_MOVIES.ADD_COUNTRY('FR', 'France');
        PKG_MOVIES.ADD_COUNTRY('NL', 'Netherlands');
        PKG_MOVIES.ADD_COUNTRY('ZA', 'South Africa');

-- Zipcodes
        PKG_MOVIES.ADD_ZIPCODE('Brussels', '1000', 'BE');
        PKG_MOVIES.ADD_ZIPCODE('New York', '10002', 'US');
        PKG_MOVIES.ADD_ZIPCODE('Paris', '75000', 'FR');
        PKG_MOVIES.ADD_ZIPCODE('Amsterdam', '1015', 'NL');
        PKG_MOVIES.ADD_ZIPCODE('Cape Town', '6665', 'ZA');

-- Locations
        PKG_MOVIES.ADD_LOCATION('Galerie de la Reine', 26, '1000', 'BE');
        PKG_MOVIES.ADD_LOCATION('Brixtonlaan', 176, '1000', 'BE');
        PKG_MOVIES.ADD_LOCATION('Aven Ackers', 227, '10002', 'US');
        PKG_MOVIES.ADD_LOCATION('West 125th Street', 254, '10002', 'US');
        PKG_MOVIES.ADD_LOCATION('Pl. du Châtelet', 2, '75000', 'FR');
        PKG_MOVIES.ADD_LOCATION('Rue Bois des Fosses', 139, '75000', 'FR');
        PKG_MOVIES.ADD_LOCATION('Kleine-Gartmanplantsoen', 15, '1015', 'NL');
        PKG_MOVIES.ADD_LOCATION('Robert de Vriesstraat', 51, '1015', 'NL');
        PKG_MOVIES.ADD_LOCATION('D.F. Malan St', 25, '6665', 'ZA');
        PKG_MOVIES.ADD_LOCATION('Oost St', 1155, '6665', 'ZA');
    END;

    PROCEDURE
        GENERATE_TICKETS(P_AMOUNT IN NUMBER)
        IS
        TYPE type_viewers IS TABLE OF VIEWERS.VIEWER_ID%TYPE
            INDEX BY PLS_INTEGER;
        t_viewerid        type_viewers;
        TYPE type_performances IS TABLE OF PERFORMANCES.PERFORMANCE_ID%TYPE
            INDEX BY PLS_INTEGER;
        t_performanceid   type_performances;
        V_R_VIEWERID      NUMBER ;
        V_R_PERFORMANCEID NUMBER ;
        V_R_SEATNUMBER    NUMBER ;
        V_R_PRICE         NUMBER ;
    BEGIN
        SELECT VIEWER_ID BULK COLLECT
        INTO t_viewerid
        FROM VIEWERS;
        SELECT PERFORMANCE_ID BULK COLLECT
        INTO t_performanceid
        FROM PERFORMANCES;
        FOR i IN 1..P_AMOUNT
            LOOP
                V_R_VIEWERID := t_viewerid(RANDOM_NUMBER_IN_RANGE(1, t_viewerid.COUNT));
                V_R_PERFORMANCEID := t_performanceid(RANDOM_NUMBER_IN_RANGE(1, t_performanceid.COUNT));
                V_R_SEATNUMBER := RANDOM_NUMBER_IN_RANGE(1, 100);
                V_R_PRICE := ROUND(RANDOM_NUMBER_IN_RANGE(1, 20),2);
                INSERT INTO TICKETS
                VALUES (V_R_VIEWERID, V_R_PERFORMANCEID,
                        V_R_SEATNUMBER, V_R_PRICE);
                commit;
            END LOOP;
    END GENERATE_TICKETS;

    PROCEDURE GENERATE_2_LEVELS(P_AMOUNT_HALLS IN NUMBER, P_AMOUNT_THEATHERS IN NUMBER, P_AMOUNT_PERFORMANCES IN NUMBER)
        IS
    BEGIN
        GENERATE_THEATHERS(P_AMOUNT_THEATHERS);
        GENERATE_HALLS(P_AMOUNT_HALLS);
        GENERATE_PERFORMANCES(P_AMOUNT_PERFORMANCES);

    END GENERATE_2_LEVELS;


    PROCEDURE GENERATE_MANY_TO_MANY(P_AMOUNT_MOVIE IN NUMBER, P_AMOUNT_VIEWERS IN NUMBER, P_AMOUNT_TICKETS IN NUMBER,
                                    P_AMOUNT_PERFORMANCES IN NUMBER, P_AMOUNT_HALLS IN NUMBER,
                                    P_AMOUNT_THEATHERS IN NUMBER)
        IS
        start_time_many pls_integer;
        start_time_2levels pls_integer;
        end_time_2levels pls_integer;
        performances_generated pls_integer;
        halls_generated pls_integer;
    BEGIN
        DBMS_OUTPUT.PUT_LINE('4.1 - Generate_movies(20)');
        GENERATE_MOVIES(P_AMOUNT_MOVIE);
        VUL_LOCATIONS();
        DBMS_OUTPUT.PUT_LINE('4.2 - Generate_viewers(20)');
        DBMS_OUTPUT.PUT_LINE('4.3 - Generate_viewers(20)');
        DBMS_OUTPUT.PUT_LINE('4.4 - Generate_tickets(50)');
        DBMS_OUTPUT.PUT_LINE('Start generating 2 Levels (generate_2_levels(40,50)');
        start_time_2levels  := dbms_utility.get_time;
        GENERATE_2_LEVELS(P_AMOUNT_HALLS, P_AMOUNT_THEATHERS, P_AMOUNT_PERFORMANCES);
        end_time_2levels  := dbms_utility.get_time;
        start_time_many := dbms_utility.get_time;
        GENERATE_VIEWERS(P_AMOUNT_VIEWERS);
        GENERATE_TICKETS(P_AMOUNT_TICKETS);
        SELECT COUNT(*) INTO performances_generated FROM PERFORMANCES ;
        SELECT COUNT(*) INTO halls_generated FROM HALLS ;
        DBMS_OUTPUT.PUT_LINE('Halls generated: ' || halls_generated);
        DBMS_OUTPUT.PUT_LINE('Performances generated: ' || performances_generated);
        DBMS_OUTPUT.PUT_LINE('4.5 - Generate_viewers(20)');
        DBMS_OUTPUT.PUT_LINE('The Duration of the many to many generation is: ' ||
                             (dbms_utility.get_time - start_time_many)/100 || ' seconds');
        DBMS_OUTPUT.PUT_LINE('The Duration of the 2 levels generation is: ' ||(end_time_2levels - start_time_2levels)/100 || ' seconds');
    END GENERATE_MANY_TO_MANY;

    PROCEDURE BEWIJS_MILESTONE_5
        IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('BEWIJS M5');
        DBMS_OUTPUT.PUT_LINE('1 - Random nummer terruggeeft binnen een nummerbereik');
        DBMS_OUTPUT.PUT_LINE('give_random_number(1,10) --> ' || ROUND(RANDOM_NUMBER_IN_RANGE(1, 10),0));
        DBMS_OUTPUT.PUT_LINE('2 - Random datum binnen een datumbereik');
        DBMS_OUTPUT.PUT_LINE('give_random_date(TO_DATE(''01-01-2000'', ''DD-MM-YYYY''), SYSDATE) --> ' ||
                             RANDOM_DATE_IN_RANGE(TO_DATE('01-01-2000', 'DD-MM-YYYY'), SYSDATE));
        DBMS_OUTPUT.PUT_LINE('3 - Random string uit een lijst');
        DBMS_OUTPUT.PUT_LINE('random_movietitle --> ' || RANDOM_MOVIE_TITLE());
        DBMS_OUTPUT.PUT_LINE('4 - Starting Many-to-Many generation (generate_many_to_many(20, 20, 50, 20))');
        GENERATE_MANY_TO_MANY(20, 20, 50, 50, 40, 20);
    END BEWIJS_MILESTONE_5;





PROCEDURE PRINT_OUT(P_AMOUNT_MOVIES IN NUMBER, P_AMOUNT_PERFORMANCES IN NUMBER, P_AMOUNT_TICKETS IN NUMBER)
    IS
    R_MOVIES     MOVIES%ROWTYPE;
    R_PERFORMANCES          PERFORMANCES%ROWTYPE;
    R_TICKETS      TICKETS%ROWTYPE;
    E_NEGATIVE   EXCEPTION;
BEGIN
    IF P_AMOUNT_MOVIES < 0 THEN
    RAISE E_NEGATIVE;
    ELSIF P_AMOUNT_PERFORMANCES < 0 THEN
        RAISE E_NEGATIVE;
    ELSIF P_AMOUNT_TICKETS < 0 THEN
        RAISE E_NEGATIVE;
    ELSE
        IF P_AMOUNT_MOVIES > 0 THEN
            DBMS_OUTPUT.PUT_LINE('OVERZICHT VAN ALLE TICKETS VERKOCHT PER FILM:');
            DBMS_OUTPUT.PUT_LINE('==================================================');
            FOR i IN 1..P_AMOUNT_MOVIES
                LOOP
                    DBMS_OUTPUT.PUT_LINE(RPAD('Movie ID',8) || '|' || LPAD('Title', 20) || '|' || LPAD('Release date', 11) || '|' || LPAD('Genre', 16) || '|' || LPAD('Type',5) || '|' || LPAD('Runtime',5) || '|' || LPAD('AVG Ticket price',10));
                    DBMS_OUTPUT.put_line('------------------------------------------------------------------------------------------------------------------------------------------------------------------');
                    SELECT * INTO R_MOVIES
                    FROM ( SELECT M.* FROM MOVIES M where rownum=i );
                    DBMS_OUTPUT.PUT_LINE(RPAD(R_MOVIES.MOVIE_ID,8) || '|' || LPAD(R_MOVIES.TITLE, 20) || '|' || LPAD(R_MOVIES.RELEASE_DATE, 11) || '|' || LPAD(R_MOVIES.GENRE, 16) || '|' || LPAD(R_MOVIES.TYPE,5) || '|' || LPAD(R_MOVIES.RUNTIME,5) || '|' || LPAD('AVG Ticket price',10));
                    IF P_AMOUNT_PERFORMANCES > 0 THEN
                        FOR j IN 1..P_AMOUNT_PERFORMANCES
                            LOOP
                                DBMS_OUTPUT.PUT_LINE(RPAD('Performance ID',8) || '|' || LPAD('Hall ID', 20) || '|' || LPAD('Start time', 11) || '|' || LPAD('AVG Ticket price',10));
                                DBMS_OUTPUT.PUT_LINE('  ------------------------------------------------------------');
                                SELECT * INTO R_PERFORMANCES
                                FROM ( SELECT P.* FROM PERFORMANCES P where rownum=i );
                                DBMS_OUTPUT.PUT_LINE(RPAD(R_PERFORMANCES.PERFORMANCE_ID,8) || '|' || LPAD(R_PERFORMANCES.HALL_ID, 20) || '|' || LPAD(R_PERFORMANCES.STARTTIME, 11) || '|' || LPAD('AVG Ticket price',10));
                                IF P_AMOUNT_TICKETS > 0 THEN
                                    FOR k IN 1..P_AMOUNT_TICKETS
                                        LOOP
                                            DBMS_OUTPUT.PUT_LINE(RPAD('SEATNUMBER',8) || '|' || LPAD('PRICE', 20));
                                            DBMS_OUTPUT.PUT_LINE('  ------------------------------------------------------------');
                                            SELECT * INTO R_TICKETS
                                            FROM ( SELECT T.* FROM TICKETS T where rownum=i );
                                            DBMS_OUTPUT.PUT_LINE(RPAD(R_TICKETS.SEATNUMBER,8) || '|' || LPAD(R_TICKETS.PRICE, 20));
                                        END LOOP;
                                END IF;
                            END LOOP;
                    END IF;
                END LOOP;
        END IF;
    END IF;
EXCEPTION
   WHEN E_NEGATIVE THEN  -- does not handle RAISEd exception
      dbms_output.put_line('parameter must be greater than 0, one can not print a negative number of rows');
WHEN OTHERS THEN
     dbms_output.put_line('Deze exception wordt niet herkent.');
END PRINT_OUT;

    -- Tip: gebruik EXECUTE IMMEDIATE.
-- Tip: gebruik deze procedure om de tabellen te legen.

-- Empty tables

    PROCEDURE
        EMPTY_TABLES IS
    BEGIN
        EXECUTE IMMEDIATE ('TRUNCATE TABLE TICKETS CASCADE');
        EXECUTE IMMEDIATE ('TRUNCATE TABLE PERFORMANCES CASCADE');
        EXECUTE IMMEDIATE ('TRUNCATE TABLE MOVIES CASCADE');
        EXECUTE IMMEDIATE ('TRUNCATE TABLE HALLS CASCADE');
        EXECUTE IMMEDIATE ('TRUNCATE TABLE THEATHERS CASCADE');
        EXECUTE IMMEDIATE ('TRUNCATE TABLE VIEWERS CASCADE');
        EXECUTE IMMEDIATE ('TRUNCATE TABLE LOCATIONS CASCADE');
        EXECUTE IMMEDIATE ('TRUNCATE TABLE ZIPCODES CASCADE');
        EXECUTE IMMEDIATE ('TRUNCATE TABLE COUNTRIES CASCADE');

        EXECUTE IMMEDIATE ('PURGE RECYCLEBIN');

        EXECUTE IMMEDIATE ('ALTER TABLE PERFORMANCES MODIFY(PERFORMANCE_ID GENERATED ALWAYS AS IDENTITY (START WITH 1))');
        EXECUTE IMMEDIATE ('ALTER TABLE MOVIES MODIFY(MOVIE_ID GENERATED ALWAYS AS IDENTITY (START WITH 1))');
        EXECUTE IMMEDIATE ('ALTER TABLE LOCATIONS MODIFY(LOCATION_ID GENERATED ALWAYS AS IDENTITY (START WITH 1))');
        EXECUTE IMMEDIATE ('ALTER TABLE HALLS MODIFY(HALL_ID GENERATED ALWAYS AS IDENTITY (START WITH 1))');
        EXECUTE IMMEDIATE ('ALTER TABLE THEATHERS MODIFY(THEATHER_ID GENERATED ALWAYS AS IDENTITY (START WITH 1))');
        EXECUTE IMMEDIATE ('ALTER TABLE VIEWERS MODIFY(VIEWER_ID GENERATED ALWAYS AS IDENTITY (START WITH 1))');

        commit;
    END EMPTY_TABLES;


-- Add procedures

    PROCEDURE
        ADD_MOVIE(P_TITLE IN VARCHAR2, P_RELEASE_DATE IN DATE, P_GENRE IN VARCHAR2, P_TYPE IN VARCHAR2,
                  P_RUNTIME IN NUMBER, P_PLOT IN VARCHAR2, P_LANGUAGE IN VARCHAR2)
        IS
    BEGIN
        INSERT INTO MOVIES (TITLE, RELEASE_DATE, GENRE, "TYPE", RUNTIME, PLOT, LANGUAGE)
        VALUES (P_TITLE, P_RELEASE_DATE, P_GENRE, P_TYPE, P_RUNTIME, P_PLOT, P_LANGUAGE);
        commit;
    END ADD_MOVIE;

    PROCEDURE
        ADD_VIEWER(P_FIRSTNAME IN VARCHAR2, P_LASTNAME IN VARCHAR2, P_BIRTHDATE IN DATE, P_GENDER IN VARCHAR2,
                   P_EMAIL IN VARCHAR2, P_STREET IN VARCHAR2, P_HOUSENUMBER IN NUMBER, P_ZIPCODE IN VARCHAR2,
                   P_COUNTRYCODE IN VARCHAR2)
        IS
        V_LOC_ID
            NUMBER := LOOKUP_LOCATION(P_STREET, P_HOUSENUMBER, P_ZIPCODE, P_COUNTRYCODE);
    BEGIN
        INSERT INTO VIEWERS (FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, EMAIL, LOCATION_ID)
        VALUES (P_FIRSTNAME, P_LASTNAME, P_BIRTHDATE, P_GENDER, P_EMAIL, V_LOC_ID);
        commit;
    END ADD_VIEWER;


    PROCEDURE
        ADD_THEATHER(P_NAME IN VARCHAR2, P_SHOP IN NUMBER, P_PHONENUMBER IN VARCHAR2, P_STREET IN VARCHAR2,
                     P_HOUSENUMBER IN NUMBER, P_ZIPCODE IN VARCHAR2, P_COUNTRYCODE IN VARCHAR2)
        IS
        V_LOC_ID
            NUMBER := LOOKUP_LOCATION(P_STREET, P_HOUSENUMBER, P_ZIPCODE, P_COUNTRYCODE);
    BEGIN
        INSERT INTO THEATHERS (NAME, SHOP, PHONENUMBER, LOCATION_ID)
        VALUES (P_NAME, P_SHOP, P_PHONENUMBER, V_LOC_ID);
        commit;
    END ADD_THEATHER;


    PROCEDURE
        ADD_HALL(P_SEAT_AMOUNT IN NUMBER, P_FLOOR IN NUMBER, P_HALLNUMBER IN NUMBER, P_SCREENTYPE IN VARCHAR2,
                 P_THEATHERNAME IN VARCHAR2, P_STREET IN VARCHAR2, P_HOUSENUMBER IN NUMBER, P_ZIPCODE IN VARCHAR2,
                 P_COUNTRYCODE IN VARCHAR2)
        IS
        V_LOC_ID
                      NUMBER := LOOKUP_LOCATION(P_STREET, P_HOUSENUMBER, P_ZIPCODE, P_COUNTRYCODE);
        V_THEATHER_ID NUMBER := LOOKUP_THEATHER(P_THEATHERNAME, V_LOC_ID);
    BEGIN
        INSERT INTO HALLS (SEAT_AMOUNT, FLOOR, HALLNUMBER, SCREENTYPE, THEATHER_ID)
        VALUES (P_SEAT_AMOUNT, P_FLOOR, P_HALLNUMBER, P_SCREENTYPE, V_THEATHER_ID);
        commit;
    END ADD_HALL;


    PROCEDURE
        ADD_PERFORMANCE(P_MOVIE_TITLE IN VARCHAR2, P_THEATHERNAME IN VARCHAR2, P_STREET IN VARCHAR2,
                        P_HOUSENUMBER IN NUMBER, P_ZIPCODE IN VARCHAR2, P_COUNTRYCODE IN VARCHAR2,
                        P_FLOOR IN NUMBER,
                        P_HALLNUMBER IN NUMBER, P_STARTTIME IN DATE)
        IS
        V_MOVIE_ID
                  NUMBER := LOOKUP_MOVIE(P_MOVIE_TITLE);
        V_THEATHER_ID
                  NUMBER := LOOKUP_THEATHER(P_THEATHERNAME,
                                            LOOKUP_LOCATION(P_STREET, P_HOUSENUMBER, P_ZIPCODE, P_COUNTRYCODE));
        V_HALL_ID NUMBER := LOOKUP_HALL(P_HALLNUMBER, P_FLOOR, V_THEATHER_ID);
    BEGIN
        INSERT INTO PERFORMANCES (MOVIE_ID, HALL_ID, STARTTIME, ENDTIME)
        VALUES (V_MOVIE_ID, V_HALL_ID, P_STARTTIME,
                P_STARTTIME + (SELECT RUNTIME FROM MOVIES WHERE MOVIE_ID = V_MOVIE_ID));
        commit;
    END ADD_PERFORMANCE;


    PROCEDURE
        ADD_TICKET(P_EMAIL IN VARCHAR2, P_MOVIE_TITLE IN VARCHAR2, P_THEATHERNAME IN VARCHAR2,
                   P_STREET IN VARCHAR2,
                   P_HOUSENUMBER IN NUMBER, P_ZIPCODE IN VARCHAR2, P_COUNTRYCODE IN VARCHAR2, P_FLOOR IN NUMBER,
                   P_HALLNUMBER IN NUMBER, P_STARTTIME IN DATE, P_SEATNUMBER IN NUMBER, P_PRICE IN NUMBER)
        IS
        V_VIEWER_ID
                   NUMBER := LOOKUP_VIEWER(P_EMAIL);
        V_MOVIE_ID NUMBER := LOOKUP_MOVIE(P_MOVIE_TITLE);
        V_THEATHER_ID
                   NUMBER := LOOKUP_THEATHER(P_THEATHERNAME,
                                             LOOKUP_LOCATION(P_STREET, P_HOUSENUMBER, P_ZIPCODE, P_COUNTRYCODE));
        V_HALL_ID  NUMBER := LOOKUP_HALL(P_HALLNUMBER, P_FLOOR, V_THEATHER_ID);
        V_PERF_ID  NUMBER := LOOKUP_PERFORMANCE(V_MOVIE_ID, V_HALL_ID, P_STARTTIME);
    BEGIN
        INSERT INTO TICKETS
        VALUES (V_VIEWER_ID, V_PERF_ID, P_SEATNUMBER, P_PRICE);
        commit;
    END ADD_TICKET;


    PROCEDURE
        ADD_LOCATION(P_STREET IN VARCHAR2, P_HOUSENUMBER IN NUMBER, P_ZIPCODE IN VARCHAR2,
                     P_COUNTRYCODE IN VARCHAR2)
        IS
    BEGIN
        INSERT INTO LOCATIONS (STREET, HOUSENUMBER, COUNTRYCODE, ZIPCODE)
        VALUES (P_STREET, P_HOUSENUMBER, P_COUNTRYCODE, P_ZIPCODE);
        commit;
    END ADD_LOCATION;


    PROCEDURE
        ADD_ZIPCODE(P_CITY IN VARCHAR2, P_ZIPCODE IN VARCHAR2, P_COUNTRYCODE IN VARCHAR2)
        IS
    BEGIN
        INSERT INTO ZIPCODES
        VALUES (P_CITY, P_ZIPCODE, P_COUNTRYCODE);
        commit;
    END ADD_ZIPCODE;


    PROCEDURE
        ADD_COUNTRY(P_COUNTRYCODE IN VARCHAR2, P_COUNTRY IN VARCHAR2)
        IS
    BEGIN
        INSERT INTO COUNTRIES
        VALUES (P_COUNTRYCODE, P_COUNTRY);
        commit;
    END ADD_COUNTRY;

END PKG_movies;
