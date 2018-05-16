#! /usr/bin/perl -w

# maintain a longterm archive of ephemeris data

# Robert Cameron
# March 2002

# This program should only extract records from the start
# of each DE files (i.e. real definitive ephemeris data).
# Consequently, the latest DE file is not processed.

# create a 100-year hash of seconds offsets from 1970

@ylen = (31622400,31536000,31536000,31536000);
$s = 0;
foreach (1970..2070) { $soy{$_} = $s; $s += $ylen[$_ % 4] };

$edir = '/dsops/GOT/aux/DEPH.dir';
$wdir = '/data/mta4/proj/rac/ops/ephem/longterm';

# make hash of already processed files

@mefiles = <$wdir/DE/deph.???????>;
foreach (@mefiles) { $done{$_} = 1 };

# make list of available ephemeris files

@efiles = <$edir/DE?????.EPH>;
@efiles1 = grep { m!$edir/DE9[0-9]{4}.EPH! } @efiles;
@efiles2 = grep { m!$edir/DE[0-8][0-9]{4}.EPH! } @efiles;
@efiles = (@efiles1,@efiles2);
foreach (@efiles) { push @ef,$_ unless ((-s $_) < 5000) };

# process each ephemeris file, extracting only 
# times not covered by a future ephemeris file.

foreach $i (0..$#ef) {
    $date = substr $ef[$i],-9,5;
    $y = ($date < 90000)? 2000000 : 1900000;
    $bigdate = $y + $date;
    $of = "$wdir/DE/deph.$bigdate";
    next if $done{$of};           # don't re-process files
    last unless $ef[$i+1];    # cannot extract data from the latest file
    $date = substr $ef[$i+1],-9,5;
    $y = ($date < 90000)? 2000000 : 1900000;
    $bigdate = $y + $date;
    $nof = "$wdir/DE/deph.$bigdate";
    next if $done{$nof};          # don't process files that have been bypassed
    
# get the start time of the next ephemeris file

    open (EF, $ef[$i+1]) or die "Cannot open next input ephemeris file $ef[$i+1]\n";
    read EF, $buf, 2800;
    read EF, $buf, 2800;
    read EF, $buf, 2800;
    close EF;
    next unless $buf;
    ($ephem_date,$dum,$ephem_days_in_year,$dum,$ephem_sec_in_day) = unpack "dl4", $buf;
    $year = int($ephem_date/1e4);
    $byear = ($year < 90)? 2000 : 1900;
    $year += $byear;
    $sec70 = $soy{$year} + ($ephem_days_in_year-1)*86400 + $ephem_sec_in_day;
    $ltime = $sec70 - $soy{1998};

# extract data from the current file up to the start time of the next file

    open (EF, $ef[$i]) or die "Cannot open input ephemeris file $ef[$i]\n";
    print "Processing $ef[$i] until time $ltime\n";
    open (OF, ">$of") or die "Cannot open output ephemeris file $of\n";
    read EF, $buf, 2800;
    read EF, $buf, 2800;
    $bad_data = 0;
    $ssec = 0;
    while ( read EF, $buf, 2800 ) {
	($ephem_date,$dum,$ephem_days_in_year,$dum,$ephem_sec_in_day,
	 $ephem_step_time,@ephem_pos_vel_data_1_50) = unpack "dl4dd300", $buf;
	$year = int($ephem_date/1e4);
	$byear = ($year < 90)? 2000 : 1900;
	$year += $byear;
	$sec70 = $soy{$year} + ($ephem_days_in_year-1)*86400 + $ephem_sec_in_day;
	$sec98 = $sec70 - $soy{1998};
	$ssec = $sec98;
	last if ($sec98 >= $ltime); 
        @vec  = map { $_ * 1e7 } @ephem_pos_vel_data_1_50;
	for $i (0..49) {
	    $ssec = $sec98 + $i*$ephem_step_time;
	    last if ($ssec >= $ltime); 
	    if ($vec[$i*6] > 1e15 || $bad_data) { 
		print "End of $ef[$i] at time $ssec\n";
		$bad_data = 1; 
		last;
	    }
	    ($sec,$min,$hour,$mday,$mon,$year,$dum,$yday,$dum) = gmtime($sec70 + $i*$ephem_step_time);
	    $year += 1900;
	    $mon++;
	    $fyear = $year + ($yday*86400 + $hour*3600 + $min*60 + $sec)/$ylen[$year % 4]; 
	    printf OF "%12.1f%15.3f%15.3f%15.3f%14.3f%14.3f%14.3f%12.6f %02d %02d %02d %02d %02d\n",
	    $ssec,@vec[$i*6..$i*6+5],$fyear,$mon,$mday,$hour,$min,$sec;
	}
    }
    print "End of $ef[$i] at time $ssec\n" if ($ssec < $ltime);
    close OF;
    `cat $of >> $wdir/dephem.dat`;    # this is dangerous! Could result in out-of-order data!
}
