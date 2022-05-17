-- In dit bestand zet je je package body. Hier zit al je code van je publieke functies, alsook private hulpfuncties.
CREATE OR REPLACE PACKAGE BODY PKG_movies IS
    TYPE type_theather_bulk IS TABLE OF THEATHERS%ROWTYPE INDEX BY PLS_INTEGER;
    TYPE type_halls_bulk IS TABLE OF HALLS%ROWTYPE INDEX BY PLS_INTEGER;
    TYPE type_performances_bulk IS TABLE OF PERFORMANCES%ROWTYPE INDEX BY PLS_INTEGER;
    -------------------------
    -- PRIVATE FUNCTIONS
    -------------------------
    -- Random Data Functions
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
    FUNCTION TIMESTAMP_DIFF(a timestamp, b timestamp)
        RETURN NUMBER IS
    BEGIN
        RETURN EXTRACT(day from (a - b)) * 24 * 60 * 60 +
               EXTRACT(hour from (a - b)) * 60 * 60 +
               EXTRACT(minute from (a - b)) * 60 +
               EXTRACT(second from (a - b));
    END TIMESTAMP_DIFF;


    -- Functions to generate Random Rows (one by one)
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
        for j in 1..t_performanceid.COUNT
            LOOP
                FOR i IN 1..P_AMOUNT
                    LOOP
                        V_R_VIEWERID := t_viewerid(RANDOM_NUMBER_IN_RANGE(1, t_viewerid.COUNT));
                        V_R_PERFORMANCEID := j;
                        V_R_SEATNUMBER := i;
                        V_R_PRICE := ROUND(RANDOM_NUMBER_IN_RANGE(0, 25), 2);
                        INSERT INTO TICKETS
                        VALUES (V_R_VIEWERID, V_R_PERFORMANCEID,
                                V_R_SEATNUMBER, V_R_PRICE);
                        commit;
                    END LOOP;
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
        start_time_many        pls_integer;
        start_time_2levels     pls_integer;
        end_time_2levels       pls_integer;
        performances_generated pls_integer;
        halls_generated        pls_integer;
    BEGIN
        DBMS_OUTPUT.PUT_LINE('4.1 - Generate_movies(20)');
        GENERATE_MOVIES(P_AMOUNT_MOVIE);
        DBMS_OUTPUT.PUT_LINE('4.2 - Generate_viewers(20)');
        DBMS_OUTPUT.PUT_LINE('4.3 - Generate_viewers(20)');
        DBMS_OUTPUT.PUT_LINE('4.4 - Generate_tickets(50)');
        DBMS_OUTPUT.PUT_LINE('Start generating 2 Levels (generate_2_levels(40,50)');
        start_time_2levels := dbms_utility.get_time;
        GENERATE_2_LEVELS(P_AMOUNT_HALLS, P_AMOUNT_THEATHERS, P_AMOUNT_PERFORMANCES);
        end_time_2levels := dbms_utility.get_time;
        start_time_many := dbms_utility.get_time;
        GENERATE_VIEWERS(P_AMOUNT_VIEWERS);
        GENERATE_TICKETS(P_AMOUNT_TICKETS);
        SELECT COUNT(*) INTO performances_generated FROM PERFORMANCES;
        SELECT COUNT(*) INTO halls_generated FROM HALLS;
        DBMS_OUTPUT.PUT_LINE('Halls generated: ' || halls_generated);
        DBMS_OUTPUT.PUT_LINE('Performances generated: ' || performances_generated);
        DBMS_OUTPUT.PUT_LINE('4.5 - Generate_viewers(20)');
        DBMS_OUTPUT.PUT_LINE('The Duration of the many to many generation is: ' ||
                             (dbms_utility.get_time - start_time_many) / 100 || ' seconds');
        DBMS_OUTPUT.PUT_LINE('The Duration of the 2 levels generation is: ' ||
                             (end_time_2levels - start_time_2levels) / 100 || ' seconds');
    END GENERATE_MANY_TO_MANY;


    -- DDL Add single Rows into DB
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

    -- DDL Generate BULK Random Rows into DB
    PROCEDURE ADD_THEATHERS_BULK(p_theathers_bulk IN type_theather_bulk)
        IS
    BEGIN
        FORALL i in indices of p_theathers_bulk
            INSERT INTO THEATHERS (NAME, SHOP, PHONENUMBER, LOCATION_ID)
            values (p_theathers_bulk(i).NAME, p_theathers_bulk(i).SHOP, p_theathers_bulk(i).PHONENUMBER,
                    p_theathers_bulk(i).LOCATION_ID);
        commit;
    END ADD_THEATHERS_BULK;
    PROCEDURE
        ADD_HALLS_BULK(p_halls_bulk IN type_halls_bulk)
        IS
    BEGIN
        FORALL i in indices of p_halls_bulk
            INSERT INTO HALLS (SEAT_AMOUNT, FLOOR, HALLNUMBER, SCREENTYPE, THEATHER_ID)
            values (p_halls_bulk(i).SEAT_AMOUNT, p_halls_bulk(i).FLOOR, p_halls_bulk(i).HALLNUMBER,
                    p_halls_bulk(i).SCREENTYPE, p_halls_bulk(i).THEATHER_ID);
        commit;
    END ADD_HALLS_BULK;
    PROCEDURE ADD_PERFORMANCES_BULK(p_performances_bulk IN type_performances_bulk)
        IS
    BEGIN
        FORALL i in indices of p_performances_bulk
            INSERT INTO PERFORMANCES (MOVIE_ID, HALL_ID, STARTTIME, ENDTIME)
            values (p_performances_bulk(i).MOVIE_ID, p_performances_bulk(i).HALL_ID, p_performances_bulk(i).STARTTIME,
                    p_performances_bulk(i).ENDTIME);
        commit;
    END ADD_PERFORMANCES_BULK;
    PROCEDURE GENERATE_THEATHERS_BULK(P_AMOUNT IN NUMBER)
        IS
        TYPE type_locations IS TABLE OF LOCATIONS.LOCATION_ID%TYPE
            INDEX BY PLS_INTEGER;
        t_locationid    type_locations;
        t_theather_bulk type_theather_bulk;
    BEGIN
        SELECT LOCATION_ID BULK COLLECT
        INTO t_locationid
        FROM LOCATIONS;
        FOR i IN 1..P_AMOUNT
            LOOP
                t_theather_bulk(i).NAME := 'Theather' || i;
                t_theather_bulk(i).SHOP := RANDOM_NUMBER_IN_RANGE(1, 1);
                t_theather_bulk(i).PHONENUMBER := '+32488857335';

                t_theather_bulk(i).LOCATION_ID := t_locationid(RANDOM_NUMBER_IN_RANGE(1, t_locationid.COUNT));
            END LOOP;
        ADD_THEATHERS_BULK(t_theather_bulk);
    END GENERATE_THEATHERS_BULK;
    PROCEDURE
        GENERATE_HALLS_BULK(P_AMOUNT IN NUMBER)
        IS
        TYPE type_theathers IS TABLE OF THEATHERS.THEATHER_ID%TYPE
            INDEX BY PLS_INTEGER;
        t_theatherid type_theathers;
        t_halls_bulk type_halls_bulk;
    BEGIN
        SELECT THEATHER_ID BULK COLLECT
        INTO t_theatherid
        FROM THEATHERS;
        FOR j IN 1..t_theatherid.COUNT
            LOOP
                FOR i IN 1..P_AMOUNT
                    LOOP
                        t_halls_bulk(i).SEAT_AMOUNT := RANDOM_NUMBER_IN_RANGE(1, 100);
                        t_halls_bulk(i).FLOOR := j;
                        t_halls_bulk(i).HALLNUMBER := i;
                        t_halls_bulk(i).SCREENTYPE := RANDOM_SCREENTYPE();
                        t_halls_bulk(i).THEATHER_ID := t_theatherid(j);
                    END LOOP;
            END LOOP;
        ADD_HALLS_BULK(t_halls_bulk);
    END GENERATE_HALLS_BULK;
    PROCEDURE GENERATE_PERFORMANCES_BULK(P_AMOUNT IN NUMBER)
        IS
        TYPE type_movies IS TABLE OF MOVIES.MOVIE_ID%TYPE
            INDEX BY PLS_INTEGER;
        t_movieid           type_movies;
        TYPE type_halls IS TABLE OF HALLS.HALL_ID%TYPE
            INDEX BY PLS_INTEGER;
        t_hallid            type_halls;
        t_performances_bulk type_performances_bulk;
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
                        t_performances_bulk(i).STARTTIME :=
                                RANDOM_DATE_IN_RANGE(TO_DATE('01-01-1900 00:00', 'DD-MM-YYYY HH24:MI'),
                                                     TO_DATE('01-01-2022 23:59', 'DD-MM-YYYY HH24:MI'));
                        t_performances_bulk(i).HALL_ID := t_hallid(j);
                        t_performances_bulk(i).MOVIE_ID := t_movieid(RANDOM_NUMBER_IN_RANGE(1, t_movieid.COUNT));
                        t_performances_bulk(i).ENDTIME :=
                                    t_performances_bulk(i).STARTTIME + RANDOM_NUMBER_IN_RANGE(0, 200);
                    END LOOP;
            END LOOP;
        ADD_PERFORMANCES_BULK(t_performances_bulk);
    END GENERATE_PERFORMANCES_BULK;
    PROCEDURE GENERATE_2_LEVELS_BULK(P_AMOUNT_HALLS IN NUMBER, P_AMOUNT_THEATHERS IN NUMBER,
                                     P_AMOUNT_PERFORMANCES IN NUMBER)
        IS
    BEGIN
        GENERATE_THEATHERS_BULK(P_AMOUNT_THEATHERS);
        GENERATE_HALLS_BULK(P_AMOUNT_HALLS);
        GENERATE_PERFORMANCES_BULK(P_AMOUNT_PERFORMANCES);

    END GENERATE_2_LEVELS_BULK;

    -------------------------
    -- PUBLIC FUNCTIONS
    -------------------------
    -- M4
    PROCEDURE MANUAL_INPUT_M4 IS
    BEGIN
        PKG_MOVIES.EMPTY_TABLES();

