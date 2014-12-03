FROM demo USING kafka_spout()
INTO s1
;
FROM s1
BEGIN GROUP BY status
  EACH status, count() as count
END GROUP
EMIT status, count USING mongo_persist('demo', 'output3_1', ['status'])
;
FROM s1
JOIN hotel
  ON hotel.hotelId = hotelId
  TO hotel.hotelName AS hotelName, hotel.areaCd AS areaCd
  EXPIRE 1h
  USING mongo_fetch('demo', 'hotel')
BEGIN GROUP BY hotelId
  BEGIN GROUP BY status
    EACH *, count() AS count
  END GROUP
  EMIT * USING mongo_persist('demo', 'output3_2', ['hotelId', 'status'])
END GROUP
;
