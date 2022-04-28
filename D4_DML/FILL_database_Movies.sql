-- Movies
INSERT INTO MOVIES (TITLE, RELEASE_DATE, GENRE, TYPE, RUNTIME, PLOT, LANGUAGE)
VALUES ('Avatar', TO_DATE('2009-11-18', 'yyyy-mm-dd'), 'Action', 'Movie', 162,
        'A paraplegic marine dispatched to the moon Pandora on a unique mission becomes torn between following his orders and protecting the world he feels is his home.',
        'EN');
INSERT INTO MOVIES (TITLE, RELEASE_DATE, GENRE, TYPE, RUNTIME, PLOT, LANGUAGE)
VALUES ('Titanic', TO_DATE('1997-10-16', 'yyyy-mm-dd'), 'Drama', 'Movie', 194,
        'A seventeen-year-old aristocrat falls in love with a kind but poor artist aboard the luxurious, ill-fated R.M.S. Titanic.',
        'EN');
INSERT INTO MOVIES (TITLE, RELEASE_DATE, GENRE, TYPE, RUNTIME, PLOT, LANGUAGE)
VALUES ('The Dark Knight', TO_DATE('2008-09-05', 'yyyy-mm-dd'), 'Action', 'Movie', 152,
        'When the menace known as the Joker wreaks havoc and chaos on the people of Gotham, Batman must accept one of the greatest psychological and physical tests of his ability to fight injustice.',
        'EN');
INSERT INTO MOVIES (TITLE, RELEASE_DATE, GENRE, TYPE, RUNTIME, PLOT, LANGUAGE)
VALUES ('The Lord of the Rings: The Return of the King', TO_DATE('2003-02-07', 'yyyy-mm-dd'), 'Action', 'Movie', 201,
        'Gandalf and Aragorn lead the World of Men against Sauron''s army to draw his gaze from Frodo and Sam as they approach Mount Doom with the One Ring.',
        'EN');
INSERT INTO MOVIES (TITLE, RELEASE_DATE, GENRE, TYPE, RUNTIME, PLOT, LANGUAGE)
VALUES ('Breaking Bad', TO_DATE('2008-01-20', 'yyyy-mm-dd'), 'Mystery', 'Series', 172,
        'A high school chemistry teacher diagnosed with inoperable lung cancer turns to manufacturing and selling methamphetamine in order to secure his familys future.',
        'EN');
-- Countries
INSERT INTO COUNTRIES
VALUES ('BE', 'Belgium');
INSERT INTO COUNTRIES
VALUES ('US', 'United States');
INSERT INTO COUNTRIES
VALUES ('FR', 'France');
INSERT INTO COUNTRIES
VALUES ('NL', 'Netherlands');
INSERT INTO COUNTRIES
VALUES ('ZA', 'South Africa');
-- Zipcodes
INSERT INTO ZIPCODES
VALUES ('Brussels', '1000', 'BE');
INSERT INTO ZIPCODES
VALUES ('New York', '10002', 'US');
INSERT INTO ZIPCODES
VALUES ('Paris', '75000', 'FR');
INSERT INTO ZIPCODES
VALUES ('Amsterdam', '1015', 'NL');
INSERT INTO ZIPCODES
VALUES ('Cape Town', '6665', 'ZA');
-- Locations
INSERT INTO LOCATIONS (STREET, HOUSENUMBER, COUNTRYCODE, ZIPCODE)
VALUES ('Galerie de la Reine', 26, 'BE', '1000');
INSERT INTO LOCATIONS (STREET, HOUSENUMBER, COUNTRYCODE, ZIPCODE)
VALUES ('Brixtonlaan', 176, 'BE', '1000');
INSERT INTO LOCATIONS (STREET, HOUSENUMBER, COUNTRYCODE, ZIPCODE)
VALUES ('Aven Ackers', 227, 'US', '10002');
INSERT INTO LOCATIONS (STREET, HOUSENUMBER, COUNTRYCODE, ZIPCODE)
VALUES ('West 125th Street', 254, 'US', '10002');
INSERT INTO LOCATIONS (STREET, HOUSENUMBER, COUNTRYCODE, ZIPCODE)
VALUES ('Pl. du Châtelet', 2, 'FR', '75000');
INSERT INTO LOCATIONS (STREET, HOUSENUMBER, COUNTRYCODE, ZIPCODE)
VALUES ('Rue Bois des Fosses', 139, 'FR', '75000');
INSERT INTO LOCATIONS (STREET, HOUSENUMBER, COUNTRYCODE, ZIPCODE)
VALUES ('Kleine-Gartmanplantsoen', 15, 'NL', '1015');
INSERT INTO LOCATIONS (STREET, HOUSENUMBER, COUNTRYCODE, ZIPCODE)
VALUES ('Robert de Vriesstraat', 51, 'NL', '1015');
INSERT INTO LOCATIONS (STREET, HOUSENUMBER, COUNTRYCODE, ZIPCODE)
VALUES ('D.F. Malan St', 25, 'ZA', '6665');
INSERT INTO LOCATIONS (STREET, HOUSENUMBER, COUNTRYCODE, ZIPCODE)
VALUES ('Oost St', 1155, 'ZA', '6665');
-- Viewers
INSERT INTO VIEWERS (FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, EMAIL, LOCATION_ID)
VALUES ('Diego', 'Luiken', TO_DATE('1962-05-22', 'yyyy-mm-dd'), 'M', 'diego.luiken@hotmail.be',
        (SELECT location_id FROM LOCATIONS WHERE street = 'Brixtonlaan' AND housenumber = 176));
