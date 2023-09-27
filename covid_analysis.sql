select *
from portfolio_project..coviddata
where continent is not null
order by 3,4

--select data we are going to use
select location, date, total_cases, new_cases, total_deaths, population
from portfolio_project..coviddata
where continent is not null
order by 1,2

-- looking at total cases vs total deaths
-- shows likelihood of dying if you contract covid in your country
select location, date, (cast(total_cases as int)) as total_cases, cast(total_deaths as int) AS total_deaths, (cast(total_deaths as int)/total_cases)*100 as death_percentage
from portfolio_project..coviddata
where location like '%greece%'
order by 1,2

-- looking at total cases vs population
-- shows what percentage of population go covid
select location, date, population, total_cases, (total_cases/population)*100 as percent_of_population_infected
from portfolio_project..coviddata
where location like '%greece%'
order by 1,2

--for map chart use
select location, date, population, total_cases, (total_cases/population)*100 as percent_of_population_infected
from portfolio_project..coviddata
where continent is not null
order by 1,2

--looking at countries with highest infection rate compared to population
select location, population, MAX(total_cases) as highest_infection_count, MAX(total_cases/population)*100 as percent_of_population_infected
from portfolio_project..coviddata
where continent is not null
group by location, population
order by percent_of_population_infected desc

--showing countries with the highest death count per population
select location, max(cast(total_deaths as int)) as total_deaths_count
from portfolio_project..coviddata
where continent is not null
group by location
order by total_deaths_count desc

--break things down by continent
select continent, max(cast(total_deaths as int)) as total_deaths_count
from portfolio_project..coviddata
where continent is not null
group by continent
order by total_deaths_count desc

-- showing continent with the highest death count per population
select continent, max(cast(total_deaths as int)) as total_deaths_count
from portfolio_project..coviddata
where continent is not null
group by continent
order by total_deaths_count desc



--total global numbers

select SUM(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as death_percentage
from portfolio_project..coviddata
where continent is not null
order by 1,2

--looking at total population vs vaccinations

select dea.continent , dea.location, dea.date, dea.population, vac.daily_vaccinations, vac.people_vaccinated, (vac.people_vaccinated/population)*100 as vaccination_percentage
from portfolio_project..coviddata dea
join portfolio_project..vaccinations$ vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3

-- creating table
drop table if exists #percent_population_vaccinated
create table #percent_population_vaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
daily_vaccinations numeric,
people_vaccinated numeric
)


insert into #percent_population_vaccinated
select dea.continent , dea.location, dea.date, dea.population, vac.daily_vaccinations, vac.people_vaccinated
from portfolio_project..coviddata dea
join portfolio_project..vaccinations$ vac
	on dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null

select * , (people_vaccinated/population)*100 as vaccination_percentage
from #percent_population_vaccinated

--creating view to store data for later visualizations
create view percent_population_vaccinated
select dea.continent , dea.location, dea.date, dea.population, vac.daily_vaccinations, vac.people_vaccinated
from portfolio_project..coviddata dea
join portfolio_project..vaccinations$ vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null

select *
from percent_population_vaccinated

select location, date, population, total_deaths_per_million, total_vaccinations
from portfolio_project..coviddata
where location like '%greece%'
order by 1,2