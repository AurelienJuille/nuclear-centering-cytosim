#!/bin/bash

# Parameters:
# 1 -> number of runs per sim
# 2 -> path to "project folder" where your put your config template file and the simulations will run
# 3 -> path to Cytosim root folder

# This script runs n times each simulations of a template file 

byn/preconfig $2/config%04i/config.cym $2/config.cym.tpl > $2/log.txt
for (( i=1; i<=$1; i++ ))
do
	printf "SET "$(printf "%03d" $i)"/"$(printf "%03d" $1)" OF SIMULATIONS STARTED AT $(date)\n" >> $2/log.txt
	byn/scan.py - 'mkdir 'run${i} $2/config????	
	byn/scan.py - $3'/bin/sim ../config.cym' $2/config????/run${i} >> $2/log.txt 'njobs=16'
	byn/scan.py - $3'/bin/report sphere > temp' $2/config????/run${i}
	path=$(pwd)
	byn/scan.py - 'python3.8 '$path'/Python/report_to_csv.py > nucleus_pos.csv' $2/config????/run${i}
	byn/scan.py - 'rm temp' $2/config????/run${i}
done

printf "ALL SIMULATIONS ENDED AT $(date)" >> $2/log.txt