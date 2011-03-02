#!/bin/bash
for i in 0; do
	unzip -p googlebooks-eng-all-3gram-20090715-${i}.csv.zip | ./wide - - | gzip - > 3gram-eng-all-normalized-wide-${i}.csv.gz
done
