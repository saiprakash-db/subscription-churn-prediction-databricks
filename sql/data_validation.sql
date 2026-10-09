-- KKBOX Subscription Churn & Cohort Retention Analysis
-- Data Validation Queries

-- 1. Validate customer scope
SELECT
    COUNT(*) AS total_customers,
    COUNT(DISTINCT msno) AS unique_customers,
    SUM(CASE WHEN is_churn = 1 THEN 1 ELSE 0 END) AS churned_customers,
    SUM(CASE WHEN is_churn = 0 THEN 1 ELSE 0 END) AS non_churned_customers,
    ROUND(100.0 * AVG(is_churn), 2) AS churn_rate_pct
FROM workspace.kkbox.customer_scope;


-- 2. Validate transaction features
SELECT
    COUNT(*) AS total_customers,
    COUNT(DISTINCT msno) AS unique_customers,
    MIN(transaction_count) AS min_transaction_count,
    MAX(transaction_count) AS max_transaction_count,
    MIN(total_amount_paid) AS min_total_amount_paid,
    MAX(total_amount_paid) AS max_total_amount_paid
FROM workspace.kkbox.transaction_features_ml;


-- 3. Validate final ML dataset
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT msno) AS unique_customers,
    SUM(CASE WHEN is_churn IS NULL THEN 1 ELSE 0 END) AS null_churn_labels,
    SUM(CASE WHEN age IS NULL THEN 1 ELSE 0 END) AS null_age,
    SUM(CASE WHEN city IS NULL THEN 1 ELSE 0 END) AS null_city,
    SUM(CASE WHEN registered_via IS NULL THEN 1 ELSE 0 END) AS null_registered_via,
    SUM(CASE WHEN registration_date IS NULL THEN 1 ELSE 0 END) AS null_registration_date
FROM workspace.kkbox.customer_features_ml;


-- 4. Validate churn distribution
SELECT
    is_churn,
    COUNT(*) AS customer_count,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS percentage
FROM workspace.kkbox.customer_features_ml
GROUP BY is_churn
ORDER BY is_churn;


-- 5. Validate leakage-safe transactions
SELECT
    COUNT(*) AS total_transaction_rows,
    COUNT(DISTINCT msno) AS unique_customers,
    MAX(transaction_date_clean) AS latest_transaction_date
FROM workspace.kkbox.transaction_features_ml;


-- 6. Validate cohort activity summary
SELECT
    signup_cohort,
    customer_count,
    active_customers,
    month_12_activity_rate
FROM workspace.kkbox.cohort_activity_summary
ORDER BY signup_cohort;
