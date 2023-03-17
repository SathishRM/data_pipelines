import logging
from datetime import datetime, timedelta

from airflow import DAG
from airflow.models import Variable
from airflow.operators.bash_operator import BashOperator

dag_group = 'ecom'
dag_name = 'H_EOM_MEMBERSHIP'
dag_args = {
    'ower': 'DE Team',
    'email': 'yyyy@xx.com',
    'email_on_failure': True,
    'email_on_retry': True,
    'start_date': datetime(2023, 3, 19, 16, 0),
    'retries': 3,
    'retry_delay': timedelta(minutes=2),
    'depends_on_past': True,
    'wait_for_downstream': True,
}

#set the logger to Airflow task
logger = logging.getLogger('airflow.task')

#get the variables from airflow
SCRIPT_BASE_DIR = Variable.get('SCRIPT_BASE_DIR')
TEMP_BASE_DIR = Variable.get('TEMP_BASE_DIR')
RAW_BASE_DIR = Variable.get('RAW_BASE_DIR')
SOURCE_DIR = Variable.get('ECOM_SOURCE_DIR') + '/membership'
SOURCE_FILE = Variable.get('ECOM_MEMBERSHIP_FILE')
OUTPUT_BASE_DIR = Variable.get('OUTPUT_BASE_DIR')
PYTHON_VENV = Variable.get('PYTHON_VENV')

SCRIPT_DIR = SCRIPT_BASE_DIR + f'/{dag_group}/{dag_name}/scripts/'
INPUT_DATE_FORMAT = '%Y-%m-%d'
OUTPUT_DATE_FORMAT = '%Y%m%d'
HASH_LENGTH = 5
SUCCESS_FILE = 'membership.csv'
NON_SUCCESS_FILE = 'non_membership.csv'


schedule_interval = '0 * * * *'
with DAG(dag_id=dag_name, schedule_interval=schedule_interval, default_args=dag_args, catchup=False) as dag:
    # capture the execution time in UTC
    execution_date = '''{{ execution_date.strftime('%Y %m %d %h') }}'''

    #Task-1 to download the source file from s3
    extract_source_file_cmd  =  SCRIPT_DIR + 'extract_source_file.sh' + execution_date + ' ' + \
        TEMP_BASE_DIR + ' ' + RAW_BASE_DIR + ' ' + SOURCE_DIR + ' ' + SOURCE_FILE
    task1 = BashOperator(task_id='extract_source_file_1', bash_command=extract_source_file_cmd)

    #Task-2 process the data and validate the membership
    process_membership_data_cmd = SCRIPT_DIR + 'process_membership.sh' + execution_date + ' ' + \
        INPUT_DATE_FORMAT + ' ' + OUTPUT_DATE_FORMAT + ' ' + HASH_LENGTH + ' ' + \
        SUCCESS_FILE + ' ' +  NON_SUCCESS_FILE + ' ' + SCRIPT_DIR + ' ' + \
        TEMP_BASE_DIR + ' ' + SOURCE_FILE + ' ' + PYTHON_VENV
    task2 = BashOperator(task_id='process_membership_2', bash_command=extract_source_file_cmd)

    #Task-3 uploads the processed files to s3
    upload_process_file_cmd  =  SCRIPT_DIR + 'upload_process_file.sh' + execution_date + ' ' + \
                                TEMP_BASE_DIR + ' ' + OUTPUT_BASE_DIR + ' ' + SUCCESS_FILE + ' ' + NON_SUCCESS_FILE
    task3 = BashOperator(task_id='upload_process_file_3', bash_command=extract_source_file_cmd)

    task1 >> task2 >> task3






