# Lending Club Credit Risk Analysis & Expected Loss Estimation

### End-to-End Financial Data Analytics Project | Python • Oracle SQL • Power BI

## 1. Project Overview

This project focuses on analyzing Lending Club's historical loan portfolio to understand credit risk, identify the factors associated with loan defaults, estimate credit losses, and evaluate the relationship between lending risk and portfolio profitability.

The project uses historical loan data from Lending Club, a peer-to-peer lending platform. The analysis combines Python-based exploratory data analysis, Oracle SQL business queries, financial risk calculations, and Power BI reporting to transform raw financial data into actionable business insights.

Rather than focusing only on descriptive statistics, this project examines practical financial questions:

* How much credit risk does the portfolio contain?
* Which credit grades contribute most to defaults and financial losses?
* How does loan duration affect default risk?
* Are higher interest rates sufficient to compensate for higher credit risk?
* How do borrower characteristics relate to repayment outcomes?
* Which borrower segments contribute disproportionately to portfolio losses?
* How can lenders improve credit assessment, pricing, and portfolio management?

The main objective is to demonstrate how data analytics can support credit risk assessment, lending strategy, portfolio monitoring, and financial decision-making.

## 2. Business Problem

Lending institutions must balance profitability with the risk of borrowers failing to repay their loans.

Approving more loans can increase interest income and expand the portfolio. However, if the lender accepts too many high-risk borrowers or sets interest rates that do not adequately compensate for potential losses, the portfolio may become less profitable.

The main business challenge is therefore not simply to identify borrowers who may default. It is to understand the financial consequences of lending to different customer segments.

This project investigates several interconnected problems:

**Credit risk identification:** Which borrower and loan characteristics are associated with higher default rates?

**Portfolio concentration:** Which credit grades, loan durations, purposes, and geographical segments contribute most to total losses?

**Risk-based pricing:** Do the interest rates charged adequately compensate for the observed credit risk?

**Expected loss estimation:** How much principal remains unpaid after defaults, and how much is recovered?

**Portfolio profitability:** Which segments appear more attractive when comparing their historical credit losses with lending income?

**Lending strategy:** How can a lender improve its approval criteria, loan pricing, monitoring, and risk diversification?

The analysis is designed to provide evidence for these decisions using historical data rather than assumptions alone.

## 3. Dataset

**Dataset:** Lending Club Loan Data
**Source:** Kaggle

Dataset: https://www.kaggle.com/wordsforthewise/lending-club

The project uses the historical `accepted_2007_to_2018Q4.csv` dataset.

The original file contains approximately 2.26 million records and information about loan characteristics, borrower financial profiles, credit history, loan performance, and repayments.

### Main Dataset Variables

| Variable              | Description                                        |
| --------------------- | -------------------------------------------------- |
| `id`                  | Unique loan identifier                             |
| `loan_amnt`           | Original loan amount                               |
| `term`                | Loan duration in months                            |
| `int_rate`            | Annual interest rate                               |
| `installment`         | Scheduled monthly loan payment                     |
| `grade`               | Lending Club credit risk grade                     |
| `sub_grade`           | More detailed credit risk classification           |
| `issue_d`             | Loan issuance date                                 |
| `loan_status`         | Recorded loan outcome or current status            |
| `purpose`             | Purpose of the loan                                |
| `annual_inc`          | Reported annual borrower income                    |
| `verification_status` | Income verification category                       |
| `home_ownership`      | Borrower's home ownership status                   |
| `dti`                 | Debt-to-income ratio                               |
| `fico_range_low`      | Lower FICO score bound                             |
| `fico_range_high`     | Upper FICO score bound                             |
| `delinq_2yrs`         | Recorded delinquencies over the previous two years |
| `inq_last_6mths`      | Credit inquiries during the previous six months    |
| `revol_bal`           | Revolving credit balance                           |
| `revol_util`          | Revolving credit utilization                       |
| `total_acc`           | Total credit accounts                              |
| `total_pymnt`         | Total payments recorded for the loan               |
| `total_rec_prncp`     | Total principal received                           |
| `recoveries`          | Amount recovered following a default or charge-off |

These variables provide the foundation for examining the relationships between borrower characteristics, lending conditions, repayment behavior, and financial losses.

## 4. Tools and Technologies

### Python

Used for data cleaning, feature engineering, exploratory data analysis, statistical comparisons, financial calculations, and visualizations.

Libraries:

* Pandas
* NumPy
* Matplotlib
* Seaborn
* Jupyter Notebook

### Oracle SQL

Used for structured financial analysis, portfolio aggregation, risk segmentation, time-series analysis, Expected Loss calculations, profitability comparisons, and business-oriented queries.

### Power BI

Used as the reporting and visualization layer to present credit risk indicators and communicate analytical results in a business-friendly format.

### Data Source

Kaggle Lending Club historical loan dataset.

## 5. Project Architecture

The project follows an end-to-end analytical workflow:

