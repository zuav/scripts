#!/bin/bash

files=`find ./recipes/ -name '*.bb' | xargs grep -l 'git.altell.local' `

for i in $files
do
    mv $i $i.$$
    cat $i.$$ | sed 's/git.altell.local/git.office.altell.ru/' > $i
    rm $i.$$
done
