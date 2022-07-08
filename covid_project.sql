/*
COVID-19 Data Exploration 
*/
-- Downloaded data on July 8, 2022 from: https://ourworldindata.org/covid-deaths 


-- Showing COVID data table ordered by country and date
SELECT *
	FROM portfolio_covid_project..covid_data
	ORDER BY 3,4



-- Global COVID Cases 
-- Showing total cases, total deaths, and percent of cases that resulted in deaths
SELECT SUM(new_cases) AS total_cases, SUM(CAST(new_deaths AS INT)) AS total_deaths, SUM(CAST(new_deaths AS INT))/SUM(new_cases)*100 AS death_percent
	FROM portfolio_covid_project..covid_data
		WHERE continent IS NOT NULL 
			ORDER BY 1,2


-- Percent of people infected sorted by country 
-- This does count people who have been infected more than once as multiple people getting infected (percentages shown are higher than the actual percentage)
SELECT location, population, MAX(total_cases) AS infection_count, (MAX(total_cases)/population)*100 AS percent_infected
	FROM portfolio_covid_project..covid_data
		WHERE continent IS NOT NULL 
			GROUP BY location, population
			ORDER BY percent_infected DESC


-- Percent of people infected sorted by country and date
-- This does count people who have been infected more than once as multiple people getting infected (percentages shown are higher than the actual percentage)
SELECT location, population, date, total_cases, (total_cases/population)*100 AS percent_infected
	FROM portfolio_covid_project..covid_data
		WHERE continent IS NOT NULL 
		ORDER BY location, date


-- Cases grouped by continent 
SELECT location, SUM(CONVERT (BIGINT,new_deaths)) AS total_deaths
	FROM portfolio_covid_project..covid_data
		WHERE continent IS NULL	
		AND location NOT IN('World', 'European Union', 'International', 'Low income', 'Lower middle income', 'High income', 'Upper middle income')
				GROUP BY location
				ORDER BY total_deaths



-- Global Vaccinations
-- Showing total population, number of people that are fully vaccinated, and the percent of the population that has been vaccinated
WITH vaccinations (location, population, current_people_vaccinated)
AS 
(
SELECT location, MAX(population), MAX(CAST(people_fully_vaccinated AS BIGINT)) AS current_people_vaccinated
	FROM portfolio_covid_project..covid_data
		WHERE people_fully_vaccinated IS NOT NULL 
		AND continent IS NOT NULL 
			GROUP BY location
)
SELECT SUM(population) AS population, SUM(current_people_vaccinated) AS total_vaccinated, (SUM(current_people_vaccinated)/SUM(population))*100 AS percent_vaccinated
	FROM vaccinations


-- Percent of people fully vaccinated by country 
SELECT location, population, MAX(people_fully_vaccinated) AS vaccination_count, (MAX(people_fully_vaccinated)/population)*100 AS percent_vaccinated
	FROM portfolio_covid_project..covid_data
		WHERE continent IS NOT NULL 
			GROUP BY location, population
			ORDER BY percent_vaccinated DESC


-- Percent of people fully vaccinated by country and date
SELECT location, population, date, people_fully_vaccinated, (people_fully_vaccinated/population)*100 AS percent_vaccinated
	FROM portfolio_covid_project..covid_data
		WHERE continent IS NOT NULL 
			ORDER BY location, date


-- Vaccinations grouped by continent
SELECT TOP 6 location, date, people_fully_vaccinated
	FROM portfolio_covid_project..covid_data
		WHERE continent IS NULL	
			AND location NOT IN('World', 'European Union', 'International', 'Low income', 'Lower middle income', 'High income', 'Upper middle income')
				ORDER BY date DESC, location
				
		