```text
Lending Club Historical Dataset
              |
              v
       Python / Pandas
              |
              v
      Data Cleaning and
      Feature Engineering
              |
              v
   Exploratory Data Analysis
      and Risk Analysis
              |
              v
    Expected Loss Analysis
    and Profitability Study
              |
              v
       Cleaned CSV Export
              |
              v
         Oracle SQL
              |
              v
       Business Queries
     and Financial Metrics
              |
              v
          Power BI
              |
              v
   Risk Monitoring, Business
     Insights and Decisions
```

The workflow combines data preparation, quantitative analysis, database querying, and business reporting.

## 6. Python Analysis

**Notebook:** `credit_risk_eda_expected_loss.ipynb.ipynb`

Python was used to prepare the dataset, investigate borrower and loan characteristics, measure default patterns, estimate historical credit losses, and create visualizations.

### 6.1 Data Loading and Initial Inspection

The analysis begins by importing the required Python libraries and loading selected columns from the original CSV file.

Instead of loading every available variable, the notebook selects 31 relevant columns covering loan characteristics, borrower financial information, credit history, loan outcomes, and repayment data.

The initial dataset contains approximately 2,260,701 rows.

The first inspection examines:

* Dataset dimensions.
* Column names and data types.
* Initial records.
* Loan status distribution.
* Missing values.
* Variables required for subsequent analysis.

This stage establishes the structure of the dataset before any financial calculations are performed.

### 6.2 Data Cleaning

The cleaning process addresses several data quality issues.

**Loan identifier validation**

Records with non-numeric loan identifiers are removed to ensure that loan IDs can be used consistently.

**Loan outcome filtering**

The analysis distinguishes between loans with recorded repayment outcomes and loans whose final outcomes are not yet established.

The notebook maps the following outcomes:

* `Fully Paid` → 0
* `Charged Off` → 1
* `Default` → 1

Two legacy status categories are also mapped according to their recorded outcomes.

Current and other unresolved statuses are excluded from this binary outcome analysis.

The resulting analytical dataset contains 1,348,099 records.

**Data type conversion**

The `term` column is converted into a numeric duration in months.

Interest rates and revolving credit utilization are converted into numeric values.

Loan issuance dates and earliest credit history dates are converted into datetime format.

**Missing value treatment**

Missing numerical values are filled using column medians, while missing categorical values are assigned an `Unknown` category.

The notebook also checks for duplicate loan IDs.

The final cleaning check reports zero duplicate IDs and 29 remaining missing values, primarily associated with date information.

**Outlier treatment**

Annual income and revolving credit balances are capped at their respective 99.5th percentiles.

This reduces the influence of extreme observations on descriptive statistics and visual comparisons.

These decisions improve consistency, although they should be documented and tested before building a production credit risk model.

### 6.3 Feature Engineering

Several additional variables are created to make the data more useful for financial analysis.

| Feature                 | Calculation or Definition                                      | Analytical Purpose                                      |
| ----------------------- | -------------------------------------------------------------- | ------------------------------------------------------- |
| `default`               | Binary loan outcome indicator                                  | Distinguishes recorded defaults from fully repaid loans |
| `issue_year`            | Year extracted from `issue_d`                                  | Supports annual portfolio and risk analysis             |
| `credit_history_years`  | Time between loan issuance and earliest recorded credit line   | Measures the approximate length of credit history       |
| `fico_avg`              | Average of FICO range boundaries                               | Creates a single numerical credit score indicator       |
| `emp_length_num`        | Numeric representation of employment length                    | Enables analysis by employment experience               |
| `loan_to_income`        | Loan amount / annual income                                    | Measures loan size relative to income                   |
| `installment_to_income` | Annual scheduled installments / annual income                  | Approximates the scheduled loan payment burden          |
| `unpaid_principal`      | Original loan amount minus principal received, floored at zero | Provides a simplified unpaid-principal proxy            |
| `net_loss`              | Unpaid-principal proxy minus recoveries for defaulted loans    | Estimates historical unrecovered principal              |
| `profit`                | Total recorded payments minus original loan amount             | Provides a simplified gross cash-flow margin proxy      |

Feature engineering makes it possible to compare borrowers using financial ratios rather than relying exclusively on raw loan amounts and categorical characteristics.

**Important methodological note:** `loan_to_income` and `installment_to_income` are not equivalent to the complete debt-to-income ratio. The latter is a separate dataset variable. Similarly, the simplified unpaid-principal calculation does not reconstruct the exact outstanding balance at the moment of default.

### 6.4 Exploratory Data Analysis

The notebook examines the distribution of loan outcomes and the characteristics associated with repayment performance.

The analysis includes:

* Overall default rate.
* Loan distribution across credit grades.
* Average interest rates by grade.
* Loan duration comparisons.
* Default rates by home ownership.
* Default rates by income verification status.
* Geographic comparisons across US states.
* Default rates by FICO score.
* Default rates by debt-to-income ratio.
* Default rates across income categories.
* Credit grade and loan duration combinations.

These comparisons help identify which variables are associated with higher or lower observed default rates.

### 6.5 Credit Grade Analysis

Lending Club classifies loans into grades from A to G, with higher letter grades generally representing riskier loans.

The notebook calculates loan counts, default counts, default rates, average interest rates, average loan amounts, and average FICO scores by grade.

