FINAL PROJECT: GROUP 11 QUERY LOG

Problem 1: What is the distribution of counties in Indiana based on the presence or absence of ALDI stores?
-- 1: Checking under what top_category and sub_category is ALDI falling
-- ANS: top_category = ”Grocery Stores” 
-- AND sub_category = ”Supermarkets and Other Grocery (except Convenience) Stores”
SELECT 
DISTINCT brand_name, top_category, sub_category
FROM 
`safegraph.brands`
WHERE 
UPPER(brand_name) = "ALDI";


-- 2: Checking for counties in INDIANA having “Supermarkets and Other Grocery (except Convenience) Stores”
-- ANS: Got 83 counties
SELECT 
DISTINCT f.county_fips, f.county
FROM
`safegraph.cbg_fips` f
JOIN
`safegraph.visits` v
ON
SUBSTRING(CAST(v.poi_cbg AS STRING), 1, 2) = f.state_fips
AND SUBSTRING(CAST(v.poi_cbg AS STRING), 3, 3) = f.county_fips
JOIN
`safegraph.brands` b
ON
b.safegraph_brand_id = v.safegraph_brand_ids
WHERE
b.top_category = "Grocery Stores"
AND 
b.sub_category = "Supermarkets and Other Grocery (except Convenience) Stores"
AND 
v.region = "IN";


-- 3: Checking counties in Indiana having ALDI's grocery store
-- ANS: Got 43 counties
SELECT
DISTINCT f.state_fips, f.state, f.county_fips, f.county
FROM
`safegraph.cbg_fips` f
JOIN
`safegraph.visits` v
ON
SUBSTRING(CAST(v.poi_cbg AS STRING), 1, 2) = f.state_fips
AND 
SUBSTRING(CAST(v.poi_cbg AS STRING), 3, 3) = f.county_fips
JOIN
`safegraph.brands` b
ON
b.safegraph_brand_id = v.safegraph_brand_ids
WHERE
b.brand_name = "ALDI"
AND 
v.region = "IN";


-- 4: Checking counties in Indiana not having ALDI's grocery store
-- ANS: Got 40 counties
WITH aldi_counties AS (
-- Getting counties having ALDI's grocery store
-- 43
SELECT
DISTINCT f.county_fips
FROM
`safegraph.cbg_fips` f
JOIN
`safegraph.visits` v
ON
SUBSTRING(CAST(v.poi_cbg AS STRING), 1, 2) = f.state_fips
AND 
SUBSTRING(CAST(v.poi_cbg AS STRING), 3, 3) = f.county_fips
JOIN
`safegraph.brands` b
ON
b.safegraph_brand_id = v.safegraph_brand_ids
WHERE
b.brand_name = "ALDI"
AND v.region = "IN")
SELECT
DISTINCT f.state_fips,
f.state,
f.county_fips,
f.county
FROM
`safegraph.cbg_fips` f
JOIN
`safegraph.visits` v
ON
SUBSTRING(CAST(v.poi_cbg AS STRING), 1, 2) = f.state_fips
AND 
SUBSTRING(CAST(v.poi_cbg AS STRING), 3, 3) = f.county_fips
JOIN
`safegraph.brands` b
ON
b.safegraph_brand_id = v.safegraph_brand_ids
WHERE
b.top_category = "Grocery Stores"
AND 
b.sub_category = "Supermarkets and Other Grocery (except Convenience) Stores"
AND 
b.brand_name != "ALDI"
AND 
v.region = "IN"
AND 
f.county_fips NOT IN (SELECT county_fips FROM aldi_counties);






