#! /usr/bin/env /bin/csh
#--------------------------------------------------------------------------------------------
#
#   G15_calc.csh: get data file and plots from NOAA site and update G15.html
#
#       01/14/02 BDS -SEC data problems, changed to www.sec.noaa.gov
#
#       modified by t. isobe (tisobe@cfa.harvard.edu)
#       last udpate: Nov 04, 2015
#
#-------------------------------------------------------------------------------------------
#
#--- set a few local directory paths
#
set G15_dir = /data/mta/space_weather/G15_dir/
set WEBdir  = /data/mta/www/MIRROR
set P_dir   = $WEBdir/G15_plots
#
#--- data/plot site names
#
set file    = ftp://ftp.sec.noaa.gov/pub/lists/particle/Gs_part_5m.txt
set pfile1  = http://services.swpc.noaa.gov/images/satellite-env.gif
set pfile2  = http://services.swpc.noaa.gov/images/goes-proton-flux.gif
set pfile3  = http://services.swpc.noaa.gov/images/goes-xray-flux.gif
#
#--- download data file
#
wget $file -o/dev/null -O$G15_dir/G15returned1

tail -24 $G15_dir/G15returned1 | head -24 >! $G15_dir/G15returned
#
#--- run nawkscript to calculate averages and mins
#
gawk -F" " -f $G15_dir/G15_process.nawk $G15_dir/G15returned >! $G15_dir/G15data
#
#---go collect the image 
#
wget $pfile1 -o/dev/null -O$P_dir/satenvBL.gif
wget $pfile2 -o/dev/null -O$P_dir/goes_pro_3d.gif
wget $pfile3 -o/dev/null -O$P_dir/goes_Xray.gif
#
#--- update web page
#
cat $G15_dir/G15header $G15_dir/G15data  $G15_dir/G15image $G15_dir/G15image2  $G15_dir/G15footer >! $WEBdir/G15.html

endif


