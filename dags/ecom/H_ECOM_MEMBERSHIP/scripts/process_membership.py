import csv
import os
import shutil
import sys
from typing import Generator
from datetime import datetime
import json
from utils.validator import Validate
from utils.hash_generator import Hash


def clean_output_directory() -> None:
    """
    Checks the output directory and clean it in exists already
    :param file: output location
    :return: None
    """
    # delete the directory if exits
    if os.path.exists(output_dir):
        shutil.rmtree(output_dir)
    # creates the directory for the new processing
    os.mkdir(output_dir)


def load_json_file(file: str) -> Generator[dict, None, None]:
    """
    read the source json file and return the content in python dict
    :param file: source file location
    :return: generator list of dict (file content)
    """
    try:
        with open(file) as f:
            record = f.readline()
            while record:
                print(record)
                yield json.loads(record)
                record = f.readline()
    except Exception as error:
        print(f'Issue in reading the source file {error}')
        raise error
    else:
        print("Source file has been read successfully")


def process_data(data: dict) -> dict:
    """
    read the source json file and return the content in python dict
    :param file: source file location
    :return: file content
    """
    try:
        # extract the fields from the json data
        name = data.get('name', '')
        dob = data.get('dob', '')
        mobile = data.get('mobile','')
        email = data.get('email','')

        # all the validation are success, write to memebership file
        if validate.validate_mobile(mobile) and validate.validate_email(email) and validate.check_age(dob) and name != '':
            print("All validation have been succeed, writing into membership file ")
            names = name.split(' ')
            first_name = ' '.join(names[1:]) if len(names) > 1 else ''
            last_name = names[0]
            dob_formatted = datetime.strptime(dob,CONST_DATE_FORMAT).strftime(DOB_OUTPUT_FORMAT)
            hash_code = hash_gen.generate_hash(dob_formatted)[:HASH_CODE_LENGTH]
            # file is opened in append mode due to stream processing instead of loading full file into memory
            with open(success_file, 'a' ) as member_file:
                member_writer = csv.writer(member_file, dialect='unix', lineterminator='\n')
                member_writer.writerow([last_name + hash_code, first_name, last_name, dob_formatted, mobile, email])
        # either 1 or more validation has failed, write to non-membership file
        else:
            # file is opened in append mode due to stream processing instead of loading full file into memory
            print("Either one or more validations are failed, writing into non-membership file ")
            with open(non_success_file, 'a') as nonmember_file:
                nonmember_writer = csv.writer(nonmember_file, dialect='unix', lineterminator='\n')
                nonmember_writer.writerow([name, dob, mobile, email])
    except Exception as error:
        print(f'Issue in validating and writing the files {error}')
        raise error
    else:
        print("Files are written successfully")

if __name__ == '__main__':
    # receive the parameters passed to the script
    CONST_DATE_FORMAT = sys.argv[1]
    DOB_OUTPUT_FORMAT = sys.argv[2]
    HASH_CODE_LENGTH = sys.argv[3]
    output_dir = sys.argv[4]
    success_file= output_dir + '\\' + sys.argv[5]
    non_success_file= output_dir + '\\' + sys.argv[6]
    source_file = sys.argv[7]

    # instantiate the required classes from the utils package
    validate = Validate()
    hash_gen = Hash()

    # clean the output files if exists already
    clean_output_directory()
    # read the source file and process the records
    for data in load_json_file(source_file):
        #process the source file
        process_data(data)
