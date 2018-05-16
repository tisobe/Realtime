#! /usr/bin/perl -w

# ACE Kp monitoring system for Chandra.

# Robert Cameron
# May 2000
# RAC, April 2004: minor cleanup

#$Kp_file = 'ftp://ftp.sec.noaa.gov/pub/lists/costello/ace_pkp_15m.txt';
$Kp_file = 'ftp://ftp.swpc.noaa.gov/pub/lists/wingkp/wingkp_list.txt';
$Kp_dat = '/data/mta4/proj/rac/ops/ACE/kp.dat';

# fetch the current Kp data

@c = `/usr/bin/lynx -source $Kp_file`;
die scalar(gmtime)." No Kp data found in $Kp_file\n" if (!@c or @c < 500);
@ch = grep { /^#/ } @c;
@cn = grep { /^\d/ } @c;
die scalar(gmtime)." No valid Kp data found in $Kp_file\n" if (!@ch or !@cn or @ch < 10 or @cn < 10);

# find the latest good record

foreach (reverse @cn) {
    @f = split;
    last if ($f[-3] >= 0 or $f[-1] >= 0);   
}
    $f[-3] = $f[-1] if ($f[-3] < 0);            
$r = join '  ',@f;

# write the latest Kp record to a file

foreach (@ch) { $txt .= $_ };
$txt .= $r;

open (KF, ">$Kp_dat") or die scalar(gmtime)." Cannot write to $Kp_dat\n";
print KF $txt;
