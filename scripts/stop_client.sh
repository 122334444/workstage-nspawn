#!/bin/bash

for i in "$@"
do
case $i in
	--cont_name=*)
		CONT_NAME="${i#*=}"
	;;
	*)
		#echo "BAD KEYS FOUND"
	;;
esac
done

machinectl stop $CONT_NAME

exit

