# KKBOX Subscription Churn & Cohort Retention Analysis

A batch data analytics and machine learning project that analyzes customer subscription behavior, cohort retention, and churn for a music streaming business using the KKBOX dataset.

The project combines data engineering, SQL analytics, cohort analysis, feature engineering, machine learning, and MLflow experiment tracking in Databricks.

---

## Business Problem

Subscription businesses need to understand why customers stop renewing and which customer behaviors are associated with churn.

This project focuses on three business questions:

1. How does customer retention and churn vary across signup cohorts?
2. Which subscription and transaction behaviors are associated with churn?
3. Can machine learning identify customers with higher churn risk?

The analysis is designed as an **automated batch pipeline**, not a real-time system.

---

## Project Objectives

- Build a reliable analytical customer scope from the KKBOX dataset
- Clean and validate subscription and member data
- Create leakage-safe customer-level features
- Analyze retention and churn across signup cohorts
- Identify behavioral patterns associated with churn
- Train and evaluate churn prediction models
- Track experiments using MLflow
- Translate analytical and ML results into business recommendations

---

## Tech Stack

- **Databricks Free Edition**
- **Python**
- **PySpark**
- **SQL**
- **Spark MLlib**
- **MLflow**
- **Delta Lake**
- **GitHub**

---

## Dataset

This project uses the **KKBOX Churn Prediction Challenge** dataset.

Source: https://www.kaggle.com/competitions/kkbox-churn-prediction-challenge

The original dataset contains customer membership, transaction, and user activity information.

Raw dataset files are not stored in this GitHub repository.

---

## Analytical Scope

A deterministic stratified customer scope of **200,000 customers** was created from the original training population while preserving the original churn distribution.

| Customer Status | Customers |
|---|---:|
| Non-Churn | 187,215 |
| Churn | 12,785 |
| **Total** | **200,000** |

**Overall churn rate: 6.39%**

---

## Batch Data Pipeline

The project follows a structured batch-processing workflow:

```text
Raw KKBOX Data
       │
       ▼
Customer Scope Creation
       │
       ▼
Data Cleaning & Validation
       │
       ▼
Transaction Processing
       │
       ▼
Temporal Leakage Audit
       │
       ▼
Feature Engineering
       │
       ├──────────────► Cohort & Retention Analysis
       │
       ▼
Leakage-Safe ML Dataset
       │
       ▼
Churn Model Training
       │
       ▼
Model Evaluation
       │
       ▼
MLflow Experiment Tracking
       │
       ▼
Business Insights
```

---

## Data Preparation

The project includes separate processing stages for:

- Customer scope creation
- Member data cleaning
- Transaction processing
- User-log processing
- Feature engineering
- Data quality validation
- Temporal leakage auditing

### Member Data

The raw member dataset contained invalid and missing age values.

Invalid ages were converted to null during cleaning, while missing demographic information was preserved rather than dropping affected customers.

A `has_member_data` indicator was also created to distinguish customers with and without member records.

### Transaction Data

The original transaction dataset was audited for:

- Transaction date validity
- Membership expiry dates
- Transactions occurring after expiry
- Customer coverage
- Anomalous timing patterns

The final leakage-safe transaction dataset contained:

**3,172,115 transactions across 200,000 customers.**

---

## Temporal Leakage Prevention

Temporal leakage was treated as an important part of the ML pipeline.

The churn label is associated with the customer's February 2017 membership expiry.

For each customer, transaction records occurring after their label expiry date were excluded from the ML feature set.

Final validation confirmed:

- **200,000 customers**
- **3,172,115 leakage-safe transactions**
- **0 post-expiry transactions**

This ensures that the model features are based only on information available before the churn outcome.

---

## Feature Engineering

Customer-level features were created from historical subscription and transaction behavior.

Examples include:

- Transaction Count
- Total Amount Paid
- Average Amount Paid
- Total Plan Price
- Average Plan Days
- Auto-Renew Count
- Cancellation Count
- Auto-Renew Rate
- Cancellation Rate
- Days Since Last Transaction
- Registration Year
- Registration Month
- Age
- Gender
- Registration Channel

Class weighting was used during model training to account for the imbalance between churned and non-churned customers.

---

# Cohort & Retention Analysis

Customers were grouped into signup cohorts based on their registration month.

The analysis examined:

- Cohort churn rates
- Customer activity over time
- Month 12 activity for cohorts with sufficient history
- Differences between early and later signup cohorts

### Example Cohort Churn Rates

| Signup Cohort | Churn Rate |
|---|---:|
| 2015-01 | 12.30% |
| 2015-02 | 10.57% |
| 2015-03 | 8.83% |
| 2015-07 | 4.86% |
| 2015-09 | 4.81% |
| 2015-10 | 4.30% |

Among the 2015 cohorts analyzed:

- **2015-01 to 2015-06:** average churn rate of **10.36%**
- **2015-07 to 2015-12:** average churn rate of **5.11%**

This indicates meaningful differences in churn behavior across signup cohorts.

---

# Churn Prediction

Two classification models were trained and evaluated:

1. Logistic Regression
2. Random Forest

The models were evaluated using a held-out test set.

## Model Comparison

