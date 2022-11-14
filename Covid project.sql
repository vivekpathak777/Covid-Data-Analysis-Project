--select * from portfolioProjectsAlex..covidvaccinations
--order by 3,4

select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from portfolioProjectsAlex..CovidDeaths
where total_cases is not null and location like '%states%'
order by 1,2


select location, date, total_cases, population, (total_cases/population)*100 as infectedPercentage
from portfolioProjectsAlex..CovidDeaths
where total_cases is not null and location like '%states%'
order by 1,2

-- highest infection rate 

select location, population, max(total_cases) as Highest_Infection_rate, 
max((total_cases/population))*100 as PercentPopulationInfected
from portfolioProjectsAlex..CovidDeaths
where total_cases is not null
group by location, population
order by PercentPopulationInfected desc

-- Highest deaths

select location, max(cast(total_deaths as int)) as TotalDeathCount
from portfolioProjectsAlex..CovidDeaths
where total_cases is not null and continent is not null
group by location
order by TotalDeathCount desc

-- continent

select continent, max(cast(total_deaths as int)) as TotalDeathCount
from portfolioProjectsAlex..CovidDeaths
where total_cases is not null and continent is not null
group by continent
order by TotalDeathCount desc

--global

select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from portfolioProjectsAlex..CovidDeaths
where total_cases is not null --and location like '%states%'
order by 1,2

-- global

select sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, 
sum(cast(new_deaths as int))/sum(new_cases)*100 as deathPercentage
from portfolioProjectsAlex..CovidDeaths
where continent is not null
order by 1,2

--global numbers

select continent, max(cast(total_deaths as int)) as total_deaths_count 
from portfolioProjectsAlex..CovidDeaths
where continent is not null
group by continent
order by total_deaths_count desc

-- looking at total population Vs Vaccinations

select d.continent,d.location,d.date,d.population,v.new_vaccinations,
sum(cast(v.new_vaccinations as int)) over (partition by d.location order by d.location, d.date) as RollingPeopleVaccinated
from portfolioProjectsAlex..CovidDeaths d join portfolioProjectsAlex..covidvaccinations v
on d.location = v.location and d.date = v.date
where d.continent is not null and d.population is not null
order by 2,3

-- popvsvac

with popvsvac (continent,location,date,population,new_vaccinations,RollingPeopleVaccinated)
as
(
select d.continent,d.location,d.date,d.population,v.new_vaccinations,
sum(cast(v.new_vaccinations as int)) over (partition by d.location order by d.location, d.date)
as RollingPeopleVaccinated
from portfolioProjectsAlex..CovidDeaths d join portfolioProjectsAlex..covidvaccinations v
on d.location = v.location and d.date = v.date
where d.continent is not null and d.population is not null
--order by 2,3
)
select *, (RollingPeopleVaccinated/population)*100
from popvsvac

--creating view

create view popvsvac as
select d.continent,d.location,d.date,d.population,v.new_vaccinations,
sum(cast(v.new_vaccinations as int)) over (partition by d.location order by d.location, d.date)
as RollingPeopleVaccinated
from portfolioProjectsAlex..CovidDeaths d join portfolioProjectsAlex..covidvaccinations v
on d.location = v.location and d.date = v.date
where d.continent is not null and d.population is not null
--order by 2,3

select * from popvsvac

---Below is copied for tableau dashboard

/*

Queries used for Tableau Project

*/



-- 1. 

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, 
SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
--Where location like '%states%'
where continent is not null 
--Group By date
order by 1,2

-- Just a double check based off the data provided
-- numbers are extremely close so we will keep them - The Second includes "International"  Location


--Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
--From PortfolioProject..CovidDeaths
----Where location like '%states%'
--where location = 'World'
----Group By date
--order by 1,2


-- 2. 

-- We take these out as they are not inluded in the above queries and want to stay consistent
-- European Union is part of Europe

Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
From portfolioProjectsAlex..CovidDeaths
--Where location like '%states%'
Where continent is null 
and location not in ('World', 'European Union', 'International')
Group by location
order by TotalDeathCount desc


-- 3.

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From portfolioProjectsAlex..CovidDeaths
--Where location like '%states%'
where population is not null
Group by Location, Population
order by PercentPopulationInfected desc


-- 4.


Select Location, Population,date, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From portfolioProjectsAlex..CovidDeaths
--Where location like '%states%'
where population is not null
Group by Location, Population, date
order by PercentPopulationInfected desc












-- Queries I originally had, but excluded some because it created too long of video
-- Here only in case you want to check them out


-- 1.

Select dea.continent, dea.location, dea.date, dea.population
, MAX(vac.total_vaccinations) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
group by dea.continent, dea.location, dea.date, dea.population
order by 1,2,3




-- 2.
Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
--Where location like '%states%'
where continent is not null 
--Group By date
order by 1,2


-- Just a double check based off the data provided
-- numbers are extremely close so we will keep them - The Second includes "International"  Location


--Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
--From PortfolioProject..CovidDeaths
----Where location like '%states%'
--where location = 'World'
----Group By date
--order by 1,2


-- 3.

-- We take these out as they are not inluded in the above queries and want to stay consistent
-- European Union is part of Europe

Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
--Where location like '%states%'
Where continent is null 
and location not in ('World', 'European Union', 'International')
Group by location
order by TotalDeathCount desc



-- 4.

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
--Where location like '%states%'
Group by Location, Population
order by PercentPopulationInfected desc



-- 5.

--Select Location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
--From PortfolioProject..CovidDeaths
----Where location like '%states%'
--where continent is not null 
--order by 1,2

-- took the above query and added population
Select Location, date, population, total_cases, total_deaths
From PortfolioProject..CovidDeaths
--Where location like '%states%'
where continent is not null 
order by 1,2


-- 6. 


With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100 as PercentPeopleVaccinated
From PopvsVac


-- 7. 

Select Location, Population,date, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
--Where location like '%states%'
Group by Location, Population, date
order by PercentPopulationInfected desc


















