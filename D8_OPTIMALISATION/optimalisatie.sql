-- Update stats
begin
    DBMS_STATS.GATHER_TABLE_STATS
        ('PROJECT', 'PERFORMANCES');
    DBMS_STATS.GATHER_TABLE_STATS
        ('PROJECT', 'HALLS');
    DBMS_STATS.GATHER_TABLE_STATS
        ('PROJECT', 'THEATHERS');
end;

alter
    session set "_partition_large_extents" = false;

-- Get table size
select segment_name,
       segment_type,
       sum(bytes / 1024 / 1024)          MB,
       (select COUNT(*) FROM PERFORMANCES) as table_count
from dba_segments
where segment_name = 'PERFORMANCES'
group by segment_name, segment_type;

-- Gemiddelde dagen tussen start en einde van film performances (die starten op een bepaalde dagen) (in dagen) per theather
SELECT /*+ FULL(P) */ T.THEATHER_ID,T.NAME, ROUND(AVG(CAST(P.ENDTIME as DATE)-CAST(P.STARTTIME AS DATE))) AS "Gemiddelde dagen per performance"
FROM THEATHERS T
         JOIN HALLS H on H.THEATHER_ID = T.THEATHER_ID
         JOIN PERFORMANCES P on P.HALL_ID = H.HALL_ID
WHERE P.STARTTIME BETWEEN TO_DATE('01-02-2018 00:00','DD-MM-YYYY HH24:MI') AND TO_DATE('01-02-2018 23:59','DD-MM-YYYY HH24:MI')
GROUP BY T.THEATHER_ID, T.NAME;

/*WHERE H.SCREENTYPE = '2D'*/
DROP TABLE PERFORMANCES CASCADE CONSTRAINTS PURGE;
CREATE TABLE PERFORMANCES
(
    performance_id INTEGER GENERATED ALWAYS AS IDENTITY CONSTRAINT fk_performance PRIMARY KEY,
    movie_id       INTEGER NOT NULL CONSTRAINT fk_movie_performance REFERENCES MOVIES(MOVIE_ID) ON DELETE CASCADE,
    hall_id        INTEGER NOT NULL CONSTRAINT fk_hall_performance REFERENCES HALLS(HALL_ID) ON DELETE CASCADE,
    starttime      TIMESTAMP NOT NULL,
    endtime        TIMESTAMP NOT NULL
)
PARTITION BY RANGE (starttime)
    INTERVAL (NUMTOYMINTERVAL(1, 'MONTH'))
(
    PARTITION p0 VALUES LESS THAN (TO_DATE('2018/02/01', 'YYYY/MM/DD')),
    PARTITION p1 VALUES LESS THAN (TO_DATE('2018/03/01', 'YYYY/MM/DD'))
);



select *
from USER_TAB_PARTITIONS;