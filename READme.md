# DS_Jobs_SQL

## Overview
This repository contains SQL scripts for processing, cleaning, transforming, and analyzing a dataset of job market data. The tasks include creating relational database schemas, handling data cleaning operations such as checking for duplicates and handling null values, and performing complex queries involving filtering, aggregating, joining, and grouping data from multiple tables. The scripts are written for an Oracle PL/SQL environment.

Key features:

- Creation of relational tables for jobs, companies, and locations.
- Insertion of data into the respective tables with appropriate foreign key relationships.
- Data cleaning operations to ensure data quality and integrity.
- Advanced SQL queries to extract meaningful insights from the dataset.
- Comprehensive examples of using subqueries, window functions, and Common Table Expressions (CTEs).

## Dataset
The dataset used in this project is provided as `Uncleaned_DS_jobs.csv`. It includes web scrapped job posts from glassdoor for data science job listings with various attributes such as job title, company name, location, salary estimate, and more.

## Repository Contents
- **`create_table.sql`**: Script for creating relational tables (`jobs`, `companies`, `locations`).
- **`insert_data.sql`**: Script for inserting data into the tables with appropriate foreign key relationships.
- **`clean_data.sql`**: Script for cleaning data, including handling duplicates and null values.
- **`data_insight.sql`**: Examples of complex SQL queries involving filtering, aggregating, joining, and grouping data.
- **`Uncleaned_DS_jobs.csv`**: The dataset used for this project.

## Setup Instructions

### Clone the Repository
```bash
git clone https://github.com/yourusername/DS_Jobs_SQL.git
cd <repo dir>
```
