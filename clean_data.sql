-- Check for duplicates and handle them
WITH JobDuplicates AS (
    SELECT
        job_title,
        company_name,
        location,
        COUNT(*) AS cnt
    FROM
        ds_jobs
    GROUP BY
        job_title,
        company_name,
        location
    HAVING
        COUNT(*) > 1
)
DELETE FROM ds_jobs
WHERE (job_title, company_name, location) IN (
    SELECT job_title, company_name, location
    FROM JobDuplicates
)
AND job_id NOT IN (
    SELECT MAX(job_id)
    FROM ds_jobs
    GROUP BY job_title, company_name, location
);

-- Handle null values
UPDATE ds_jobs
SET
    salary_estimate = NVL(salary_estimate, 'Not Disclosed'),
    rating = NVL(rating, 0),
    company_name = NVL(company_name, 'Unknown'),
    location = NVL(location, 'Unknown'),
    headquarters = NVL(headquarters, 'Unknown'),
    size = NVL(size, 'Unknown'),
    founded = NVL(founded, 0),
    type_of_ownership = NVL(type_of_ownership, 'Unknown'),
    industry = NVL(industry, 'Unknown'),
    sector = NVL(sector, 'Unknown'),
    revenue = NVL(revenue, 'Unknown'),
    competitors = NVL(competitors, 'None')
WHERE
    salary_estimate IS NULL
    OR rating IS NULL
    OR company_name IS NULL
    OR location IS NULL
    OR headquarters IS NULL
    OR size IS NULL
    OR founded IS NULL
    OR type_of_ownership IS NULL
    OR industry IS NULL
    OR sector IS NULL
    OR revenue IS NULL
    OR competitors IS NULL;
