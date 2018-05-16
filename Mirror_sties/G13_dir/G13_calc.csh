#! /usr/bin/env /bin/csh
#---------------------------------------------------------------------------------
#
#   13_calc.csh: copy data and plots from NOAA site and update G13.html page
#   
#       01/14/02 BDS -SEC data problems, changed to www.sec.noaa.gov
#
#       modified by t. isobe (tisobe@cfa.harvard.edu)
#       last update: Nov 04, 2015
#
#---------------------------------------------------------------------------------
#
#--- set a few local directory paths
#
set G13_dir = /data/mta/space_weather/G13_dir
set WEBdir  = /data/mta/www/MIRROR
set P_dir   = $WEBdir/G13_plots
#
#--- data/plot site names
#
set file    = ftp://ftp.sec.noaa.gov/pub/lists/particle/Gp_part_5m.txt
set pfile1  = http://services.swpc.noaa.gov/images/satellite-env.gif
set pfile2  = http://services.swpc.noaa.gov/images/goes-proton-flux.gif
set pfile3  = http://services.swpc.noaa.gov/images/goes-xray-flux.gif
#
#--- download data file
#
wget $file -o/dev/null -O$G13_dir/G13returned1

tail -24 $G13_dir/G13returned1 | head -24 >! $G13_dir/G13returned
#
#--- run nawkscript to calculate averages and mins
#
gawk -F" " -f $G13_dir/G13_process.nawk $G13_dir/G13returned >! $G13_dir/G13data
#
#--- go collect the images
#
wget $pfile1 -o/dev/null -O$P_dir/satenvBL.gif
wget $pfile2 -o/dev/null -O$P_dir/goes_pro_3d.gif
wget $pfile3 -o/dev/null -O$P_dir/goes_Xray.gif
#
#--- update web page
#
cat $G13_dir/G13header $G13_dir/G13data  $G13_dir/G13image $G13_dir/G13image2  $G13_dir/G13footer >! $WEBdir/G13.html

endif


