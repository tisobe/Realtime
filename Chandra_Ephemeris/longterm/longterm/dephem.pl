#! /usr/bin/perl -w

#-------------------------------------------------------------------
#
# maintain a longterm archive of ephemeris data
#
# Robert Cameron
# March 2002
#
# This program should only extract records from the start
# of each DE files (i.e. real definitive ephemeris data).
# Consequently, the latest DE file is not processed.
#
#-------------------------------------------------------------------
#
#--- create a 100-year hash of seconds offsets from 1970
#
@ylen = (31622400,31536000,31536000,31536000);
$s    = 0;

foreach (1970..2070) { $soy{$_} = $s; $s += $ylen[$_ % 4] };

$edir = '/dsops/GOT/aux/DEPH.dir';
$wdir = '/data/mta4/proj/rac/ops/ephem/longterm';
###$wdir = '/data/mta4/proj/rac/ops/ephem/Test';
#
#--- make hash of already processed files
#
@mefiles = <$wdir/DE/deph.???????>;
foreach (@mefiles) { $done{$_} = 1 };
#
#--- make list of available ephemeris files
#
@efiles  = <$edir/DE?????.EPH>;
@efiles1 = grep { m!$edir/DE9[0-9]{4}.EPH! } @efiles;
@efiles2 = grep { m!$edir/DE[0-8][0-9]{4}.EPH! } @efiles;
@efiles  = (@efiles1,@efiles2);

foreach (@efiles) { push @ef,$_ unless ((-s $_) < 5000) };
#
#--- process each ephemeris file, extracting only 
#--- times not covered by a future ephemeris file.
#
foreach $i (0..$#ef) {
    $date    = substr $ef[$i],-9,5;
    $y       = ($date < 90000)? 2000000 : 1900000;
    $bigdate = $y + $date;
    $of      = "$wdir/DE/deph.$bigdate";

    next if $done{$of};                     #--- don't re-process files

    last unless $ef[$i+1];                  #--- cannot extract data from the latest file

    $date    = substr $ef[$i+1],-9,5;
    $y       = ($date < 90000)? 2000000 : 1900000;
    $bigdate = $y + $date;
    $nof     = "$wdir/DE/deph.$bigdate";

    next if $done{$nof};                    #--- don't process files that have been bypassed
#    
#--- get the start time of the next ephemeris file
#
    open (EF, $ef[$i+1]) or die "Cannot open next input ephemeris file $ef[$i+1]\n";

    system("cp $ef[$i+1] ./pedat");
    system("idl ephem.idl");

    `cat ./pedat_out >> $wdir/dephem.dat`;    # this is dangerous! Could result in out-of-order data!
    system("mv pedat_out $of");
    system("rm pedat");
}
