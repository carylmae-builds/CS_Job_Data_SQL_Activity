/*****************************************************************************************************************************************************
1  Calculate the average rating per industry using the rating column in the jobs table and the industry column in the companies table.              *
*****************************************************************************************************************************************************/
SELECT
    c.industry,
    AVG(j.rating) AS average_rating
FROM jobs j
JOIN companies c ON j.company_id = c.company_id
GROUP BY c.industry
ORDER BY c.industry;

/*****************************************************************************************************************************************************
2 Create a new column based on the values from column founded that will calculate the company age based on the year its founded to the year today.  *
-- This approach will give you a company_age column that reflects how long each company has been in business based on its founding year.             *
*****************************************************************************************************************************************************/

-- Add the new column for company age
ALTER TABLE companies
ADD (company_age NUMBER);

-- Calculate and update company age based on the founded year
UPDATE companies
SET company_age = EXTRACT(YEAR FROM SYSDATE) - founded;


COMMIT;

/****************************************************************************************************************************************************
3 Create a view that simply indicates whether the Location and Headquarters are the same using the data from companies table and locations table.   *
-- This view provides a straightforward way to compare locations and headquarters and determine if they are in the same state.                       *
-- If there is a same informations in these two columns it means they will work in headquarter of company, otherwise not.                            *
*****************************************************************************************************************************************************/
CREATE OR REPLACE VIEW company_location_comparison AS
SELECT
    c.company_id,
    c.company_name,
    c.headquarters,
    l.location,
    CASE
        WHEN c.headquarters = l.location THEN 'Y'
        ELSE 'N'
    END AS same_state
FROM companies c
LEFT JOIN locations l ON c.company_id = l.location_id;  

/****************************************************************************************************************************************************
-- This is a view to get the job listings in a given location.                                                                                      *
*****************************************************************************************************************************************************/
CREATE OR REPLACE VIEW job_listings_by_location AS
SELECT 
    l.location,
    j.job_id,
    j.job_title,
    j.salary_estimate,
    j.job_description,
    j.rating,
    c.company_name
FROM 
    jobs j
JOIN 
    locations l ON j.location_id = l.location_id
JOIN 
    companies c ON j.company_id = c.company_id;

-- Query the view for a specific location
SELECT *
FROM job_listings_by_location
WHERE location = 'New York';

/****************************************************************************************************************************************************
4 I want to extract common technology keywords of Data Science role from the Job Description column and create boolean columns for each technology.*
-- In the following procedure, it will update the new columns based on whether the keywords are present in the job descriptions.                    *
*****************************************************************************************************************************************************/

-- Alter the jobs table to add the new boolean columns:
ALTER TABLE jobs
ADD (
    requires_python NUMBER(1) DEFAULT 0,
    requires_excel NUMBER(1) DEFAULT 0,
    requires_hadoop NUMBER(1) DEFAULT 0,
    requires_spark NUMBER(1) DEFAULT 0,
    requires_aws NUMBER(1) DEFAULT 0,
    requires_tableau NUMBER(1) DEFAULT 0,
    requires_big_data NUMBER(1) DEFAULT 0
);

-- Create procedure to update these columns in the jobs table:
CREATE OR REPLACE PROCEDURE update_technology_flags AS
BEGIN

    UPDATE jobs
    SET requires_python = CASE
        WHEN LOWER(job_description) LIKE '%python%' THEN 1
        ELSE 0
    END;

    UPDATE jobs
    SET requires_excel = CASE
        WHEN LOWER(job_description) LIKE '%excel%' THEN 1
        ELSE 0
    END;

    UPDATE jobs
    SET requires_hadoop = CASE
        WHEN LOWER(job_description) LIKE '%hadoop%' THEN 1
        ELSE 0
    END;

    UPDATE jobs
    SET requires_spark = CASE
        WHEN LOWER(job_description) LIKE '%spark%' THEN 1
        ELSE 0
    END;

    UPDATE jobs
    SET requires_aws = CASE
        WHEN LOWER(job_description) LIKE '%aws%' THEN 1
        ELSE 0
    END;

    UPDATE jobs
    SET requires_tableau = CASE
        WHEN LOWER(job_description) LIKE '%tableau%' THEN 1
        ELSE 0
    END;

    UPDATE jobs
    SET requires_big_data = CASE
        WHEN LOWER(job_description) LIKE '%big data%' OR LOWER(job_description) LIKE '%bigdata%' THEN 1
        ELSE 0
    END;
END;
/

SELECT
    job_id,
    job_title,
    salary_estimate,
    job_description,
    rating,
    company_id,
    location_id,
    CASE WHEN requires_python = 1 THEN 'TRUE' ELSE 'FALSE' END AS requires_python,
    CASE WHEN requires_excel = 1 THEN 'TRUE' ELSE 'FALSE' END AS requires_excel,
    CASE WHEN requires_hadoop = 1 THEN 'TRUE' ELSE 'FALSE' END AS requires_hadoop,
    CASE WHEN requires_spark = 1 THEN 'TRUE' ELSE 'FALSE' END AS requires_spark,
    CASE WHEN requires_aws = 1 THEN 'TRUE' ELSE 'FALSE' END AS requires_aws,
    CASE WHEN requires_tableau = 1 THEN 'TRUE' ELSE 'FALSE' END AS requires_tableau,
    CASE WHEN requires_big_data = 1 THEN 'TRUE' ELSE 'FALSE' END AS requires_big_data
FROM jobs;