The analysis also compares the proportion of each grade's borrowers who default.

This is important because a credit grade can influence both the likelihood of default and the interest rate charged to a borrower.

The results show a clear increase in observed default rates across the credit grades in the full cleaned outcome dataset.

| Grade |   Loans | Observed Default Rate | Average Interest Rate |
| ----- | ------: | --------------------: | --------------------: |
| A     | 235,193 |                 6.04% |                 7.11% |
| B     | 393,102 |                13.40% |                10.68% |
| C     | 382,323 |                22.44% |                14.02% |
| D     | 201,657 |                30.38% |                17.71% |
| E     |  94,192 |                38.43% |                21.11% |
| F     |  32,306 |                45.15% |                24.88% |
| G     |   9,326 |                49.67% |                27.54% |

These figures refer to the full cleaned dataset containing recorded outcomes, not exclusively to the mature 2009–2015 cohort used for the main historical loss analysis.

The results indicate that the risk classification is strongly associated with observed default frequency.

### 6.6 Loan Duration Analysis

The notebook compares 36-month and 60-month loans.

The full cleaned outcome dataset produces the following results:

| Loan Term | Number of Loans | Observed Default Rate | Average Interest Rate |
| --------- | --------------: | --------------------: | --------------------: |
| 36 months |       1,023,206 |                16.02% |                12.12% |
| 60 months |         324,893 |                32.45% |                16.77% |

The observed default rate is substantially higher among 60-month loans.

However, this comparison does not prove that longer duration independently causes default. Borrowers receiving different loan terms may also differ in credit grade, income, debt burden, and other risk characteristics.

The project therefore also examines loan duration together with credit grade.

### 6.7 Borrower Financial Profile Analysis

The notebook groups borrowers according to financial characteristics.

**FICO score**

Borrowers are grouped into score ranges to examine how credit score relates to default risk.

**Debt-to-income ratio**

DTI is divided into bands to investigate whether borrowers with higher debt burdens exhibit higher default rates.

**Annual income**

Income categories are compared to identify differences in observed default rates across income groups.

**Home ownership**

Borrowers with mortgages, owned homes, and rental housing arrangements are compared.

**Income verification**

The notebook examines whether default rates differ across income verification categories.

**Credit history**

The length of credit history, previous delinquencies, recent credit inquiries, revolving credit utilization, and other credit variables are investigated.

These analyses help identify useful risk indicators and support the development of more comprehensive borrower assessment strategies.

### 6.8 Statistical Analysis and Visualizations

The notebook uses multiple visualization techniques to communicate the findings.

| Visualization         | Purpose                                                                       |
| --------------------- | ----------------------------------------------------------------------------- |
| Bar charts            | Compare default rates across categorical segments                             |
| Heatmaps              | Examine risk across combinations of credit grades, loan terms, or years       |
| Box plots             | Compare interest rate distributions across credit grades                      |
| KDE plots             | Compare distributions of financial variables between outcome groups           |
| Correlation heatmap   | Examine linear relationships among selected numerical variables               |
| Time-series charts    | Investigate changes in default rates and portfolio performance                |
| Scatter plots         | Compare risk indicators such as Probability of Default and Loss Given Default |
| Portfolio loss charts | Compare loan volume, unpaid principal, recoveries, and estimated losses       |

A correlation matrix is also created to explore relationships between default outcomes and variables such as interest rate, FICO score, DTI, annual income, loan amount, and revolving credit utilization.

Correlation is treated as an exploratory measure, not proof of causation.

### 6.9 Expected Loss Analysis

One of the central parts of the project is the financial analysis of historical credit losses.

The notebook focuses on loans issued between 2009 and 2015 because a larger proportion of those loans have had time to reach a recorded outcome.

The selected historical cohort contains:

* **826,359 loans**
* **152,411 recorded defaults**
* **18.44% observed default rate**

The analysis estimates three key credit risk components.

**Probability of Default (PD)**

The proportion of loans in the selected cohort that defaulted.

$$
PD = \frac{\text{Number of Defaulted Loans}}{\text{Total Loans}}
$$

**Loss Given Default (LGD)**

The proportion of the unpaid-principal proxy that remains unrecovered after accounting for recorded recoveries.

$$
LGD = 1-\frac{\text{Recoveries}}{\text{Unpaid Principal}}
$$

**Exposure at Default (EAD)**

The project estimates exposure using the average unpaid-principal proxy among defaulted loans.

$$
EAD = \text{Average Unpaid Principal for Defaulted Loans}
$$

The standard conceptual relationship is:

$$
\boxed{EL = PD \times LGD \times EAD}
$$

For an individual exposure, Expected Loss is conventionally estimated by multiplying the probability of default by the loss severity and the exposure at default.

For a portfolio, expected losses are aggregated across the relevant exposures.

In this project, the calculations use historical outcomes and simplified principal and recovery proxies to estimate portfolio losses. The resulting figures are best interpreted as historical loss estimates rather than an independently validated forward-looking Expected Credit Loss model.

### 6.10 Historical Loss Results

The main historical cohort produces the following results:

