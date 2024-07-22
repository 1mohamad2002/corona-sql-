Select * 

from  CoronaProject..CovidDeaths
where continent is not null


--Select * 
--from [corona project]..Covidvacinations$
--order  by 3,4

-- Select DAta that we are going to using 

--Select location ,date ,total_cases,new_cases,total_deaths
--from [corona project]..covidDeaths$
--order  by 1,2

-- looking at total casses vs total deaths


-- shows likelihood of dying if you had covid in your country 


-- looking at total cases vs population 
--https://youtu.be/qfyynHBFOsM?si=p4yRRPsELq2JL7qY&t=1411

 --AlTER TABLE [CovidDeaths]
 --ALTER COLUMN	[total_deaths] float




-- -- percentage of dying if u had corona 
--Select location,date, total_cases,total_deaths,
--(total_deaths /CAST (total_cases AS FLOAT ))*100 as DeathPercentage
--from CoronaProject..CovidDeaths
--WHERE location like '%States%'
--order by 1,2



---- looking at total cases vs population  what is percentage of peoole got covid 
--Select location,date,total_cases,population,(total_cases/population)*100 AS InfectionPercentage
--from CoronaProject..CovidDeaths
----where location like  '%lebanon%'
-- group by continent
--order by InfectionPercentage DESC


---- looking at countries with Highest infection rare compared to population 
--Select location ,Max(total_cases) as HighestInfectionCount,population,Max((total_cases/population))*100 AS InfectionPercentage
--from CoronaProject..CovidDeaths
--Group by location ,population
--order by InfectionPercentage DESC
	
--	-- showing the countries with hightest death count per population 

-- Select continent,max(cast(total_deaths AS int)) As TotalDeathCount
-- from CoronaProject..CovidDeaths
--  where continent is not   null
-- group by continent
-- order by TotalDeathCount DESC
 


-- -- showing contintents with the highest death count per population
-- Select continent,max(cast(total_deaths AS int)) As TotalDeathCount
-- from CoronaProject..CovidDeaths
--  where continent is not   null
-- group by continent
-- order by TotalDeathCount DESC




-- -- global numbers 

--SELECT 
--    date, 
--    SUM(new_cases) AS TotalCases,
--    SUM(CAST(new_deaths AS INT)) AS TotalDeaths,
--    CASE 
--        WHEN SUM(new_cases) > 0 THEN (SUM(CAST(new_deaths AS INT)) / SUM(new_cases)) * 100
--        ELSE 0 
--    END AS DeathPercentage
--FROM 
--    CoronaProject..CovidDeaths
--WHERE 
--    continent IS NOT NULL
----GROUP BY 
----    date
----ORDER BY 
----    date, TotalCases;

--SELECT 
--    SUM(new_cases) AS TotalCases,
--    SUM(CAST(new_deaths AS INT)) AS TotalDeaths,
--    CASE 
--        WHEN SUM(new_cases) > 0 THEN (SUM(CAST(new_deaths AS INT)) / SUM(new_cases)) * 100
--        ELSE 0 
--    END AS DeathPercentage
--FROM 
--    CoronaProject..CovidDeaths
--WHERE 
--    continent IS NOT NULL;


	-- looking at total population vs vaccinations 

	select  dea.continent,
	 dea.location,
	dea.date,
	dea.population,
	vaci.new_vaccinations,
	SUM(CONVERT (float,vaci.new_vaccinations))OVER (partition by dea.location Order by dea.location,dea.date)  as Rollingpeoplevacinations
	--,(Rollingpeoplevacinations /dea.population) *100
	from CoronaProject..CovidDeaths dea
	join CoronaProject..CovidVacinations vaci

	on dea.location=vaci.location and 
	dea.date= vaci.date
	where dea.continent is not null 
	order by 2,3


	-- use cte 

	with popvsvac(Contient,location,date,population,Rollingpeoplevacinations, new_vaccinations)
	as 
	(
	SELECT  dea.continent,
	 dea.location,
	dea.date,
	dea.population,
	vaci.new_vaccinations,
	SUM(CONVERT (float,vaci.new_vaccinations))OVER (partition by dea.location Order by dea.location,dea.date)  as Rollingpeoplevacinations
	--(Rollingpeoplevacinations /dea.population) *100
	from CoronaProject..CovidDeaths dea
	join CoronaProject..CovidVacinations vaci

	on dea.location=vaci.location 
	and dea.date= vaci.date
	where dea.continent is not null 
	--order by 2,3
	)
	SELECT *,(Rollingpeoplevacinations/population)*100
   
FROM 
    popvsvac
ORDER BY 
    location, date;