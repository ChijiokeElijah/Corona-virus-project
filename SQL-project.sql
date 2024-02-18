Select *
From Projects..covidDeath
Where continent is not null




---Select Data that we are going to be using

Select Location, date, total_cases, new_cases, total_deaths, population
From Projects..covidDeath
order by 1,2


-- Looking at Total cases vs Total Death

Select Location, date, total_cases, total_deaths, (cast(total_deaths as float)/ cast(total_cases as float))*100 as DeathPercentage
From Projects..covidDeath
where location like '%Nigeria%'
order by 1,2

--looking at the total cases vs population
Select Location, date, total_cases, population, (cast(total_cases as float)/ cast(population as float))*100 as PercentagewithCovid
From Projects..covidDeath
where location like '%Nigeria%'
order by 1,2

--looking at countries with Highest Infection Rate compared to population

Select Location, population, MAX(total_cases) as HighestInfectionCount, Max(cast(total_cases as float)/ cast(population as float))*100 as PercentagewithCovid
From Projects..covidDeath
where continent is not null
Group by Population, location
order by PercentagewithCovid desc


--showing the countries with highest death count per population
Select Location, MAX(cast(total_deaths as int)) as TotalDeathCount
From Projects..covidDeath
--where location like '%Nigeria%'
Where continent is not null
Group by Location
order by TotalDeathCount desc

--let's break things down by continent



--showing the continent with highest death count
Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
From Projects..covidDeath
--where location like '%Nigeria%'
Where continent is not null
Group by continent
order by TotalDeathCount desc


--Global Numbers

Select  date, total_cases, total_deaths, (cast(total_deaths as float)/ cast(total_cases as float))*100 as DeathPercentage
From Projects..covidDeath
--where location like '%Nigeria%'
where continent is not null
Group by continent
order by 1,2

SELECT *
FROM Projects..AbiaDATA
where LGA like '%Ohafia%' 


--GLOBAL NUMBERS
SELECT  SUM(cast(new_cases as int)) as total_cases, SUM(cast(total_deaths as int)) as total_deaths, SUM(cast(new_deaths as float))/SUM(cast(new_cases as float))*100 as DeathPercentage
From Projects..covidDeath
where continent is not null
--Group by date
order by 1,2


-- Looking at Total population vs Vaccination
select dea.continent,dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.location order by dea.location, dea.date) as rollingPeopleVaccinated
from projects..covidDeath as dea
Join projects..covidVaccination as vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3

--USE CTE
With PopvsVac (Continent, Location, Date, Population, new_vaccinations, rollingPeopleVaccinated)
as
(
Select dea.continent,dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.location order by dea.location, dea.date) as rollingPeopleVaccinated
from projects..covidDeath as dea
Join projects..covidVaccination as vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
select *, (rollingPeopleVaccinated/Population)*100 
From PopvsVac




Select SUM([NET PAY ])  as LGSumPAY
From Projects..AbiaDATA
where LGA = 'Ohafia'


Select SUM(new_cases) as total_cases,SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
From Projects..covidDeath
where continent is not null
order by 1,2


--TEMP TABLE
DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingpeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent,dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.location order by dea.location, dea.date) as rollingPeopleVaccinated
from projects..covidDeath as dea
Join projects..covidVaccination as vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated



Create View PercentagePopulationVaccinated as
Select dea.continent,dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.location order by dea.location, dea.date) as rollingPeopleVaccinated
from projects..covidDeath as dea
Join projects..covidVaccination as vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3
