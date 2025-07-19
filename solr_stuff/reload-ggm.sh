# find . -type f | perl -pe 's/^\.//' | grep thumbnail > fnames.txt
# perl -ne '$x=$_;s#^.*/##;s/.thumbnail.jpg//;print "$1\t$2 $3\t$4\t$5\t$6\t/images$x" if /^(\d+) ?\-? ([A-Za-z]+) ?(\d+) ?\- ([A-Z]\d+)?,? ?(.*?) ?(\d+)?$/' fnames.txt > ggm1a.csv
perl -n ggm.pl fnames.txt > ggm1a.csv
cat ggm1a-header.csv ggm1a.csv > g
mv g ggm1a.csv
./clear-core.sh ggm
time curl -X POST -S -s "http://localhost:8983/solr/ggm/update/csv?commit=true&header=true&separator=%09" -T ggm1a.csv -H 'Content-type:text/plain; charset=utf-8'
