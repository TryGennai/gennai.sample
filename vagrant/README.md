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

## サービス

下記はサービス化しています。

|#|Service|local|distributed|備考|
|:--:|:--|:--:|:--:|:--|
|1|ZooKeeper|○|○||
|2|Kafka|○|○||
|3|MongoDB|○|○||
|4|Storm nimbus|-|○||
|5|Storm supervisor|-|○||
|6|Storm UI|-|-||
|7|GungnirServer|○|○||

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

