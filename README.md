
Welcome to the Data Warehouse and Analytics project!

# Will EVs Replace Petrol Cars in the EU? — Automated Data Warehouse

## Project Overview

A modern data warehouse project built to analyse the shift from petrol to electric vehicles across the European Union between 2015 and 2024.

This project covers the full data engineering lifecycle: ingestion, transformation, modeling, and reporting — using real-world data from Eurostat and energy price APIs.

---

## Architecture

This project follows the **Medallion Architecture** with three layers:

| Layer | Name | Description |
|-------|------|-------------|
| 🥉 Bronze | Raw | Raw data as-is from source files and APIs. No transformations. |
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

Notes:
While building the Silver layer I accidentally inserted some data twice. 
Adding a UNIQUE constraint caught it straight away — a good reminder of why these safeguards matter.

In stg_vehicle_stock 'Turkey' was spelled differently 'T urkiye' and 'Turkiye' that UNIQUE CONSTRAINT didn't catch because it looks like 2 different countries to PostgreSQL.
Didn't fix it because it wouldn't affect the Gold layer as Turkiye is not an EU country.

The Eurostat files also needed cleaning before loading (empty columns).

---

## About

Built by **Aliona** — a data professional with a background in reporting and analytics, building hands-on experience in data warehouse design and pipeline development.
