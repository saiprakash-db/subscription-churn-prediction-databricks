# Business Insights

## Overview

This document summarizes the key business insights identified from the 200,000-customer analytical scope used in the KKBOX Subscription Churn & Cohort Retention Analysis project.

The analysis focuses on customer renewal behavior, cancellation behavior, transaction activity, and the main behavioral signals associated with churn.

---

## 1. Auto-Renewal Behavior

Customers without auto-renewal showed a **31.92% churn rate**.

This was substantially higher than the overall churn rate of **6.39%**, making auto-renewal status one of the strongest business signals observed in the analysis.

### Business Recommendation

Prioritize customers without auto-renewal for renewal reminders and targeted retention campaigns.

---

## 2. Cancellation Behavior

Customers in the high-cancellation segment had an **82.37% churn rate**.

Although this segment was relatively small, the high churn rate indicates that repeated cancellation behavior can act as an important warning signal.

### Business Recommendation

Monitor repeated cancellation activity and treat it as an early retention warning signal.

---

## 3. Auto-Renewal and Cancellation Combination

Customers with auto-renewal and no cancellation had a **0.60% churn rate**.

This represents a very low-risk customer segment compared with customers showing weaker renewal behavior.

### Business Recommendation

Maintain a smooth renewal experience for customers who consistently use auto-renewal without cancellation activity.

---

## 4. Key Churn Model Drivers

The Random Forest model identified the following as the top three feature importance drivers:

1. **Days Since Last Transaction**
2. **Auto-Renew Rate**
3. **Cancel Rate**

These results indicate that recent customer activity and renewal-related behavior are important signals for identifying churn risk.

Feature importance indicates model influence and should not be interpreted as proof of causation.

### Business Recommendation

Use recent activity, auto-renewal behavior, and cancellation behavior as key signals when monitoring customer churn.

---

## Key Findings

| Insight Area | Finding | Business Action |
|---|---|---|
| Auto-Renewal | No auto-renewal customers had a 31.92% churn rate | Prioritize renewal reminders and retention campaigns |
| Cancellation | High-cancellation customers had an 82.37% churn rate | Monitor repeated cancellation activity |
| Renewal and Cancellation | Auto-renewal with no cancellation had a 0.60% churn rate | Protect this low-risk customer segment |
| Model Drivers | Days Since Last Transaction, Auto-Renew Rate, and Cancel Rate were the top three Random Forest features | Focus churn monitoring on recent activity and renewal behavior |

---

## Project Context

The analysis was performed as part of a **batch subscription churn and cohort retention project** using Databricks, Python, PySpark, SQL, and machine learning.

The churn model was evaluated using a leakage-safe customer dataset, and the Random Forest model achieved a ROC-AUC of **0.9465** and PR-AUC of **0.5666** on the held-out test set.

The business insights documented here are based on the analysis completed in `10_business_insights.ipynb`.
