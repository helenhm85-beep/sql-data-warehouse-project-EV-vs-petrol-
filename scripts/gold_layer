Gold Layer transformation

SELECT DISTINCT vehicle_type,
CASE WHEN
	vehicle_type = 'ev' THEN 'Electric'
	WHEN
	vehicle_type IN ('plugin_petrol', 'plugin_diesel') THEN 'Transitional'
	ELSE 'Combustion'
END AS category
FROM stg_vehicle_stock;

SELECT country, year_,
	CASE WHEN vehicle_type = 'ev' THEN 'Electric'
	WHEN vehicle_type IN ('plugin_petrol', 'plugin_diesel') THEN 'Transitional'
	ELSE 'Combustion'
END AS category,
SUM(count_) AS total_vehicles
FROM stg_vehicle_stock
GROUP BY country, year_, category
ORDER BY country, year_;

SELECT country, year_,
	CASE WHEN vehicle_type = 'ev' THEN 'Electric'
	WHEN vehicle_type IN ('plugin_petrol', 'plugin_diesel') THEN 'Transitional'
	ELSE 'Combustion'
END AS category,
COALESCE (SUM(count_), 0) AS total_vehicles
FROM stg_vehicle_stock
GROUP BY country, year_, category
ORDER BY country, year_;

CREATE VIEW gold_vehicle_stock_by_category AS
SELECT
country,
year_,
COALESCE(SUM(count_),0) AS total_stock_vehicles,
CASE WHEN vehicle_type = 'ev' THEN 'Electric'
	WHEN vehicle_type IN ('plugin_petrol', 'plugin_diesel') THEN 'Transitional'
	ELSE 'Combustion'
END AS category
FROM stg_vehicle_stock
GROUP BY country, year_, category
ORDER BY country;

CREATE VIEW gold_vehicle_new_reg AS
SELECT
country,
year_,
COALESCE(SUM(count_), 0) AS total_new_reg_vehicles,
CASE WHEN vehicle_type = 'ev' THEN 'Electric'
	WHEN vehicle_type IN ('plugin_diesel', 'plugin_petrol') THEN 'Transitional'
	ELSE 'Combustion'
END AS category
FROM stg_vehicle_new_reg
GROUP BY country, year_, category
ORDER BY country;

ALTER VIEW gold_vehicle_new_reg RENAME TO gold_vehicle_new_reg_by_category;

Checking each stg_table vs country_mapping to find the missing countries

SELECT DISTINCT nr.country, cm.country_code FROM stg_vehicle_new_reg AS nr
LEFT JOIN country_mapping AS cm
ON nr.country = cm.country_name
WHERE cm.country_code IS NULL;


CREATE OR REPLACE VIEW gold_dim_country AS
SELECT country_name, country_code
FROM country_mapping
ORDER BY country_name;

Move out UK from the gold_dim_country

CREATE OR REPLACE VIEW gold_dim_country AS
SELECT country_name, country_code
FROM country_mapping
WHERE country_code <> 'UK'
ORDER BY country_name;

Check the range of the years in each table

SELECT MAX(year_), MIN(year_) FROM stg_charging_infrastructure;

Create gold_dim_year

CREATE OR REPLACE VIEW gold_dim_year AS
SELECT generate_series (2015, 2025) AS year_;

Create gold_dim_fuel_category

CREATE OR REPLACE VIEW gold_dim_fuel_category AS
SELECT * FROM (VALUES('Electric', 1),('Transitional', 2), ('Combustion', 3))
AS t(fuel_category, sort_order);

Creating the fact tables (right click - scripts - CREATE script)

1. gold_fact_vehicle_stock

-- View: public.gold_vehicle_stock_by_category

-- DROP VIEW public.gold_vehicle_stock_by_category

CREATE OR REPLACE VIEW public.gold_fact_vehicle_stock
 AS
 SELECT dmc.country_name,
 dmc.country_code,
 sv.year_,
  CASE
            WHEN sv.vehicle_type = 'ev'::text THEN 'Electric'::text
            WHEN sv.vehicle_type = ANY (ARRAY['plugin_petrol'::text, 'plugin_diesel'::text]) THEN 'Transitional'::text
            ELSE 'Combustion'::text
        END AS fuel_category,
   COALESCE(sum(sv.count_), 0::bigint) AS total_vehicle_count
   FROM stg_vehicle_stock AS sv
 
   INNER JOIN gold_dim_country AS dmc
   ON sv.country = dmc.country_name
  GROUP BY dmc.country_name, dmc.country_code, sv.year_, (
        CASE
            WHEN sv.vehicle_type = 'ev'::text THEN 'Electric'::text
            WHEN sv.vehicle_type = ANY (ARRAY['plugin_petrol'::text, 'plugin_diesel'::text]) THEN 'Transitional'::text
            ELSE 'Combustion'::text
        END)
  ORDER BY dmc.country_name, dmc.country_code;

