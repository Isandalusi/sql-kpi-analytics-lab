-- 1. Monthly GMV, Approval Rate, SLA Breach Rate (>24h), and MoM Growth via LAG()
WITH monthly_metrics AS (
    SELECT
        strftime('%Y-%m', tx_date) AS year_month,
        COUNT(*) AS total_tx,
        SUM(CASE WHEN status = 'Approved' THEN amount_usd ELSE 0 END) AS approved_gmv_usd,
        ROUND(100.0 * SUM(CASE WHEN status = 'Approved' THEN 1 ELSE 0 END) / COUNT(*), 2) AS approval_rate_pct,
        ROUND(100.0 * SUM(CASE WHEN sla_hours > 24 THEN 1 ELSE 0 END) / COUNT(*), 2) AS sla_breach_pct
    FROM transactions
    GROUP BY strftime('%Y-%m', tx_date)
)
SELECT
    year_month,
    total_tx,
    ROUND(approved_gmv_usd, 2) AS approved_gmv_usd,
    approval_rate_pct,
    sla_breach_pct,
    ROUND(
        CASE
            WHEN LAG(approved_gmv_usd) OVER (ORDER BY year_month) > 0
            THEN 100.0 * (approved_gmv_usd - LAG(approved_gmv_usd) OVER (ORDER BY year_month))
                 / LAG(approved_gmv_usd) OVER (ORDER BY year_month)
            ELSE NULL
        END,
        2
    ) AS mom_gmv_growth_pct
FROM monthly_metrics
ORDER BY year_month;

-- 2. Customer Risk & Revenue Ranking using Window Functions
WITH customer_summary AS (
    SELECT
        c.customer_id,
        c.company_name,
        c.segment,
        COUNT(t.tx_id) AS tx_count,
        ROUND(SUM(CASE WHEN t.status = 'Approved' THEN t.amount_usd ELSE 0 END), 2) AS approved_volume_usd,
        SUM(CASE WHEN t.status IN ('Chargeback', 'Declined') THEN 1 ELSE 0 END) AS risk_events,
        ROUND(MAX(t.amount_usd) / NULLIF(AVG(t.amount_usd), 0), 2) AS max_to_avg_ratio
    FROM customers c
    JOIN transactions t ON t.customer_id = c.customer_id
    GROUP BY c.customer_id, c.company_name, c.segment
)
SELECT
    company_name,
    segment,
    tx_count,
    approved_volume_usd,
    risk_events,
    max_to_avg_ratio,
    RANK() OVER (ORDER BY approved_volume_usd DESC) AS revenue_rank
FROM customer_summary
ORDER BY revenue_rank;
