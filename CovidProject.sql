--SELECT *
--FROM PortfolioProject..CovidDeaths
--where continent is not null
--order by 3,4

--SELECT *
--FROM PortfolioProject..CovidVaccinations
--order by 3,4

Select location, date, total_cases, new_cases, total_deaths, population
from PortfolioProject..CovidDeaths
where continent is not null
order by 1,2

--looking at total cases vs total deaths
Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 As DeathPercentage
from PortfolioProject..CovidDeaths
Where location = 'Bangladesh'
and continent is not null
order by 1,2

--looking at total cases vs population
Select location, date, population, total_cases, (total_cases/population)*100 As AffectedPercentage
from PortfolioProject..CovidDeaths
Where location = 'Bangladesh'
and continent is not null
order by 1,2

--Looking for countries with highest infection rate compared to population

Select location, population, max(total_cases) as Highest_Infection_Count,  (max(total_cases)/population)*100 As Percentage_of_Population_Infected
from PortfolioProject..CovidDeaths
where continent is not null
group by location, population
order by Percentage_of_Population_Infected desc

--Showing countries with highest death by location(individual country wise)

Select location, MAX(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
where continent is not null
group by location
order by TotalDeathCount desc


--Showing countries with highest death by continent

Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
where continent is not null
group by continent
order by TotalDeathCount desc

--GLOBAL NUMBER

Select date, SUM(new_cases) as Total_cases, SUM(cast(new_deaths as int)) as Total_death, SUM(cast(new_deaths as int))/SUM(new_cases)*100 As DeathPercentage
from PortfolioProject..CovidDeaths
where continent is not null
group by date
order by 1,2


Select  SUM(new_cases) as Total_cases, SUM(cast(new_deaths as int)) as Total_death, SUM(cast(new_deaths as int))/SUM(new_cases)*100 As DeathPercentage
from PortfolioProject..CovidDeaths
where continent is not null
order by 1,2


SELECT *
FROM PortfolioProject..CovidVaccinations
order by 3,4

--Looking at total population vs vaccinations
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations , 
sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by  dea.date) as Sum_of_Vaccination
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
 on dea.location= vac.location
 and dea.date= vac.date
where dea.continent is not null
order by 2,3

--USE CTE to get Vaccinated percentage
WITH popvsVac(continent, location, date, population, New_vaccinations, Sum_of_Vaccination)
as
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations , 
sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by  dea.date) as Sum_of_Vaccination
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
 on dea.location= vac.location
 and dea.date= vac.date
where dea.continent is not null
--order by 2,3
)
select *, (Sum_of_Vaccination/population)*100 As VaccinationPercentage
from popvsVac



--TEMP TABLE to get Vaccinated percentage

DROP TABLE IF EXISTS  VaccinatedPopulation

CREATE TABLE VaccinatedPopulation
(
Continent nvarchar(100),
Location nvarchar(100),
Date datetime,
Population numeric,
New_Vaccinations numeric,
Sum_of_Vaccination numeric
)
INSERT INTO VaccinatedPopulation
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations , 
sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by  dea.date) as Sum_of_Vaccination
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
 on dea.location= vac.location
 and dea.date= vac.date
where dea.continent is not null
--order by 2,3

select *, (Sum_of_Vaccination/population)*100 As VaccinationPercentage
from VaccinatedPopulation



--CREATING VIEW TO STORE DATA FOR LATER VISUALIZATIONS
DROP VIEW IF EXISTS VaccinatedPopulationView;
GO
CREATE VIEW VaccinatedPopulationView AS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations , 
sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by  dea.date) as Sum_of_Vaccination
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
 on dea.location= vac.location
 and dea.date= vac.date
where dea.continent is not null
--order by 2,3

SELECT * 
FROM sys.views 
WHERE name = 'VaccinatedPopulationView';

Select *
FROM VaccinatedPopulationView;


