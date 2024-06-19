# Data-Cleaning-Using-MySQL
Data Layoffs Cleaning and Data Exploratory Project using MySQL



-- Data Cleaning

ALTER TABLE layoffs RENAME TO layoffs_table;

select * from layoffs_table;

-- 1. Remove Duplicates
-- 2. Standardize the Data
-- 3. Null Values or Blank Values
-- 4. Remove any column that are unnecessary



create table layoffs_table2
like layoffs_table;

select * from layoffs_table2;

insert into layoffs_table2
select * from layoffs_table;

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


alter table layoffs_table3
drop column row_num;






-- exploratory data analysis

select * from layoffs_table3
order by company;

-- i select everything that in the table that has a 100% layoffs and it is ordered by from the highest total laid off to lowest.

select * from layoffs_table3
where percentage_laid_off = 1
order by total_laid_off desc;

-- getting the sum of total laid off of each company

select company, sum(total_laid_off)
from layoffs_table3
group by company
order by 2 desc;

-- selecting the year that laiding off starts and laiding off end

select min(`date`), max(`date`)
from layoffs_table3;

-- getting the sum of total laid off of each industry

select industry, sum(total_laid_off)
from layoffs_table3
group by industry
order by 2 desc;


-- getting the sum of total laid off of each country

select country, sum(total_laid_off)
from layoffs_table3
group by country
order by 2 desc;


-- getting the sum of total laid off of each date

select `date`, sum(total_laid_off)
from layoffs_table3
group by `date`
order by 1 desc;

-- getting the sum of total laid off of each date (per year)

select year(`date`), sum(total_laid_off)
from layoffs_table3
group by year(`date`)
order by 1 desc;

-- getting the sum of total laid off of each stage

select stage, sum(total_laid_off)
from layoffs_table3
group by stage
order by 2 desc;


select * from layoffs_table3;

-- getting the sum of total laid off of each year and month without null values 

select substring(`date`, 1,7) as `Month`, sum(total_laid_off)
from layoffs_table3
where substring(`date`, 1,7) is not null
group by `Month`
order by 1 asc;

-- getting the sum of total laid off of each year and month with rolling sum to find out the detailed
-- total number of people laid off each year. without null values 

with rolling_total as 
(
select substring(`date`, 1,7) as `Month`, sum(total_laid_off) as total_laid
from layoffs_table3
where substring(`date`, 1,7) is not null
group by `Month`
order by 1 asc
)
select `Month`,total_laid
,sum(total_laid) over(order by `Month`) as ROLING_TOTAL
from rolling_total;


select company, sum(total_laid_off)
from layoffs_table3
group by company
order by 2 desc;

-- getting the total laid off each company per year

select company, year(`date`) as `year`, sum(total_laid_off)
from layoffs_table3
group by company,`year`
order by `year`;

-- Ranking the companies with the highest total layoffs each year

with Company_year (company, years, total_laid_off) as
(
select company, year(`date`) as `year`, sum(total_laid_off)
from layoffs_table3
group by company,`year`
)
select *, dense_rank() over (partition by years order by total_laid_off desc) as ranking
from Company_year
where years is not null
order by ranking asc;

-- ranking the top 5 companies with the highest total layoffs each year.

with Company_year (company, years, total_laid_off) as
(
select company, year(`date`) as `year`, sum(total_laid_off)
from layoffs_table3
group by company,`year`
),
company_year_rank as 
(
select *, dense_rank() over (partition by years order by total_laid_off desc) as ranking
from Company_year
where years is not null
)
select * from company_year_rank
where ranking <= 5;

-- Ranking the industry with the highest total layoffs each year

with Industry_year (industry, years, total_laid_off) as
(
select industry, year(`date`) as `year`, sum(total_laid_off)
from layoffs_table3
group by industry,`year`
)
select *, dense_rank() over (partition by years order by total_laid_off desc) as ranking
from Industry_year
where years is not null
order by ranking asc;


-- ranking the top 5 industry with the highest total layoffs each year.

with Industry_year (industry, years, total_laid_off) as
(
select industry, year(`date`) as `year`, sum(total_laid_off)
from layoffs_table3
group by industry,`year`
),
industry_year_rank as 
(
select *, dense_rank() over (partition by years order by total_laid_off desc) as ranking
from Industry_year
where years is not null
)
select * from industry_year_rank
where ranking <= 5;