2. gold_fact_new_registrations

-- View: public.gold_vehicle_new_reg_by_category

-- DROP VIEW public.gold_vehicle_new_reg_by_category;

CREATE OR REPLACE VIEW public.gold_fact_new_registrations
 AS
 SELECT dmc.country_name,
 dmc.country_code,
    nr.year_,
	CASE
            WHEN nr.vehicle_type = 'ev'::text THEN 'Electric'::text
            WHEN nr.vehicle_type = ANY (ARRAY['plugin_diesel'::text, 'plugin_petrol'::text]) THEN 'Transitional'::text
            ELSE 'Combustion'::text
        END AS fuel_category,
    COALESCE(sum(nr.count_), 0::bigint) AS total_new_reg_vehicles_count
 
   FROM stg_vehicle_new_reg AS nr
   INNER JOIN gold_dim_country AS dmc
   ON nr.country = dmc.country_name
  GROUP BY dmc.country_name, dmc.country_code, nr.year_, (
        CASE
            WHEN nr.vehicle_type = 'ev'::text THEN 'Electric'::text
            WHEN nr.vehicle_type = ANY (ARRAY['plugin_diesel'::text, 'plugin_petrol'::text]) THEN 'Transitional'::text
            ELSE 'Combustion'::text
        END)
  ORDER BY dmc.country_name, dmc.country_code;

ALTER TABLE public.gold_vehicle_new_reg_by_category
    OWNER TO postgres;

3. Create a gold fact view for charging points

CREATE VIEW gold_fact_charging_points AS
SELECT
dmc.country_name,
dmc.country_code,
ci.year_,
ci.ac_points_year,
ci.dc_points_year,
ci.ac_points_year + ci.dc_points_year AS total_points_year
FROM stg_charging_infrastructure AS ci
INNER JOIN gold_dim_country AS dmc
	ON ci.country = dmc.country_name;

Previous query that produces an error in data - ac_points + dc.points with COALESCE resulted in 0, even if there was data for ac or dc points for a country (Malta, Cyprus, France).
Dropped 2 views - gold_charging_readiness (depend on gold_fact_charging_points) and gold_fact_charging_points and recreated them.
CREATE VIEW gold_fact_charging_points AS
SELECT
dmc.country_name,
dmc.country_code,
ci.year_,
ci.ac_points_year,
ci.dc_points_year,
COALESCE(ci.ac_points_year + ci.dc_points_year, 0) AS total_points_year
FROM stg_charging_infrastructure AS ci
INNER JOIN gold_dim_country AS dmc
ON ci.country = dmc.country_name;

4. Create a gold fuel prices view

CREATE VIEW gold_fact_fuel_prices AS
SELECT
dmc.country_name,
dmc.country_code,
fp.year_,
fp.fuel_type,
fp.fuel_price
FROM stg_fuel_prices AS fp
INNER JOIN gold_dim_country AS dmc
ON fp.country = dmc.country_name;

5. Create a gold electricity prices view

CREATE VIEW gold_fact_electricity_prices AS
SELECT
dmc.country_name,
dmc.country_code,
ep.year_,
ep.price AS electricity_price
FROM stg_electricity_prices AS ep
INNER JOIN gold_dim_country AS dmc
ON ep.country = dmc.country_name;


Sanity check if there are any repeated numbers (errors in the previous calculations in Python)

SELECT electricity_price, COUNT(*) FROM gold_fact_electricity_prices
WHERE year_ = 2025
GROUP BY electricity_price
ORDER BY 2 DESC;

6. Create a gold ev ratio view

CREATE VIEW gold_ev_share_by_country_year AS
SELECT
nr.country_name,
nr.country_code,
nr.year_,
SUM(
	CASE WHEN nr.fuel_category = 'Electric' THEN nr.total_new_reg_vehicles_count ELSE 0 END) AS ev_new_reg,
SUM(nr.total_new_reg_vehicles_count) AS total_new_reg,
CASE
	WHEN SUM(CASE WHEN nr.fuel_category = 'Combustion' THEN nr.total_new_reg_vehicles_count ELSE 0 END) = 0
	THEN NULL
	ELSE
ROUND(SUM(
	CASE WHEN nr.fuel_category = 'Electric' THEN nr.total_new_reg_vehicles_count ELSE 0 END)
	/NULLIF (SUM(nr.total_new_reg_vehicles_count),0) *100, 3) END AS pct_ev_new_reg,
