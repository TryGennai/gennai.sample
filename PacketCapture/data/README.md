最初に
==========

MongoDBに下記コマンドを実行。

```
use front;
db.service.insert({"sid": "gennai", "host": "host.001.jp"});
db.service.insert({"sid": "gennai", "host": "host.002.jp"});
db.service.insert({"sid": "gennai", "host": "host.003.jp"});
db.service.insert({"sid": "gennai", "host": "host.004.jp"});
db.service.insert({"sid": "gennai", "host": "host.005.jp"});
db.service.insert({"sid": "gennai", "host": "host.006.jp"});
db.service.insert({"sid": "gennai", "host": "host.007.jp"});
db.service.insert({"sid": "gennai", "host": "host.008.jp"});
db.service.insert({"sid": "gennai", "host": "host.009.jp"});
db.service.insert({"sid": "gennai", "host": "host.010.jp"});
```

input data
==========

data post.

RequestPacket URL => http://[server]:9191/gungnir/v0.1/track/[userid]/RequestPacket

ResponsePacket URL => http://[server]:9191/gungnir/v0.1/track/[userid]/ResponsePacket


output data
===========

MongoDBに出力されたデータ。

```
db.output.find({}, {_id: 0, cnt: 1, record: 1, sid: 1, host: 1, uri: 1, status: 1});
```

下記のフィールドは非表示
 * \_id
 * request_time
 * response_time

※ TOPOLOGYからLIMIT句を削除して実行した場合です。
