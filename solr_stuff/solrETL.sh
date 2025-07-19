#!/bin/bash -x
date
TENANT=$1

##############################################################################
# clear out the existing data
##############################################################################
curl -S -s "http://localhost:8983/solr/${TENANT}/update" --data '<delete><query>*:*</query></delete>' -H 'Content-type:text/xml; charset=utf-8'
curl -S -s "http://localhost:8983/solr/${TENANT}/update" --data '<commit/>' -H 'Content-type:text/xml; charset=utf-8'
##############################################################################
# extract metadata
##############################################################################
cp $2 4solr.${TENANT}.csv 
##############################################################################
# compute _i values for _dt values (to support BL date range searching)
##############################################################################
#time python3 computeTimeIntegers.py d9.csv 4solr.${TENANT}.csv
# clean up some outstanding sins perpetuated by earlier scripts
#perl -i -pe 's/\r//g;s/\\/\//g;s/\t"/\t/g;s/"\t/\t/g;s/\"\"/"/g' 4solr.${TENANT}.csv
##############################################################################
# ok, now let's load this into solr...
# clear out the existing data
##############################################################################
##############################################################################
# this POSTs the csv to the Solr / update endpoint
# note, among other things, the overriding of the encapsulator with \
##############################################################################
time curl -X POST -S -s "http://localhost:8983/solr/${TENANT}/update/csv?commit=true&header=true&separator=%09&f.path_ss.split=true&f.path_ss.separator=|&encapsulator=\\" -T 4solr.${TENANT}.csv -H 'Content-type:text/plain; charset=utf-8' &
time python3 evaluate.py 4solr.${TENANT}.csv temp.${TENANT}.csv > 4solr.fields.${TENANT}.counts.csv &
wait
##############################################################################
# wrap things up: make a gzipped version of what was loaded
##############################################################################
date
