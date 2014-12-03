FROM demo USING kafka_spout()
INTO s1
;
FROM s1
BEGIN GROUP BY status
  EACH status, count() as count
END GROUP
EMIT status, count USING mongo_persist('demo', 'output4_1', ['status'])
;
FROM s1
JOIN hotel
  ON hotel.hotelId = hotelId
  TO hotel.hotelName AS hotelName, hotel.areaCd AS areaCd
  USING mongo_fetch('demo', 'hotel')
BEGIN GROUP BY hotelId
  BEGIN GROUP BY stat
    EACH *, count() AS count
  END GROUP
  INTO s2
END GROUP
;
FROM s2
EMIT * USING mongo_persist('demo', 'output4_2', ['hotelId', 'status'])
;
FROM s2
EMIT * USING kafka_emit('demo4')
;
