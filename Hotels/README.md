デモ用クエリ

## 事前準備

MongoDBにマスタデータ用意。

```
use demo;

db.hotel.insert({"areaCd":"010000", "hotelId":"yad321756", "hotelName":"グランドホテル"});
db.hotel.insert({"areaCd":"010000", "hotelId":"yad321524", "hotelName":"リッチホテル札幌"});
db.hotel.insert({"areaCd":"010000", "hotelId":"yad350240", "hotelName":"プラザ札幌"});
db.hotel.insert({"areaCd":"010000", "hotelId":"yad326902", "hotelName":"ルネッサンスホテル"});
db.hotel.insert({"areaCd":"010000", "hotelId":"yad302905", "hotelName":"クロスル札幌"});
db.hotel.insert({"areaCd":"010000", "hotelId":"yad383054", "hotelName":"グランド小樽"});
db.hotel.insert({"areaCd":"010000", "hotelId":"yad388086", "hotelName":"ホテルノイカロス小樽"});
db.hotel.insert({"areaCd":"010000", "hotelId":"yad331701", "hotelName":"オーマイ小樽"});
db.hotel.insert({"areaCd":"010000", "hotelId":"yad313464", "hotelName":"ラピス函館"});
db.hotel.insert({"areaCd":"010000", "hotelId":"yad320921", "hotelName":"山本亭"});
db.hotel.insert({"areaCd":"130000", "hotelId":"yad337841", "hotelName":"王国ホテル"});
db.hotel.insert({"areaCd":"130000", "hotelId":"yad303873", "hotelName":"ホテルメトロ"});
db.hotel.insert({"areaCd":"130000", "hotelId":"yad303241", "hotelName":"ザ・ニンジン東京"});
db.hotel.insert({"areaCd":"130000", "hotelId":"yad387456", "hotelName":"街角ステーションホテル"});
db.hotel.insert({"areaCd":"130000", "hotelId":"yad381123", "hotelName":"ロイヤルホテル"});
db.hotel.insert({"areaCd":"210000", "hotelId":"yad393168", "hotelName":"熱海温泉ホテル"});
db.hotel.insert({"areaCd":"210000", "hotelId":"yad347759", "hotelName":"リゾート熱海"});
```

## 投入スクリプト

GungnirServreにデモイベントを投入するスクリプトの実行方法。

* watch : 閲覧イベント
* commit : 成約イベント
* cancel : 違約イベント

#### イベントの割合

下記の割合で実行。

watch:commit:cancel = 90:9:1

### nodeで実行する場合

```
$ npm install
$ node post.js
```

停止はCtrl-C。

### shで実行する場合

```
$ sh post.sh
```

停止はCtrl-C。
