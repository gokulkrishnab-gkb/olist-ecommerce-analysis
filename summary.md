# Olist Marketplace: Business Summary

**Prepared for:** Olist leadership **Data:** about 100k orders, Jan 2017 to Aug 2018 (delivered orders, revenue excludes freight)

## Headline

Olist grew about 9x in 2017 by acquiring new customers, but growth flattened in 2018 because almost no customers come back. Late deliveries affect only about 7% of orders, yet they cut review scores by about 2 points.

## Findings and recommendations

### 1. Growth flattened in 2018

- Monthly revenue rose from 112k (Jan 2017) to 988k (Nov 2017, Black Friday), then stayed between 0.83M and 0.98M through Aug 2018. Year-over-year growth slowed from about 100% (May 2018) to 51% (Aug 2018).
- **Recommendation:** treat 2018's plateau as the baseline, and set growth targets from new levers (retention, new sellers), not from 2017's pace.

### 2. Growth came from more orders, not bigger orders

- Average order value stayed at about 125 to 150 reais throughout. The Black Friday jump was a 63% rise in orders, and December fell 26.5% afterwards.
- **Recommendation:** judge promotions by whether the customers they bring come back, not only by the order spike.

### 3. Almost nobody comes back

- Only 3.0% of customers placed a second order, and 1.81% ordered in a different month. About 0.5% return in the month after their first purchase, with no improvement in later months. The Black Friday 2017 cohort retained no better than other cohorts.
- New customers per month grew from 717 (Jan 2017) to 7,060 (Nov 2017) and then stayed flat at about 5.9k to 6.8k, so flat acquisition explains the flat revenue.
- **Recommendation:** test a post-purchase retention offer (for example a discount on a second order) in an A/B test before rolling it out.

### 4. Late deliveries hurt satisfaction

- 6.77% of orders arrived late, and these average a review score of 2.27, against 4.29 for on-time orders. Late rates are highest in MA (17.4%), CE (13.8%) and BA (12.2%), and RJ alone produces about 23% of all late orders.
- Estimates are conservative: orders typically arrive 10 to 14 days before the estimated date, so late orders are exceptions.
- **Recommendation:** investigate carriers and sellers on routes into RJ and BA first, where fixing delays affects the most orders.

### 5. Some categories depend on a few sellers

- In watches_gifts, the top 3 sellers hold about 47% of category revenue, and in bed_bath_table, 2 sellers hold about 31%. The other top categories are spread out.
- **Recommendation:** monitor these sellers and recruit alternatives in the concentrated categories.

## Caveats

- The review gap shows an association, not proof that lateness causes low scores. Distance, product type and seller may also play a part.
- Sep to Dec 2016 and Sep to Oct 2018 are excluded because they have too few delivered orders.
- 610 products without a category are excluded from category figures.
- Retention figures cover customers who ordered at least once, and later cohorts have had less time to return.

## Where to look

SQL queries: `02_revenue.sql` to `06_delivery.sql`. Charts: `charts/`. Full findings with sources: `README.md`.
