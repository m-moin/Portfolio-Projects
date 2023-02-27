select *
From [Portfolio Project]..  CovidDeaths$
Where continent is not null
ORDER BY 3,4

--select *
--From [Portfolio Project].. CovidVaccinations$
--ORDER BY 3,4

-- Select Data that we are going to be using
-- Shows the likelihood of dying if you are conracted covid in any selected country 

Select location, date, total_cases, new_cases, total_deaths, population
From [Portfolio Project]..CovidDeaths$
Where continent is not null
ORDER BY 1,2

-- Looking at Total Cases vs Total Deaths

Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From [Portfolio Project]..CovidDeaths$
Where location like '%states%'
and continent is not null
ORDER BY 1,2


--Looking at Total Cases vs Total Population
-- Showing what percentage of population got infected by Covid

Select location, date, population, total_cases, (total_cases/population)*100 as PercentPopulationInfected
From [Portfolio Project]..CovidDeaths$
-- Where location like '%states%'
Where continent is not null
ORDER BY 1,2

-- Looking at countries with highest infection rate compared to Population
Select location, population, MAX(total_cases) as HighestInfectionCount, MAX(total_cases/population)*100 as PercentPopulationInfected
From [Portfolio Project]..CovidDeaths$
-- Where location like '%states%'
Where continent is not null
Group by location, population
ORDER BY PercentPopulationInfected desc

-- Showing Countries with Highest Death Count per Population

Select location, MAX(cast(total_deaths as int)) as TotalDeathCount
From [Portfolio Project]..CovidDeaths$
-- Where location like '%states%'
Where continent is not null
Group by location
ORDER BY TotalDeathCount desc

-- Breaking things down by Continent

Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
From [Portfolio Project]..CovidDeaths$
-- Where location like '%states%'
Where continent is not null
Group by continent
ORDER BY TotalDeathCount desc

-- Showing the continents with Highest Death Count
Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
From [Portfolio Project]..CovidDeaths$
-- Where location like '%states%'
Where continent is not null
Group by continent
ORDER BY TotalDeathCount desc

-- GLOBAL NUMBERS
Select date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage -- ,(total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From [Portfolio Project]..CovidDeaths$
-- Where location like '%states%'
Where continent is not null
Group By date
 
 With PopvsVac (Continent, location, date, population, New_vaccinations, RollingPeopleVaccinated)
 as
 (

-- Looking at Total Population vs Vaccination

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Cast(vac.new_vaccinations as int)) OVER (Partition by dea.location Order by dea.location,  dea.date) as RollingPeopleVaccinated
--, RollingPeopleVaccinated
From [Portfolio Project]..CovidDeaths$ dea
Join [Portfolio Project]..CovidVaccinations$ vac
	On dea.location = vac.location 
	and dea.date = vac.date
Where dea.continent is not null
--ORDER BY 2,3
)

Select* , (RollingPeopleVaccinated/Population)*100
From PopvsVac

