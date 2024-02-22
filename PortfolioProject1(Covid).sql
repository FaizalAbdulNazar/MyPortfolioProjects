select *
from PortfolioProject.dbo.CovidDeaths
where continent is not null
order by 3,4

--select *
--from CovidVaccinations
--order by 3,4

SELECT Location, Date, total_cases, new_cases, total_deaths, population 
FROM PortfolioProject.dbo.CovidDeaths
order by 1,2

-- Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in your country
select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject.dbo.CovidDeaths
where Location like '%India%'
and continent is not null
order by 1,2

-- Total Cases vs Population
-- Shows what percentage of population got covid
select Location, date, total_cases, population, (total_cases/population)*100 AS PercentagePopulationInfected
from PortfolioProject.dbo.CovidDeaths
-- Where location like '%India%'
order by 1,2

-- Highest Infected Countries Compared to Population
select Location, population,MAX(total_cases) AS HighestInfectedPopulation, MAX((total_cases/population))*100 AS PercentagePopulationInfected
from PortfolioProject.dbo.CovidDeaths
--Where location like '%India%'
where continent is not null
group by Location, population
order by HighestInfectedPopulation desc

--Countries with Highest Death Count Compared to Population
select location, MAX(cast(total_deaths as int)) AS HighestDeathCount
from PortfolioProject..CovidDeaths
where continent is null
group by location
order by HighestDeathCount desc


--GLOBAL CASES AND DEATH COUNT WITH DATE
select date, SUM(new_cases), SUM(cast(new_deaths as int)) as total_Death, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths
where continent is not null
group by date
order by 1,2


--GLOBAL CASES AND DEATH COUNT WITHOUT DATE
select  SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_Deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths
where continent is not null
order by 1,2



--Total Population vs Vaccination
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations 
from PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
ON dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 2,3


--Total Population vs Vaccination(Rolling Over)
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int, vac.new_vaccinations)) over (Partition by dea.location order by dea.location, dea.date ) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/Population)*100
from PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
ON dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 2,3

--Using CTE
With PopulationVsVaccination(continent,location,date,population,new_vaccination,RollingPeopleVaccinated)
as
(
select dea.continent,dea.location,dea.date, dea.population, vac.new_vaccinations
,SUM(cast(vac.new_vaccinations as int)) over (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
)
select *, (RollingPeopleVaccinated/Population)*100 as VaccinationPercent
from PopulationVsVaccination


--Using Temp Table
DROP TABLE IF EXISTS #PercentpopulationVaccinated
Create Table #PercentPopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric
)
INSERT INTO #PercentPopulationVaccinated
select dea.continent,dea.location,dea.date, dea.population, vac.new_vaccinations
,SUM(cast(vac.new_vaccinations as int)) over (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
--where dea.continent is not null
--order by 2,3
select *, (RollingPeopleVaccinated/Population)*100 
from #PercentPopulationVaccinated


-- Creating View for later Visualizations
USE PortfolioProject;
GO
Create view PercentPopulationVaccinated as
select dea.continent,dea.location,dea.date, dea.population, vac.new_vaccinations
,SUM(cast(vac.new_vaccinations as int)) over (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3

Select * from PercentPopulationVaccinated





