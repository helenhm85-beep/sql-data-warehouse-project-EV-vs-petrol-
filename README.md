
Welcome to the Data Warehouse and Analytics project!

# Will EVs Replace Petrol Cars in the EU? — Automated Data Warehouse

## Project Overview

A modern data warehouse project built to analyse the shift from petrol to electric vehicles across the European Union between 2015 and 2024.

This project covers the full data engineering lifecycle: ingestion, transformation, modeling, and reporting — using real-world data from Eurostat and fuel prices from europa.eu - Weekly Oil Bulletin.

---

## Architecture

This project follows the **Medallion Architecture** with three layers:

| Layer | Name | Description |
|-------|------|-------------|
| 🥉 Bronze | Raw | Raw data as-is from source files. No transformations. |
| 🥈 Silver | Cleaned | Standardised, deduplicated, type-corrected data ready for modelling. |
| 🥇 Gold | Analytics | Aggregated, business-ready data powering reports and dashboards. |

---

## Tech Stack

| Tool | Purpose |
|------|---------|
| PostgreSQL | Data warehouse |
| Python | Data ingestion, pipeline automation |
| Power BI | Analytics dashboard (Gold layer) |
| draw.io | Architecture and schema design |
| GitHub | Version control and documentation |

---

## Data Sources

- **Eurostat** — EV and petrol vehicle registration and stock statistics (CSV), energy prices
- **EAFO** - charging stations in EU countries
- **Europa.eu** — fuel prices across EU countries (Weekly Oil Bulletin)

**Scope:** European Union | 2015–2024

---

## Project Status

🚧 **In progress**

- [x] Architecture design
- [x] Schema design
- [x] Naming conventions defined
- [x] GitHub repository set up
- [x] Bronze layer — raw data ingestion
- [x] Silver layer — cleaning and transformation - in progress (4 of 5 tables done)
- [x] Gold layer — aggregations and data model
- [ ] Power BI dashboard

# Challenges & Lessons Learned

While building the Silver layer I accidentally inserted some data twice. 
Adding a UNIQUE constraint caught it straight away — a good reminder of why these safeguards matter.

In stg_vehicle_stock 'Turkey' was spelled differently 'T urkiye' and 'Turkiye' that UNIQUE CONSTRAINT didn't catch because it looks like 2 different countries to PostgreSQL.
Didn't fix it because it wouldn't affect the Gold layer as Turkiye is not an EU country.

The Eurostat files also needed cleaning before loading (empty columns).

While building the EV-share view in the Gold layer, my registration counts came out inflated. Austria 2015 should have had 1,677 new EV registrations — my view returned 5,031, exactly 3×. Total registrations were tripled too (923,529 instead of 307,843), as were the stock figures. Only the percentages looked right, because the numerator and denominator had both been multiplied by the same factor — so the bug was invisible in the ratios and only showed up in the absolute numbers.

The cause was the join multiplied rows. My ON clause matched on country and year but not on fuel_category, so each registrations row joined to all three stock rows (Electric, Transitional, Combustion) for that country-year, and every count was summed three times. Adding AND nr.fuel_category = vs.fuel_category made the join 1:1 and the numbers correct.

Lesson: a correct row count and plausible-looking percentages are not proof the data is right. This bug passed both. It only surfaced when I checked an absolute value against its source — which is now something I do routinely.

## The 100% EV share

After the join multiplied rows fix, some countries showed 100% EV share in their early years — Bulgaria, Croatia and Czechia from 2015 to 2019, Germany in 2015–2016. That can't be real; nobody was selling only electric cars in 2015.

The cause was upstream. Eurostat didn't publish the combustion breakdown for those country-years, and somewhere between Bronze and Silver the missing values had become 0 — most likely through a COALESCE(SUM(...), 0) that was meant to turn empty groups into zeros but couldn't tell "reported zero" apart from "not reported." With combustion at 0, EV became 100% of a total made up only of EVs.

I fixed it in the share view: the percentage is set to NULL whenever the combustion count for that country-year is 0, so an undefined share reads as a gap rather than a fake 100%. I also added a data_complete boolean flag, which marks the 55 country-years where at least one measure is missing, so the dashboard can filter them out. The proper fix belongs in Silver — keeping the missing values as NULL instead of 0 — which I've noted as future work.

Lesson: COALESCE(..., 0) is convenient but it destroys the difference between zero and missing. That distinction matters the moment you compute a ratio.

## The Netherlands denominator

Building the Power BI dashboard, the Netherlands showed an EV share of ~48% in 2018 — far above every other country. The data_complete flag rated it complete, so at first it looked genuine.

It wasn't. The Netherlands' total registrations for 2018 came to 50,158 — smaller than Luxembourg's and Estonia's, which is impossible for a market of 17 million (the real figure is around 440,000). Most of the fuel-type categories were missing for 2015–2018, so the share was being calculated against roughly 10% of the actual market. From 2019 on the totals are correct (444,000+), so the problem is confined to the early years.

This exposed a blind spot in my data_complete flag: it checks that the combustion count isn't zero, but not that the total is plausible. The Netherlands had a non-zero combustion figure and still a broken total. I scoped the dashboard to 2020–2024 — chosen because the charging data only starts in 2020, and as a side effect it excludes every unreliable pre-2019 vehicle year.

Lesson: a completeness check is only as good as its definition of complete. "Combustion isn't zero" wasn't enough; "the total is in a sane range" would have caught this. Sanity-checking an aggregate against real-world scale catches things no row-level constraint will.

---

## About

Built by **Aliona** — a data professional with a background in reporting and analytics, building hands-on experience in data warehouse design and pipeline development.
