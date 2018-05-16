#! /usr/bin/perl -w
#
#--- set directory paths
#
$rac  = '/data/mta4/proj/rac/ops/';
$wd   = '/data/mta4/proj/rac/ops/ephem/';
$edir = '/dsops/GOT/aux/DEPH.dir/';

#
# find the latest (non-trivial) ephemeris file
#
$MIN_FILE_SIZE = 100000;	                #----- Based on looking at existing ephem files


@efiles = <$edir/DE?????.EPH>;
@efiles = grep { m!$edir/DE[0-9]{5}.EPH! } @efiles;

@date = map { substr $_,-9,5 } @efiles;
$dm = 0;
foreach (@date) {
    if ( $_ > $dm
	 and $_ < 90000
	 and (stat "$edir/DE$_.EPH")[7] > $MIN_FILE_SIZE) {
	$dm = $_;
    }
}
#
# process the latest ephemeris file
#
$efile = "$edir/DE$dm.EPH";
print "\nLatest ephemeris file: $efile\n";

`cp $efile $wd/PE.EPH`;

$output = `/usr/local/bin/idl $wd/ephem.idl`;

print "IDL output: $output\n";
#
#--- if the file exists, rename is so that cocochan can read it
#
`mv $wd/PE.EPH.dat0 $wd/PE.EPH.dat` if -s "$wd/PE.EPH.dat0";
#
#--- output of cocchan are PE.EPH.gsme and PE.EPH.gsme_in_R
#
system("$wd/geopack/cocochan");

remove_na();
#system('/data/mta4/proj/rac/ops/ephem/remove_na.perl');

system("$rac/CRM/runcrm");
system("$rac/CRM2/runcrm");
system("$rac/CRM3/runcrm");

# must change directories to find *.BIN files for CRM3
#system("cd $rac/CRM3 ; $rac/CRM3/runcrm ; cd $wd");

system("$wd/solun_eph");
#
#---some idl funtion called by gsme_plots do not exist anymore.
#
#system("/usr/local/bin/idl $wd/gsme_plots.idl");


##################################################################
##################################################################
##################################################################

sub remove_na{
    open(FH, '/data/mta4/proj/rac/ops/ephem/PE.EPH.gsme');
    open(OUT, '> /data/mta4/proj/rac/ops/ephem/temp');
    while(<FH>){
        if($_ =~ /na/){
            next;
        }
        print OUT "$_";
    }
    close(OUT);
    close(FH);
    system("mv -f /data/mta4/proj/rac/ops/ephem/temp /data/mta4/proj/rac/ops/ephem/PE.EPH.gsme");
    
    
    open(FH, '/data/mta4/proj/rac/ops/ephem/PE.EPH.gsme_in_Re');
    open(OUT, '> /data/mta4/proj/rac/ops/ephem/temp');
    while(<FH>){
        if($_ =~ /na/){
            next;
        }
        print OUT "$_";
    }
    close(OUT);
    close(FH);
    system("mv -f /data/mta4/proj/rac/ops/ephem/temp /data/mta4/proj/rac/ops/ephem/PE.EPH.gsme_in_Re");
}

