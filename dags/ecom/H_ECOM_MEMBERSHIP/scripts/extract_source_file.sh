#!/usr/bin/env bash

if [[ $# -ne 7 ]]
then
  echo "Please pass the required parameters"
  exit 1
fi

year=$1
month=$2
day=$3
hour=$4
temp_base_dir=$5
raw_base_dir=$6
source_dir=$7
file=$8

retry=5

# Clean the working directory
temp_dir="$temp_base_dir/ecom/H_ECOM_MEMBERSHIP/$year/$month/$day/$hour"
rm -rf $temp_dir
mkdir $temp_dir

# Path to copy the source file into the DataLake
raw_dir="$raw_base_dir/ecom/H_ECOM_MEMBERSHIP/$year/$month/$day/$hour/"

#Check if the file is available
source_file="$source_dir/$file"
cur=1
while [ $cur -le $retry]
do
  if [ $(aws s3 ls $source_file/ | grep -c $file) -ge 1 ]
  then
    echo "File $source_file is available for processing"
    break
  fi
  echo "File $source_file is not yet available"
  sleep 60
  ((cur++))
done

if [ $cur -gt $retry ]
then
  echo "Source file does not exist for processing, have waited for 5 minutes"
  exit 1
fi

echo "copy the source file to path $raw_dir"
aws s3 sync $source_dir $raw_dir --delete



