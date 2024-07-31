/****************************************************************************************************************************************************
1 Check for duplicates and handle them                                                                                                              *
-- This procedure to remove duplicates from the companies, locations, and jobs tables.                                                              *
*****************************************************************************************************************************************************/

CREATE OR REPLACE PROCEDURE remove_duplicates(p_table_name IN VARCHAR2, p_table_columns IN VARCHAR2) AS
    v_sql       VARCHAR2(4000);
BEGIN
    -- Generate and execute the SQL to delete duplicates
    v_sql := 'DELETE FROM ' || p_table_name || 
             ' WHERE ROWID NOT IN (' ||
             'SELECT MIN(ROWID) FROM ' || p_table_name || 
             ' GROUP BY ' || p_table_columns || ')';
    
    EXECUTE IMMEDIATE v_sql;

    -- Commit the changes
    COMMIT;
END;
/

-- Call the procedure for each table with the appropriate columns
BEGIN
    -- For companies table
    remove_duplicates('company', 'company_name, headquarters, size, founded, type_of_ownership, industry, sector, revenue, competitors');
    -- For locations table
    remove_duplicates('location', 'location');
    -- For jobs table
    remove_duplicates('job', 'job_title, salary_estimate, job_description, rating, company_id, location_id');
END;
/


/****************************************************************************************************************************************************
2 I found '-1' and 'Unknown' values in some columns, we have to replace it with 'N/A' instead.                                                      *
-- This procedure ensures that all occurrences of '-1' and 'Unknown' in the companies, locations, and jobs table are replaced with 'N/A'.           *
-- This process will iterate through all columns of a specified table and update them based on the criteria.                                        *
*****************************************************************************************************************************************************/

CREATE OR REPLACE PROCEDURE clean_table(p_table_name IN VARCHAR2) AS
    v_sql       VARCHAR2(4000);
    v_column    VARCHAR2(100);
    v_cursor    SYS_REFCURSOR;
BEGIN
    -- Open a cursor to select columns from the specified table
    OPEN v_cursor FOR
    SELECT column_name
    FROM all_tab_columns
    WHERE table_name = UPPER(p_table_name)
      AND data_type IN ('CHAR', 'VARCHAR2', 'CLOB');

    -- Loop through each column
    LOOP
        FETCH v_cursor INTO v_column;
        EXIT WHEN v_cursor%NOTFOUND;

        -- Generate and execute the SQL to update the column
        v_sql := 'UPDATE ' || p_table_name || ' SET ' || v_column || ' = ''N/A'' ' ||
                 'WHERE ' || v_column || ' IS NULL OR ' || v_column || ' = ''-1'' OR ' || v_column || ' = ''Unknown''';
        
        EXECUTE IMMEDIATE v_sql;
    END LOOP;

    CLOSE v_cursor;

    -- Commit the changes
    COMMIT;
END;
/

-- Call the procedure for the desired table
BEGIN
    clean_table('company');
    clean_table('location'); 
    clean_table('job');
END;
/


/****************************************************************************************************************************************************
3 In our dataset, the salary estimate are formatted as range. We want organize these values and be able to derive insights from it easily.          *
-- In this process, I will be extracting the minimum and maximum salary estimation to another column and calculate the average salary.              *
*****************************************************************************************************************************************************/

-- Add columns for min, max, and average salary
ALTER TABLE jobs
ADD (min_salary NUMBER,
     max_salary NUMBER,
     avg_salary NUMBER);

-- Extract and update minimum and maximum salary estimates
UPDATE jobs
SET min_salary = TO_NUMBER(REGEXP_SUBSTR(salary_estimate, '\$([0-9]+)K', 1, 1, NULL, 1)) * 1000,
    max_salary = TO_NUMBER(REGEXP_SUBSTR(salary_estimate, '-([0-9]+)K', 1, 1, NULL, 1)) * 1000;

-- Calculate average salary
UPDATE jobs
SET avg_salary = (min_salary + max_salary) / 2;

COMMIT;
