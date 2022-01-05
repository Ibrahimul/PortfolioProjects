  /*
Covid-19 Data Exploration
Data downloaded on 01/01/2022 from https://ourworldindata.org/explorers/coronavirus-data-explorer?zoomToSelection=true&facet=none&pickerSort=desc&pickerMetric=new_deaths_per_million&Metric=Confirmed+deaths&Interval=7-day+rolling+average&Relative+to+Population=true&Align+outbreaks=false&country=IND~USA~GBR~CAN~DEU~FRA

Skill used: Joins, Temp Table, Windows Functions, Aggregate Functions,

*/

SELECT *
FROM my-data-project-100.PortfolioProject.CovidDeath
ORDER BY 3,4

  -- SELECT*
  -- FROM my-data-project-100.PortfolioProject.CovidVaccinations
  -- ORDER BY 3,4
  -- Select Data that we are going to be useing

SELECT
  location,
  date,
  total_cases,
  new_cases,
  total_deaths,
  population
FROM
  my-data-project-100.PortfolioProject.CovidDeath
ORDER BY
  1,2

  -- Looking at Total Cases vs Total Death
  -- Shows likelihood of dying from COVID-19 if contract in United States at a given date


SELECT
  location,
  date,
  total_cases,
  total_deaths,
  (total_deaths/total_cases)*100 AS death_percentage
FROM
  my-data-project-100.PortfolioProject.CovidDeath
WHERE
  location = "United States"
ORDER BY
  death_percentage DESC

  -- Looking at Total Case vs Population
  -- Shows percentage of positive cases on each date compared to total number of poppulation in the United States


SELECT
  location,
  date,
  population,
  total_cases,
  new_cases,
  (new_cases/population)*100 AS covid_positive_perccentage
FROM
  my-data-project-100.PortfolioProject.CovidDeath
WHERE
  location LIKE '%States%'
ORDER BY
  date DESC


  --Looking at countries with Highest Infection Rate compared to Population


SELECT
  location,
  population,
  MAX(total_cases) AS num_of_infections,
  MAX(total_cases/population)*100 AS percent_population_infected
FROM
  my-data-project-100.PortfolioProject.CovidDeath
GROUP BY
  location,
  population
ORDER BY
  percent_population_infected DESC


  -- Showing Countries with Highest Death Count per Population


SELECT
  location,
  MAX(total_deaths) AS total_death_count
FROM
  my-data-project-100.PortfolioProject.CovidDeath
WHERE
  continent IS NOT NULL
GROUP BY
  location
ORDER BY
  total_death_count DESC


  -- Breaking things down by continent


SELECT
  continent,
  MAX(total_deaths) AS total_death_count
FROM
  my-data-project-100.PortfolioProject.CovidDeath
WHERE
  continent IS NOT NULL
GROUP BY
  continent
ORDER BY
  total_death_count DESC


  --Joining CovidDeath and CovidVaccination table together


SELECT
  *
FROM
  my-data-project-100.PortfolioProject.CovidDeath AS dea
JOIN
  my-data-project-100.PortfolioProject.CovidVaccinations AS vac
ON
  dea.location = vac.location
  AND dea.date = vac.date


  -- Looking at Total Population vs Vaccinations
  -- Shows percentage of populatiion that has received covid vaccine


SELECT
  dea.continent,
  dea.location,
  dea.date,
  dea.population,
  vac.new_vaccinations,
  SUM(new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS rolling_people_vaccinated
FROM
  my-data-project-100.PortfolioProject.CovidDeath AS dea
JOIN
  my-data-project-100.PortfolioProject.CovidVaccinations AS vac
ON
  dea.location = vac.location
  AND dea.date = vac.date
WHERE
  dea.continent IS NOT NULL
ORDER BY
  rolling_people_vaccinated DESC


  -- Using Temp Table to perform calculation on partition by in previous query
  
WITH
  PopvsVac AS (
  SELECT
    dea.continent,
    dea.location,
    dea.date,
    dea.population,
    vac.new_vaccinations,
    SUM(new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS rolling_people_vaccinated
  FROM
    my-data-project-100.PortfolioProject.CovidDeath AS dea
  JOIN
    my-data-project-100.PortfolioProject.CovidVaccinations AS vac
  ON
    dea.location = vac.location
    AND dea.date = vac.date
  WHERE
    dea.continent IS NOT NULL )
SELECT
  *,
  (rolling_people_vaccinated/population)*100 AS percentage_population_vaccinated
FROM
  PopvsVac