Silver layer of the project "Will EVs replace petrol in EU?"

-- Create a new staging table "stg_vehicle_stock"

CREATE TABLE stg_vehicle_stock (
    country TEXT,
    year_ INTEGER,
    vehicle_type TEXT,
    count_ INTEGER
);

-- Insert data into "stg_vehicle_stock"

INSERT INTO stg_vehicle_stock (country, year, vehicle_type, count)

SELECT time AS country, 2015 AS year_, 'ev' AS vehicle_type, NULLIF(REGEXP_REPLACE("2015", '[: ]', '', 'g'), '')::integer AS count_
FROM raw_ev_car_sales_stock UNION ALL
SELECT time, 2016, 'ev', NULLIF(REGEXP_REPLACE("2015", '[: ]', '', 'g'), '')::integer FROM raw_ev_car_sales_stock UNION ALL
SELECT time, 2017, 'ev', NULLIF(REGEXP_REPLACE("2015", '[: ]', '', 'g'), '')::integer FROM raw_ev_car_sales_stock UNION ALL
SELECT time, 2018, 'ev', NULLIF(REGEXP_REPLACE("2015", '[: ]', '', 'g'), '')::integer FROM raw_ev_car_sales_stock UNION ALL
SELECT time, 2019, 'ev', NULLIF(REGEXP_REPLACE("2015", '[: ]', '', 'g'), '')::integer FROM raw_ev_car_sales_stock UNION ALL
SELECT time, 2020, 'ev', NULLIF(REGEXP_REPLACE("2015", '[: ]', '', 'g'), '')::integer FROM raw_ev_car_sales_stock UNION ALL
SELECT time, 2021, 'ev', NULLIF(REGEXP_REPLACE("2015", '[: ]', '', 'g'), '')::integer FROM raw_ev_car_sales_stock UNION ALL
SELECT time, 2022, 'ev', NULLIF(REGEXP_REPLACE("2015", '[: ]', '', 'g'), '')::integer FROM raw_ev_car_sales_stock UNION ALL
SELECT time, 2023, 'ev', NULLIF(REGEXP_REPLACE("2015", '[: ]', '', 'g'), '')::integer FROM raw_ev_car_sales_stock UNION ALL
SELECT time, 2024, 'ev', NULLIF(REGEXP_REPLACE("2015", '[: ]', '', 'g'), '')::integer FROM raw_ev_car_sales_stock;

Same pattern for the rest of the vehicle types: petrol, diesel, hybrid_petrol, hybrid_diesel, plugin_petrol, plugin_diesel

SELECT time AS country, 2015 AS year_, 'diesel' AS vehicle_type, NULLIF(REGEXP_REPLACE("2015", '[: ]', '', 'g'), '')::integer AS count_
FROM raw_diesel_excl_hybrid_car_sales_stock UNION ALL
SELECT time, 2016, 'diesel', NULLIF(REGEXP_REPLACE("2015", '[: ]', '', 'g'), '')::integer FROM raw_diesel_excl_hybrid_car_sales_stock UNION ALL
SELECT time, 2017, 'diesel', NULLIF(REGEXP_REPLACE("2015", '[: ]', '', 'g'), '')::integer FROM raw_diesel_excl_hybrid_car_sales_stock UNION ALL
SELECT time, 2018, 'diesel', NULLIF(REGEXP_REPLACE("2015", '[: ]', '', 'g'), '')::integer FROM raw_diesel_excl_hybrid_car_sales_stock UNION ALL
SELECT time, 2019, 'diesel', NULLIF(REGEXP_REPLACE("2015", '[: ]', '', 'g'), '')::integer FROM raw_diesel_excl_hybrid_car_sales_stock UNION ALL
SELECT time, 2020, 'diesel', NULLIF(REGEXP_REPLACE("2015", '[: ]', '', 'g'), '')::integer FROM raw_diesel_excl_hybrid_car_sales_stock UNION ALL
SELECT time, 2021, 'diesel', NULLIF(REGEXP_REPLACE("2015", '[: ]', '', 'g'), '')::integer FROM raw_diesel_excl_hybrid_car_sales_stock UNION ALL
SELECT time, 2022, 'diesel', NULLIF(REGEXP_REPLACE("2015", '[: ]', '', 'g'), '')::integer FROM raw_diesel_excl_hybrid_car_sales_stock UNION ALL
SELECT time, 2023, 'diesel', NULLIF(REGEXP_REPLACE("2015", '[: ]', '', 'g'), '')::integer FROM raw_diesel_excl_hybrid_car_sales_stock UNION ALL
SELECT time, 2024, 'diesel', NULLIF(REGEXP_REPLACE("2015", '[: ]', '', 'g'), '')::integer FROM raw_diesel_excl_hybrid_car_sales_stock;


