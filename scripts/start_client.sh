#!/bin/bash

for i in "$@"
do
case $i in
	--cont_dir_log=*)
		CONT_DIR_LOG="${i#*=}"
	;;
	--cont_dir=*)
		CONT_DIR="${i#*=}"
	;;
	--cont_name=*)
		CONT_NAME="${i#*=}"
	;;
	*)
	;;
esac
done

if [ ! -d $CONT_DIR_LOG ]; then
	echo "Каталог для логов контейенра не найден!"; exit 1
fi
if [ ! -d $CONT_DIR ]; then
	echo "Каталог для контейенров не существует!"; exit 1
fi
if [ ! -d $CONT_DIR/$CONT_NAME ]; then
	echo "Каталог контейнера не найден!"; exit 1
fi

nohup systemd-nspawn -n --capability=CAP_SYS_MODULE -b -D $CONT_DIR/$CONT_NAME >> $CONT_DIR_LOG/$CONT_NAME.log &

exit

