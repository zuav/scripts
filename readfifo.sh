#!/bin/bash

pipe=$1

trap "rm -f $pipe" EXIT

if [[ ! -p $pipe ]]; then
    echo "Not found $pipe"
    exit 1
fi

while true
do
    if read line <$pipe; then
        echo $line
    fi
done