SELECT time AS country, 2015 AS year_, 'petrol' AS vehicle_type, NULLIF(REGEXP_REPLACE("2015", '[: ]', '', 'g'), '')::integer AS count_
FROM raw_petrol_excl_hybrid_car_sales_stock UNION ALL
SELECT time, 2016, 'petrol', NULLIF(REGEXP_REPLACE("2015", '[: ]', '', 'g'), '')::integer FROM raw_petrol_excl_hybrid_car_sales_stock UNION ALL
SELECT time, 2017, 'petrol', NULLIF(REGEXP_REPLACE("2015", '[: ]', '', 'g'), '')::integer FROM raw_petrol_excl_hybrid_car_sales_stock UNION ALL
SELECT time, 2018, 'petrol', NULLIF(REGEXP_REPLACE("2015", '[: ]', '', 'g'), '')::integer FROM raw_petrol_excl_hybrid_car_sales_stock UNION ALL
SELECT time, 2019, 'petrol', NULLIF(REGEXP_REPLACE("2015", '[: ]', '', 'g'), '')::integer FROM raw_petrol_excl_hybrid_car_sales_stock UNION ALL
SELECT time, 2020, 'petrol', NULLIF(REGEXP_REPLACE("2015", '[: ]', '', 'g'), '')::integer FROM raw_petrol_excl_hybrid_car_sales_stock UNION ALL
SELECT time, 2021, 'petrol', NULLIF(REGEXP_REPLACE("2015", '[: ]', '', 'g'), '')::integer FROM raw_petrol_excl_hybrid_car_sales_stock UNION ALL
SELECT time, 2022, 'petrol', NULLIF(REGEXP_REPLACE("2015", '[: ]', '', 'g'), '')::integer FROM raw_petrol_excl_hybrid_car_sales_stock UNION ALL
SELECT time, 2023, 'petrol', NULLIF(REGEXP_REPLACE("2015", '[: ]', '', 'g'), '')::integer FROM raw_petrol_excl_hybrid_car_sales_stock UNION ALL
SELECT time, 2024, 'petrol', NULLIF(REGEXP_REPLACE("2015", '[: ]', '', 'g'), '')::integer FROM raw_petrol_excl_hybrid_car_sales_stock;


SELECT time AS country, 2015 AS year_, 'hybrid_petrol' AS vehicle_type, NULLIF(REGEXP_REPLACE("2015", '[: ]', '', 'g'), '')::integer AS count_
FROM raw_hybrid_petrol_car_sales_stock UNION ALL
SELECT time, 2016, 'hybrid_petrol', NULLIF(REGEXP_REPLACE("2015", '[: ]', '', 'g'), '')::integer FROM raw_hybrid_petrol_car_sales_stock UNION ALL
SELECT time, 2017, 'hybrid_petrol', NULLIF(REGEXP_REPLACE("2015", '[: ]', '', 'g'), '')::integer FROM raw_hybrid_petrol_car_sales_stock UNION ALL
SELECT time, 2018, 'hybrid_petrol', NULLIF(REGEXP_REPLACE("2015", '[: ]', '', 'g'), '')::integer FROM raw_hybrid_petrol_car_sales_stock UNION ALL
SELECT time, 2019, 'hybrid_petrol', NULLIF(REGEXP_REPLACE("2015", '[: ]', '', 'g'), '')::integer FROM raw_hybrid_petrol_car_sales_stock UNION ALL
SELECT time, 2020, 'hybrid_petrol', NULLIF(REGEXP_REPLACE("2015", '[: ]', '', 'g'), '')::integer FROM raw_hybrid_petrol_car_sales_stock UNION ALL
SELECT time, 2021, 'hybrid_petrol', NULLIF(REGEXP_REPLACE("2015", '[: ]', '', 'g'), '')::integer FROM raw_hybrid_petrol_car_sales_stock UNION ALL
SELECT time, 2022, 'hybrid_petrol', NULLIF(REGEXP_REPLACE("2015", '[: ]', '', 'g'), '')::integer FROM raw_hybrid_petrol_car_sales_stock UNION ALL
SELECT time, 2023, 'hybrid_petrol', NULLIF(REGEXP_REPLACE("2015", '[: ]', '', 'g'), '')::integer FROM raw_hybrid_petrol_car_sales_stock UNION ALL
SELECT time, 2024, 'hybrid_petrol', NULLIF(REGEXP_REPLACE("2015", '[: ]', '', 'g'), '')::integer FROM raw_hybrid_petrol_car_sales_stock;


