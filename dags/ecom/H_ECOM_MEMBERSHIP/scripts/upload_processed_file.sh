#!/usr/bin/env bash

if [[ $# -ne 7 ]]
then
  echo "Please pass the required parameters."
  echo "Usage $(basename $0) <year> <month> <day> <hour> <temp_base_dir> <output_base_dir> <processed_base_dir>"
  exit 1
fi

year=$1
month=$2
day=$3
hour=$4
temp_base_dir=$5
output_base_dir=$6
processed_base_dir=$7

# current hour directories are framed from base dirs
temp_dir="$temp_base_dir/ecom/H_ECOM_MEMBERSHIP/$year/$month/$day/$hour"
output_dir="$output_base_dir/ecom/H_ECOM_MEMBERSHIP/$year/$month/$day/$hour"
processed_dir="$processed_base_dir/$year/$month/$day/$hour/"

#output files
mem_file="$output_dir/success_membership.csv"
non_mem_file="$output_dir/unsuccess_membership.csv"


if [ -f $mem_file -o -f $non_mem_file ]
then
  echo "Member or Non-member file exists for the hour, will be uploaded into $processed_dir"
  aws s3 sync $output_dir $processed_dir --delete
else
  echo "No data for this hour"
fi

echo "Removing the data files and directories from local file system"
rm -rf $temp_dir
rm -rf $output_dir


