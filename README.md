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

- Total revenue (delivered orders, excluding freight): about 13.2 million reais.
- Revenue grew roughly 9x from Jan to Nov 2017, with a Black Friday spike in Nov 2017.
- Growth came from order volume, not order value: average order value stayed
  around 125 to 150 reais throughout.
- Revenue is spread across categories: the top 10 categories make up about 62%
  of revenue, and the largest (health_beauty) is only about 9%.
- Most customers buy only once: 96,096 unique customers placed 99,441 orders.

---

- “MoM growth was strong through Nov 2017 (+52% at Black Friday), then flattened in 2018 (about -12% to +15% per month). Source: 03_growth.sql.”

## Project files

- `load_data.py`: loads the Olist CSVs into a SQLite database
- `01_basics.sql`: data exploration queries
- `02_revenue.sql`: revenue, AOV, category and seller queries

## Data

Dataset: "Brazilian E-Commerce Public Dataset by Olist" on Kaggle.
The data is not included in this repo. Download it and place the CSVs in a `data/` folder.

_Work in progress._
