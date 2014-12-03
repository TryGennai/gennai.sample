FROM demo USING kafka_spout()
INTO s1
;
FROM s1
BEGIN GROUP BY status
  EACH status, count() as count
END GROUP
EMIT status, count USING mongo_persist('demo', 'output2_1', ['status'])
;
FROM s1
BEGIN GROUP BY hotelId
  BEGIN GROUP BY status
    EACH hotelId, status, count() AS count
  END GROUP
  EMIT hotelId, status, count USING mongo_persist('demo', 'output2_2', ['hotelId', 'status'])
END GROUP
;