Problem 2: How do footfall, dwell time, and the number of grocery stores per 100,000 people vary between Indiana counties with and without ALDI stores?
-- 1: FETCHING TOP 5 COUNTIES HAVING PRESENCE OF ALDI STORES BASED ON DWELL_TIME, AVG_MONTHLY_VISITS AND GROCERY_STORE_DENSITY
SELECT
a.county_fips,
a.county,
COUNT(DISTINCT b.safegraph_brand_id) AS distinct_gs,
SUM(d.pop_total) AS total_pop,
ROUND(((SUM(d.pop_total) / COUNT(DISTINCT b.safegraph_brand_id)) / 100000), 1) AS gs_density,
ROUND(AVG(v.raw_visit_counts)) AS avg_monthly_visits,
ROUND(AVG(v.median_dwell)) AS avg_median_dwell,
ROUND((0.7*AVG(v.median_dwell))+(0.3*((SUM(d.pop_total) / COUNT(DISTINCT b.safegraph_brand_id)) / 100000))) AS score
FROM
`safegraph.aldi_counties` a
JOIN
`safegraph.visits` v
ON
SUBSTRING(CAST(v.poi_cbg AS STRING), 1, 2) = a.state_fips
AND 
SUBSTRING(CAST(v.poi_cbg AS STRING), 3, 3) = a.county_fips
JOIN
`team11-fa24-mgmt58200-final.safegraph.brands` b
ON
b.safegraph_brand_id = v.safegraph_brand_ids
AND 
b.top_category = "Grocery Stores"
AND 
b.sub_category = "Supermarkets and Other Grocery (except Convenience) Stores"
JOIN
`safegraph.cbg_demographics` d
ON
SUBSTRING(CAST(d.cbg AS STRING), 1, 2) = a.state_fips
AND 
SUBSTRING(CAST(d.cbg AS STRING), 3, 3) = a.county_fips
GROUP BY 
1,2
HAVING
avg_median_dwell > 25 AND avg_monthly_visits > 600
ORDER BY
8 DESC
LIMIT 5;


-- 2: FETCHING TOP 5 COUNTIES NOT HAVING PRESENCE OF ALDI STORES BASED ON DWELL_TIME, AVG_MONTHLY_VISITS AND GROCERY_STORE_DENSITY
SELECT
na.county_fips,
na.county,
COUNT(DISTINCT b.safegraph_brand_id) AS distinct_gs,
SUM(d.pop_total) AS total_pop,
ROUND(((SUM(d.pop_total) / COUNT(DISTINCT b.safegraph_brand_id)) / 100000),1) AS gs_density,
ROUND(AVG(v.raw_visit_counts)) AS avg_monthly_visit,
ROUND(AVG(v.median_dwell)) AS avg_median_dwell,
ROUND((0.7*AVG(v.raw_visit_counts))+(0.3*((SUM(d.pop_total) / COUNT(DISTINCT b.safegraph_brand_id)) / 100000))) AS score
FROM
`safegraph.non_aldi_counties` na
JOIN
`safegraph.visits` v
ON
SUBSTRING(CAST(v.poi_cbg AS STRING), 1, 2) = na.state_fips
AND 
SUBSTRING(CAST(v.poi_cbg AS STRING), 3, 3) = na.county_fips
JOIN
`safegraph.brands` b
ON
b.safegraph_brand_id = v.safegraph_brand_ids
AND 
b.top_category = "Grocery Stores"
AND 
b.sub_category = "Supermarkets and Other Grocery (except Convenience) Stores"
JOIN
`safegraph.cbg_demographics` d
ON
SUBSTRING(CAST(d.cbg AS STRING), 1, 2) = na.state_fips
AND 
SUBSTRING(CAST(d.cbg AS STRING), 3, 3) = na.county_fips
GROUP BY 1,2
HAVING
(avg_median_dwell > 10 
AND 
-- "<120" to filter out wrongly populated 323 dwell_time record
avg_median_dwell < 120) 
AND 
avg_monthly_visit > 600 AND gs_density > 1.2
ORDER BY 
8 DESC
LIMIT 5;


Problem 3: Which counties (both with and without existing ALDI stores) in Indiana have a high average weighted household income?
-- 1: Creating Weighted Average Income for all Counties in Indiana
WITH all_indiana_counties AS (
-- All counties in Indiana (both with and without ALDI)
SELECT
DISTINCT f.county_fips,
f.county
FROM
`safegraph.cbg_fips` f
LEFT JOIN
`safegraph.visits` v
ON
SUBSTRING(CAST(v.poi_cbg AS STRING), 1, 2) = f.state_fips
AND 
SUBSTRING(CAST(v.poi_cbg AS STRING), 3, 3) = f.county_fips
LEFT JOIN
`safegraph.brands` b
ON
b.safegraph_brand_id = v.safegraph_brand_ids
WHERE
f.state_fips = '18' -- Indiana FIPS 
)
SELECT c.county_fips, 
       c.county, 
       -- Weighted average income calculation
