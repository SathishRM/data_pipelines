# data_pipelines
Contains source code for data ingestion from different source systems

### ECOM MEMBERSHIP INGESTION 

This ingestion uses airflow as scheduler
The dag H_ECOM_MEMBERSHIP ingests data form the system ecom to Data Lake.
It contains 3 tasks
- Extract data from the ECOM S3 location to local file system
- Process the data in streaming approach to avoid memory issue while processing huge files
  - Validate the fields in the source json file
  - Generates the hash code for the new field membership_id
  - Successful applications are captured in the CSV files `membership.csv` and the failed applications are captured in a separated file `non_membership.csv` 
- Uploads the processed data into DataLake S3 path

#####List of variables to be declared in the airflow
1. SCRIPT_BASE_DIR - Script home path in the airflow nodes `/apps/data-ingestio/scripts/`
2. TEMP_BASE_DIR - Working directory home path in the airflow nodes `/data/data-ingestion/`
3. RAW_BASE_DIR - S3 home path of the Data Lake raw layer `s3://data-ingestion/raw/`
4. ECOM_SOURCE_DIR - S3 path of the ecom `s3://ecom-data/membership/`
5. ECOM_MEMBERSHIP_FILE - Source file name `new_membership_application.json`
6. OUTPUT_BASE_DIR - S3 home path of the Data Lake enriched layer `s3://data-ingestion/enriched`
7. PYTHON_VENV - Python virtual env base path in the airflow nodes `/apps/data-ingestion/airflow/venv`

#####Source JSON file format 
`{"name" : "last_name first_name", "dob": "customer_dob_in_YYYY-mm-dd", "mobile": "customer_mobile_no",  "email" : "customer_email_address"}`

#####Processed file formats
1. successful application `membership.csv` -> 
    `generated_membership_id, first_name, last_name, dob in YYYYmmdd, customoer_mobile_no, customer_email `
2. failed application `non_membership.csv` -> `name, dob in YYYY-mm-dd, customer_mobile_no, customer_email`
3. processed file location -> `s3://data-ingestion/enriched/ecom/H_ECOM_MEMBERSHIP/process_membership/<year>/<month>/<day>/<hour>/`