SELECT *
FROM dbo.['CovidDeaths(2)$']
ORDER BY 3,4


--SELECT *
--FROM dbo.['CovidVaccinations(2)$']
--ORDER BY 3,4

--Select data that we are going to be using

SELECT Location, Date, total_cases, new_cases, total_deaths, population
FROM dbo.['CovidDeaths(2)$']
ORDER BY 1,2

--Looking at the Total Cases vs. Total Deaths
--Shows likelihood of dying if you contract covid in your country

SELECT Location, Date, total_cases, total_deaths, 100* CAST(total_deaths as Integer)/CAST(total_cases as Integer) as DeathPercentage
FROM dbo.['CovidDeaths(2)$']
WHERE location LIKE '%states%'
ORDER BY 1,2


--Looking at the Total Cases vs. Population
--Shows what percentage of population got covid

SELECT continent, Date, population,total_cases, (total_cases/population)*100 as PercentagePopulationInfection
FROM dbo.['CovidDeaths(2)$']
--WHERE location LIKE '%states%'
ORDER BY 1,2


--Looking at Countries with Highest Infection Rate compared to Population

SELECT continent, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected
FROM dbo.['CovidDeaths(2)$']
--WHERE location LIKE '%states%'
GROUP BY continent, Population
ORDER BY PercentPopulationInfected DESC


--Showing Countries with the Highest Death Count per Population

SELECT continent, MAX(cast(total_deaths as int)) as TotalDeathCount
FROM dbo.['CovidDeaths(2)$']
--WHERE location LIKE '%states%'
WHERE continent is not null
GROUP BY continent
ORDER BY TotalDeathCount DESC

--LET'S BREAK THINGS DOWN BY CONTINENT
--Showing the continents with the highest death count per population

SELECT continent, MAX(cast(total_deaths as int)) as TotalDeathCount
FROM dbo.['CovidDeaths(2)$']
--WHERE location LIKE '%states%'
WHERE continent is not null
GROUP BY continent
ORDER BY TotalDeathCount DESC


--GLOBAL NUMBERS

SELECT Date, SUM(new_cases) as total_cases,SUM(cast(new_deaths as int)) as total_deaths,SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
FROM dbo.['CovidDeaths(2)$']
--WHERE location LIKE '%states%'
WHERE continent is not null
--GROUP BY date
ORDER BY 1,2


--Looking at Total Population vs. Vaccinations

--USE CTE

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated) 
as
(
SELECT dea.continent,dea.location,dea.date, dea.population,vac.new_vaccinations,
SUM(convert(bigint,vac.new_vaccinations)) over (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated --,(RollingPeopleVaccinated/population)*100
FROM dbo.['CovidDeaths(2)$'] dea
JOIN dbo.['CovidVaccinations(2)$'] vac
ON dea.location = vac.location and dea.date = vac.date
WHERE dea.continent is not null
--order by 2,3
)
SELECT *,(RollingPeopleVaccinated/Population)*100
FROM PopvsVac

--Temp Table

DROP table if exists #PercentPopulationVaccinated
Create table #PercentPopulationVaccinated
(
Continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric
)

INSERT INTO #PercentPopulationVaccinated
SELECT dea.continent,dea.location,dea.date, dea.population,vac.new_vaccinations,
SUM(convert(bigint,vac.new_vaccinations)) over (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated --,(RollingPeopleVaccinated/population)*100
FROM dbo.['CovidDeaths(2)$'] dea
JOIN dbo.['CovidVaccinations(2)$'] vac
ON dea.location = vac.location and dea.date = vac.date
--WHERE dea.continent is not null
--order by 2,3


SELECT *,(RollingPeopleVaccinated/Population)*100
FROM #PercentPopulationVaccinated

--Creating view to store data for later visualizations

Create View PercentPopulationVaccinated as
SELECT dea.continent,dea.location,dea.date, dea.population,vac.new_vaccinations,
SUM(convert(bigint,vac.new_vaccinations)) over (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated --,(RollingPeopleVaccinated/population)*100
FROM dbo.['CovidDeaths(2)$'] dea
JOIN dbo.['CovidVaccinations(2)$'] vac
ON dea.location = vac.location and dea.date = vac.date
WHERE dea.continent is not null
--order by 2,3

SELECT *
FROM PercentPopulationVaccinated