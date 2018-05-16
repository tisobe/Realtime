#! /usr/bin/env /bin/csh
#-------------------------------------------------------------------------------------
#
#  THIS IS THE ACE WEB GENERATION AND ALERTS MAIL SOURCE
#  HERE WE GET THE ACE DATA,  FIND THE FIGURES FOR THE 
#  WEB PAGE AND FORMAT. 
# 
#  ADDED code to create reversed page 13 Aug 2002 - SJW
#  CHANGES: image (2/_i) changed KP from costello to SEC  20 Aug 2002 - SJW
#           changed back the next day.
#
#  CALLS:  process_ace.nawk WHICH CALCULATES MINS AND MAXS OVER TIME RANGE
#          change line 105 to change limit
#          CALLS: aceviolation_protons.csh which pages people  
#
# TO RESET THE ALERTS SYSTEM, REMOVE THE "prot_violate" files
# from /home/swolk , e.g.
#

# 01/14/02 BDS -SEC data problems, changed to www.sec.noaa.gov
#   old links marked with #sec
# 11/06/03 BDS - change www.sec.noaa.gov to www.sec.noaa.gov (web farm)
# 11/14/03 BDS - make our own plot, with scaled P3 values
#                old sec plot instructions are commented out
#                with #sec_plot
#   modified by t. isobe (tisobe@cfa.harvard.edu)
#   last udpate: Nov 05, 2015
#
#-------------------------------------------------------------------------------------


set ACE_dir  = /data/mta/space_weather/ACE_fast_dir/
set WEBdir   = /data/mta/www/MIRROR
set P_dir    = $WEBdir/ACE_fast_plots

set file     = ftp://mussel.srl.caltech.edu/pub/ace/browse/EPAM/EPAM_quicklook.txt
set pfile1   = http://services.swpc.noaa.gov/images/ace-epam-7-day.gif
set pfile2   = http://services.swpc.noaa.gov/images/ace-mag-swepam-7-day.gif
set pfile3   = http://services.swpc.noaa.gov/images/wing-kp-24-hour.gif

/bin/rm $ACE_dir/returned_fast
wget $file -o/dev/null -O$ACE_dir/returned_fast

set count = `cat $ACE_dir/returned_fast | wc -l`

if ($count > 28) then 
    /bin/rm  $ACE_dir/last45_fast
    /bin/rm  $ACE_dir/lasthour_fast
    tail -24 $ACE_dir/returned_fast > $ACE_dir/lasthour_fast
    head -24 $ACE_dir/lasthour_fast > $ACE_dir/last45_fast
    

gawk -F" " -f $ACE_dir/process_ace_fast.nawk $ACE_dir/last45_fast > $ACE_dir/acedata_fast
#
#---go collect ACE image and invert. 
#

wget $pfile1 -o/dev/null -O$P_dir/Epam_7d.gif
wget $pfile1 -o/dev/null -O$P_dir/mta_ace_plot.gif

/usr/bin/convert -negate $P_dir/mta_ace_plot.gif    $P_dir/Epam_7di.gif
#/usr/bin/convert -negate $P_dir/mta_ace_plot_P3.gif $P_dir/Epam_7di_P3.gif
#
#--- get wind speed etc. plot
#
wget $pfile2 -o/dev/null -O$P_dir/Mag_swe_7d.gif
/usr/bin/convert -negate $P_dir/Mag_swe_7d.gif $P_dir/Mag_swe_7di.gif
#
#---go and collect Kp image 
#
wget $pfile3 -o/dev/null -O$P_dir/wingkp.gif
/usr/bin/convert -negate  $P_dir/wingkp.gif - >! $P_dir/wingkp_i.gif

cat $ACE_dir/header_fast $ACE_dir/acedata_fast  $ACE_dir/image2 $ACE_dir/rob1 $ACE_dir/footer >! $WEBdir/ace_fast.html

endif


