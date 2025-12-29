-- =====================================================
-- US EMISSIONS DASHBOARD | MASTER SQL FILE
-- =====================================================
-- Data Source: EPA emissions data (2023)
-- Platform: Databricks Community Edition
-- Author: Grace Rebeca
-- =====================================================


-- -----------------------------------------------------
-- 1. TOP 10 STATES BY TOTAL EMISSIONS
-- -----------------------------------------------------
SELECT state_abbr,
       SUM(
         CAST(REPLACE(`GHG emissions mtons CO2e`, ',', '') AS DOUBLE)
       ) AS Total_Emissions
FROM emissions_data
GROUP BY state_abbr
ORDER BY Total_Emissions DESC
LIMIT 10;


-- -----------------------------------------------------
-- 2. GEO DATA FOR EMISSIONS MAP
-- -----------------------------------------------------
SELECT latitude,
       longitude,
       `GHG emissions mtons CO2e` AS Emissions
FROM emissions_data;


-- -----------------------------------------------------
-- 3. EMISSIONS PER PERSON (PER CAPITA)
-- -----------------------------------------------------
SELECT county_state_name,
       population,
       CAST(REPLACE(`GHG emissions mtons CO2e`, ',', '') AS DOUBLE)
       / NULLIF(
         CAST(REPLACE(population, ',', '') AS DOUBLE), 0
       ) AS Emissions_Per_Person
FROM emissions_data
ORDER BY Emissions_Per_Person DESC
LIMIT 10;


-- -----------------------------------------------------
-- 4. CONTRIBUTION OF TOP 10 STATES TO TOTAL EMISSIONS
-- -----------------------------------------------------
WITH top10 AS (
  SELECT state_abbr,
         SUM(
           CAST(REPLACE(`GHG emissions mtons CO2e`, ',', '') AS DOUBLE)
         ) AS Total_Emissions
  FROM emissions_data
  GROUP BY state_abbr
  ORDER BY Total_Emissions DESC
  LIMIT 10
)
SELECT
  SUM(Total_Emissions) AS Top10_Emissions,
  (SUM(Total_Emissions) /
    (SELECT
       SUM(
         CAST(REPLACE(`GHG emissions mtons CO2e`, ',', '') AS DOUBLE)
       )
     FROM emissions_data)
  ) * 100 AS Top10_Percentage
FROM top10;


-- -----------------------------------------------------
-- 5. TOP 10 COUNTIES BY TOTAL EMISSIONS
-- -----------------------------------------------------
SELECT county_state_name,
       population,
       CAST(
         REPLACE(`GHG emissions mtons CO2e`, ',', '') AS DOUBLE
       ) AS Total_Emissions
FROM emissions_data
ORDER BY Total_Emissions DESC
LIMIT 10;
