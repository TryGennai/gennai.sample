FROM demo USING kafka_spout()
EMIT * USING mongo_persist('demo', 'output0')
;
SUBMIT TOPOLOGY demo0
;
