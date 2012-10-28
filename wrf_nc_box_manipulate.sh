#!/bin/bash
#
# Copyright (C) Yagnesh Raghava Yakkala. http://yagnesh.org
#    File: wrf_nc_box_manipulate.sh
# Created: 土曜日, 10月 27 2012
# License: GPL v3 or later.  <http://www.gnu.org/licenses/gpl.html>
#

# user options
SCRIPTS_DIR=$(cd `dirname $BASH_SOURCE`; pwd)
read_wrf_nc="$SCRIPTS_DIR/read_wrf_nc.o"
no_of_doms=3

if [ "${1}" == "hok" ]; then
    declare -a box=("106 149 93 130" "118 246 70 175" "103 396 1 215")     # hok
elif [ "${1}" == "sak" ]; then
    declare -a box=("121 143 130 207" "161 218 175 348" "157 354 215 492")     # sak
else
    echo "box name unknown"
    exit
fi

#
function run_rwn()
{
    echo ${read_wrf_nc} $@
    ${read_wrf_nc} $@ >> $log_file
}


function rem_topo()
{
    declare -a variables=("HGT_U" "HGT_V" "HGT_M" "SLPY" "SLPX"
        "OA1" "OA2" "OA3" "OA4" "OL1" "OL2" "OL3" "OL4" "VAR" "CON")
    i=0
    while [[ i -lt $no_of_doms ]]; do
        for var in ${variables[@]}; do
            run_rwn -box ${box[i]} -EditData $var ${geofiles[i]}
        done
        let i=i+1
    done
}

function land2sea()
{
    rem_topo
    declare -a variables=("LANDMASK"  "GREENFRAC" "ALBEDO12M" "LANDUSEF"
        "SOILCTOP" "SOILCBOT" "SOILTEMP" "SLOPECAT" "SNOALB" "LU_INDEX"
        "SCT_DOM" "SCB_DOM"
        "IVGTYP" "ISLTYP" "VEGFRA" "ALBBCK" "SHDMAX" "SHDMIN"  "SNOWC" "SNOW")
    i=0
    while [[ i -lt $no_of_doms ]]; do
        for var in ${variables[@]}; do
            run_rwn -box ${box[i]} -EditData $var ${geofiles[i]}
        done
        let i=i+1
    done
}


# code
log_file=log.rwn
echo "run: $(date)" > $log_file

i=0
while [[ i -lt $no_of_doms ]]; do
    let dummy=i+1
    geofiles[i]="geo_em.d0${dummy}.nc"
    let i=i+1
done

i=0
while [[ i -lt $no_of_doms ]]; do
    let dummy=i+1
    wrfinputfiles[i]="wrfinput_d0${dummy}"
    let i=i+1
done

land2sea

# wrf_nc_box_manipulate.sh ends here
