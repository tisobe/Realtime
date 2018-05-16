#! /usr/bin/perl -w

# Fetch the monthly ACE EPAM and yearly WDC Kp files

# Robert Cameron
# September 2001

$lynx = "/usr/bin/lynx";

$odir = "/data/mta4/proj/rac/ops/ACE/longterm";

# get ACE EPAM files

print "Fetching monthly ACE EPAM files:\n";
$site = "ftp://ftp.swpc.noaa.gov/pub/lists/ace2/";
$l = `$lynx -crawl -dump $site`;
@l = split / /,$l;
@f = grep /_ace_epam_1h.txt/, @l;
@f = reverse sort @f;
foreach (@f[0..1]) {
    $f = `$lynx -source $site/$_`;
    open (OF, ">$odir/$_") or die scalar(gmtime)." Cannot open output file $odir/$_\n";
    print OF $f;
    print "   $_\n";
}

# get WDC Kp files

print "Fetching yearly WDC Kp files:\n";
$site = "ftp://ftp.gfz-potsdam.de/pub/home/obs/kp-ap/wdc/";
($mon,$year) = (gmtime)[4,5];
$year += 1900;
push @year,$year--;
push @year,$year if ($mon == 0);
foreach (@year) {
    $kpf = "kp$_.wdc";
    $f = `$lynx -source $site/$kpf`;
    open (OF, ">$odir/$kpf") or die scalar(gmtime)." Cannot open output file $odir/$kpf\n";
    print OF $f;
    print "   $kpf\n";
}
