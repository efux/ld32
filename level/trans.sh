#!/bin/bash

rm /home/efux/Documents/dev/ld32/level/test.map

while read line; do
	if [[ $line != *"<"* ]]
	then
		echo $line;
		echo $line >> /home/efux/Documents/dev/ld32/level/test.map
	fi
done < /home/efux/Documents/dev/ld32/level/test.tmx
