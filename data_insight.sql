-- Calculate average rating per industry
WITH AvgIndustryRating AS (
    SELECT
        industry,
        AVG(rating) AS avg_rating
    FROM
        ds_jobs
    GROUP BY
        industry
)
SELECT
    j.job_title,
    j.company_name,
    j.location,
    j.salary_estimate,
    j.rating,
    j.industry,
    air.avg_rating
FROM
    ds_jobs j
    JOIN AvgIndustryRating air ON j.industry = air.industry
WHERE
    j.rating > air.avg_rating
ORDER BY
    j.rating DESC;
