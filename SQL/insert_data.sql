--Typically I would use a tool like SQL*Loader or an ETL process to load data from a CSV file into the Oracle table. Here, we'll be using external table to access data in a flat file directly as if it were a database table.
CREATE OR REPLACE DIRECTORY data_dir AS 'Dataset/Uncleaned_DS_jobs.csv';

CREATE TABLE external_ds_jobs (
    index_column NUMBER,
    job_title VARCHAR2(100),
    salary_estimate VARCHAR2(100),
    job_description CLOB,
    rating NUMBER(2,1),
    company_name VARCHAR2(100),
    location VARCHAR2(100),
    headquarters VARCHAR2(100),
    size VARCHAR2(100),
    founded NUMBER,
    type_of_ownership VARCHAR2(100),
    industry VARCHAR2(100),
    sector VARCHAR2(100),
    revenue VARCHAR2(100),
    competitors VARCHAR2(4000)
)
ORGANIZATION EXTERNAL (
    TYPE ORACLE_LOADER
    DEFAULT DIRECTORY data_dir
    ACCESS PARAMETERS (
        RECORDS DELIMITED BY NEWLINE
        FIELDS TERMINATED BY ','
        OPTIONALLY ENCLOSED BY '"'
        MISSING FIELD VALUES ARE NULL
    )
    LOCATION ('Uncleaned_DS_jobs.csv')
);


-- Insert unique companies data from companies table
INSERT INTO company (company_name, headquarters, size, founded, type_of_ownership, industry, sector, revenue, competitors)
SELECT DISTINCT 
    company_name, 
    headquarters, 
    size, 
    founded, 
    type_of_ownership, 
    industry, 
    sector, 
    revenue, 
    competitors
FROM external_ds_jobs
WHERE company_name IS NOT NULL;


-- Insert unique locations data from locations table
INSERT INTO location (location)
SELECT DISTINCT location
FROM external_ds_jobs
WHERE location IS NOT NULL;



-- Insert jobs with foreign keys
INSERT INTO job (job_title, salary_estimate, job_description, rating, company_id, location_id)
SELECT 
    job_title, 
    salary_estimate, 
    job_description, 
    rating,
    (SELECT company_id FROM companies WHERE companies.company_name = external_ds_jobs.company_name),
    (SELECT location_id FROM locations WHERE locations.location = external_ds_jobs.location)
FROM external_ds_jobs;

COMMIT;
