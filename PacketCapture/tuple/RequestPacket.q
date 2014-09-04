CREATE TUPLE RequestPacket(
  request_properties STRUCT<
    Content_Length STRING,
    Content_Type STRING,
    Method STRING,
    Request_URI STRING,
    Authorization STRING,
    Host STRING,
    Accept STRING,
    Connection STRING,
    Referer STRING,
    User_Agent STRING
  >,
  request_pheader STRUCT<
    Packet_Length INT,
    Destination_Port STRING,
    Source_Port STRING,
    Destination_Ip STRING,
    Source_Ip STRING,
    ID STRING
  >,
  _time
);
