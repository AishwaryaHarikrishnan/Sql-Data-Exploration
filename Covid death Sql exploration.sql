Select *
From Portfolioproject..coviddeath$ 
order by 3,4

--Select *
--From Portfolioproject..covidvacciniation$ 
--order by 3,4
--Selecting the data which we are going to use
Select location, date,total_cases,new_cases,total_deaths,population
from Portfolioproject..coviddeath$
order by 1,2


--exploring total cases and total death
SELECT location, date, total_cases, total_deaths, CAST(total_deaths AS float) / CAST(total_cases AS float) * 100 AS Deathrate
FROM Portfolioproject..coviddeath$
where location like'%India%'
ORDER BY 1, 2

--Exploring total_cases_population
SELECT location, date, total_cases, population, CAST(total_deaths AS float) / CAST(total_cases AS float) * 100 AS Deathrate
FROM Portfolioproject..coviddeath$
where location like'%India%'
ORDER BY 1, 2

--Exploring contries with highest infection rate compared to population
SELECT location, 
       MAX(total_cases) AS highest_infectionCount, 
       MAX((total_cases/population))*100 AS percentage_population_infected
FROM Portfolioproject..coviddeath$
WHERE location LIKE '%India%'
GROUP BY location, population
ORDER BY 1, 2

--Countries with highest death rate with population
Select Location, MAX(cast(Total_deaths as int)) as TotalDeathCount
From PortfolioProject..coviddeath$
--Where location like '%states%'
Where continent is not null 
Group by Location
order by TotalDeathCount desc

--Exploring contintents with the highest death count per population
Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
From PortfolioProject..coviddeath$
--Where location like '%states%'
Where continent is not null 
Group by continent
order by TotalDeathCount desc

---- GLOBAL NUMBERS

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From PortfolioProject..coviddeath$
--Where location like '%states%'
where continent is not null 
--Group By date
order by 1,2

-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..coviddeath$ dea
Join PortfolioProject..covidvacciniation$ vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3

-- Using CTE to perform Calculation on Partition By in previous query

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..coviddeath$ dea
Join PortfolioProject..covidvacciniation$ vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac


drop table if exists #PercentPopulationVaccinated 
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)
Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(Bigint,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..coviddeath$ dea
Join PortfolioProject..covidvacciniation$ vac
	On dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null 
--order by 2,3
Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated


 

select*
From PercentPopulationVaccinated



		 










