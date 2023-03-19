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
  - Successful applications are captured in the file `membership.csv` and the failed applications are captured in a separated file `non_membership.csv` 
- Uploads the processed data into DataLake S3 path
