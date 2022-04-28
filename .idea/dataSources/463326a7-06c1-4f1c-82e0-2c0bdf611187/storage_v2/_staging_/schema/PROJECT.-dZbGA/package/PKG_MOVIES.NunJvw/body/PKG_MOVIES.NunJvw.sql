create PACKAGE BODY PKG_movies AS
    -- Lookup functions
    FUNCTION LOOKUP_VIEWER(P_EMAIL IN VARCHAR2)
        RETURN NUMBER
        IS
        VIEWER_ID NUMBER;
    BEGIN
        SELECT VIEWER_ID
        INTO VIEWER_ID
        FROM VIEWERS
        WHERE LOWER(P_EMAIL) = LOWER(EMAIL);
        RETURN VIEWER_ID;
    END;
    FUNCTION
        LOOKUP_MOVIE(P_MOVIETITLE IN VARCHAR2)
        RETURN NUMBER
        IS
        MOVIE_ID NUMBER;
    BEGIN
        SELECT MOVIE_ID
        INTO MOVIE_ID
        FROM MOVIES
        WHERE LOWER(P_MOVIETITLE) = LOWER(title);
        RETURN MOVIE_ID;
    END;
    FUNCTION
        LOOKUP_PERFORMANCE(P_MOVIE_ID IN NUMBER, P_HALL_ID IN NUMBER, P_STARTTIME IN DATE)
        RETURN NUMBER
        IS
        PERFORMANCE_ID NUMBER;
    BEGIN
        SELECT PERFORMANCE_ID
        INTO PERFORMANCE_ID
        FROM PERFORMANCES
        WHERE MOVIE_ID = P_MOVIE_ID
          AND HALL_ID = P_HALL_ID
          AND STARTTIME = P_STARTTIME;
        RETURN PERFORMANCE_ID;
    END;
    FUNCTION
        LOOKUP_THEATHER(P_THEATHERNAME IN VARCHAR2, P_LOCATION_ID IN NUMBER)
        RETURN NUMBER
        IS
        THEATHER_ID NUMBER;
    BEGIN
        SELECT THEATHER_ID
        INTO THEATHER_ID
        FROM THEATHERS
        WHERE LOWER(P_THEATHERNAME) = LOWER(name)
          AND LOCATION_ID = P_LOCATION_ID;
        RETURN THEATHER_ID;
    END;
    FUNCTION
        LOOKUP_HALL(P_HALLNUMBER IN NUMBER, P_FLOOR IN NUMBER, P_THEATHER_ID IN NUMBER)
        RETURN NUMBER
        IS
        HALL_ID NUMBER;
    BEGIN
        SELECT HALL_ID
        INTO HALL_ID
        FROM HALLS
        WHERE HALLNUMBER = P_HALLNUMBER
          AND FLOOR = P_FLOOR
          AND THEATHER_ID = P_THEATHER_ID;
        RETURN HALL_ID;
    END;
    FUNCTION
        LOOKUP_LOCATION(STREET IN VARCHAR2,
                        HOUSENUMBER IN NUMBER, ZIPCODE IN VARCHAR2, COUNTRYCODE IN VARCHAR2)
        RETURN NUMBER
        IS
        LOCATION_ID NUMBER;
    BEGIN
        SELECT LOCATION_ID
        INTO LOCATION_ID
        FROM LOCATIONS
                 JOIN ZIPCODES Z on Z.ZIPCODE = LOCATIONS.ZIPCODE and Z.COUNTRYCODE = LOCATIONS.COUNTRYCODE
                 JOIN COUNTRIES C on C.COUNTRYCODE = Z.COUNTRYCODE
        WHERE LOWER(STREET) = LOWER(LOCATIONS.STREET)
          AND HOUSENUMBER = LOCATIONS.HOUSENUMBER
          AND LOWER(ZIPCODE) = LOWER(Z.ZIPCODE)
          AND LOWER(COUNTRYCODE) = LOWER(C.COUNTRYCODE);
        RETURN LOCATION_ID;
    END;
    FUNCTION
        LOOKUP_COUNTRY(COUNTRYCODE IN VARCHAR2)
        RETURN NUMBER
        IS
        COUNTRYCODE NUMBER;
    BEGIN
        SELECT COUNTRYCODE
        INTO COUNTRYCODE
        FROM COUNTRIES
        WHERE LOWER(COUNTRYCODE) = LOWER(COUNTRYCODE);
        RETURN COUNTRYCODE;
    END;

    -- Tip: gebruik EXECUTE IMMEDIATE.
