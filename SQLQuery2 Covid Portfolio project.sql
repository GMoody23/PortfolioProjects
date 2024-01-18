SELECT * 
FROM PortfolioProject..CovidDeaths
where continent is not null
Order by 3,4

SELECT *
FROM PortfolioProject..CovidVaccinations
Order by 3,4

Select location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject..CovidDeaths
where continent is not null
Order by 1,2

--Looking at total cases vs total deaths percentage 
--Showing  the possibilty of dying if you had covid diesease in the US/Country 2020-2021

Select location, date, total_cases, total_deaths, (total_deaths/total_cases) *100 as DeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE location like '%states%'
and continent is not null
Order by 1,2

-- Total cases vs population 2020-2021
--Shows percentage of population that got covid
Select location, date, population, total_cases,(total_cases/population) *100 as PercentagePopulationInfected
FROM PortfolioProject..CovidDeaths
--WHERE location like '%states%'
Order by 1,2

-- Countries with highest infection rate compared to population 
Select location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population)) *100 as PercentagePopulationInfected
FROM PortfolioProject..CovidDeaths
--WHERE location like '%states%'
Group by Location, population
Order by PercentagePopulationInfected desc


--showing countries with the highest death count per population
Select location, MAX(cast(total_deaths as int)) as totaldeathcounts
FROM PortfolioProject..CovidDeaths
--WHERE location like '%states%'
where continent is not null
Group by Location
Order by totaldeathcounts desc

-- By continents
Select continent, MAX(cast(total_deaths as int)) as totaldeathcounts
FROM PortfolioProject..CovidDeaths
--WHERE location like '%states%'
where continent is not null
Group by continent
Order by totaldeathcounts desc

-- Global Numbers 

Select date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage--total_cases, total_deaths, (total_deaths/total_cases) *100 as DeathPercentage
FROM PortfolioProject..CovidDeaths
--WHERE location like '%states%'
where continent is not null
Group by date
Order by 1,2

--looking at total population vs vaccinations 
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
 SUM(CAST(vac.new_vaccinations as int)) OVER (Partition by dea.location Order by dea.location,dea.Date) as RollingPeopleVaccinated
 --,(RollingPeopleVaccinated/population)*100
FROM PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
On dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 2,3

--CTE 
With PopvsVac (Continent, location, date, population, New_vaccinations, RollingPeopleVaccinated)
as
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
 SUM(CAST(vac.new_vaccinations as int)) OVER (Partition by dea.location Order by dea.location,dea.Date) as RollingPeopleVaccinated
 --,(RollingPeopleVaccinated/population)*100
FROM PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
On dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
SELECT *, (RollingPeopleVaccinated/population)*100
From PopvsVac


--CReate view to store data for later visualizatiions
Create view PercentPopulationVaccinated as
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
 SUM(CAST(vac.new_vaccinations as int)) OVER (Partition by dea.location Order by dea.location,dea.Date) as RollingPeopleVaccinated
 --,(RollingPeopleVaccinated/population)*100
FROM PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
On dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3