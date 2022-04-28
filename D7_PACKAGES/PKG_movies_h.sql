-- In dit bestand zet je je package specificatie. Hier komen alle specificaties van je publieke functies.
CREATE
    OR REPLACE PACKAGE PKG_MOVIES IS

    PROCEDURE EMPTY_TABLES;
-- Add procedures
    PROCEDURE ADD_MOVIE(P_TITLE IN VARCHAR2, P_RELEASE_DATE IN DATE, P_GENRE IN VARCHAR2, P_TYPE IN VARCHAR2,
                        P_RUNTIME IN NUMBER, P_PLOT IN VARCHAR2, P_LANGUAGE IN VARCHAR2);
    PROCEDURE ADD_VIEWER(P_FIRSTNAME IN VARCHAR2, P_LASTNAME IN VARCHAR2, P_BIRTHDATE IN DATE, P_GENDER IN VARCHAR2,
                         P_EMAIL IN VARCHAR2, P_STREET IN VARCHAR2, P_HOUSENUMBER IN NUMBER, P_ZIPCODE IN VARCHAR2,
                         P_COUNTRYCODE IN VARCHAR2);
    PROCEDURE ADD_THEATHER(P_NAME IN VARCHAR2, P_SHOP IN NUMBER, P_PHONENUMBER IN VARCHAR2, P_STREET IN VARCHAR2,
                           P_HOUSENUMBER IN NUMBER, P_ZIPCODE IN VARCHAR2, P_COUNTRYCODE IN VARCHAR2);
    PROCEDURE ADD_HALL(P_SEAT_AMOUNT IN NUMBER, P_FLOOR IN NUMBER, P_HALLNUMBER IN NUMBER, P_SCREENTYPE IN VARCHAR2,
                       P_THEATHERNAME IN VARCHAR2, P_STREET IN VARCHAR2, P_HOUSENUMBER IN NUMBER, P_ZIPCODE IN VARCHAR2,
                       P_COUNTRYCODE IN VARCHAR2);
    PROCEDURE ADD_PERFORMANCE(P_MOVIE_TITLE IN VARCHAR2, P_THEATHERNAME IN VARCHAR2, P_STREET IN VARCHAR2,
                              P_HOUSENUMBER IN NUMBER, P_ZIPCODE IN VARCHAR2, P_COUNTRYCODE IN VARCHAR2,
                              P_FLOOR IN NUMBER,
                              P_HALLNUMBER IN NUMBER, P_STARTTIME IN DATE);
    PROCEDURE ADD_TICKET(P_EMAIL IN VARCHAR2, P_MOVIE_TITLE IN VARCHAR2, P_THEATHERNAME IN VARCHAR2,
                         P_STREET IN VARCHAR2,
                         P_HOUSENUMBER IN NUMBER, P_ZIPCODE IN VARCHAR2, P_COUNTRYCODE IN VARCHAR2, P_FLOOR IN NUMBER,
                         P_HALLNUMBER IN NUMBER, P_STARTTIME IN DATE, P_SEATNUMBER IN NUMBER, P_PRICE IN NUMBER);
    PROCEDURE ADD_LOCATION(P_STREET IN VARCHAR2, P_HOUSENUMBER IN NUMBER, P_ZIPCODE IN VARCHAR2,
                           P_COUNTRYCODE IN VARCHAR2);
    PROCEDURE ADD_ZIPCODE(P_CITY IN VARCHAR2, P_ZIPCODE IN VARCHAR2, P_COUNTRYCODE IN VARCHAR2);
    PROCEDURE ADD_COUNTRY(P_COUNTRYCODE IN VARCHAR2, P_COUNTRY IN VARCHAR2);

END;