| Metric                                     |                       Result |
| ------------------------------------------ | ---------------------------: |
| Analysis period                            |                    2009–2015 |
| Number of loans                            |                      826,359 |
| Recorded defaults                          |                      152,411 |
| Probability of Default (PD)                |                       18.44% |
| Loss Given Default (LGD)                   |                       87.62% |
| Average EAD proxy per defaulted loan       |                      $10,339 |
| Estimated portfolio loss                   | Approximately $1.381 billion |
| Loss rate relative to original loan volume |                       11.60% |

The loss estimate is calculated from the outstanding-principal proxy and recorded recoveries for the selected historical cohort.

The results indicate that recoveries offset only a relatively small proportion of the unpaid-principal proxy in this dataset.

This highlights the importance of evaluating not only how frequently borrowers default, but also how much money is lost when defaults occur.

### 6.11 Expected Loss by Credit Grade

The notebook calculates risk and loss indicators for each credit grade.

| Grade |     PD |    LGD | EL Rate | Share of Estimated Total Loss |
| ----- | -----: | -----: | ------: | ----------------------------: |
| A     |  5.57% | 87.57% |   2.42% |                         3.58% |
| B     | 12.04% | 87.81% |   6.19% |                        14.37% |
| C     | 20.37% | 87.67% |  11.74% |                        26.82% |
| D     | 28.13% | 87.69% |  17.90% |                        24.57% |
| E     | 36.75% | 87.59% |  24.68% |                        19.66% |
| F     | 42.30% | 87.20% |  29.94% |                         8.57% |
| G     | 46.60% | 87.12% |  32.83% |                         2.44% |

The results show two important patterns.

First, the estimated loss rate rises substantially from Grade A to Grade G.

Second, the highest-risk grade does not necessarily produce the largest total dollar loss.

Grades C and D contribute a larger share of the estimated portfolio losses because they combine substantial loan volumes with elevated default rates.

This distinction is important for portfolio management: a lender must consider both the risk of an individual exposure and the amount of capital concentrated in a segment.

### 6.12 Expected Loss by Loan Term

The historical 2009–2015 cohort also produces the following comparison:

| Loan Term |   Loans | Default Rate | Estimated EL Rate |
| --------- | ------: | -----------: | ----------------: |
| 36 months | 618,026 |       13.91% |             6.84% |
| 60 months | 208,333 |       31.90% |            20.43% |

The estimated EL rate for 60-month loans is substantially higher than that for 36-month loans.

The analysis suggests that longer-term loans deserve additional attention when evaluating credit risk, exposure, and portfolio profitability.

However, the comparison is observational. Differences in borrower characteristics, loan pricing, and credit grades must also be considered before attributing the difference to loan duration alone.

### 6.13 Interest Rates and Portfolio Profitability

The project compares average interest rates with estimated loss rates across credit grades.

| Grade | Average Interest Rate | Estimated EL Rate |              Difference |
| ----- | --------------------: | ----------------: | ----------------------: |
| A     |                 7.23% |             2.42% | +4.82 percentage points |
| B     |                10.86% |             6.19% | +4.67 percentage points |
| C     |                14.03% |            11.74% | +2.29 percentage points |
| D     |                17.23% |            17.90% | -0.67 percentage points |
| E     |                19.98% |            24.68% | -4.70 percentage points |
| F     |                23.63% |            29.94% | -6.31 percentage points |
| G     |                25.74% |            32.83% | -7.09 percentage points |

This comparison is intended as an initial screening tool.

It highlights a potential risk-pricing problem: in the historical cohort, estimated loss rates for Grades D through G exceed the corresponding average contractual interest rates when the two percentages are compared directly.

**Important limitation:** The average contractual interest rate is generally an annualized rate, while the estimated EL rate in this project is a cumulative loss-to-original-principal ratio for the observed loan cohort. They are not directly comparable measures of profitability.

The difference therefore does not establish that these grades generated accounting losses. A proper profitability analysis must account for loan duration, actual interest cash flows, repayment timing, funding costs, servicing expenses, fees, recoveries, and other relevant costs.

Nevertheless, the comparison identifies credit segments that deserve deeper financial analysis.

## 7. Oracle SQL Analysis

**SQL file:** `03_credit_risk_queries.sql`

Oracle SQL was used to organize the analytical dataset and perform structured financial and portfolio analysis.

The script creates an `lc_loans` table containing loan characteristics, borrower information, derived risk variables, repayment measures, and loss indicators.

The table supports aggregation, segmentation, and time-series analysis directly within the database.

The SQL script includes approximately 70 business-oriented analytical questions.

### 7.1 Portfolio Performance

The first group of queries examines the overall structure of the lending portfolio.

The analysis calculates:

* Total loan count.
* Total original loan volume.
* Average loan amount.
* Average interest rate.
* Number of defaults.
* Default rate.
* Estimated total loss.
* Loss rate relative to original loan volume.

These indicators provide an overview of portfolio size, risk, and financial exposure.

### 7.2 Loan Distribution and Portfolio Composition

The SQL analysis examines how the portfolio is distributed across:

