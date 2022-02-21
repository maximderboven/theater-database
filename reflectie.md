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
- Reviewer
- Movie
- Actor
- Hall
- Theather

Relatietypes:
-------------

- Movie
  - was reviewed by
  - Reviewer
- Actor
  - acts in
  - Movie
- Movie
  - is played in
  - Hall
- Halls
  - are rented by
  - Theather

Attributen:
-----------

- Movie
  - title
  - release_date
  - genre
  - type
  - runtime
  - plot
  - lang
- Actor
  - firstname
  - lastname
  - email
  - phonenumber
  - street
  - number
  - city
  - country
  - ZIP
  - gender
  - birthday
- Reviewer
  - firstname
  - lastname
  - stars
  - comment
  - published
  - email
- Hall
  - amount_seats
  - floor
  - screentype
- Theather
  - name
  - shop
  - phonenumber
  - street
  - number
  - city
  - country
  - ZIP
