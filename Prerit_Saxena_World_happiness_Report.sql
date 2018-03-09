/* Project - World Happiness Report */

RETURN;

/* Creating Database */

CREATE DATABASE DM_Project;
USE DM_Project;

/* Checking for the presence of files */

IF OBJECT_ID('dbo.newdata_2015', 'U') IS NOT NULL DROP TABLE dbo.newdata_2015;
IF OBJECT_ID('dbo.newdata_2016', 'U') IS NOT NULL DROP TABLE dbo.newdata_2016;
IF OBJECT_ID('dbo.newdata_2017', 'U') IS NOT NULL DROP TABLE dbo.newdata_2017;

/** DATA LOADING **/

CREATE TABLE dbo.newdata_2015(Country VARCHAR(50) NULL,
							  Region VARCHAR(50) NULL,
							  Happy_rank INT,
							  Happy_score DECIMAL(6,3),
							  Economy DECIMAL(7,5),
							  Family DECIMAL(7,5),
							  Health DECIMAL(7,5),
							  Freedom DECIMAL(7,5),
							  Trust DECIMAL(7,5),
							  Generosity DECIMAL(7,5),
							  Dystopia DECIMAL(7,5))

CREATE TABLE dbo.newdata_2016(Country VARCHAR(50) NULL,
							  Region VARCHAR(50) NULL,
							  Happy_rank INT,
							  Happy_score DECIMAL(6,3),
							  Economy DECIMAL(7,5),
							  Family DECIMAL(7,5),
							  Health DECIMAL(7,5),
							  Freedom DECIMAL(7,5),
							  Trust DECIMAL(7,5),
							  Generosity DECIMAL(7,5),
							  Dystopia DECIMAL(7,5))

CREATE TABLE dbo.newdata_2017(Country VARCHAR(50) NULL,
							  Region VARCHAR(50) NULL,
							  Happy_rank INT,
							  Happy_score DECIMAL(6,3),
							  Economy DECIMAL(7,5),
							  Family DECIMAL(7,5),
							  Health DECIMAL(7,5),
							  Freedom DECIMAL(7,5),
							  Trust DECIMAL(7,5),
							  Generosity DECIMAL(7,5),
							  Dystopia DECIMAL(7,5))
	
/* Adding Data */

INSERT INTO dbo.newdata_2015
SELECT Country, Region, CAST([Happiness Rank] AS INT), CAST([Happiness Score] AS DECIMAL(6,3)), CAST([Economy (GDP per Capita)] AS DECIMAL(7,5)), CAST(Family AS DECIMAL(7,5)), CAST([Health (Life Expectancy)] AS DECIMAL(7,5)), CAST(Freedom AS DECIMAL(7,5)), CAST([Trust (Government Corruption)] AS DECIMAL(7,5)), CAST(Generosity AS DECIMAL(7,5)), CAST([Dystopia Residual] AS DECIMAL(7,5))
FROM dbo.data_2015;

select * from dbo.newdata_2015;

INSERT INTO dbo.newdata_2016
SELECT Country, Region, CAST([Happiness Rank] AS INT), CAST([Happiness Score] AS DECIMAL(6,3)), CAST([Economy (GDP per Capita)] AS DECIMAL(7,5)), CAST(Family AS DECIMAL(7,5)), CAST([Health (Life Expectancy)] AS DECIMAL(7,5)), CAST(Freedom AS DECIMAL(7,5)), CAST([Trust (Government Corruption)] AS DECIMAL(7,5)), CAST(Generosity AS DECIMAL(7,5)), CAST([Dystopia Residual] AS DECIMAL(7,5))
FROM dbo.data_2016;

select * from dbo.newdata_2016;

INSERT INTO dbo.newdata_2017
SELECT Country, Region, CAST([Happiness Rank] AS INT), CAST([Happiness Score] AS DECIMAL(6,3)), CAST([Economy (GDP per Capita)] AS DECIMAL(7,5)), CAST(Family AS DECIMAL(7,5)), CAST([Health (Life Expectancy)] AS DECIMAL(7,5)), CAST(Freedom AS DECIMAL(7,5)), CAST([Trust (Government Corruption)] AS DECIMAL(7,5)), CAST(Generosity AS DECIMAL(7,5)), CAST([Dystopia Residual] AS DECIMAL(7,5))
FROM dbo.data_2017;

select * from dbo.newdata_2017;

/** DATA CLEANING STARTS HERE **/

/* Sanity check for different countries in different tables */
create table dbo.countries(Country VARCHAR(50) NULL,
							  Region VARCHAR(50) NULL);

INSERT INTO DBO.COUNTRIES
select distinct Country, Region
from dbo.newdata_2015
UNION
select distinct Country, Region
from dbo.newdata_2016
UNION
select distinct Country, Region
from dbo.newdata_2017

