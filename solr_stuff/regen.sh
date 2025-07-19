perl -n parse.pl fnames.txt > temp
cat ggm1a-header.csv temp > ggm.csv
rm temp
./solrETL.sh ggm ggm.csv
#ln -s /Users/johnlowe/projects/blacklight-ggm/public/images ggm-images
#ln -s /Users/johnlowe/projects/blacklight-ggm/public/images /Users/johnlowe/projects/blacklight-ggm/public/ggm-images