| Model | ROC-AUC | PR-AUC | Precision | Recall | F1 |
|---|---:|---:|---:|---:|---:|
| Logistic Regression | 0.8845 | 0.3272 | 0.2373 | 0.7720 | 0.3630 |
| **Random Forest** | **0.9465** | **0.5666** | **0.3196** | **0.9137** | **0.4736** |

Random Forest performed better across all reported evaluation metrics and was selected as the stronger model for this project.

### Random Forest Confusion Matrix

| | Predicted Non-Churn | Predicted Churn |
|---|---:|---:|
| Actual Non-Churn | 32,413 | 4,939 |
| Actual Churn | 219 | 2,320 |

---

# Model Feature Importance

The Random Forest model identified the following features as the strongest contributors to model decisions:

| Rank | Feature |
|---:|---|
| 1 | Days Since Last Transaction |
| 2 | Auto-Renew Rate |
| 3 | Cancel Rate |
| 4 | Auto-Renew Count |
| 5 | Cancel Count |
| 6 | Transaction Count |
| 7 | Average Amount Paid |
| 8 | Registered Via |
| 9 | Average Plan Days |
| 10 | Total Amount Paid |

The strongest signals were primarily related to **customer activity and subscription renewal/cancellation behavior**.

Feature importance represents model influence and should not be interpreted as proof of causation.

---

# MLflow Experiment Tracking

MLflow was used to track the model experiments.

Experiment:

```text
/Shared/kkbox-churn-model
```

Tracked information includes:

- Model type
- Hyperparameters
- Training/test split
- Class weighting
- ROC-AUC
- PR-AUC
- Precision
- Recall
- F1 score

The trained Random Forest model was also saved to a Databricks Unity Catalog volume.

---

# Business Insights

## 1. Auto-Renewal Is Strongly Associated With Churn

Customers with no auto-renewal had a:

**31.92% churn rate**

Compared with:

**2.95% churn for customers who always auto-renewed.**

### Business Action

Prioritize customers without auto-renewal for:

- Renewal reminders
- Auto-renewal education
- Retention campaigns
- Easier renewal experiences

---

## 2. Cancellation Behavior Is a Strong Warning Signal

Customers in the high-cancellation segment had an:

**82.37% churn rate**

This is a relatively small segment, so the result should be treated as a strong warning signal rather than a causal conclusion.

### Business Action

Use repeated cancellation behavior as an early retention warning signal.

---

## 3. Auto-Renewal + No Cancellation Represents a Low-Churn Segment

Customers with auto-renewal and no cancellations had a:

**0.60% churn rate**

### Business Action

Protect this segment by maintaining a smooth renewal experience and avoiding unnecessary friction.

---

## 4. Recent Activity Is Important

The strongest Random Forest feature was:

**Days Since Last Transaction**

This suggests that recent subscription activity is an important signal in the model.

### Business Action

Use recent customer activity together with renewal and cancellation behavior when designing churn monitoring strategies.

---

# Key Project Results

| Metric | Result |
|---|---:|
| Analytical Customers | 200,000 |
| Overall Churn Rate | 6.39% |
| Leakage-Safe Transactions | 3,172,115 |
| Random Forest ROC-AUC | 0.9465 |
| Random Forest PR-AUC | 0.5666 |
| Random Forest Recall | 0.9137 |
| Random Forest F1 | 0.4736 |
| No Auto-Renewal Churn | 31.92% |
| High-Cancellation Churn | 82.37% |
| Auto-Renew + No Cancellation Churn | 0.60% |

---

# Repository Structure

```text
subscription-churn-prediction-databricks/
│
├── README.md
│
├── notebooks/
│   ├── 01_create_customer_scope
│   ├── 02_clean_members
│   ├── 03_process_user_logs
│   ├── 04_feature_engineering
│   ├── 05_temporal_leakage_audit
│   ├── 06_build_ml_dataset
│   ├── 07_cohort_retention_analysis
│   ├── 08_train_churn_model
│   ├── 09_model_evaluation_mlflow
│   └── 10_business_insights
│
├── sql/
├── models/
└── docs/
```

---

# Project Limitations

- The project uses a deterministic 200,000-customer analytical scope rather than the complete original training population.
- User-log data was not used as a feature source for the churn ML model because the available extracted user-log file did not provide the required temporal coverage for the February 2017 churn cohort.
- Customer-level churn probability scoring was not included because the exact original training preprocessing pipeline could not be safely reconstructed for full-population scoring.
- Feature importance indicates model influence, not causal relationships.
- The project is an **automated batch analytics and ML pipeline**, not a real-time prediction system.

---

# Project Status

**Core analytics and machine learning pipeline: Complete**

Completed:

- [x] Customer scope creation
- [x] Data cleaning
- [x] Transaction processing
- [x] Temporal leakage audit
- [x] Feature engineering
- [x] Leakage-safe ML dataset
- [x] Cohort analysis
- [x] Retention analysis
- [x] Churn prediction
- [x] Model evaluation
- [x] MLflow tracking
- [x] Business insights

---

# Author

**Sai Prakash Lingala**

B.Tech in Artificial Intelligence  
Aspiring Data Analyst | Data Analytics & Engineering | AI | SQL | Python | Power BI | Databricks

- GitHub: https://github.com/saiprakash-db
- LinkedIn: https://www.linkedin.com/in/sai-prakash-lingala-400854287
