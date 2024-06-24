-- Data Cleaning

ALTER TABLE layoffs RENAME TO layoffs_table;

select * from layoffs_table;

-- 1. Remove Duplicates
-- 2. Standardize the Data
-- 3. Null Values or Blank Values
-- 4. Remove any column that are unnecessary


--creating copy table and inserting values

create table layoffs_table2
like layoffs_table;

select * from layoffs_table2;

insert into layoffs_table2
select * from layoffs_table;

-- adding row_num to Identify the duplicate data and delete it.
select *,
row_number() over
(partition by company,industry, total_laid_off, percentage_laid_off, `date`) as row_num
from layoffs_table2;

with duplicate_cte as 
(
select *,
row_number() over
(partition by company,location, industry, total_laid_off, percentage_laid_off, `date`,stage, country, funds_raised_millions) as row_num
from layoffs_table2
)
select * from duplicate_cte
where row_num > 1;

select * from layoffs_table2
where company = 'Casper';

with duplicate_cte as 
(
select *,
row_number() over
(partition by company,location, industry, total_laid_off, percentage_laid_off, `date`,stage, country, funds_raised_millions) as row_num
from layoffs_table2
)
delete from duplicate_cte
where row_num > 1;

-- creating new table to insert new column for row_num to delete duplicate data

CREATE TABLE `layoffs_table3` (
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


select * from layoffs_table3;

insert into layoffs_table3
select *,
row_number() over
(partition by company,location, industry, total_laid_off, percentage_laid_off, `date`,stage, country, funds_raised_millions) as row_num
from layoffs_table2;

select * from layoffs_table3
;

delete from layoffs_table3
where row_num > 1
;

-- Standardizing Data

select company, trim(company)
from layoffs_table3
;

update layoffs_table3
set company = trim(company);

select *
from layoffs_table3
where industry like 'crypto%'
;

update layoffs_table3
set industry = 'Crypto'
where industry like 'Crypto%';

select distinct industry from layoffs_table3;

select distinct location from layoffs_table3
order by 1;

select distinct country from layoffs_table3
order by 1;

select *
from layoffs_table3
where country like 'United States%';

select distinct country, trim(trailing '.' from country)
from layoffs_table3
order by 1;

update layoffs_table3
set country = trim(trailing '.' from country)
where country like 'United States%';

select `date`,
str_to_date(`date`, '%m/%d/%Y')
from layoffs_table3;

update layoffs_table3
set `date` = str_to_date(`date`, '%m/%d/%Y');

select `date`
from layoffs_table3;

alter table layoffs_table3
modify column `date` date;

select *
from layoffs_table3;

--selecting and deleting null values that is unnecessary

select *
from layoffs_table3
where total_laid_off is null
and percentage_laid_off is null;

select * from layoffs_table3
where industry is null
or industry= '';

select * from layoffs_table3
where company = 'Airbnb';

select in1.industry, in2.industry
from layoffs_table3 in1
join layoffs_table3 in2
	on in1.company=in2.company
where (in1.industry is null or in1.industry = '')
and in2.industry is not null;

update layoffs_table3
set industry = null
where industry = '';


update layoffs_table3 in1
join layoffs_table3 in2
	on in1.company=in2.company
set in1.industry = in2.industry
where (in1.industry is null)
and in2.industry is not null;


select * from layoffs_table3
where industry is null
or industry= '';

select * from layoffs_table3
where company like 'Bally%';

select * from layoffs_table3;



select * from layoffs_table3
where total_laid_off is null
and percentage_laid_off is null;

delete from layoffs_table3
where total_laid_off is null
and percentage_laid_off is null;

-- deleting column that is unnecessary

alter table layoffs_table3
drop column row_num;