-- Movies
        PKG_MOVIES.ADD_MOVIE('Avatar', TO_DATE('2009-11-18', 'yyyy-mm-dd'), 'Action', 'Movie', 162,
                             'A paraplegic marine dispatched to the moon Pandora on a unique mission becomes torn between following his orders and protecting the world he feels is his home.',
                             'EN');
        PKG_MOVIES.ADD_MOVIE('Titanic', TO_DATE('1997-10-16', 'yyyy-mm-dd'), 'Drama', 'Movie', 194,
                             'A seventeen-year-old aristocrat falls in love with a kind but poor artist aboard the luxurious, ill-fated R.M.S. Titanic.',
                             'EN');
        PKG_MOVIES.ADD_MOVIE('The Dark Knight', TO_DATE('2008-09-05', 'yyyy-mm-dd'), 'Action', 'Movie', 152,
                             'When the menace known as the Joker wreaks havoc and chaos on the people of Gotham, Batman must accept one of the greatest psychological and physical tests of his ability to fight injustice.',
                             'EN');
        PKG_MOVIES.ADD_MOVIE('The Lord of the Rings: The Return of the King', TO_DATE('2003-02-07', 'yyyy-mm-dd'),
                             'Action',
                             'Movie', 201,
                             'Gandalf and Aragorn lead the World of Men against Sauron''s army to draw his gaze from Frodo and Sam as they approach Mount Doom with the One Ring.',
                             'EN');
        PKG_MOVIES.ADD_MOVIE('Breaking Bad', TO_DATE('2008-01-20', 'yyyy-mm-dd'), 'Mystery', 'Series', 172,
                             'A high school chemistry teacher diagnosed with inoperable lung cancer turns to manufacturing and selling methamphetamine in order to secure his familys future.',
                             'EN');

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