SUM(d.inc_lt10 * 5000 + d.`inc_10-15` * 12500 + d.`inc_15-20` * 17500 + 
d.`inc_20-25` * 22500 + d.`inc_25-30` * 27500 + d.`inc_30-35` * 32500 + 
d.`inc_35-40` * 37500 + d.`inc_40-45` * 42500 + d.`inc_45-50` * 47500 + 
d.`inc_50-60` * 55000 + d.`inc_60-75` * 67500 + d.`inc_75-100` * 87500 + 
d.`inc_100-125` * 112500 + d.`inc_125-150` * 137500 + 
d.`inc_150-200` * 175000 + d.inc_gte200 * 225000) / SUM(d.inc_lt10 + 
d.`inc_10-15` + d.`inc_15-20` + d.`inc_20-25` + d.`inc_25-30` + 
d.`inc_30-35` + d.`inc_35-40` + d.`inc_40-45` + d.`inc_45-50` + 
d.`inc_50-60` + d.`inc_60-75` + d.`inc_75-100` + d.`inc_100-125` + 
d.`inc_125-150` + d.`inc_150-200` + d.inc_gte200) AS weighted_avg_income
FROM 
all_indiana_counties c
JOIN 
`safegraph.cbg_demographics` d
ON 
SUBSTRING(CAST(d.cbg AS STRING), 1, 2) = '18’	-- Indiana STATE_FIPS code
AND 
SUBSTRING(CAST(d.cbg AS STRING), 3, 3) = c.county_fips
GROUP BY 
c.county_fips, c.county
ORDER BY 
weighted_avg_income ASC;


-- 2: Combine ALDI and non-ALDI counties, retain all values
DROP TABLE IF EXISTS 
`safegraph.combined_top_counties`;
CREATE TABLE 
`safegraph.combined_top_counties` AS 
(
SELECT t1.*, 
        1 as aldi_flag 
FROM `safegraph.aldi_top_counties` as t1 -- Output from Problem 2 Query 1

UNION ALL 

SELECT t2.*, 
        0 as aldi_flag 
FROM `safegraph.non_aldi_top_counties` AS t2 -- Output from Problem 2 Query 2
);

-- 3: Final join with the weighted average income table based on county_fips
-- OUTPUT: Ranked list of 10 Counties (5 for each ALDI and non-ALDI) in both categories 
DROP TABLE IF EXISTS
`safegraph.top_counties_with_income_ranked`;

CREATE TABLE
`safegraph.top_counties_with_income_ranked` AS
(
SELECT
c.county_fips,
c.county,
c.distinct_gs,
c.total_pop,
c.gs_density,
c.avg_monthly_visits,
c.avg_median_dwell,
c.score,
c.aldi_flag,
i.weighted_avg_income,
-- Ranking the combined table for ALDI and non-ALDI stores as per the average weighted income per capita
RANK() OVER (PARTITION BY aldi_flag ORDER BY i.weighted_avg_income DESC) AS rn 
FROM
`safegraph.combined_top_counties` c
LEFT JOIN
`safegraph.Avg_wtd_inc_by_county` i
ON
c.county_fips = i.county_fips
ORDER BY
i.weighted_avg_income DESC
);


Problem 4: Which of the identified high-income counties (both with and without ALDI stores) exhibit the most consistent and highest foot traffic throughout the week?

-- 1: Fetching the footfall by day of week from the visits table for top 5 ALDI and non-ALDI counties
DROP TABLE IF EXISTS
`safegraph.weekly_popularity_IN_agg`;
CREATE TABLE
`safegraph.weekly_popularity_IN_agg` AS
SELECT
SUBSTRING(CAST(poi_cbg AS STRING), 3, 3) AS county_fips,
ROUND(AVG(CAST(JSON_EXTRACT_SCALAR(popularity_by_day, '$.Monday') AS INT64))) AS total_monday,
ROUND(AVG(CAST(JSON_EXTRACT_SCALAR(popularity_by_day, '$.Tuesday') AS INT64))) AS total_tuesday,
ROUND(AVG(CAST(JSON_EXTRACT_SCALAR(popularity_by_day, '$.Wednesday') AS INT64))) AS total_wednesday,
ROUND(AVG(CAST(JSON_EXTRACT_SCALAR(popularity_by_day, '$.Thursday') AS INT64))) AS total_thursday,
ROUND(AVG(CAST(JSON_EXTRACT_SCALAR(popularity_by_day, '$.Friday') AS INT64))) AS total_friday,
ROUND(AVG(CAST(JSON_EXTRACT_SCALAR(popularity_by_day, '$.Saturday') AS INT64))) AS total_saturday,
ROUND(AVG(CAST(JSON_EXTRACT_SCALAR(popularity_by_day, '$.Sunday') AS INT64))) AS total_sunday
FROM
`safegraph.visits`
WHERE
region='IN'
GROUP BY
SUBSTRING(CAST(poi_cbg AS STRING), 3, 3);

