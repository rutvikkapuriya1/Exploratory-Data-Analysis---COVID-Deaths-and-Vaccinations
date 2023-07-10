
--Title : Exploratory Data Analysis - COVID Deaths and Vaccinations

--Objective: The objective is to give insights of COVID-19. For that, It will be shown how is the number of deaths and vaccinations for each continent and country. 
			--This analysis is based on real data about covid 19 from January 2020 to July 2021 using MS Server.

--The project aims to provide a comprehensive understanding of the COVID-19 situation globally, highlighting variations in the number of deaths and vaccinations 
-- across different regions and identifying What are the most important factors that have contributed to the spread of the pandemic.

--1) Checking for null values, duplicate values, change data types and total rows in both tables
--2) Top 10 country which have highest no. of avg death by day and highest death_percentage by population.
--3) which countries have the highest rate of infection in relation to population ?
--4) Which continents and locations have the highest average percentage of COVID-19 cases relative to their population?
--5) what percentage of the population vaccinated for each country?
--6) What is the rolling average of new COVID-19 cases over a 7-day period for each location in Europe?

select * from covid_deaths
select * from covid_vaccination

select count(*) from covid_deaths
select count(*) from covid_vaccination

ALTER TABLE covid_deaths
ALTER COLUMN population BIGINT;


--Checking for duplicate values¶
--Deaths table Query:

SELECT date, continent, location,
COUNT(*) AS 'Duplicates'
FROM covid_deaths
GROUP BY date, continent, location
HAVING COUNT(*) > 1;

--Vaccination table Query:

SELECT date, continent, location,
COUNT(*) AS 'Duplicates'
FROM covid_vaccination
GROUP BY date, continent, location
HAVING COUNT(*) > 1;

--Checking the quantity of continents and countries


SELECT COUNT(DISTINCT continent) AS continents,
       COUNT(DISTINCT location) AS countries
FROM covid_deaths;

--continents: 6, countries: 230

SELECT continent, COUNT(DISTINCT location) AS countries
FROM covid_deaths
GROUP BY continent;

--continent	   countries
--North America	 34
--Asia        	 50
--Africa      	 55
--Oceania     	 18
--South America	 13
--Europe	     51

--Average number of deaths by day (Continents and Countries)¶

SELECT Top 10 location,
ROUND(AVG(new_deaths),2) AS Deaths_Average_Day
FROM covid_deaths
GROUP BY location
ORDER BY Deaths_Average_Day DESC;

--Average of cases divided by the number of population of each country (TOP 10)¶

SELECT TOP 10
    continent,
    location,
    ROUND(AVG((total_cases * 100.0) / population), 3) AS Percentage_Population
FROM
    covid_deaths
GROUP BY
    continent,
    location,
    population
ORDER BY
    Percentage_Population DESC;


--The top three countries with highest percentage of people infected is: Andorra, Seychelles and Montenegro.

--Countries with the highest number of deaths¶

SELECT location,
MAX(total_deaths) AS Max_of_Deaths
FROM covid_deaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY Max_of_Deaths DESC;

--Usa, Brazil and India are the top 3 in the number of deaths. But this information is not enough to say if they are also the higher percentage of deaths versus population.

SELECT TOP 10 location, MAX(total_deaths) AS max_deaths, population,
       (CONVERT(FLOAT, MAX(total_deaths)) / population) * 100 AS death_percentage
FROM covid_deaths
GROUP BY location, population
ORDER BY death_percentage DESC;

--peru, Hungary and Bosnia and Herzegovina are the top 3 in the highest death_percentage


--What is the rolling average of new COVID-19 cases over a 7-day period for each location in Europe?"

SELECT location, date, new_cases,
       AVG(new_cases) OVER (PARTITION BY location ORDER BY date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS rolling_average
FROM covid_deaths
WHERE continent = 'Europe';



--The percentage of the population vaccinated for each country.

SELECT cv.location, (cv.total_vaccinations / cd.population) * 100 AS vaccination_percentage
FROM covid_vaccination cv
JOIN covid_deaths cd ON cv.location = cd.location
ORDER BY vaccination_percentage ;

;






