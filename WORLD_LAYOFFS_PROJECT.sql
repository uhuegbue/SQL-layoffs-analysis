--- DATA CLEANING


SELECT *
FROM layoffs;

---- 1.  Remove Duplicates if there are any----
---- 2. Standardize the Data
---- 3. Null Values or blank Values
---- 4. Remove any unnecessary columns and rows


--- The reason is to dublicate the raw database base so that incase of any changes we are unable to correct, we still have the 
--- main raw data base called "layoffs" ----

CREATE TABLE Layoffs_staging
LIKE layoffs;


SELECT *
FROM Layoffs_staging;

INSERT Layoffs_staging
SELECT *
FROM layoffs;


SELECT *,
ROW_NUMBER () OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`) AS row_num
FROM Layoffs_staging;


WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER () OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions ) AS row_num
FROM Layoffs_staging
)
SELECT * 
FROM duplicate_cte
WHERE row_num > 1;


SELECT *
FROM Layoffs_staging
WHERE company = 'Casper';


WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER () OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions ) AS row_num
FROM Layoffs_staging
)
DELETE 
FROM duplicate_cte
WHERE row_num > 1;



CREATE TABLE `Layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


SELECT *
FROM Layoffs_staging2
WHERE row_num > 1;

INSERT INTO Layoffs_staging2
SELECT *,
ROW_NUMBER () OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions ) AS row_num
FROM Layoffs_staging;


DELETE
FROM Layoffs_staging2
WHERE row_num > 1;

SELECT *
FROM Layoffs_staging2;


---- Standardizing Data
SELECT company, TRIM(company)
FROM Layoffs_staging2;

UPDATE Layoffs_staging2
SET company = TRIM(company);


SELECT DISTINCT industry 
FROM Layoffs_staging2
;

UPDATE Layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';


SELECT *
FROM Layoffs_staging2
ORDER BY 1;


UPDATE Layoffs_staging2
SET location = 'Dusseldorf'
WHERE location LIKE '%DÃ¼sseldorf%';

SELECT *
FROM Layoffs_staging2
ORDER BY 1; 


UPDATE Layoffs_staging2
SET country = 'United States'
WHERE country LIKE '%United States%';


SELECT DISTINCT country, TRIM(country)
FROM Layoffs_staging2
ORDER BY 1; 

SELECT DISTINCT country
FROM Layoffs_staging2
ORDER BY 1; 

SELECT *
FROM Layoffs_staging2; 

-- Change date column from texts---

SELECT `date`,
STR_TO_DATE(`date`, '%m/%d/%Y') AS "Date"
FROM Layoffs_staging2;

UPDATE Layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y'); 

SELECT `date`
FROM Layoffs_staging2;

ALTER TABLE Layoffs_staging2
MODIFY COLUMN `date` DATE;


SELECT * 
FROM Layoffs_staging2;

-- REmoving Null and Blank Values or populating them with the right information especially for the industry and location-----

SELECT * 
FROM Layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

UPDATE Layoffs_staging2
SET industry = NULL 
WHERE industry = ''; 


SELECT *
FROM Layoffs_staging2
WHERE industry IS NULL
OR industry = '';

SELECT *
FROM Layoffs_staging2
WHERE company = 'Airbnb';


SELECT *
FROM Layoffs_staging2
WHERE company LIKE 'Bally%';

SELECT T1.industry, T2.industry
FROM Layoffs_staging2 T1
JOIN Layoffs_staging2 T2
	ON T1.company = T2.company
WHERE (T1.industry IS NULL OR T1.industry = '')
AND T2.industry IS NOT NULL; 


UPDATE Layoffs_staging2 T1
JOIN Layoffs_staging2 T2
	ON T1.company = T2.company
SET T1.industry = T2.industry
WHERE T1.industry IS NULL 
AND T2.industry IS NOT NULL; 


SELECT *
FROM Layoffs_staging2;


SELECT * 
FROM Layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

DELETE 
FROM Layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL; 


SELECT * 
FROM Layoffs_staging2;


ALTER TABLE Layoffs_staging2
DROP COLUMN row_num;






 