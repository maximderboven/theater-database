Milestone 3: Creatie Databank
---

    Identity columns
---
- Mandatory
  - computergames: game_id
  - Player: player_id
  - Influencer_youtubechannel: channel_id
  - Influencer_youtubevideo: video_id
- other:
  - gamestudios: studio_id
  - Locations: location_id


      Table Counts
---
![Table counts](./screenshots/table_count.PNG)

    @query 1: Relatie Veel-op-veel

    SELECT game_title, release_date, patch_title, p.PLAYER_NAME, h.HIGHSCORE, date_played, email
    FROM computergames cg
    JOIN highscores h ON cg.game_id = h.game_id
    JOIN players p ON h.player_id = p.player_id;
--- 
![query 1: Relatie Veel-op-veel](./screenshots/veel_op_veel.PNG)



    @query 2: 2 niveau’s diep

    SELECT game_title, channel_name, channel_url, subscriber_count, video_title, viewer_count, duration
    FROM computergames cg
    JOIN influencer_youtubechannels iyc ON cg.game_id = iyc.game_id
    JOIN influencer_youtubevideos iyv ON iyc.channel_id = iyv.channel_id
    ORDER BY game_title, channel_name, video_title;
--- 
![query 2: 2 niveau’s diep](./screenshots/2_niveaus_diep.PNG)

    @query 3: player_locations

    SELECT zc.countrycode AS "COUNTRY", zc.zipcode AS "ZIP", city, country_name, street, housenumber, p.player_name
    FROM countries c
    JOIN zipcodes zc ON c.countrycode = zc.countrycode
    JOIN locations lc ON zc.countrycode = lc.countrycode AND zc.zipcode = lc.zipcode
    JOIN player_locations pl ON lc.location_id = pl.location_id
    JOIN players p ON pl.player_id = p.player_id
    ORDER BY player_name, country;
--- 
![query 3: player locations](./screenshots/player_locations.PNG)

    @query 4: Game studios

    SELECT gs.studio_name, zc.zipcode, zc.city, c.country_name, release_date, cg.game_title
    FROM computergames cg
    JOIN gamestudios gs ON cg.studio_id = gs.studio_id
    JOIN locations l ON gs.studio_address = l.location_id
    JOIN zipcodes zc ON l.countrycode = zc.countrycode AND l.zipcode = zc.zipcode
    JOIN countries c ON zc.countrycode = c.countrycode
    ORDER BY gs.studio_name,  cg.game_title;
--- 
![query 4: Game studios](./screenshots/game_studio.PNG)


  Bewijs Domeinen - constraints M2
--- 
    Player: zipcodes - minumum 4 characters

---
![Bewijs Zipcodes](./screenshots/bewijs_zipcodes.PNG)

    Player: email must contains @

---
![Bewijs email](./screenshots/bewijs_email.PNG)


    Computergame: release_date < last_updated

---

![Bewijs release_patch_dates](./screenshots/bewijs_release_patch_date.PNG)


