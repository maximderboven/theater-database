Milestone 1: Onderwerp en Git
---

Student:
--------
Maxim Derboven  
0145196-84

Onderwerp: (veel op veel)
-------------------------
- M:N
  - Viewer - Movie


- 2Level: Movie
  - Hall
  - Theather


Entiteittypes:
--------------
- Viewer
- Movie
- MovieType
- Hall
- Theather

Relatietypes:
-------------

- Movie
  - was viewed by
  - Viewer
- Movie
  - is described by
  - MovieType
- Movie
  - is played in
  - Hall
- Halls
  - are inside a
  - Theather

Attributen:
-----------

- Viewer
  - firstname
  - lastname
  - birthday
  - email
- Movie
  - title
  - release_date
  - age_restriction
  - runtime
  - plot
  - price
  - playTime
  - playDate
  - lang
- MovieType
  - genre
  - type
- Hall
  - amount_seats
  - floor
  - screenType
- Theather
  - name
  - shop
  - phoneNumber
  - street
  - number
  - city
  - country
  - ZIP
