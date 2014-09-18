SET topology.metrics.enabled = true
;
SET topology.metrics.interval.secs = 60
;
SET default.parallelism = 32
;
FROM (
  RequestPacket JOIN ResponsePacket
  ON RequestPacket.request_pheader.Destination_Port = ResponsePacket.response_pheader.Source_Port
  AND RequestPacket.request_pheader.Source_Port = ResponsePacket.response_pheader.Destination_Port
  AND RequestPacket.request_pheader.Destination_Ip = ResponsePacket.response_pheader.Source_Ip
  AND RequestPacket.request_pheader.Source_Ip = ResponsePacket.response_pheader.Destination_Ip
  TO
    RequestPacket.request_properties AS request_properties,
    RequestPacket._time AS request_time,
    ResponsePacket.response_properties AS response_properties,
    ResponsePacket._time AS response_time
  EXPIRE 10sec
) AS packet USING kafka_spout() parallelism 8
EACH
  request_properties.Host AS host,
  request_properties.Request_URI AS uri,
  response_properties.Status AS status,
  request_time,
  response_time
INTO s1
;
FROM s1
SNAPSHOT EVERY 1min *, count() AS cnt
EACH *, sum(cnt) AS sum, ifnull(record, 'cnt_all') AS record parallelism 1
EMIT record, sum, request_time, response_time USING mongo_persist('front', 'count', ['record']) parallelism 1
;
FROM s1
SNAPSHOT EVERY 1min *, count() AS cnt
SLIDE LENGTH 5min BY response_time sum(cnt) AS sum, request_time, response_time parallelism 1
EACH *, ifnull(record, 'cnt_all_time') AS record parallelism 1
EMIT record, sum, request_time, response_time USING mongo_persist('front', 'count', ['record']) parallelism 1
;
FROM s1
JOIN service ON service.host = host TO service.sid AS sid EXPIRE 10min USING mongo_fetch('front', 'service')
INTO s2
;
FROM s2
FILTER sid IS NULL
JOIN unknowns ON unknowns.host = host TO unknowns.host AS flag EXPIRE 10min USING mongo_fetch('front', 'unknowns')
FILTER flag IS NULL
EMIT host USING mongo_persist('front', 'unknowns')
;
FROM s2
EACH ifnull(sid, 'unknowns') AS sid, host, uri, status, request_time, response_time
BEGIN GROUP BY sid
INTO s3
;
FROM s3
SNAPSHOT EVERY 1min *, count() AS cnt
EACH *, sum(cnt) AS sum, ifnull(record, 'cnt_sid') AS record parallelism 1
EMIT record, sum, sid, request_time, response_time USING mongo_persist('front', 'count', ['record', 'sid']) parallelism 1
;
FROM s3
SNAPSHOT EVERY 1min *, count() AS cnt
SLIDE LENGTH 5min BY response_time sum(cnt) AS sum, sid, request_time, response_time parallelism 1
EACH *, ifnull(record, 'cnt_sid_time') AS record parallelism 1
EMIT record, sum, sid, request_time, response_time USING mongo_persist('front', 'count', ['record', 'sid']) parallelism 1
;
FROM s3
FILTER sid <> 'unknowns'
BEGIN GROUP BY host
INTO s4
;
FROM s4
SNAPSHOT EVERY 1min *, count() AS cnt
EACH *, sum(cnt) AS sum, ifnull(record, 'cnt_host') AS record  parallelism 1
EMIT record, sum, sid, host, request_time, response_time USING mongo_persist('front', 'count', ['record', 'sid', 'host']) parallelism 1
;
FROM s4
SNAPSHOT EVERY 1min *, count() AS cnt
SLIDE LENGTH 5min BY response_time sum(cnt) AS sum, sid, host, request_time, response_time parallelism 1
EACH *, ifnull(record, 'cnt_host_time') AS record parallelism 1
EMIT record, sum, sid, host, request_time, response_time USING mongo_persist('front', 'count', ['record', 'sid', 'host']) parallelism 1
;
FROM s4
EACH *, regexp_extract(status, '(.*) (\d{3}) (.*)', 2) AS code 
FILTER code REGEXP '^[^23]\d{2}$'
BEGIN GROUP BY code
INTO s5
;
FROM s5
SNAPSHOT EVERY 1min *, count() AS cnt
EACH *, sum(cnt) AS sum, ifnull(record, 'cnt_status') AS record  parallelism 1
EMIT record, sum, sid, host, code, request_time, response_time USING mongo_persist('front', 'count', ['record', 'sid', 'host', 'code']) parallelism 1
;
FROM s5
SNAPSHOT EVERY 1min *, count() AS cnt
SLIDE LENGTH 5min BY response_time sum(cnt) AS sum, sid, host, uri, code, request_time, response_time parallelism 1
EACH *, ifnull(record, 'cnt_status_time') AS record parallelism 1
EMIT record, sum, sid, host, code, request_time, response_time USING mongo_persist('front', 'count', ['record', 'sid', 'host', 'code']) parallelism 1
;
FROM s5
EACH *, ifnull(record, 'uri_status') AS record
EMIT record, sid, host, uri, status, code, request_time, response_time USING mongo_persist('front', 'output')
;