* Credit grades and sub-grades.
* Loan durations.
* Loan purposes.
* Loan statuses.
* Loan issuance years.
* Borrower income categories.
* Geographical regions.

The queries calculate loan counts, total loan volumes, average loan sizes, and portfolio shares.

This helps identify segments that account for a substantial proportion of lending activity.

### 7.3 Default Risk by Borrower Characteristics

The script investigates how default rates vary across several borrower and loan characteristics.

These include:

* Credit grade and sub-grade.
* Loan purpose.
* Home ownership.
* Income verification status.
* Employment length.
* Annual income.
* Debt-to-income ratio.
* FICO score.
* Loan amount.
* Interest rate.
* Credit history.
* Recent credit inquiries.
* Previous delinquencies.
* Public records and bankruptcies.
* Revolving credit utilization.
* Number of open credit accounts.
* Loan-to-income ratio.
* Installment-to-income ratio.

The analysis uses conditional aggregation, grouped calculations, CASE expressions, and other SQL techniques to compare risk across segments.

### 7.4 Loan Duration and Credit Grade Interaction

The project investigates how loan duration and credit grade interact.

Instead of examining these variables independently, the queries compare default rates for combinations such as:

* Grade A, 36 months.
* Grade A, 60 months.
* Grade C, 36 months.
* Grade C, 60 months.
* Higher-risk grades with different repayment terms.

This approach helps identify combinations that may require additional underwriting attention.

The SQL analysis also examines FICO and DTI combinations to investigate how credit quality and borrower debt burden interact.

### 7.5 Time-Series and Vintage Analysis

The script includes time-based analyses of loan issuance and credit performance.

These include:

* Annual loan volume.
* Annual default rates.
* Monthly lending activity.
* Monthly default rates.
* Three-month moving averages.
* Quarterly default rates.
* Year-over-year loan growth.
* Changes in portfolio grade composition.
* Vintage performance by issuance year.
* Grade-by-year default patterns.
* Seasonal changes in lending volume and risk.

Vintage analysis is particularly useful because loans issued in different periods may have different repayment histories and exposure to economic conditions.

However, recent loan cohorts should not be compared directly with mature cohorts without accounting for differences in time since origination and outcome maturity.

### 7.6 Expected Loss and Recovery Analysis

The SQL script extends the analysis beyond default frequency.

It examines:

* Expected Loss by credit grade.
* Expected Loss by loan duration.
* Expected Loss by loan purpose.
* Expected Loss by state.
* Expected Loss by grade and duration.
* Expected Loss by issuance year.
* Expected Loss by FICO segment.
* Expected Loss by DTI segment.
* High-loss combinations of grade and loan purpose.
* Recovery rates following default.
* Concentration of losses across sub-grades.

These queries help distinguish segments with high default rates from segments that contribute the most financial losses.

### 7.7 Revenue and Profitability Analysis

The SQL analysis also investigates whether different lending segments appear financially attractive after accounting for estimated credit losses.

The questions include:

* Which credit grades have higher recorded payment margins?
* How do 36-month and 60-month loans compare?
* Which loan issuance years have stronger observed financial outcomes?
* Which combinations of grade, term, and purpose have lower profitability proxies?
* How do borrower income groups compare?
* Does the observed interest rate appear sufficient relative to estimated credit losses?
* Which risk segments contribute the most to portfolio exposure and losses?

The analysis also explores potential credit score thresholds and the trade-off between excluding risky borrowers and losing potential customers.

These calculations provide a starting point for developing risk-adjusted lending strategies.

### 7.8 Data Quality and Portfolio Concentration

Additional SQL questions investigate:

* Potentially inconsistent or suspicious records.
* Geographical concentration.
* Large individual loan losses.
* The contribution of individual segments to aggregate losses.
* Concentration of estimated losses among sub-grades.

This helps identify both data quality concerns and business concentration risks.

### 7.9 SQL Techniques Used

The SQL script demonstrates practical database analysis techniques, including:

* `CREATE TABLE`
* `SELECT`
* `WHERE`
* `GROUP BY`
* `HAVING`
* Aggregate functions
* `CASE WHEN`
* Subqueries
* Common analytical expressions
* Window functions
* `RATIO_TO_REPORT`
* `PERCENTILE_CONT`
* Conditional aggregation
* Pivot-style aggregation
* Sorting and ranking
* Time-based grouping
* Financial ratios and derived metrics

These techniques make it possible to answer business questions directly from structured loan data.

## 8. Power BI Reporting

**Power BI file:** `Risk_analysis.pbix`
<img width="1141" height="625" alt="image" src="https://github.com/user-attachments/assets/49105a45-1eb9-484c-8106-5d69e9200880" />

<img width="1142" height="623" alt="image" src="https://github.com/user-attachments/assets/ba96bbf9-54f4-4dc1-8414-8efa5fcc8244" />

<img width="1200" height="638" alt="image" src="https://github.com/user-attachments/assets/79230059-8942-419a-be60-d016a310355e" />


Power BI serves as the reporting and presentation component of the project.

