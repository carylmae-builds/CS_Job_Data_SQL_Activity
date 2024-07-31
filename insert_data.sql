-- Insert unique companies
INSERT INTO companies (company_name, headquarters, size, founded, type_of_ownership, industry, sector, revenue, competitors)
SELECT DISTINCT company_name, headquarters, size, founded, type_of_ownership, industry, sector, revenue, competitors
FROM ds_jobs;

-- Insert unique locations
INSERT INTO locations (location)
SELECT DISTINCT location
FROM ds_jobs;

-- Insert jobs with foreign keys
INSERT INTO jobs (job_title, salary_estimate, job_description, rating, company_id, location_id)
SELECT 
    job_title, 
    salary_estimate, 
    job_description, 
    rating,
    (SELECT company_id FROM companies WHERE companies.company_name = ds_jobs.company_name),
    (SELECT location_id FROM locations WHERE locations.location = ds_jobs.location)
FROM ds_jobs;
