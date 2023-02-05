Select *
From PortfolioProject..CovidDeaths
Where continent IS NOT NULL

--Total Cases VS Total Deaths
Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DEATHPERCENTAGE
From PortfolioProject..CovidDeaths
order by 1,2


--Total Cases VS Population
Select location, date, total_cases, population, (total_cases/population)*100 AS COVIDPERCENTAGE
From PortfolioProject..CovidDeaths

--Countries with highest infection rate compared to population
Select location, population, MAX(total_cases) AS HighestInfectionCount, MAX((total_cases/population))*100 AS PERCENTINFECTEDPOPULATION
From PortfolioProject..CovidDeaths
Group by location, population
order by PERCENTINFECTEDPOPULATION desc

--Countries with highest death count
Select location, MAX(cast(total_deaths AS int)) AS TotalDeathCount
From PortfolioProject..CovidDeaths
Where continent IS NOT NULL
Group by location, continent
order by TotalDeathCount desc

--Continent with highest death count
Select continent, MAX(cast(total_deaths AS int)) AS TotalDeathCount
From PortfolioProject..CovidDeaths
Where continent IS NOT NULL
Group by continent
order by TotalDeathCount desc

--Global Numbers
Select date, SUM(new_cases)AS total_cases, SUM(cast(new_deaths AS int)) AS total_deaths, SUM(cast(new_deaths AS int))/SUM(new_cases)*100 AS NEWDEATHPERCENTAGE
From PortfolioProject..CovidDeaths
where continent is not null
group by date
order by 1,2

--Total Population vs Vaccinations

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location Order by dea.location, dea.date) AS RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
     On dea.location = vac.location
	 and dea.date = vac.date
Where dea.continent is not null
order by 2,3

--CTE

With PopvsVac(continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
AS (
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location Order by dea.location, dea.date) AS RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
     On dea.location = vac.location
	 and dea.date = vac.date
Where dea.continent is not null
--order by 2,3
)
Select *
From PopvsVac


--TEMP TABLE
Drop Table if Exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

INSERT INTO #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location Order by dea.location, dea.date) AS RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
     On dea.location = vac.location
	 and dea.date = vac.date
--Where dea.continent is not null
--order by 2,3
Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated


--Creating View 

Create View PercentPopulationVaccinated AS 
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location Order by dea.location, dea.date) AS RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
     On dea.location = vac.location
	 and dea.date = vac.date
--Where dea.continent is not null
--order by 2,3


Select * 
From PercentPopulationVaccinated