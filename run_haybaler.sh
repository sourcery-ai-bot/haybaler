#!/bin/bash
# Sophia Poertner
# Run haybaler https://github.com/MHH-RCUG/haybaler/

echo "Starting Haybaler"

# set directory to get the haybaler heatmaps scripts from
# use default directory if no argument ($1) given

# set debug to 1, (default 0) to print diagnostic messages
debug=0

# Users: change this to your haybaler path
haybaler_directory="/mnt/ngsnfs/tools/dev/haybaler/" 


# Users: don't modify this section
if [ -z "$1" ]
then
  haybaler_dir=$haybaler_directory
else
  haybaler_dir="$1"
fi

outputDir=haybaler_output
if [ ! -d $outputDir ]
then
    echo "INFO: Creating directory:" $outputDir
    mkdir $outputDir
fi

cp $haybaler_dir/prepare_for_R_heatmap.sh $outputDir
cp $haybaler_dir/runbatch_create_heatmap.sh $outputDir
cp $haybaler_dir/create_heatmap.R $outputDir


# Only run for *bam*.csv if files exist in current dir
count=`ls -1 *mq30.bam*us*.csv 2>/dev/null | wc -l`
if [ $count != 0 ]
    then
    if [ $debug != 0 ]
	  then
	  echo "Found $count mq30.bam*us csv files to process"
    fi
    for csv in $(ls *.bam*.csv)
    do
      python3 haybaler.py -i "$csv" -p . -op $outputDir  -o haybaler.csv
    done
fi


# Only run for *bam*.txt if files exist in current dir
count=`ls -1 *mq30.bam*.txt 2>/dev/null | wc -l`
if [ $count != 0 ]
    then
    if [ $debug != 0 ]
          then
          echo "Found $count mq30.bam*us txt files to process"
    fi
    for csv in $(ls *.bam*.txt)
    do
      python3 haybaler.py -i "$csv" -p . -op $outputDir  -o haybaler.csv
    done
fi

