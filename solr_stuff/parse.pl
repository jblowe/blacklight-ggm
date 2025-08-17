s/[\r\n]//g;
chomp;
$x=$_;
s#^.*/##;
$filename = $_;
s/.thumbnail(.*).jpg//;

my ($year, $month, $day_of_month, $lockenumber, $location, $imagenumber, $title, $city, $filename, $top, $sxb, $path);

# 2010 - November 12 - K7 Gam Bāhā 1

($year, $month, $day_of_month, $lockenumber, $location, $imagenumber) = /^(\d+) ?\-? ([A-Za-z]+) ?(\d+) ?\- ([A-Z]\d+)?,? ?(.*?) ?(\d+)?$/;
$title = $_;
$x =~ m#^/(.*?)/# ;
$top = $1;

$top =~ s/ of the Kathmandu Valley//;
$top =~ s/,.*$//;

$city = 'Kathmandu' if $lockenumber =~ /K/;
$city = 'Patan'     if $lockenumber =~ /P/;
$city = 'Bhaktapur' if $lockenumber =~ /B/;

print "$year\t$month $day_of_month\t$lockenumber\t$location\t$imagenumber\t$title\t$city\t$filename\t$top\t$sxb\t/ggm-images$x\n";
