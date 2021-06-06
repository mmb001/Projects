Select * 
From PortfolioProject..CovidDeaths
where continent is not null
Order By 3,4

--Select * 
--From PortfolioProject..CovidVaccinations
--Order By 3,4

--Select the data that we need 

Select location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths
where continent is not null
order by 1,2

--looking at total cases vs total deaths
--shows the chances of death if you are infected with covid-19 in your respective country
Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
where continent is not null
and location like 'India'
--remember to use single quotes while using like 
order by 1,2

--now we will evaluate total cases by population
--this shows what percentage of population has got covid
Select location, date, total_cases, population, (total_cases/population)*100 as PopDeathPercentage
From PortfolioProject..CovidDeaths
--where location like 'India'

--lets see the countries with highest infection rate wrt their population
Select location, population, max(total_cases) as HighestInfectionCount,  (max(total_cases)/population)*100 as PercentInfectionRate
From PortfolioProject..CovidDeaths
group by location, population
order by PercentInfectionRate desc

-- now lets see the countries with the highest deaths wrt their population
Select location, max(cast(total_deaths as int)) as HighestDeathCount  
From PortfolioProject..CovidDeaths
where continent is not null
group by location
order by HighestDeathCount desc

--now visualising by continent
Select continent, max(cast(total_deaths as int)) as HighestDeathCount  
From PortfolioProject..CovidDeaths
where continent is not null
group by continent
order by HighestDeathCount desc

--showing the continents with the highest death count
--same as before
Select continent, max(cast(total_deaths as int)) as HighestDeathCount  
From PortfolioProject..CovidDeaths
where continent is not null
group by continent
order by HighestDeathCount desc


--Global Numbers
Select sum(new_cases) as totalcases, sum(cast(new_deaths as int)) as totaldeaths, sum(cast (new_deaths as int))/sum(new_cases)*100 as deathpercentage--total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
where continent is not null
--and location like 'India'
--remember to use single quotes while using like 
--group by date
order by 1,2 

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert(int, vac.new_vaccinations)) over (partition by dea.location order by dea.location
--,dea.date) as rollingpeoplevaccinated
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac 
	on dea.location=vac.location
	and dea.date=vac.date
where dea.continent is not null
order by 2,3

--use CTE
With PopvsVac (Continent, Location, Date, Population, new_vaccinations, rollinpeoplevaccinated)	
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert(int, vac.new_vaccinations)) over (partition by dea.location order by dea.location,
dea.date) as rollingpeoplevaccinated
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac 
	on dea.location=vac.location
	and dea.date=vac.date
where dea.continent is not null
--order by 2,3
)
select *, (rollinpeoplevaccinated/Population)*100 
from PopvsVac

--TEMP TABLE
Create table #PercentPopVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric,
)


Insert into
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert(int, vac.new_vaccinations)) over (partition by dea.location order by dea.location
--,dea.date) as rollingpeoplevaccinated
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac 
	on dea.location=vac.location
	and dea.date=vac.date
where dea.continent is not null
order by 2,3

select *, (rollinpeoplevaccinated/Population)*100 
from #PercentPopVaccinated

--View

Create view Highestdeathcount as
Select continent, max(cast(total_deaths as int)) as HighestDeathCount  
From PortfolioProject..CovidDeaths
where continent is not null
group by continent
--order by HighestDeathCount desc