SUM(
	CASE WHEN vs.fuel_category = 'Electric' THEN vs.total_vehicle_count ELSE 0 END) AS ev_stock,
SUM(vs.total_vehicle_count) AS total_stock,
CASE
	WHEN SUM(CASE WHEN vs.fuel_category = 'Combustion' THEN vs.total_vehicle_count ELSE 0 END) = 0
	THEN NULL
	ELSE
ROUND(SUM(
	CASE WHEN vs.fuel_category = 'Electric' THEN vs.total_vehicle_count ELSE 0 END)
	/NULLIF (SUM(vs.total_vehicle_count),0) *100 ,3) END AS pct_ev_stock,
SUM(
	CASE WHEN nr.fuel_category = 'Combustion' THEN nr.total_new_reg_vehicles_count ELSE 0 END
) > 0
	AND SUM(
			CASE WHEN vs.fuel_category = 'Combustion' THEN vs.total_vehicle_count ELSE 0 END
	) > 0
AS data_complete
FROM gold_fact_new_registrations AS nr
INNER JOIN gold_fact_vehicle_stock AS vs
ON nr.country_name = vs.country_name AND nr.country_code = vs.country_code AND nr.year_ = vs.year_
AND nr.fuel_category = vs.fuel_category
GROUP BY nr.country_name, nr.country_code, nr.year_;

Lesson to be learned: Austria 2015 electric registrations: the fact table says 1,677. Your view says 5,031. That's exactly 3×. Total new registrations 923,529 is also 3× the true 307,843, and the stock numbers are 3× too. Only the ratios survived, because numerator and denominator were both tripled.

Cause: your ON clause joins on country and year but not on fuel_category. So each registrations row matches all three stock rows for that country-year, and every count gets summed three times. Add AND nr.fuel_category = vs.fuel_category to the ON and the join becomes 1:1.

The lesson worth writing down: the row count was correct, the percentages looked plausible, and the bug was still there. A fan-out join only shows up when you check an absolute number against its source. This will make a good README paragraph.

7. Create a gold_charging_readiness view

CREATE VIEW gold_charging_readiness AS
SELECT
evs.country_name,
evs.country_code,
evs.year_,
evs.ev_stock,
cp.total_points_year,
ROUND(evs.ev_stock/NULLIF(cp.total_points_year, 0),1) AS evs_per_point
FROM gold_ev_share_by_country_year AS evs
INNER JOIN gold_fact_charging_points AS cp
ON evs.country_name = cp.country_name AND evs.country_code = cp.country_code AND evs.year_ = cp.year_;

8. Create VIEW gold_running cost comparison

CREATE VIEW gold_running_cost_comparison AS
SELECT
ep.country_name,
ep.country_code,
ep.year_,
ROUND((petrol.fuel_price * 6.5), 2) AS petrol_cost_100km,
ROUND((diesel.fuel_price * 5.5), 2) AS diesel_cost_100km,
ROUND((ep.electricity_price * 17), 2) AS electricity_cost_100km,
ROUND((petrol.fuel_price * 6.5) / NULLIF(ep.electricity_price * 17, 0), 2) AS petrol_vs_ev_ratio,
ROUND((diesel.fuel_price * 5.5) / NULLIF(ep.electricity_price *17, 0), 2) AS diesel_vs_ev_ratio,
petrol.fuel_price AS petrol_price,
diesel.fuel_price AS diesel_price,
ep.electricity_price
FROM gold_fact_electricity_prices AS ep
INNER JOIN gold_fact_fuel_prices AS petrol
ON ep.country_name = petrol.country_name
AND ep.country_code = petrol.country_code
AND ep.year_ = petrol.year_
AND petrol.fuel_type = 'euro95'
INNER JOIN gold_fact_fuel_prices AS diesel
ON ep.country_name = diesel.country_name
AND ep.country_code = diesel.country_code
AND ep.year_ = diesel.year_
AND diesel.fuel_type = 'diesel';

9. Create view gold_adoption_momentum

CREATE VIEW gold_adoption_momentum AS
SELECT
country_name,
country_code,
year_,
ev_new_reg,
LAG(ev_new_reg) OVER(PARTITION BY country_name ORDER BY year_) AS prev_ev_new_reg,
ROUND((ev_new_reg - LAG(ev_new_reg) OVER(PARTITION BY country_name ORDER BY year_)) /
NULLIF (LAG(ev_new_reg) OVER(PARTITION BY country_name ORDER BY year_), 0) *100, 1)  AS yoy_change
FROM gold_ev_share_by_country_year;
