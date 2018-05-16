#! /bin/tcsh -f
#---------------------------------------------------------------------------------------------
#
#   G13_Ecalc.csh:  copy a data file and a plot from NOAA site and update G13E.html
#
#       01/14/02 BDS -SEC data problems, changed to www.sec.noaa.gov
#
#       modified by t. isobe (tisobe@cfa.harvard.edu)
#       last update: Nov 04, 2015
#
#---------------------------------------------------------------------------------------------
#
#--- set a few local directory paths
#
set G13E_dir = /data/mta/space_weather/G13E_dir
set WEBdir   = /data/mta_www/MIRROR
set P_dir    = $WEBdir/G13E_plots
#
#--- data/plot site names
#
set file     = http://services.swpc.noaa.gov/text/goes-particle-flux-primary.txt
set pfile    = http://services.swpc.noaa.gov/images/goes-electron-flux.gif
#
#--- download data file
#
wget $file -o/dev/null -O$G13E_dir/G13Ereturned1

tail -24 $G13E_dir/G13Ereturned1 | head -24 >! $G13E_dir/G13Ereturned
#
#--- run nawkscript to calculate averages and mins
#
gawk -F" " -f $G13E_dir/G13_Eprocess.nawk $G13E_dir/G13Ereturned >! $G13E_dir/G13Edata
#
#--- collet the image 
#
wget $pfile -o/dev/null -O $P_dir/elec_3d.gif
#
#--- update web page
#
cat $G13E_dir/G13Eheader $G13E_dir/G13Edata  $G13E_dir/G13Eimage $G13E_dir/G13Efooter >! $WEBdir/G13E.html


endif


