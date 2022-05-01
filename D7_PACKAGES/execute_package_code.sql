-- In dit bestand voor je alle code uit die je package aanroept.
-- een oproep van de package zit tussen een BEGIN en een END blok

BEGIN
    PKG_MOVIES.EMPTY_TABLES();
    PKG_MOVIES.BEWIJS_MILESTONE_5();
END;

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
    PKG_MOVIES.ADD_MOVIE('The Lord of the Rings: The Return of the King', TO_DATE('2003-02-07', 'yyyy-mm-dd'), 'Action',
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
    PKG_MOVIES.ADD_VIEWER('Diego', 'Luiken', TO_DATE('1962-05-22', 'yyyy-mm-dd'), 'M', 'diegoluiken@gmail.com',
                          'Brixtonlaan', 176, '1000', 'BE');
    PKG_MOVIES.ADD_VIEWER('Agnes', 'R. Sutton', TO_DATE('1945-06-20', 'yyyy-mm-dd'), 'X', 'agnessutton@gmail.com',
                          'Aven Ackers', 227, '10002', 'US');
    PKG_MOVIES.ADD_VIEWER('Ogier', 'Dennis', TO_DATE('2002-07-05', 'yyyy-mm-dd'), 'M', 'ogierdennis@gmail.com',
                          'Rue Bois des Fosses', 139, '75000', 'FR');
    PKG_MOVIES.ADD_VIEWER('Sylvia', 'B. Ralston', TO_DATE('1990-10-12', 'yyyy-mm-dd'), 'V', 'sylviaralston@gmail.com',
                          'Oost St', 1155, '6665', 'ZA');
    PKG_MOVIES.ADD_VIEWER('Shaniqua', 'Braams', TO_DATE('1962-05-10', 'yyyy-mm-dd'), 'V', 'shaniquabraams@gmail.com',
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
    PKG_MOVIES.ADD_PERFORMANCE('The Lord of the Rings: The Return of the King', 'Pathé City', 'Kleine-Gartmanplantsoen',
                               15, '1015', 'NL', 1, 9, TO_DATE('2016-04-01 20:50', 'yyyy-mm-dd hh24:mi'));
    PKG_MOVIES.ADD_PERFORMANCE('Breaking Bad', 'Artscape Theatre Centre', 'D.F. Malan St', 25, '6665', 'ZA', 2, 2,
                               TO_DATE('2015-02-18 19:45', 'yyyy-mm-dd hh24:mi'));


-- Tickets
    PKG_MOVIES.ADD_TICKET('diegoluiken@gmail.com',
                          'Avatar', 'Théâtre de la Ville', 'Pl. du Châtelet', 2, '75000', 'FR', 3, 8,
                          TO_DATE('2014-12-25 16:30', 'yyyy-mm-dd hh24:mi'),
                          2, 10.50);
    PKG_MOVIES.ADD_TICKET('agnessutton@gmail.com',
                          'The Dark Knight','Cinema Galeries', 'Galerie de la Reine', 26, '1000', 'BE', 2, 13,TO_DATE('2012-04-09 12:20', 'yyyy-mm-dd hh24:mi'),
                          4, 12);
    PKG_MOVIES.ADD_TICKET('ogierdennis@gmail.com', 'Titanic', 'Apollo Theater', 'West 125th Street', 254, '10002', 'US',
                          2, 4, TO_DATE('2014-12-25 14:00', 'yyyy-mm-dd hh24:mi'),
                          5, 10.50);
    PKG_MOVIES.ADD_TICKET('agnessutton@gmail.com', 'The Lord of the Rings: The Return of the King', 'Pathé City',
                          'Kleine-Gartmanplantsoen', 15, '1015', 'NL', 1, 9,
                          TO_DATE('2016-04-01 20:50', 'yyyy-mm-dd hh24:mi'),
                          10, 12);
    PKG_MOVIES.ADD_TICKET('shaniquabraams@gmail.com', 'Breaking Bad', 'Artscape Theatre Centre', 'D.F. Malan St', 25,
                          '6665', 'ZA', 2, 2, TO_DATE('2015-02-18 19:45', 'yyyy-mm-dd hh24:mi'),
                          15, 10.50);

end;