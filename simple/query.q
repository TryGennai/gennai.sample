FROM simple
USING kafka_spout()
FILTER Content REGEXP '^A[A-Z]*$'
EMIT * USING mongo_persist('test', 'simple_output');
