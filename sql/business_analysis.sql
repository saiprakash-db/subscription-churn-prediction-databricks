-- KKBOX Subscription Churn & Cohort Retention Analysis
-- Business Analysis Queries


-- 1. Churn behavior comparison
SELECT
    is_churn,
    COUNT(*) AS customer_count,
    ROUND(AVG(transaction_count), 2) AS avg_transaction_count,
    ROUND(AVG(total_amount_paid), 2) AS avg_total_amount_paid,
    ROUND(AVG(avg_amount_paid), 2) AS avg_amount_paid,
    ROUND(AVG(avg_plan_days), 2) AS avg_plan_days,
    ROUND(
        100.0 * AVG(auto_renew_count / NULLIF(transaction_count, 0)),
        2
    ) AS auto_renew_rate_pct,
    ROUND(
        100.0 * AVG(cancel_count / NULLIF(transaction_count, 0)),
        2
    ) AS cancel_rate_pct
FROM workspace.kkbox.customer_features_ml
GROUP BY is_churn
ORDER BY is_churn;


-- 2. Churn rate by auto-renewal segment
SELECT
    CASE
        WHEN auto_renew_count = transaction_count THEN 'Always'
        WHEN auto_renew_count = 0 THEN 'No Auto-Renew'
        WHEN auto_renew_count > 0 THEN 'Mixed'
        ELSE 'Unknown'
    END AS auto_renew_segment,
    COUNT(*) AS customer_count,
    SUM(is_churn) AS churned_customers,
    ROUND(100.0 * AVG(is_churn), 2) AS churn_rate_pct
FROM workspace.kkbox.customer_features_ml
GROUP BY
    CASE
        WHEN auto_renew_count = transaction_count THEN 'Always'
        WHEN auto_renew_count = 0 THEN 'No Auto-Renew'
        WHEN auto_renew_count > 0 THEN 'Mixed'
        ELSE 'Unknown'
    END
ORDER BY churn_rate_pct DESC;


-- 3. Churn rate by cancellation behavior
SELECT
    CASE
        WHEN cancel_count >= 3 THEN 'High'
        WHEN cancel_count >= 1 THEN 'Moderate'
        ELSE 'No'
    END AS cancellation_segment,
    COUNT(*) AS customer_count,
    SUM(is_churn) AS churned_customers,
    ROUND(100.0 * AVG(is_churn), 2) AS churn_rate_pct
FROM workspace.kkbox.customer_features_ml
GROUP BY
    CASE
        WHEN cancel_count >= 3 THEN 'High'
        WHEN cancel_count >= 1 THEN 'Moderate'
        ELSE 'No'
    END
ORDER BY churn_rate_pct DESC;


-- 4. Cohort churn rates
SELECT
    signup_cohort,
    COUNT(*) AS customer_count,
    SUM(is_churn) AS churned_customers,
    ROUND(100.0 * AVG(is_churn), 2) AS churn_rate_pct
FROM workspace.kkbox.customer_features_ml
GROUP BY signup_cohort
ORDER BY signup_cohort;


-- 5. Month 12 activity by signup cohort
SELECT
    signup_cohort,
    customer_count,
    active_customers,
    month_12_activity_rate
FROM workspace.kkbox.cohort_activity_summary
WHERE signup_cohort BETWEEN '2015-01' AND '2016-02'
ORDER BY signup_cohort;


-- 6. Overall churn summary
SELECT
    COUNT(*) AS total_customers,
    SUM(is_churn) AS churned_customers,
    ROUND(100.0 * AVG(is_churn), 2) AS churn_rate_pct
FROM workspace.kkbox.customer_features_ml;
