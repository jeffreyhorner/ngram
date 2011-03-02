#!/bin/bash
for i in `seq $1 $2`; do
    time ./fill_cache.R < ${3}/2gram-all-20090715-${i}.csv >> failed_keys.txt; 
done