-- Viewers
        /* PKG_MOVIES.ADD_VIEWER('Diego', 'Luiken', TO_DATE('1962-05-22', 'yyyy-mm-dd'), 'M', 'diegoluiken@gmail.com',
                              'Brixtonlaan', 176, '1000', 'BE');
        PKG_MOVIES.ADD_VIEWER('Agnes', 'R. Sutton', TO_DATE('1945-06-20', 'yyyy-mm-dd'), 'X', 'agnessutton@gmail.com',
                              'Aven Ackers', 227, '10002', 'US');
        PKG_MOVIES.ADD_VIEWER('Ogier', 'Dennis', TO_DATE('2002-07-05', 'yyyy-mm-dd'), 'M', 'ogierdennis@gmail.com',
                              'Rue Bois des Fosses', 139, '75000', 'FR');
        PKG_MOVIES.ADD_VIEWER('Sylvia', 'B. Ralston', TO_DATE('1990-10-12', 'yyyy-mm-dd'), 'V',
                              'sylviaralston@gmail.com',
                              'Oost St', 1155, '6665', 'ZA');
        PKG_MOVIES.ADD_VIEWER('Shaniqua', 'Braams', TO_DATE('1962-05-10', 'yyyy-mm-dd'), 'V',
                              'shaniquabraams@gmail.com',
                              'Robert de Vriesstraat', 51, '1015', 'NL');

-- Theathers
        PKG_MOVIES.ADD_THEATHER('Cinema Galeries', 0, '+3225147498',
                                'Galerie de la Reine', 26, '1000', 'BE');
        PKG_MOVIES.ADD_THEATHER('Apollo Theater', 0, '+12125315300',
                                'West 125th Street', 254, '10002', 'US');
        PKG_MOVIES.ADD_THEATHER('Théâtre de la Ville', 1, '+33142742277',
                                'Pl. du Châtelet', 2, '75000', 'FR');
        PKG_MOVIES.ADD_THEATHER('Pathé City', 1, '+31885152050',
                                'Kleine-Gartmanplantsoen', 15, '1015', 'NL');
        PKG_MOVIES.ADD_THEATHER('Artscape Theatre Centre', 1, '+27214109800',
                                'D.F. Malan St', 25, '6665', 'ZA');

-- Halls
        PKG_MOVIES.ADD_HALL(150, 2, 13, 'MDX', 'Cinema Galeries', 'Galerie de la Reine', 26, '1000', 'BE');
        PKG_MOVIES.ADD_HALL(130, 2, 4, '4D', 'Apollo Theater', 'West 125th Street', 254, '10002', 'US');
        PKG_MOVIES.ADD_HALL(60, 3, 8, '3D', 'Théâtre de la Ville', 'Pl. du Châtelet', 2, '75000', 'FR');
        PKG_MOVIES.ADD_HALL(199, 1, 9, 'Digital', 'Pathé City', 'Kleine-Gartmanplantsoen', 15, '1015', 'NL');
        PKG_MOVIES.ADD_HALL(100, 2, 2, 'MDX', 'Artscape Theatre Centre', 'D.F. Malan St', 25, '6665', 'ZA');


-- Performances
        PKG_MOVIES.ADD_PERFORMANCE('The Dark Knight', 'Cinema Galeries', 'Galerie de la Reine', 26, '1000', 'BE', 2, 13,
                                   TO_DATE('2012-04-09 12:20', 'yyyy-mm-dd hh24:mi'));
        PKG_MOVIES.ADD_PERFORMANCE('Titanic', 'Apollo Theater', 'West 125th Street', 254, '10002', 'US', 2, 4,
                                   TO_DATE('2014-12-25 14:00', 'yyyy-mm-dd hh24:mi'));
        PKG_MOVIES.ADD_PERFORMANCE('Avatar', 'Théâtre de la Ville', 'Pl. du Châtelet', 2, '75000', 'FR', 3, 8,
                                   TO_DATE('2014-12-25 16:30', 'yyyy-mm-dd hh24:mi'));
        PKG_MOVIES.ADD_PERFORMANCE('The Lord of the Rings: The Return of the King', 'Pathé City',
                                   'Kleine-Gartmanplantsoen',
                                   15, '1015', 'NL', 1, 9, TO_DATE('2016-04-01 20:50', 'yyyy-mm-dd hh24:mi'));
        PKG_MOVIES.ADD_PERFORMANCE('Breaking Bad', 'Artscape Theatre Centre', 'D.F. Malan St', 25, '6665', 'ZA', 2, 2,
                                   TO_DATE('2015-02-18 19:45', 'yyyy-mm-dd hh24:mi'));


-- Tickets
        PKG_MOVIES.ADD_TICKET('diegoluiken@gmail.com',
                              'Avatar', 'Théâtre de la Ville', 'Pl. du Châtelet', 2, '75000', 'FR', 3, 8,
                              TO_DATE('2014-12-25 16:30', 'yyyy-mm-dd hh24:mi'),
                              2, 10.50);
        PKG_MOVIES.ADD_TICKET('agnessutton@gmail.com',
                              'The Dark Knight', 'Cinema Galeries', 'Galerie de la Reine', 26, '1000', 'BE', 2, 13,
                              TO_DATE('2012-04-09 12:20', 'yyyy-mm-dd hh24:mi'),
                              4, 12);
        PKG_MOVIES.ADD_TICKET('ogierdennis@gmail.com', 'Titanic', 'Apollo Theater', 'West 125th Street', 254, '10002',
                              'US',
                              2, 4, TO_DATE('2014-12-25 14:00', 'yyyy-mm-dd hh24:mi'),
                              5, 10.50);
        PKG_MOVIES.ADD_TICKET('agnessutton@gmail.com', 'The Lord of the Rings: The Return of the King', 'Pathé City',
                              'Kleine-Gartmanplantsoen', 15, '1015', 'NL', 1, 9,
                              TO_DATE('2016-04-01 20:50', 'yyyy-mm-dd hh24:mi'),
                              10, 12);
        PKG_MOVIES.ADD_TICKET('shaniquabraams@gmail.com', 'Breaking Bad', 'Artscape Theatre Centre', 'D.F. Malan St',
                              25,
                              '6665', 'ZA', 2, 2, TO_DATE('2015-02-18 19:45', 'yyyy-mm-dd hh24:mi'),
                              15, 10.50);*/

    end MANUAL_INPUT_M4;
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
    -- M5
    PROCEDURE BEWIJS_MILESTONE_5
        IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('BEWIJS M5');
        DBMS_OUTPUT.PUT_LINE('1 - Random nummer terruggeeft binnen een nummerbereik');
        DBMS_OUTPUT.PUT_LINE('give_random_number(1,10) --> ' || ROUND(RANDOM_NUMBER_IN_RANGE(1, 10), 0));
        DBMS_OUTPUT.PUT_LINE('2 - Random datum binnen een datumbereik');
        DBMS_OUTPUT.PUT_LINE('give_random_date(TO_DATE(''01-01-2000'', ''DD-MM-YYYY''), SYSDATE) --> ' ||
                             RANDOM_DATE_IN_RANGE(TO_DATE('01-01-2000', 'DD-MM-YYYY'), SYSDATE));
        DBMS_OUTPUT.PUT_LINE('3 - Random string uit een lijst');
        DBMS_OUTPUT.PUT_LINE('random_movietitle --> ' || RANDOM_MOVIE_TITLE());
        DBMS_OUTPUT.PUT_LINE('4 - Starting Many-to-Many generation (generate_many_to_many(20, 20, 50, 20))');
        GENERATE_MANY_TO_MANY(20, 20, 5, 5, 40, 20);
    END BEWIJS_MILESTONE_5;
    -- M6
    PROCEDURE PRINTREPORT_2_LEVELS_M6(P_AMOUNT_MOVIES IN NUMBER, P_AMOUNT_PERFORMANCES IN NUMBER,
                                      P_AMOUNT_TICKETS IN NUMBER)
        IS
        CURSOR cur_movies IS
            SELECT MOVIE_ID, TITLE, RELEASE_DATE, GENRE, "TYPE", RUNTIME
            FROM MOVIES;
        R_MOVIES       cur_movies%ROWTYPE;
        CURSOR cur_performances(PM R_MOVIES.MOVIE_ID%TYPE) IS
            SELECT PERFORMANCE_ID, MOVIE_ID, HALL_ID, STARTTIME
            FROM PERFORMANCES
            WHERE MOVIE_ID = PM;
        R_PERFORMANCES cur_performances%ROWTYPE;
        CURSOR cur_tickets(PP R_PERFORMANCES.PERFORMANCE_ID%TYPE) IS
            SELECT PERFORMANCE_ID, SEATNUMBER, PRICE
            FROM TICKETS
            WHERE PERFORMANCE_ID = PP;
        R_TICKETS      cur_tickets%ROWTYPE;
        E_NEGATIVE EXCEPTION;
        CURSOR cur_avg_ticket_per_performance_per_movie(MID R_MOVIES.MOVIE_ID%TYPE) IS SELECT AVG(PRICE)
                                                                                       FROM TICKETS
                                                                                                JOIN PERFORMANCES P on TICKETS.PERFORMANCE_ID = P.PERFORMANCE_ID
                                                                                       WHERE P.MOVIE_ID = MID
                                                                                       GROUP BY P.MOVIE_ID;
        AVG_TICKET_PER_PERFORMANCE_PER_MOVIE NUMBER;
        CURSOR cur_avg_ticket_per_performance(PID R_PERFORMANCES.PERFORMANCE_ID%TYPE) IS SELECT AVG(PRICE)
                                                                                         FROM TICKETS
                                                                                         WHERE PERFORMANCE_ID = PID
                                                                                         GROUP BY PERFORMANCE_ID;
        AVG_TICKET_PER_PERFORMANCE           NUMBER;

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
                OPEN cur_movies;
                FOR i IN 1..P_AMOUNT_MOVIES
                    LOOP
                        DBMS_OUTPUT.PUT_LINE(RPAD('Movie ID', 8) || '|' || LPAD('Title', 20) || '|' ||
                                             LPAD('Release date', 15) || '|' || LPAD('Genre', 10) || '|' ||
                                             LPAD('Type', 10) || '|' || LPAD('Runtime', 10) || '|' ||
                                             LPAD('AVG Ticket price', 20));
                        DBMS_OUTPUT.put_line('------------------------------------------------------------------------------------------------------------------------------------------------------------------');
                        FETCH cur_movies INTO R_MOVIES;
                        EXIT WHEN cur_movies%NOTFOUND;
                        OPEN cur_avg_ticket_per_performance_per_movie(R_MOVIES.MOVIE_ID);
                        FETCH cur_avg_ticket_per_performance_per_movie INTO AVG_TICKET_PER_PERFORMANCE_PER_MOVIE;
                        DBMS_OUTPUT.PUT_LINE(RPAD(R_MOVIES.MOVIE_ID, 8) || '|' || LPAD(R_MOVIES.TITLE, 20) || '|' ||
                                             LPAD(R_MOVIES.RELEASE_DATE, 15) || '|' || LPAD(R_MOVIES.GENRE, 10) ||
                                             '|' || LPAD(R_MOVIES.TYPE, 10) || '|' || LPAD(R_MOVIES.RUNTIME, 10) ||
                                             '|' || LPAD(ROUND(AVG_TICKET_PER_PERFORMANCE_PER_MOVIE, 2), 20));
                        IF P_AMOUNT_PERFORMANCES > 0 THEN
                            OPEN cur_performances(R_MOVIES.MOVIE_ID);

                            FOR j IN 1..P_AMOUNT_PERFORMANCES
                                LOOP
                                    DBMS_OUTPUT.PUT_LINE(RPAD('PERFORMANCE ID', 15) || '|' || LPAD('Hall ID', 10) ||
                                                         '|' ||
                                                         LPAD('Start time', 20) || '|' || LPAD('AVG Ticket price', 20));
                                    DBMS_OUTPUT.PUT_LINE('  ------------------------------------------------------------');
                                    FETCH cur_performances INTO R_PERFORMANCES;
                                    EXIT WHEN cur_performances%NOTFOUND;
                                    OPEN cur_avg_ticket_per_performance(R_PERFORMANCES.PERFORMANCE_ID);
                                    FETCH cur_avg_ticket_per_performance INTO AVG_TICKET_PER_PERFORMANCE;
                                    DBMS_OUTPUT.PUT_LINE(RPAD(R_PERFORMANCES.PERFORMANCE_ID, 15) || '|' ||
                                                         LPAD(R_PERFORMANCES.HALL_ID, 10) || '|' ||
                                                         LPAD(TO_CHAR(R_PERFORMANCES.STARTTIME), 20) || '|' ||
                                                         LPAD(ROUND(AVG_TICKET_PER_PERFORMANCE, 2), 20));
                                    IF P_AMOUNT_TICKETS > 0 THEN
                                        OPEN cur_tickets(R_PERFORMANCES.PERFORMANCE_ID);
                                        DBMS_OUTPUT.PUT_LINE(RPAD('SEATNUMBER', 10) || '|' || LPAD('PRICE', 6) || '|' ||
                                                             LPAD('PERFORMANCE_ID', 15));
                                        DBMS_OUTPUT.PUT_LINE('  ------------------------------------------------------------');
                                        FOR k IN 1..P_AMOUNT_TICKETS
                                            LOOP
                                                FETCH cur_tickets INTO R_TICKETS;
                                                EXIT WHEN cur_tickets%NOTFOUND;
                                                DBMS_OUTPUT.PUT_LINE(RPAD(R_TICKETS.SEATNUMBER, 10) || '|' ||
                                                                     LPAD(R_TICKETS.PRICE, 6) || '|' ||
                                                                     LPAD(R_TICKETS.PERFORMANCE_ID, 15));
                                            END LOOP;
                                        CLOSE cur_tickets;
                                    END IF;
                                    CLOSE cur_avg_ticket_per_performance;
                                END LOOP;
                            CLOSE cur_performances;
                        END IF;
                        CLOSE cur_avg_ticket_per_performance_per_movie;
                    END LOOP;
                CLOSE cur_movies;
            END IF;
        END IF;
    EXCEPTION
        WHEN E_NEGATIVE THEN -- does not handle RAISEd exception
            dbms_output.put_line('parameter must be greater than 0, one can not print a negative number of rows');
        /*WHEN OTHERS THEN
            dbms_output.put_line('Deze exception wordt niet herkent.');*/
    END PRINTREPORT_2_LEVELS_M6;
    -- M7
    PROCEDURE COMPARISON_SINGLE_BULK_M7(P_THEATHERS_AMOUNT IN NUMBER, P_HALLS_AMOUNT IN NUMBER,
                                        P_PERFORMANCES_AMOUNT IN NUMBER) IS
        v_date_start timestamp;
    BEGIN
        DBMS_OUTPUT.PUT_LINE(to_char(systimestamp, '[YYYY-MM-DD HH24:MM:SS] ') ||
                             'COMPARISON SINGLE BULK - COMPARISON_SINGLE_BULK_M7(' || P_THEATHERS_AMOUNT || ', ' ||
                             P_HALLS_AMOUNT || ', ' ||
                             P_PERFORMANCES_AMOUNT || ')');
        EMPTY_TABLES();
        MANUAL_INPUT_M4();
        DBMS_OUTPUT.PUT_LINE(to_char(systimestamp, '[YYYY-MM-DD HH24:MM:SS] ') ||
                             'generate_2_level(' || P_THEATHERS_AMOUNT || ', ' || P_HALLS_AMOUNT || ', ' ||
                             P_PERFORMANCES_AMOUNT || ');');
        v_date_start := systimestamp;
        generate_2_levels(P_THEATHERS_AMOUNT, P_HALLS_AMOUNT, P_PERFORMANCES_AMOUNT);
        DBMS_OUTPUT.PUT_LINE(to_char(systimestamp, '[YYYY-MM-DD HH24:MM:SS] ') ||
                             '     The duration of generate_2_levels was: ' ||
                             (extract(minute from systimestamp - v_date_start)) || ':' ||
                             (extract(second from systimestamp - v_date_start)));

        EMPTY_TABLES();
        MANUAL_INPUT_M4();
        DBMS_OUTPUT.PUT_LINE(to_char(systimestamp, '[YYYY-MM-DD HH24:MM:SS] ') ||
                             'generate_2_level_bulk(' || P_THEATHERS_AMOUNT || ', ' || P_HALLS_AMOUNT || ', ' ||
                             P_PERFORMANCES_AMOUNT || ');');
        v_date_start := systimestamp;
        generate_2_levels_bulk(P_THEATHERS_AMOUNT, P_HALLS_AMOUNT, P_PERFORMANCES_AMOUNT);
        DBMS_OUTPUT.PUT_LINE(to_char(systimestamp, '[YYYY-MM-DD HH24:MM:SS] ') ||
                             '     The duration of generate_2_levels was: ' ||
                             (extract(minute from systimestamp - v_date_start)) || ':' ||
                             (extract(second from systimestamp - v_date_start)));
        DBMS_OUTPUT.PUT_LINE('-------------------------------------------------------');
    END COMPARISON_SINGLE_BULK_M7;
END PKG_movies;
