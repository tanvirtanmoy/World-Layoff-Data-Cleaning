# World Layoff Data Cleaning

This repository contains a project focused on cleaning and preprocessing a dataset of company layoffs using SQL. The dataset includes various details about layoffs across different companies, industries, and locations.

## Table of Contents

- [Dataset](#dataset)
- [Project Scope](#project-scope)
- [Sample SQL Queries](#sample-sql-queries)
- [How to Use](#how-to-use)

## Dataset

The dataset (`layoffs.csv`) contains the following columns:
- `company`: Name of the company
- `location`: Location of the company
- `industry`: Industry of the company
- `total_laid_off`: Total number of employees laid off
- `percentage_laid_off`: Percentage of workforce laid off
- `date`: Date of the layoff
- `stage`: Stage of the company (e.g., Post-IPO, Series B)
- `country`: Country where the company is located
- `funds_raised_millions`: Total funds raised by the company in millions

## Project Scope

The main objective of this project is to clean and preprocess the dataset using SQL. The following steps outline the data cleaning process:

1. **Data Import**: Import the CSV file into a SQL database.
2. **Missing Value Treatment**: Handle missing values in the `percentage_laid_off` column.
3. **Data Type Conversion**: Ensure correct data types for each column (e.g., dates, numerical values).
4. **Outlier Detection and Treatment**: Identify and handle outliers in numerical columns.
5. **Consistency Checks**: Ensure consistency in categorical data (e.g., location names, industry types).
6. **Normalization and Standardization**: Normalize numerical columns if necessary for analysis.
7. **Final Export**: Export the cleaned data for further analysis or visualization.

## Sample SQL Queries

Here are some sample SQL queries used in the data cleaning process:

```sql
-- Create table
CREATE TABLE `layoffs_staging_delete_duplicates` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


-- Finding Duplicates 
with finding_duplicates as(
select *, row_number() over(partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
from layoffs_staging
)
select* 
from finding_duplicates
where row_num >1 ;

-- updating the table so that there are no null or empty values in the industry column 
  update layoffs_staging_delete_duplicates t1
   join layoffs_staging_delete_duplicates t2
  on t1.company= t2.company
  and t1.location= t2.location
  set t1.industry = t2.industry
  where (t1.industry is null or t1.industry='')
  and (t2.industry is not null and t2.industry != '');

```
## How to Use

1. **Clone the repository to your local machine:**

    ```bash
    git clone https://github.com/yourusername/your-repo-name.git
    ```

2. **Import the `layoffs.csv` file into your SQL database:**

    ```sql
    COPY layoffs
    FROM '/path/to/layoffs.csv'
    DELIMITER ','
    CSV HEADER;
    ```

3. **Run the provided SQL queries to clean and preprocess the data:**    

4. **Export the cleaned data for further analysis or visualization:**










