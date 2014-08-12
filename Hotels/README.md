デモ用クエリ

## 事前準備

下記項目の事前準備が必要。

1. gungnirにユーザを作成
2. TUPLE作成
3. MongoDBにマスタデータ用意

以降詳細。

### 1. gungnirにユーザを作成

下記のユーザを作成する。

* ユーザ名称: gennai
* パスワード: gennai

```
$ gungnir -u root -p gennai
gungnir> CREATE USER 'gennai' IDENTIFIED BY 'gennai';
```

### 2. TUPLE作成

1.で作成したユーザにTUPLEを作成する。
※ tupleファイル

```
$ gungnir -u gennai -p gennai
gungnir> CREATE TUPLE demo(status STRING, hotelId STRING, _time);
```

### 3. MongoDBにマスタデータ用意

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

※ IDを変更すること(下記参照)。

```
$ npm install
$ node post.js
```

停止はCtrl-C。

### shで実行する場合

IDを引数に実行すること(下記参照)。

```
$ sh post.sh [ID]
```

停止はCtrl-C。

### ID確認方法

下記の"id"を取得。

```
$ gungnir -u [id] -p [password]
gungnir> DESC USER;
{"id":"53d9de890cf214613ba97185","name":"gennai","createTime":"2014-07-31T06:13:29.826Z"}
gungnir>
```
