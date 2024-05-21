-- viewing raw data table 
select* from layoffs;

-- creating a staging table 
create table layoffs_staging
like layoffs;

-- inserting data into staging table 
insert layoffs_staging
select * 
from layoffs;

-- viewing the staging table 
select* from layoffs_staging;

-- 1. remove duplicates
-- 2. standardize the data 
-- 3. null or blank values
-- 4. remove any columns


-- 1. Remove duplicates
--  finding duplicates
with finding_duplicates as(
select *, row_number() over(partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
from layoffs_staging
)
select* 
from finding_duplicates
where row_num >1 ;

-- 1.2 creating a staging table for deletion of the duplicates

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


--  viewing staging table for deletion
select* 
from layoffs_staging_delete_duplicates;

-- inserting data into deletion table 
insert into layoffs_staging_delete_duplicates
select *, row_number() over(partition by company, location, industry, 
total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
from layoffs_staging;

-- viewing the duplicate values 
select* 
from layoffs_staging_delete_duplicates
where row_num>1;

-- deleting duplicate values 
delete
from layoffs_staging_delete_duplicates
where row_num>1;

-- 2. standardization

-- viewing how the data would look after trim 
select company, trim(company)
from layoffs_staging_delete_duplicates;

-- updating the trimed column 
update layoffs_staging_delete_duplicates
set company = trim(company);


-- viewing distinct industries and possible need of standardization 
select distinct industry
from layoffs_staging_delete_duplicates
order by 1;
 
 -- intial observation suggested the 'crypto' industry might need ome standaradization 
 select distinct industry
 from layoffs_staging_delete_duplicates
 where industry like 'crypto%';
 
 -- updating the crypto industry name
 update layoffs_staging_delete_duplicates
 set industry = 'Crypto'
 where industry like 'crypto%';
 
 -- viewing location column and possible need for standardization
 select location 
 from layoffs_staging_delete_duplicates
 order by 1;
 
-- viewing country column and possible need for standardization
 select distinct country 
 from layoffs_staging_delete_duplicates
 order by 1;
 
 -- viewing country column how it would look like after updating the name 'united states'
 select distinct country, trim(trailing '.' from country)
 from layoffs_staging_delete_duplicates
 order by 1;
 
 -- updating the country column and fixing the name of 'united states'
 update layoffs_staging_delete_duplicates
 set country = trim(trailing '.' from country)
 where country like 'United States%';
 
 -- we have a date column in string type and we need to change it to date type
 -- first lets view how the converted column may look like 
 select `date`, str_to_date(`date`, '%m/%d/%Y')
 from layoffs_staging_delete_duplicates;
 
 -- we are updating the date column from string to date type
 update layoffs_staging_delete_duplicates
 set `date` =  str_to_date(`date`, '%m/%d/%Y');
 
 -- now that we have changed the column values from string to date type, we can alter the column of the table from string to date type
 


