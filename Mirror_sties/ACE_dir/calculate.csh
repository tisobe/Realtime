#! /usr/bin/env /bin/csh

#------------------------------------------------------------------------------------------
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
# 01/14/02 BDS -SEC data problems, changed to www.sec.noaa.gov
# 11/06/03 BDS - change www.sec.noaa.gov to www.sec.noaa.gov (web farm)
# 11/14/03 BDS - make our own plot, with scaled P3 values
#                old sec plot instructions are commented out
#                with #sec_plot
#   modified by t. isobe (tisobe@cfa.harvard.edu)
#   last udate: Nov 05, 2015
#
#------------------------------------------------------------------------------------------
#
#--- set a few local directory paths
#
set ACE_dir = /data/mta/space_weather/ACE_dir/
set WEBdir     = /data/mta/www/MIRROR
set P_dir      = $WEBdir/ACE_plots
#
#--- data/plot site names
#
set file       = ftp://ftp.sec.noaa.gov/pub/lists/ace/ace_epam_5m.txt
set pfile1     = http://services.swpc.noaa.gov/images/ace-epam-7-day.gif
set pfile2     = http://services.swpc.noaa.gov/images/ace-mag-swepam-7-day.gif
set pfile3     = http://services.swpc.noaa.gov/images/wing-kp-24-hour.gif
#
#--- download data
#
/bin/rm $ACE_dir/returned
wget $file -o/dev/null -O $ACE_dir/returned

set count = `cat $ACE_dir/returned | wc -l`

if ($count > 28) then 
    /bin/rm $ACE_dir/last45
    /bin/rm $ACE_dir/lasthour
    tail -24 $ACE_dir/returned > $ACE_dir/lasthour
    head -24 $ACE_dir/lasthour > $ACE_dir/last45
#
#---run nawkscript to calculate averages and mins
#
gawk -F" " -f $ACE_dir/process_ace.nawk $ACE_dir/last45 > $ACE_dir/acedata
#
#--- go collect ACE image and invert. 
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
#--- go and collect Kp image 

wget $pfile3 -o/dev/null -O$P_dir/wingkp.gif
/usr/bin/convert -negate  $P_dir/wingkp.gif - >! $P_dir/wingkp_i.gif


cat $ACE_dir/header $ACE_dir/acedata  $ACE_dir/image2 $ACE_dir/rob1 $ACE_dir/footer >! $WEBdir/ace.html

cat $ACE_dir/header_i $ACE_dir/acedata  $ACE_dir/image_i  $ACE_dir/rob1 $ACE_dir/footer >! $WEBdir/ace_i.html

endif


