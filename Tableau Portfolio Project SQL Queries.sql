  /*

  Queries used for Tableau Project

  */

-- 1.

  SELECT SUM(new_cases) AS total_cases,SUM(new_deaths) AS total_deaths,SUM(new_deaths)/SUM(new_cases)*100 AS death_percentage
  FROM my-data-project-100.PortfolioProject.CovidDeath
  WHERE continent is not null
  ORDER BY 1,2

-- 2.

SELECT continent, SUM(new_deaths) AS total_deaths
FROM my-data-project-100.PortfolioProject.CovidDeath
WHERE continent is not null 
AND location not in ('world','european Union','international')
GROUP BY continent
ORDER BY total_deaths DESC 

-- 3.

SELECT location,population,MAX(total_cases) AS highest_infection_count, MAX((total_cases/population))*100 AS percent_population_infectd 
FROM my-data-project-100.PortfolioProject.CovidDeath
GROUP BY location,population
ORDER BY percent_population_infectd DESC

-- 4.

SELECT location,population,date,MAX(total_cases) AS highest_infection_count, MAX((total_cases/population))*100 AS percent_population_infectd 
FROM my-data-project-100.PortfolioProject.CovidDeath
GROUP BY location,population,date 