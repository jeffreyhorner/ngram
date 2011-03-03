#!/bin/bash
ngramdir=$1
rm -f ${ngramdir}/failed_keys.txt && touch ${ngramdir}/failed_keys.txt

for i in `find $ngramdir | grep csv`; do
    time ./ngram/fill_cache.R < ${i} >> ${ngramdir}/failed_keys.txt; 
	echo $i
done
