#!/bin/bash

perl=`which perl`

for mod in `cat module-list`; do
    echo "Build $mod"
    $perl `which cpanm` $mod
    if [[ $? -ne 0 ]] ; then
       echo "Build of $mod died"
       exit 1
    fi
done