-- Tip: gebruik deze procedure om de tabellen te legen.

-- Empty tables

    PROCEDURE EMPTY_TABLES
        IS
    BEGIN
        FOR i IN (SELECT table_name FROM user_tables)
            LOOP
                EXECUTE IMMEDIATE ('TRUNCATE TABLE ' || i.TABLE_NAME || ' CASCADE');
            END LOOP;
    END EMPTY_TABLES;


-- Add procedures

    PROCEDURE ADD_MOVIE(P_TITLE IN VARCHAR2, P_RELEASE_DATE IN DATE, P_GENRE IN VARCHAR2, P_TYPE IN VARCHAR2,
                        P_RUNTIME IN NUMBER, P_PLOT IN VARCHAR2, P_LANGUAGE IN VARCHAR2)
        IS
    BEGIN
        INSERT INTO MOVIES (TITLE, RELEASE_DATE, GENRE, TYPE, RUNTIME, PLOT, LANGUAGE)
        VALUES (P_TITLE, P_RELEASE_DATE, P_GENRE, P_TYPE, P_RUNTIME, P_PLOT, P_LANGUAGE);
    END ADD_MOVIE;

    PROCEDURE ADD_VIEWER(P_FIRSTNAME IN VARCHAR2, P_LASTNAME IN VARCHAR2, P_BIRTHDATE IN DATE, P_GENDER IN VARCHAR2,
                         P_EMAIL IN VARCHAR2, P_STREET IN VARCHAR2, P_HOUSENUMBER IN NUMBER, P_ZIPCODE IN VARCHAR2,
                         P_COUNTRYCODE IN VARCHAR2)
        IS
        V_LOC_ID NUMBER := LOOKUP_LOCATION(P_STREET, P_HOUSENUMBER, P_ZIPCODE, P_COUNTRYCODE);
    BEGIN
        INSERT INTO VIEWERS (FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, EMAIL, LOCATION_ID)
        VALUES (P_FIRSTNAME, P_LASTNAME, P_BIRTHDATE, P_GENDER, P_EMAIL, V_LOC_ID);
    END ADD_VIEWER;


    PROCEDURE ADD_THEATHER(P_NAME IN VARCHAR2, P_SHOP IN NUMBER, P_PHONENUMBER IN VARCHAR2, P_STREET IN VARCHAR2,
                           P_HOUSENUMBER IN NUMBER, P_ZIPCODE IN VARCHAR2, P_COUNTRYCODE IN VARCHAR2)
        IS
        V_LOC_ID NUMBER := LOOKUP_LOCATION(P_STREET, P_HOUSENUMBER, P_ZIPCODE, P_COUNTRYCODE);
    BEGIN
        INSERT INTO THEATHERS (NAME, SHOP, PHONENUMBER, LOCATION_ID)
        VALUES (P_NAME, P_SHOP, P_PHONENUMBER, V_LOC_ID);
    END ADD_THEATHER;


    PROCEDURE ADD_HALL(P_SEAT_AMOUNT IN NUMBER, P_FLOOR IN NUMBER, P_HALLNUMBER IN NUMBER, P_SCREENTYPE IN VARCHAR2,
                       P_THEATHERNAME IN VARCHAR2, P_STREET IN VARCHAR2, P_HOUSENUMBER IN NUMBER, P_ZIPCODE IN VARCHAR2,
                       P_COUNTRYCODE IN VARCHAR2)
        IS
        V_LOC_ID      NUMBER := LOOKUP_LOCATION(P_STREET, P_HOUSENUMBER, P_ZIPCODE, P_COUNTRYCODE);
        V_THEATHER_ID NUMBER := LOOKUP_THEATHER(P_THEATHERNAME, V_LOC_ID);
    BEGIN
        INSERT INTO HALLS (SEAT_AMOUNT, FLOOR, HALLNUMBER, SCREENTYPE, THEATHER_ID)
        VALUES (P_SEAT_AMOUNT, P_FLOOR, P_HALLNUMBER, P_SCREENTYPE, V_THEATHER_ID);
    END ADD_HALL;


    PROCEDURE ADD_PERFORMANCE(P_MOVIE_TITLE IN VARCHAR2, P_THEATHERNAME IN VARCHAR2, P_STREET IN VARCHAR2,
                              P_HOUSENUMBER IN NUMBER, P_ZIPCODE IN VARCHAR2, P_COUNTRYCODE IN VARCHAR2,
                              P_FLOOR IN NUMBER,
                              P_HALLNUMBER IN NUMBER, P_STARTTIME IN DATE)
        IS
        V_MOVIE_ID    NUMBER := LOOKUP_MOVIE(P_MOVIE_TITLE);
        V_THEATHER_ID NUMBER := LOOKUP_THEATHER(P_THEATHERNAME,
                                                LOOKUP_LOCATION(P_STREET, P_HOUSENUMBER, P_ZIPCODE, P_COUNTRYCODE));
        V_HALL_ID     NUMBER := LOOKUP_HALL(P_FLOOR, P_HALLNUMBER, V_THEATHER_ID);
    BEGIN
        INSERT INTO PERFORMANCES (MOVIE_ID, HALL_ID, STARTTIME, ENDTIME)
        VALUES (V_MOVIE_ID, V_HALL_ID, P_STARTTIME,
                P_STARTTIME + (SELECT RUNTIME FROM MOVIES WHERE MOVIE_ID = V_MOVIE_ID));
    END ADD_PERFORMANCE;


    PROCEDURE ADD_TICKET(P_EMAIL IN VARCHAR2, P_MOVIE_TITLE IN VARCHAR2, P_THEATHERNAME IN VARCHAR2,
                         P_STREET IN VARCHAR2,
                         P_HOUSENUMBER IN NUMBER, P_ZIPCODE IN VARCHAR2, P_COUNTRYCODE IN VARCHAR2, P_FLOOR IN NUMBER,
                         P_HALLNUMBER IN NUMBER, P_STARTTIME IN DATE, P_SEATNUMBER IN NUMBER, P_PRICE IN NUMBER)
        IS
        V_VIEWER_ID   NUMBER := LOOKUP_VIEWER(P_EMAIL);
        V_MOVIE_ID    NUMBER := LOOKUP_MOVIE(P_MOVIE_TITLE);
        V_THEATHER_ID NUMBER := LOOKUP_THEATHER(P_THEATHERNAME,
                                                LOOKUP_LOCATION(P_STREET, P_HOUSENUMBER, P_ZIPCODE, P_COUNTRYCODE));
        V_HALL_ID     NUMBER := LOOKUP_HALL(P_FLOOR, P_HALLNUMBER, V_THEATHER_ID);
        V_PERF_ID     NUMBER := LOOKUP_PERFORMANCE(P_STARTTIME, V_MOVIE_ID, V_HALL_ID);
    BEGIN
        INSERT INTO TICKETS
        VALUES (V_VIEWER_ID, V_PERF_ID, P_SEATNUMBER, P_PRICE);

    END ADD_TICKET;


    PROCEDURE ADD_LOCATION(P_STREET IN VARCHAR2, P_HOUSENUMBER IN NUMBER, P_ZIPCODE IN VARCHAR2,
                           P_COUNTRYCODE IN VARCHAR2)
        IS
    BEGIN
        INSERT INTO LOCATIONS (STREET, HOUSENUMBER, COUNTRYCODE, ZIPCODE)
        VALUES (P_STREET, P_HOUSENUMBER, P_COUNTRYCODE, P_ZIPCODE);
    END ADD_LOCATION;


    PROCEDURE ADD_ZIPCODE(P_CITY IN VARCHAR2, P_ZIPCODE IN VARCHAR2, P_COUNTRYCODE IN VARCHAR2)
        IS
    BEGIN
        INSERT INTO ZIPCODES
        VALUES (P_CITY, P_ZIPCODE, P_COUNTRYCODE);
    END ADD_ZIPCODE;


    PROCEDURE ADD_COUNTRY(P_COUNTRYCODE IN VARCHAR2, P_COUNTRY IN VARCHAR2)
        IS
    BEGIN
        INSERT INTO COUNTRIES
        VALUES (P_COUNTRYCODE, P_COUNTRY);
    END ADD_COUNTRY;

END PKG_movies;

