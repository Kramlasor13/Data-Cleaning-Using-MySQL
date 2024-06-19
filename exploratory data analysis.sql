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

















