FROM demo USING kafka_spout()
BEGIN GROUP BY status
  EACH status, count() as count
END GROUP
EMIT status, count USING mongo_persist('demo', 'output1', ['status'])
;
SUBMIT TOPOLOGY demo1
;