INSERT INTO VIEWERS (FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, EMAIL, LOCATION_ID)
VALUES ('Agnes', 'R. Sutton', TO_DATE('1945-06-20', 'yyyy-mm-dd'), 'X', 'agnes.Sutton@gmail.com',
        (SELECT location_id FROM LOCATIONS WHERE street = 'Aven Ackers' AND housenumber = 227));
INSERT INTO VIEWERS (FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, EMAIL, LOCATION_ID)
VALUES ('Ogier', 'Dennis', TO_DATE('2002-07-05', 'yyyy-mm-dd'), 'M', 'ogierdennis@outlook.com',
        (SELECT location_id FROM LOCATIONS WHERE street = 'Rue Bois des Fosses' AND housenumber = 139));
INSERT INTO VIEWERS (FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, EMAIL, LOCATION_ID)
VALUES ('Sylvia', 'B. Ralston', TO_DATE('1990-10-12', 'yyyy-mm-dd'), 'V', 's.ralston@gmail.com',
        (SELECT location_id FROM LOCATIONS WHERE street = 'Oost St' AND housenumber = 1155));
INSERT INTO VIEWERS (FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, EMAIL, LOCATION_ID)
VALUES ('Shaniqua', 'Braams', TO_DATE('1962-05-10', 'yyyy-mm-dd'), 'V', 'shaniqua1962@gmail.com',
        (SELECT location_id FROM LOCATIONS WHERE street = 'Robert de Vriesstraat' AND housenumber = 51));
-- Theathers
INSERT INTO THEATHERS (NAME, SHOP, PHONENUMBER, LOCATION_ID)
VALUES ('Cinema Galeries', 0, '+3225147498',
        (SELECT location_id FROM LOCATIONS WHERE street = 'Galerie de la Reine' AND housenumber = 26));
INSERT INTO THEATHERS (NAME, SHOP, PHONENUMBER, LOCATION_ID)
VALUES ('Apollo Theater', 0, '+12125315300',
        (SELECT location_id FROM LOCATIONS WHERE street = 'West 125th Street' AND housenumber = 254));
INSERT INTO THEATHERS (NAME, SHOP, PHONENUMBER, LOCATION_ID)
VALUES ('Théâtre de la Ville', 1, '+33142742277',
        (SELECT location_id FROM LOCATIONS WHERE street = 'Pl. du Châtelet' AND housenumber = 2));
INSERT INTO THEATHERS (NAME, SHOP, PHONENUMBER, LOCATION_ID)
VALUES ('Pathé City', 1, '+31885152050',
        (SELECT location_id FROM LOCATIONS WHERE street = 'Kleine-Gartmanplantsoen' AND housenumber = 15));
INSERT INTO THEATHERS (NAME, SHOP, PHONENUMBER, LOCATION_ID)
VALUES ('Artscape Theatre Centre', 1, '+27214109800',
        (SELECT location_id FROM LOCATIONS WHERE street = 'D.F. Malan St' AND housenumber = 25));
-- Halls
INSERT INTO HALLS (SEAT_AMOUNT, FLOOR, HALLNUMBER, SCREENTYPE, THEATHER_ID)
VALUES (150, 2, 13,'MDX', (SELECT theather_id FROM THEATHERS WHERE name = 'Cinema Galeries'));
INSERT INTO HALLS (SEAT_AMOUNT, FLOOR, HALLNUMBER, SCREENTYPE, THEATHER_ID)
VALUES (130, 2, 4,'4D', (SELECT theather_id FROM THEATHERS WHERE name = 'Apollo Theater'));
INSERT INTO HALLS (SEAT_AMOUNT, FLOOR, HALLNUMBER, SCREENTYPE, THEATHER_ID)
VALUES (60, 3, 8,'3D', (SELECT theather_id FROM THEATHERS WHERE name = 'Théâtre de la Ville'));
INSERT INTO HALLS (SEAT_AMOUNT, FLOOR, HALLNUMBER, SCREENTYPE, THEATHER_ID)
VALUES (199, 1, 9,'Digital', (SELECT theather_id FROM THEATHERS WHERE name = 'Pathé City'));
INSERT INTO HALLS (SEAT_AMOUNT, FLOOR, HALLNUMBER, SCREENTYPE, THEATHER_ID)
VALUES (100, 2, 2,'MDX', (SELECT theather_id FROM THEATHERS WHERE name = 'Artscape Theatre Centre'));
-- Performances
INSERT INTO PERFORMANCES (MOVIE_ID, HALL_ID, STARTTIME, ENDTIME)
VALUES ((SELECT movie_id FROM MOVIES WHERE title = 'The Dark Knight'), (SELECT hall_id
                                                                        FROM HALLS
                                                                        WHERE theather_id =
                                                                              (SELECT theather_id FROM THEATHERS WHERE name = 'Cinema Galeries')),
        TO_DATE('2012-04-09 12:20', 'yyyy-mm-dd hh24:mi'), TO_DATE('2012-04-09 14:20', 'yyyy-mm-dd hh24:mi'));