-- 2: Fetching day-of-week traffic into top 5 ALDI and non-ALDI table and taking top 3 in each ALDI and non-ALDI category
-- Output: 3 Counties in each category (ALDI and non-ALDI)
-- From top 6, based on our analysis, we selected ‘Tippecanoe County’ from ALDI category and ‘Morgan County’ from NON-ALDI category as most suitable from a business expansion standpoint.
DROP TABLE IF EXISTS 
`safegraph.top_3_hinc_weekly_popularity_temp`;

CREATE TABLE
`safegraph.top_3_hinc_weekly_popularity_temp` AS
SELECT
a.*,
b.total_monday,
b.total_tuesday,
b.total_wednesday,
b.total_thursday,
b.total_friday,
b.total_saturday,
b.total_sunday
FROM
safegraph.top_counties_with_income_ranked AS a
INNER JOIN
safegraph.weekly_popularity_IN_agg AS b
ON
a.county_fips=b.county_fips
AND 
a.rn IN (1,2,3);


Problem 5: Which major cities in the identified counties present optimal conditions for establishing a new ALDI store based on demographic and economic factors? 
-- 1: Selecting relevant data for all the cities present in the selected counties – Tippecanoe (county_fips=157) and Morgan (county_fips=109) to make an informed data-driven business decision
-- INFERENCE: For Morgan County – ‘Monrovia' has highest avg income 91k, highest population - 11.7 million, an avg visits count - 235, median dwell time - 77 minutes. Hence, a new store should be opened in Monrovia.
-- For Tippecanoe County - West Lafayette and Lafayette have the highest population but ‘West Lafayette’ has higher gs denisty and dwell time. Therefore, West Lafayette should be the target city for business expansion.

SELECT
hinc.county,
v.city,
ROUND(cw.weighted_avg_income) AS avg_income,
ROUND(AVG(v.raw_visit_counts)) AS avg_visits_count,
ROUND(AVG(v.median_dwell)) AS avg_median_dwell,
COUNT(DISTINCT b.safegraph_brand_id) AS distinct_gs,
SUM(d.pop_total) AS total_pop,
ROUND(((SUM(d.pop_total) / (COUNT(DISTINCT b.safegraph_brand_id))) / 100000),1) AS gs_density,
ROUND((0.7*AVG(v.raw_visit_counts))+(0.3*((SUM(d.pop_total) / (COUNT(DISTINCT b.safegraph_brand_id))) / 100000))) AS score
-- COUNT(DISTINCT safegraph_brand_id) AS distinct_gs,
FROM
`safegraph.top_3_hinc_weekly_popularity_temp` hinc
JOIN
`safegraph.visits` v
ON
SUBSTRING(CAST(v.poi_cbg AS STRING), 3, 3) = hinc.county_fips
AND 
SUBSTRING(CAST(v.poi_cbg AS STRING), 1, 2) = "18"
LEFT JOIN
`team11-fa24-mgmt58200-final.safegraph.brands` b
ON
b.safegraph_brand_id = v.safegraph_brand_ids
LEFT JOIN
`safegraph.cbg_demographics` d
ON
SUBSTRING(CAST(d.cbg AS STRING), 1, 2) = "18"
AND 
SUBSTRING(CAST(d.cbg AS STRING), 3, 3) = hinc.county_fips
LEFT JOIN
`safegraph.city_wt_avg` cw
ON
cw.city = v.city
WHERE
SUBSTRING(CAST(v.poi_cbg AS STRING), 3, 3) IN ("109","157")
GROUP BY 
1, 2, 3
HAVING 
distinct_gs !=0
ORDER BY 1;