While Python and Oracle SQL are used for data preparation and analytical calculations, Power BI provides a business-oriented way to communicate risk indicators and compare portfolio segments.

The analysis supports reporting on the following areas:

### Portfolio Overview

* Total number of loans.
* Total original loan volume.
* Average loan amount.
* Default rate.
* Estimated losses.
* Loan distribution by grade and duration.

### Credit Risk Analysis

* Default rates by grade and sub-grade.
* Default rates by FICO score.
* Default rates by DTI.
* Default rates by loan purpose.
* Default rates by borrower income category.
* Comparison of 36-month and 60-month loans.

### Expected Loss Analysis

* Estimated loss by credit grade.
* Estimated loss by loan duration.
* Estimated loss by borrower segment.
* Estimated loss by loan purpose.
* Recovery and unpaid-principal comparisons.

### Portfolio Trends

* Annual lending volume.
* Default rate trends.
* Portfolio composition over time.
* Differences between loan issuance cohorts.

### Business Interpretation

The reporting layer is intended to help users identify high-risk segments, understand portfolio concentration, and compare risk indicators without needing to examine individual SQL queries or notebook outputs.

The specific visuals, measures, filters, and interactions should be documented against the final saved Power BI report.

## 9. Key Business Findings

The combined analysis highlights several important patterns.

### Finding 1: Default Risk Increases Across Lower Credit Grades

In the full cleaned outcome dataset, the observed default rate rises from approximately 6.04% for Grade A to 49.67% for Grade G.

This suggests that credit grade is a useful indicator for portfolio segmentation.

**Business implication:** Credit grades should be evaluated using actual historical outcomes and monitored regularly to ensure that risk classifications remain informative.

### Finding 2: Longer-Term Loans Show Higher Observed Default Rates

The observed default rate is approximately 16.02% for 36-month loans and 32.45% for 60-month loans in the full cleaned outcome dataset.

The mature 2009–2015 cohort also shows a substantial difference in estimated loss rates between the two durations.

**Business implication:** Longer-term loans may require additional risk assessment, appropriate pricing, and closer monitoring.

However, differences in borrower characteristics must be controlled for before attributing the difference entirely to duration.

### Finding 3: Grades C and D Make a Significant Contribution to Total Losses

In the mature cohort, Grade C contributes approximately 26.82% of estimated portfolio losses, while Grade D contributes approximately 24.57%.

Together, these two grades account for approximately 51.39% of the estimated total loss.

They are not the highest-risk grades individually, but their substantial portfolio volumes make them important contributors to aggregate losses.

**Business implication:** Portfolio management should prioritize both high-risk borrowers and large segments where moderate-to-high risk is concentrated.

### Finding 4: Lower-Income Borrowers Have Higher Observed Default Rates

The notebook reports an observed default rate of approximately 24.38% for borrowers with annual income below $30,000, compared with 14.62% for borrowers earning $150,000 or more.

**Business implication:** Income should be considered alongside debt burden, existing obligations, credit history, and repayment capacity.

Income alone should not be used as an automatic approval or rejection rule.

### Finding 5: Higher DTI Is Associated with Higher Default Rates

The analysis finds that default rates generally increase across higher DTI categories.

For example, the observed default rate is approximately 14.92% for the 0–10 DTI band and 29.10% for the 30–40 band.

**Business implication:** Debt burden is an important factor when assessing whether a borrower can reasonably meet additional repayment obligations.

Lenders should evaluate DTI together with verified income and existing debt commitments.

### Finding 6: Higher FICO Scores Are Associated with Lower Default Rates

The observed default rate decreases across the higher FICO score categories in the full cleaned outcome dataset.

For example, the reported rate is approximately 23.60% for the 660–700 band and 10.57% for the 740–780 band.

**Business implication:** Credit scores can support risk segmentation, but should be combined with other relevant information rather than used as the only decision criterion.

### Finding 7: Recoveries Offset Only Part of Estimated Unpaid Principal

The mature cohort's estimated LGD is approximately 87.62%.

Under the project's simplified definitions, this indicates that a large share of the unpaid-principal proxy remains unrecovered after accounting for recorded recoveries.

**Business implication:** Credit risk management should consider both the probability of default and the potential severity of losses after default.

Recovery processes and early intervention may be important components of loss reduction.

### Finding 8: High Interest Rates Do Not Necessarily Mean High Profitability

The estimated loss rate increases across higher-risk grades, and for Grades D through G it exceeds the average contractual interest rate in the project's direct comparison.

Because these rates represent different time and accounting bases, this is not proof of negative profitability.

**Business implication:** Lending decisions should be based on a complete risk-adjusted profitability analysis, not on nominal interest rates alone.

## 10. Business Problems and Recommended Solutions

### Problem 1: High Credit Losses in Riskier Segments

The historical results show that higher-risk credit grades experience substantially higher default rates and estimated loss rates.

**Recommended actions:**

* Strengthen underwriting for segments with consistently high observed losses.
* Combine credit grade, FICO, DTI, income, and credit history in borrower assessment.
* Review the performance of each credit grade regularly.
* Evaluate the financial impact of different approval thresholds.
* Monitor the trade-off between reducing defaults and losing potential lending opportunities.

