#!/bin/bash
#
# Copyright (C) Yagnesh Raghava Yakkala. http://yagnesh.org
#    File: remove_topo.sh
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
function rem_topo()
{
    declare -a variables=("HGT_U" "HGT_V" "HGT_M" "SLPY" "SLPX")
    i=0
    while [[ i -lt $no_of_doms ]]; do
        for var in ${variables[@]}; do
            echo ${read_wrf_nc} -box ${box[i]} -EditData $var ${geofiles[i]}
            ${read_wrf_nc} -box ${box[i]} -EditData $var ${geofiles[i]}
        done
        let i=i+1
    done
}


# code
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

rem_topo

# remove_topo.sh ends here
