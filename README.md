# Olist E-commerce Analysis

## Business problem

I analysed about 100k orders from Olist, a Brazilian online marketplace
(2016 to 2018), to answer three questions:

1. Where does revenue come from?
2. Are customers coming back?
3. Is delivery performance hurting satisfaction?

## Tools

SQL (SQLite), Python (pandas), Git/GitHub

## Findings so far

**Revenue and growth**

- Total revenue is about 13.2M reais (delivered orders, excluding freight).
  _Source: `02_revenue.sql`, total revenue query._
- Monthly revenue grew almost 9x from Jan 2017 (112k) to Nov 2017 (988k), with a
  Black Friday spike. It then fell 26.5% in December, so the spike was a one-off.
  _Source: `02_revenue.sql`, monthly revenue; `03_growth.sql`, MoM growth._
- Growth came from order volume, not order value. Average order value stayed around
  125 to 150 reais, while the Nov 2017 jump was a 63% rise in orders.
  _Source: `02_revenue.sql`, monthly orders and AOV._
- Growth flattened in 2018: monthly revenue stayed at roughly 0.83M to 0.98M, and
  MoM growth moved between -12% and +15%.
  _Source: `03_growth.sql`, MoM growth._
- Year-over-year growth slowed from about 100% (May 2018) to 51% (Aug 2018). Early
  2018 YoY figures are inflated by the small 2017 base.
  _Source: `03_growth.sql`, YoY growth._
- Cumulative revenue passed 5M in Nov 2017 and 10M in May 2018. The second 5M took
  6 months, against 11 months for the first.
  _Source: `03_growth.sql`, running total._

**Categories and sellers**

- Revenue is spread across categories: the top 10 make up about 62% of revenue, and
  the largest (health_beauty) is about 9%.
  _Source: `02_revenue.sql`, top 10 categories._
- The same 3 categories lead in 2017 and 2018. health_beauty grew fastest (about +60%),
  watches_gifts about +45%, and bed_bath_table stalled (about +8.5%). 2018 covers
  only Jan to Aug, so these are conservative.
  _Source: `04_ranking.sql`, top 3 categories per year._
- Seller risk: in watches_gifts, the top 3 sellers hold about 47% of category revenue,
  and in bed_bath_table, 2 sellers hold about 31%. The other top categories are spread out.
  Overall, the top 10 sellers earn about 13% of total revenue.
  _Source: `04_ranking.sql`, top sellers per category; `02_revenue.sql`, top 10 sellers._
- São Paulo state has the most orders (41,746, about 42% of all orders).
  _Source: `02_revenue.sql`, top states._

**Early signal on retention**

- 96,096 unique customers placed 99,441 orders, suggesting most customers buy once.
  Cohort retention (coming) will measure this properly.
  _Source: `01_basics.sql`._

## Data quality notes

- Data runs from Sep 2016 to Oct 2018. Sep to Dec 2016 is too sparse to use (Nov 2016
  is missing), so trend analysis starts from Jan 2017 and ends at Aug 2018.
- 610 products have no category name (about X% of products). Category analysis
  excludes them. _Source: `01_basics.sql`, data quality checks._
- A few orders have a status that disagrees with their delivery date. These are
  excluded or handled in the delivery analysis. _Source: `01_basics.sql`._

## Project files

- `load_data.py`: loads the Olist CSVs into a SQLite database
- `01_basics.sql`: data exploration queries
- `02_revenue.sql`: revenue, AOV, category and seller queries

## Data

Dataset: "Brazilian E-Commerce Public Dataset by Olist" on Kaggle.
The data is not included in this repo. Download it and place the CSVs in a `data/` folder.

_Work in progress._