SELECT time AS country, 2015 AS year_, 'hybrid_diesel' AS vehicle_type, NULLIF(REGEXP_REPLACE("2015", '[: ]', '', 'g'), '')::integer AS count_
FROM raw_hybrid_diesel_car_sales_stock UNION ALL
SELECT time, 2016, 'hybrid_diesel', NULLIF(REGEXP_REPLACE("2015", '[: ]', '', 'g'), '')::integer FROM raw_hybrid_diesel_car_sales_stock UNION ALL
SELECT time, 2017, 'hybrid_diesel', NULLIF(REGEXP_REPLACE("2015", '[: ]', '', 'g'), '')::integer FROM raw_hybrid_diesel_car_sales_stock UNION ALL
SELECT time, 2018, 'hybrid_diesel', NULLIF(REGEXP_REPLACE("2015", '[: ]', '', 'g'), '')::integer FROM raw_hybrid_diesel_car_sales_stock UNION ALL
SELECT time, 2019, 'hybrid_diesel', NULLIF(REGEXP_REPLACE("2015", '[: ]', '', 'g'), '')::integer FROM raw_hybrid_diesel_car_sales_stock UNION ALL
SELECT time, 2020, 'hybrid_diesel', NULLIF(REGEXP_REPLACE("2015", '[: ]', '', 'g'), '')::integer FROM raw_hybrid_diesel_car_sales_stock UNION ALL
SELECT time, 2021, 'hybrid_diesel', NULLIF(REGEXP_REPLACE("2015", '[: ]', '', 'g'), '')::integer FROM raw_hybrid_diesel_car_sales_stock UNION ALL
SELECT time, 2022, 'hybrid_diesel', NULLIF(REGEXP_REPLACE("2015", '[: ]', '', 'g'), '')::integer FROM raw_hybrid_diesel_car_sales_stock UNION ALL
SELECT time, 2023, 'hybrid_diesel', NULLIF(REGEXP_REPLACE("2015", '[: ]', '', 'g'), '')::integer FROM raw_hybrid_diesel_car_sales_stock UNION ALL
SELECT time, 2024, 'hybrid_diesel', NULLIF(REGEXP_REPLACE("2015", '[: ]', '', 'g'), '')::integer FROM raw_hybrid_diesel_car_sales_stock;


