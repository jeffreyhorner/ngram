#!/bin/bash
ngramdir=$1
ngramfile=$2
rm -f ${ngramdir}/failed_keys.txt && touch ${ngramdir}/failed_keys.txt

for i in `find $1 -name "${2}"`; do
    time ./fill_cache.R < ${i} >> ${ngramdir}/failed_keys.txt; 
	echo $i
done
