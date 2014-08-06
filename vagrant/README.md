# VMに関して

## アプリケーション

|#|Application|Version|Install Directory|
|:--:|:--|:--|:--|
|1|JDK|1.6.0_45|/usr/java/jdk1.6.0_45|
|2|ZooKeeper|3.4.5|/opt/zookeeper|
|3|Kafka|0.8.0|/opt/kafka|
|4|storm|0.9.0.1|/opt/storm|
|5|GungnirServer|0.0.1|/opt/gungnir-server|
|6|GungnirClient|0.0.1|/opt/gungnir-client|

JDK, ZooKeeper, GungnirClientにはPATHを通しています。

VM起動後、各サービスが起動している事が確認できれば下記コマンドを実行する事ができます。

```
$ gungnir -u root -p gennai
```

## config.ini

`files/config.ini`に各種設定を書く事ができます。

|#|Section Name|Key|Value|default Value|Content|
|:--:|:--|:--|:--|:--|:--|
|1|common|mode|local/value|local||
|2|zookeeper|install|true/false|true||
|3|zookeeper|dir||/opt|
|4|zookeeper|version||3.4.5||
|5|zookeeper|user||vagrant||
|6|zookeeper|group||vagrant||
|7|zookeeper|service|on/off|off||
|8|kafka|install|true/false|true||
|9|kafka|version||0.8.0||
|10|kafka|scala||2.8.0||
|11|kafka|user||vagrant||
|12|kafka|group||vagrant||
|13|kafka|service|on/off|off||
|14|mongodb|install|true/false|true||
|15|mongodb|service|on/off|off||
|16|storm|install|true/false|true||
|17|storm|dir||/opt||
|18|storm|version||0.9.0.1||
|19|storm|user||vagrant||
|20|storm|group||vagrant||
|21|storm|service|on/off|off||
|22|gungnir|install|true/false|true||
|23|gungnir|dir||/opt||
|24|gungnir|user||vagrant||
|25|gungnir|group||vagrant||
|26|gungnir|service|on/off|off||



## サービス

下記はサービス化しています。

|#|Service|local|distributed|備考|
|:--:|:--|:--:|:--:|:--|
|1|ZooKeeper|○|○||
|2|Kafka|○|○||
|3|MongoDB|○|○||
|4|Storm nimbus|-|○|※1 ※2|
|5|Storm supervisor|-|○|※1 ※2|
|6|Storm UI|-|-|※1 ※2|
|7|GungnirServer|○|○||

※1: localモードの場合はインストールされません。
※2: localモードかつStormをインストールしたい場合には、config.iniに`install=true`をstormセクションに明示的に記載してください。

### ZooKeeper

```
$ sudo service zookeeper [start|stop]
```

### Kafka

```
$ sudo service kafka [start|stop]
```

### Storm nimbus

```
$ sudo service storm-nimbus [start|stop]
```

### Storm supervisor

```
$ sudo service storm-supervisor [start|stop]
```

### Storm UI

```
$ sudo service storm-ui [start|stop]
```

### GungnirServer

```
$ sudo service gungnir-server [start|stop]
```


## VMに関して

現時点ではメモリは各種でフォルト設定で起動されています。
よって重い処理を実行するとメモリが足りなくなる恐れがあります。

Vagrantfileを編集し、VMのメモリ容量・CPU数を増やしてください。

```
  virtualbox.memory=2048
  virtualbox.cpus = 2
```