SELECT time AS country, 2015 AS year_, 'plugin_diesel' AS vehicle_type, NULLIF(REGEXP_REPLACE("2015", '[: ]', '', 'g'), '')::integer AS count_
FROM raw_plug_in_diesel_car_sales_stock UNION ALL
SELECT time, 2016, 'plugin_diesel', NULLIF(REGEXP_REPLACE("2015", '[: ]', '', 'g'), '')::integer FROM raw_plug_in_diesel_car_sales_stock UNION ALL
SELECT time, 2017, 'plugin_diesel', NULLIF(REGEXP_REPLACE("2015", '[: ]', '', 'g'), '')::integer FROM raw_plug_in_diesel_car_sales_stock UNION ALL
SELECT time, 2018, 'plugin_diesel', NULLIF(REGEXP_REPLACE("2015", '[: ]', '', 'g'), '')::integer FROM raw_plug_in_diesel_car_sales_stock UNION ALL
SELECT time, 2019, 'plugin_diesel', NULLIF(REGEXP_REPLACE("2015", '[: ]', '', 'g'), '')::integer FROM raw_plug_in_diesel_car_sales_stock UNION ALL
SELECT time, 2020, 'plugin_diesel', NULLIF(REGEXP_REPLACE("2015", '[: ]', '', 'g'), '')::integer FROM raw_plug_in_diesel_car_sales_stock UNION ALL
SELECT time, 2021, 'plugin_diesel', NULLIF(REGEXP_REPLACE("2015", '[: ]', '', 'g'), '')::integer FROM raw_plug_in_diesel_car_sales_stock UNION ALL
SELECT time, 2022, 'plugin_diesel', NULLIF(REGEXP_REPLACE("2015", '[: ]', '', 'g'), '')::integer FROM raw_plug_in_diesel_car_sales_stock UNION ALL
SELECT time, 2023, 'plugin_diesel', NULLIF(REGEXP_REPLACE("2015", '[: ]', '', 'g'), '')::integer FROM raw_plug_in_diesel_car_sales_stock UNION ALL
SELECT time, 2024, 'plugin_diesel', NULLIF(REGEXP_REPLACE("2015", '[: ]', '', 'g'), '')::integer FROM raw_plug_in_diesel_car_sales_stock;


SELECT time AS country, 2015 AS year_, 'plugin_petrol' AS vehicle_type, NULLIF(REGEXP_REPLACE("2015", '[: ]', '', 'g'), '')::integer AS count_
FROM raw_plug_in_petrol_car_sales_stock UNION ALL
SELECT time, 2016, 'plugin_petrol', NULLIF(REGEXP_REPLACE("2015", '[: ]', '', 'g'), '')::integer FROM raw_plug_in_petrol_car_sales_stock UNION ALL
SELECT time, 2017, 'plugin_petrol', NULLIF(REGEXP_REPLACE("2015", '[: ]', '', 'g'), '')::integer FROM raw_plug_in_petrol_car_sales_stock UNION ALL
SELECT time, 2018, 'plugin_petrol', NULLIF(REGEXP_REPLACE("2015", '[: ]', '', 'g'), '')::integer FROM raw_plug_in_petrol_car_sales_stock UNION ALL
SELECT time, 2019, 'plugin_petrol', NULLIF(REGEXP_REPLACE("2015", '[: ]', '', 'g'), '')::integer FROM raw_plug_in_petrol_car_sales_stock UNION ALL
SELECT time, 2020, 'plugin_petrol', NULLIF(REGEXP_REPLACE("2015", '[: ]', '', 'g'), '')::integer FROM raw_plug_in_petrol_car_sales_stock UNION ALL
SELECT time, 2021, 'plugin_petrol', NULLIF(REGEXP_REPLACE("2015", '[: ]', '', 'g'), '')::integer FROM raw_plug_in_petrol_car_sales_stock UNION ALL
SELECT time, 2022, 'plugin_petrol', NULLIF(REGEXP_REPLACE("2015", '[: ]', '', 'g'), '')::integer FROM raw_plug_in_petrol_car_sales_stock UNION ALL
SELECT time, 2023, 'plugin_petrol', NULLIF(REGEXP_REPLACE("2015", '[: ]', '', 'g'), '')::integer FROM raw_plug_in_petrol_car_sales_stock UNION ALL
SELECT time, 2024, 'plugin_petrol', NULLIF(REGEXP_REPLACE("2015", '[: ]', '', 'g'), '')::integer FROM raw_plug_in_petrol_car_sales_stock;

----

Add UNIQUE CONSTRAINT to avoid incerting the same data once again

ALTER TABLE stg_vehicle_stock
ADD CONSTRAINT unique_vehicle_stock_record 
UNIQUE (country, year_, vehicle_type);


I used the same queries as above to create stg_vehicle_new_reg - same 7 vehicle types
Also I added UNIQUE CONSTRAINT
