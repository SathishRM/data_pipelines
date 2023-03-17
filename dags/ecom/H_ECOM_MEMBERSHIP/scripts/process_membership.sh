#!/usr/bin/env bash

#Validate the no of parameters passed
if [[ $# -ne 13 ]]
then
  echo "Please pass the required parameters."
  echo "Usage $(basename $0) <year> <month> <day> <hour> <input_date_format> <output_date_format> <hash_length> <success_file> <non_success_file> <script_path> <temp_base_dir> <source_file_name> <python_venv>"
  exit 1
fi

#get the parameters value
year=$1
month=$2
day=$3
hour=$4
input_date_format=$5
output_date_format=$6
hash_length=$7
success_file=$8
non_success_file=$9
script_path=${10}
temp_base_dir=${11}
source_file_name=${12}
python_venv=${13}

source_file=$temp_base_dir/extract_source_file/$year/$month/$day/$hour/$source_file_name
output_dir=$temp_base_dir/process_membership/$year/$month/$day/$hour

# ignore the unset variables
set +u
source $python_venv/bin/activate
set -u

echo "call the python code for precssing the data"
python3 $script_path/process_membership.py \
          $input_date_format $output_date_format $hash_length $output_dir \
          $success_file $non_success_file $source_file \