The objective is not necessarily to eliminate all high-risk lending, but to ensure that risk is understood, priced, and managed appropriately.

### Problem 2: Long-Term Loans Have Higher Observed Loss Rates

The historical data shows higher default and estimated loss rates for 60-month loans than for 36-month loans.

**Recommended actions:**

* Compare long- and short-term loans within similar credit grades.
* Evaluate whether longer durations require different pricing or underwriting criteria.
* Monitor early repayment difficulties.
* Estimate losses separately by loan term and borrower risk category.
* Test alternative loan structures using historical data before implementation.

Any policy change should be evaluated against borrower demand, expected revenue, and risk-adjusted profitability.

### Problem 3: Portfolio Losses Are Concentrated in Large Segments

Grades C and D contribute more than half of the estimated loss in the selected historical cohort.

**Recommended actions:**

* Monitor both default rate and total loss contribution.
* Create separate risk dashboards for high-volume segments.
* Review underwriting performance in grades that combine substantial volume with elevated losses.
* Set portfolio monitoring thresholds for unexpected deterioration.
* Evaluate whether concentration in particular grades creates excessive exposure.

A segment with a moderate default rate can still be a major financial concern if the lender has a large amount of capital exposed to it.

### Problem 4: Nominal Interest Rates May Not Fully Reflect Credit Risk

The comparison between contractual interest rates and estimated loss rates highlights a potential mismatch in risk pricing.

**Recommended actions:**

* Calculate expected lifetime cash flows for each loan segment.
* Include funding costs, servicing expenses, fees, and recovery assumptions.
* Estimate risk-adjusted returns by credit grade and loan duration.
* Back-test pricing decisions against realized loan outcomes.
* Avoid relying on a simple difference between annual interest rates and cumulative loss rates.

A more useful pricing measure would compare expected revenue and all relevant costs over a consistent time horizon.

### Problem 5: Borrower Affordability Needs Better Assessment

The observed relationships between default rates, income, and DTI suggest that borrower affordability deserves attention.

**Recommended actions:**

* Verify income where appropriate and legally permitted.
* Evaluate existing debt obligations.
* Analyze scheduled loan payments relative to verified income.
* Investigate the combined effects of DTI, credit score, and credit history.
* Test whether affordability measures improve predictive performance.

These variables should support a comprehensive credit assessment rather than act as isolated rules.

### Problem 6: Loss Recovery May Be Insufficient

The high estimated LGD indicates that the unpaid-principal proxy is not substantially reduced by recorded recoveries.

**Recommended actions:**

* Analyze recovery rates by grade and loan type.
* Track the time required to recover unpaid balances.
* Investigate which segments have consistently low recoveries.
* Evaluate early delinquency monitoring and collection processes.
* Estimate whether improved recovery strategies could reduce portfolio losses.

Recovery performance should be evaluated alongside default probability and exposure.

### Problem 7: Recent Loan Cohorts May Be Incomparable

Loans issued in different years have different amounts of time to reach repayment or default outcomes.

Comparing recent and mature cohorts without considering this difference can distort risk conclusions.

**Recommended actions:**

* Use mature loan cohorts for historical outcome comparisons.
* Introduce vintage analysis.
* Track delinquency and default at consistent periods after loan origination.
* Separate active loans from loans with established outcomes.
* Use appropriate survival analysis or time-to-event methods when developing more advanced models.

This helps distinguish actual changes in credit quality from differences in loan maturity.

### Problem 8: Historical Analysis Is Not Yet a Validated Predictive Model

The project identifies associations between borrower characteristics and defaults, but it does not establish that those variables can predict future defaults accurately.

**Recommended actions:**

* Develop a separate predictive modeling stage.
* Use time-aware training and testing datasets.
* Prevent information leakage from post-origination variables.
* Evaluate precision, recall, ROC-AUC, PR-AUC, and calibration.
* Compare model predictions with actual outcomes.
* Test the model on a later time period.
* Evaluate fairness, explainability, and applicable regulatory requirements before production use.

Predictive performance should be demonstrated empirically before a model is used in real lending decisions.

## 11. Methodological Limitations

The results must be interpreted within the limits of the dataset and the calculations.

### Outcome Selection

The binary default analysis excludes active and unresolved loans.

This creates a dataset of loans with recorded outcomes rather than a complete representation of every loan at every stage of its life cycle.

The resulting default rates should not automatically be interpreted as the default probability of all newly issued loans.

### Historical Cohort Selection

The Expected Loss analysis focuses on loans issued between 2009 and 2015 because these cohorts have had more time to reach a recorded outcome.

This improves outcome maturity but means the results may not represent current lending conditions.

### Simplified EAD Calculation

The project estimates unpaid principal using original loan amount minus total principal received.

This is a simplified proxy and does not reconstruct the precise exposure outstanding at the moment of default.

### Expected Loss Interpretation

The standard Expected Loss framework is:

$$
EL = PD \times LGD \times EAD
$$

However, this project uses historical default outcomes and simplified exposure and recovery calculations.