select * from dbo.countries

/* This count is higher than count of countries from individual tables*/

/* Combining */

CREATE TABLE dbo.combined1(Year INT, Country VARCHAR(50) NULL,
							  Region VARCHAR(50) NULL,
							  Happy_rank INT,
							  Happy_score DECIMAL(6,3),
							  Economy DECIMAL(7,5),
							  Family DECIMAL(7,5),
							  Health DECIMAL(7,5),
							  Freedom DECIMAL(7,5),
							  Trust DECIMAL(7,5),
							  Generosity DECIMAL(7,5),
							  Dystopia DECIMAL(7,5))

INSERT INTO DBO.COMBINED1
select DATEPART(Year, '01/01/2015') as Year, country, region, happy_rank,
	   happy_score, economy, family,
	   health, freedom, trust,
	   generosity, dystopia
from dbo.newdata_2015
UNION
select DATEPART(Year, '01/01/2016') as Year, country, region, happy_rank,
	   happy_score, economy, family,
	   health, freedom, trust,
	   generosity, dystopia
from dbo.newdata_2016
UNION
select DATEPART(Year, '01/01/2017') as Year,country, region, happy_rank,
	   happy_score, economy, family,
	   health, freedom, trust,
	   generosity, dystopia
from dbo.newdata_2017

select * from dbo.combined1

/* Creating final table */

CREATE TABLE dbo.combined2(Year INT, Country VARCHAR(50) NULL,
							  Region VARCHAR(50) NULL,
							  Happy_rank INT,
							  Happy_score DECIMAL(6,3),
							  Economy DECIMAL(7,5),
							  Family DECIMAL(7,5),
							  Health DECIMAL(7,5),
							  Freedom DECIMAL(7,5),
							  Trust DECIMAL(7,5),
							  Generosity DECIMAL(7,5),
							  Dystopia DECIMAL(7,5))

INSERT INTO dbo.combined2
select m.year, m.country, m.region,
	   n.happy_rank, n.happy_score,
	   n.economy, n.family, n.health,
	   n.freedom, n.trust, n.generosity,
	   n.dystopia
from
(
select distinct x.country, x.region, y.year
from
		(select a.country, a.region
		from dbo.newdata_2015 a
		inner join
		dbo.newdata_2016 b
		on a.country = b.country
		inner join
		dbo.newdata_2017 c
		on a.country=c.country) x
	FULL JOIN
		(select distinct year, country
		from dbo.combined1) y
		on x.country = y.country
		where x.country is not null and y.country is not null) m
LEFT JOIN
	dbo.combined1 n
on m.country = n.country and m.year = n.year

select * from dbo.combined2;

/* Aggregated Statistics */

/* Counting the number of rows for each country as sanity check */

select count(*) as num_records
from dbo.combined2
group by country
order by num_records

/* Calculating MAX/MIN and AVG region wise to see 
if there is a differnce between regions */

/* Average */

select Region, avg(Happy_score) as avg_happiness_score,
	   avg(Economy) as avg_Economy,
	   avg(Family) as avg_Family,
	   avg(Health) as avg_Health,
	   avg(Freedom) as avg_Freedom,
	   avg(Trust) as avg_Trust,
	   avg(Generosity) as avg_Generosity,
	   avg(Dystopia) as avg_Dystopia
from dbo.combined2
group by Region

/* Min */

select Region, min(Happy_score) as min_happiness_score, 
	   min(Economy) as min_Economy,
	   min(Family) as min_Family,
	   min(Health) as min_Health,
	   min(Freedom) as min_Freedom,
	   min(Trust) as min_Trust,
	   min(Generosity) as min_Generosity,
	   min(Dystopia) as min_Dystopia
from dbo.combined2
group by Region

/* Max */

select Region, max(Happy_score) as max_happiness_score, 
	   max(Economy) as max_Economy,
	   max(Family) as max_Family,
	   max(Health) as max_Health,
	   max(Freedom) as max_Freedom,
	   max(Trust) as max_Trust,
	   max(Generosity) as max_Generosity,
	   max(Dystopia) as max_Dystopia
from dbo.combined2
group by Region

/* To check if the world has moved ahead in terms of happiness */

/* Taking average over years */

select Year, avg(Happy_score) as avg_happiness_score,
	   avg(Economy) as avg_Economy,
	   avg(Family) as avg_Family,
	   avg(Health) as avg_Health,
	   avg(Freedom) as avg_Freedom,
	   avg(Trust) as avg_Trust,
	   avg(Generosity) as avg_Generosity,
	   avg(Dystopia) as avg_Dystopia
from dbo.combined2
group by Year

