# KKBOX Subscription Churn & Cohort Retention Analysis

A batch data analytics and machine learning project analyzing subscription churn and cohort retention for a music streaming business using the KKBOX dataset.

## Project Overview

This project analyzes customer subscription behavior to understand:

- Customer retention by signup cohort
- Subscription and transaction patterns
- Customer churn behavior
- Customer segmentation
- Features associated with churn
- Churn prediction using machine learning

The project is being developed using Databricks Free Edition with SQL and Python, with GitHub used for project version control and documentation.

## Tech Stack

- Python
- SQL
- PySpark
- Databricks
- Delta Lake
- MLflow
- GitHub
- Machine Learning

## Dataset

The project uses the KKBOX Churn Prediction Challenge dataset.

Source: [KKBOX Churn Prediction Challenge](https://www.kaggle.com/competitions/kkbox-churn-prediction-challenge)

The raw dataset files are not stored in this repository.

## Project Scope

A deterministic 200,000-customer analytical scope was created from the original training population while preserving the original churn distribution.

The selected scope contains:

- 187,215 non-churned customers
- 12,785 churned customers
- 200,000 customers total

## Current Progress

- [x] Dataset selection
- [x] Customer scope creation
- [x] Transaction data validation
- [x] Transaction anomaly investigation
- [x] Clean transaction Delta table
- [ ] Member data cleaning
- [ ] User log processing
- [ ] Feature engineering
- [ ] Cohort and retention analysis
- [ ] Churn prediction
- [ ] Model evaluation
- [ ] MLflow experiment tracking
- [ ] Business insights
- [ ] Final documentation

## Pipeline Approach

The project uses an automated **batch pipeline** approach.

Raw data is processed in Databricks, transformed into analytical tables, and used for SQL analysis, feature engineering, and machine learning.

## Repository Structure

```text
subscription-churn-prediction-databricks/
│
├── README.md
├── data/
├── notebooks/
├── sql/
├── models/
└── docs/