Its reported loss estimate should therefore be interpreted as a historical loss estimate under the project's definitions, not as a fully validated forecast of future credit losses.

### Profitability Limitations

The variable `profit` is calculated as total payments minus the original loan amount.

This is a gross cash-flow margin proxy, not accounting profit or net economic profit.

It does not fully account for funding costs, servicing expenses, payment timing, the time value of money, or all other relevant costs.

Similarly, contractual annual interest rates and cumulative portfolio loss rates are not directly comparable measures.

### Correlation and Causation

Observed relationships do not establish causation.

For example, the higher default rate associated with longer-term loans may reflect differences in borrower profiles or loan characteristics rather than duration alone.

### Data Quality

Median imputation and outlier capping can influence results.

The remaining missing date values should also be investigated before the dataset is used in a production modeling pipeline.

## 12. Future Improvements

Several improvements could extend the project beyond descriptive and historical credit risk analysis.

### Predictive Credit Risk Modeling

Develop a model to estimate the probability of default using borrower and loan characteristics available at the time of application.

Potential models include:

* Logistic Regression.
* Decision Trees.
* Random Forest.
* Gradient Boosting.
* XGBoost, subject to appropriate validation.

### Risk-Adjusted Profitability

Build a more complete financial model incorporating expected interest cash flows, funding costs, operating expenses, recoveries, and the timing of payments.

### Model Validation

Evaluate discrimination, calibration, stability, and performance across time periods.

### Advanced Loss Estimation

Improve the measurement of exposure at default, recovery behavior, and loss severity.

### Portfolio Stress Testing

Investigate how portfolio losses might change under hypothetical economic conditions, such as higher unemployment, reduced borrower income, or deteriorating repayment performance.

### Automated Reporting

Develop an automated data pipeline that updates the analytical dataset and reporting layer as new data becomes available.

## 13. Repository Structure

The current project files are organized as follows:

```text
credit-risk-analysis/
│
├── 03_credit_risk_queries.sql
│
├── credit_risk_eda_expected_loss.ipynb.ipynb
│
├── Risk_analysis.pbix
│
└── README.md
```

The notebook also exports a cleaned dataset named `lc_clean.csv` for downstream analysis.

The exact repository structure may be adjusted to include the cleaned data, dependency list, and supporting documentation.

## 14. How to Run the Project

### Step 1: Download the Dataset

Download the Lending Club dataset from Kaggle:

https://www.kaggle.com/wordsforthewise/lending-club

The notebook expects the historical `accepted_2007_to_2018Q4.csv` file.

Update the file path in the notebook to match your local environment.

### Step 2: Install Python Dependencies

Install the required libraries:

```bash
pip install pandas numpy matplotlib seaborn jupyter
```

### Step 3: Run the Notebook

Launch Jupyter Notebook:

```bash
jupyter notebook
```

Open the credit risk analysis notebook and execute the cells in order.

The notebook performs data preparation, exploratory analysis, risk calculations, and visualization.

### Step 4: Prepare the SQL Environment

Create the `lc_loans` table in Oracle Database.

Load the cleaned data into the table using a suitable CSV import or database loading process.

Ensure that the database columns and data types match the SQL table definition.

### Step 5: Execute the SQL Queries

Run the queries in `03_credit_risk_queries.sql` against the populated `lc_loans` table.

The script contains portfolio-level metrics, risk segmentation, Expected Loss analysis, profitability comparisons, and time-based analyses.

### Step 6: Open the Power BI Report

Open `Risk_analysis.pbix` in Power BI Desktop.

If the report uses a local data source, update its connection settings to match the location and structure of the available data.

## 15. Conclusion

This project demonstrates an end-to-end approach to financial data analytics using Python, Oracle SQL, and Power BI.

The analysis moves beyond basic loan summaries to examine borrower characteristics, default behavior, credit grades, loan duration, portfolio loss concentration, recoveries, and historical profitability indicators.

The results show that credit risk is not evenly distributed across the portfolio. Higher-risk credit grades exhibit substantially higher default rates, longer-term loans show higher observed default and estimated loss rates, and Grades C and D account for a significant proportion of the estimated losses in the selected historical cohort.

The project also highlights an important business principle: higher nominal interest rates do not necessarily guarantee stronger risk-adjusted returns.

For lending institutions, effective credit risk management requires a combination of borrower assessment, appropriate pricing, loss estimation, portfolio monitoring, and recovery management.

By integrating Python analysis, SQL-based business queries, and Power BI reporting, this project illustrates how financial data can be transformed into insights that support more informed lending and portfolio management decisions.

### Skills Demonstrated

* Financial Data Analysis
* Credit Risk Analysis
* Data Cleaning and Feature Engineering
* Exploratory Data Analysis
* Python and Pandas
* Oracle SQL
* Portfolio Analytics
* Expected Loss Estimation
* Risk Segmentation
* Data Visualization
* Business Intelligence
* Financial Interpretation and Business Recommendations

---

**Dataset Source:** Lending Club Loan Data — Kaggle

**Technologies:** Python, Pandas, NumPy, Matplotlib, Seaborn, Jupyter Notebook, Oracle SQL, Power BI.