INSERT INTO PERFORMANCES (MOVIE_ID, HALL_ID, STARTTIME, ENDTIME)
VALUES ((SELECT movie_id FROM MOVIES WHERE title = 'Titanic'), (SELECT hall_id
                                                                FROM HALLS
                                                                WHERE theather_id =
                                                                      (SELECT theather_id FROM THEATHERS WHERE name = 'Apollo Theater')),
        TO_DATE('2013-10-01 10:30', 'yyyy-mm-dd hh24:mi'), TO_DATE('2013-10-01 12:00', 'yyyy-mm-dd hh24:mi'));
INSERT INTO PERFORMANCES (MOVIE_ID, HALL_ID, STARTTIME, ENDTIME)
VALUES ((SELECT movie_id FROM MOVIES WHERE title = 'Avatar'), (SELECT hall_id
                                                               FROM HALLS
                                                               WHERE theather_id =
                                                                     (SELECT theather_id FROM THEATHERS WHERE name = 'Théâtre de la Ville')),
        TO_DATE('2014-12-25 14:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2014-12-25 16:30', 'yyyy-mm-dd hh24:mi'));
INSERT INTO PERFORMANCES (MOVIE_ID, HALL_ID, STARTTIME, ENDTIME)
VALUES ((SELECT movie_id FROM MOVIES WHERE title = 'The Lord of the Rings: The Return of the King'),
        (SELECT hall_id FROM HALLS WHERE theather_id = (SELECT theather_id FROM THEATHERS WHERE name = 'Pathé City')),
        TO_DATE('2016-04-01 20:50', 'yyyy-mm-dd hh24:mi'), TO_DATE('2016-04-01 22:50', 'yyyy-mm-dd hh24:mi'));
INSERT INTO PERFORMANCES (MOVIE_ID, HALL_ID, STARTTIME, ENDTIME)
VALUES ((SELECT movie_id FROM MOVIES WHERE title = 'Breaking Bad'), (SELECT hall_id
                                                                     FROM HALLS
                                                                     WHERE theather_id = (SELECT theather_id
                                                                                          FROM THEATHERS
                                                                                          WHERE name = 'Artscape Theatre Centre')),
        TO_DATE('2015-02-18 17:15', 'yyyy-mm-dd hh24:mi'), TO_DATE('2015-02-18 19:45', 'yyyy-mm-dd hh24:mi'));

-- Tickets
INSERT INTO TICKETS
VALUES ((SELECT viewer_id FROM VIEWERS WHERE firstname = 'Diego' AND lastname = 'Luiken'),
        (SELECT performance_id FROM PERFORMANCES WHERE movie_id = (SELECT movie_id FROM MOVIES WHERE title = 'Avatar')),
        2,10.50);
INSERT INTO TICKETS
VALUES ((SELECT viewer_id FROM VIEWERS WHERE firstname = 'Agnes' AND lastname = 'R. Sutton'), (SELECT performance_id
                                                                                               FROM PERFORMANCES
                                                                                               WHERE movie_id = (SELECT movie_id FROM MOVIES WHERE title = 'The Dark Knight')),
        4,12);
INSERT INTO TICKETS
VALUES ((SELECT viewer_id FROM VIEWERS WHERE firstname = 'Ogier' AND lastname = 'Dennis'), (SELECT performance_id
                                                                                            FROM PERFORMANCES
                                                                                            WHERE movie_id = (SELECT movie_id FROM MOVIES WHERE title = 'Titanic')),
        5,10.50);
INSERT INTO TICKETS
VALUES ((SELECT viewer_id FROM VIEWERS WHERE firstname = 'Sylvia' AND lastname = 'B. Ralston'), (SELECT performance_id
                                                                                                 FROM PERFORMANCES
                                                                                                 WHERE movie_id =
                                                                                                       (SELECT movie_id
                                                                                                        FROM MOVIES
                                                                                                        WHERE title = 'The Lord of the Rings: The Return of the King')),
        10,12);
INSERT INTO TICKETS
VALUES ((SELECT viewer_id FROM VIEWERS WHERE firstname = 'Shaniqua' AND lastname = 'Braams'), (SELECT performance_id
                                                                                               FROM PERFORMANCES
                                                                                               WHERE movie_id = (SELECT movie_id FROM MOVIES WHERE title = 'Breaking Bad')),
        15,10.50);