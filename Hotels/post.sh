#!/bin/sh


GUNGNIR_SERVER='10.0.1.13'
GUNGNIR_PORT=9191
GUNGNIR_UID='53d4c41fe4b0f86f8d431154'
GUNGNIR_TUPLE='demo'


STATS=('watch' 'watch' 'watch' 'watch' 'watch' 'watch' 'watch' 'watch' 'watch' 'watch' 'watch' 'watch' 'watch' 'watch' 'watch' 'watch' 'watch' 'watch' 'watch' 'watch' 'watch' 'watch' 'watch' 'watch' 'watch' 'watch' 'watch' 'watch' 'watch' 'watch' 'watch' 'watch' 'watch' 'watch' 'watch' 'watch' 'watch' 'watch' 'watch' 'watch' 'watch' 'watch' 'watch' 'watch' 'watch' 'watch' 'watch' 'watch' 'watch' 'watch' 'watch' 'watch' 'watch' 'watch' 'watch' 'watch' 'watch' 'watch' 'watch' 'watch' 'watch' 'watch' 'watch' 'watch' 'watch' 'watch' 'watch' 'watch' 'watch' 'watch' 'watch' 'watch' 'watch' 'watch' 'watch' 'watch' 'watch' 'watch' 'watch' 'watch' 'watch' 'watch' 'watch' 'watch' 'watch' 'watch' 'watch' 'watch' 'watch' 'watch' 'commit' 'commit' 'commit' 'commit' 'commit' 'commit' 'commit' 'commit' 'commit' 'cancel')
HOTELS=('yad321756' 'yad321524' 'yad350240' 'yad326902' 'yad302905' 'yad383054' 'yad388086' 'yad331701' 'yad313464' 'yad320921')

INDEX=0
WATCH_COUNT=0
COMMIT_COUNT=0
CANCEL_COUNT=0

while true
do
	INDEX=`expr ${INDEX} + 1`
	SINDEX=`expr ${RANDOM} % 100`
	HINDEX=`expr ${RANDOM} % 10`
	curl -H 'Content-Type: application/json' -X POST -d '{"status":"'${STATS[${SINDEX}]}'","hotelId":"'${HOTELS[${HINDEX}]}'"}' http://${GUNGNIR_SERVER}:${GUNGNIR_PORT}/gungnir/v0.1/track/${GUNGNIR_UID}/${GUNGNIR_TUPLE}

	if [ ${STATS[${SINDEX}]} == 'watch' ] ; then
		WATCH_COUNT=`expr ${WATCH_COUNT} + 1`
	elif [ ${STATS[${SINDEX}]} == 'commit' ] ; then
		COMMIT_COUNT=`expr ${COMMIT_COUNT} + 1`
	elif [ ${STATS[${SINDEX}]} == 'cancel' ] ; then
		CANCEL_COUNT=`expr ${CANCEL_COUNT} + 1`
	fi

	if [ `expr ${INDEX} % 100` == 0 ] ; then
		printf "%s % 10d total, % 10d watches, % 10d commits, % 10d cancels\n" `date +'%s'` ${INDEX} ${WATCH_COUNT} ${COMMIT_COUNT} ${CANCEL_COUNT}
	fi
done
