# Data Engineering Pipeline

## Brief
This pipeline is build using following stack:
- Apache Airflow (for orchestrating)
- DBT (for modelling and documenting)
- AWS Redshift (as data warehouse)
- Metabase for dashboarding

## Architecture diagram
The high level architecture of the pipeline is as below:

![arch](./documentation/arch.png)


## Dashboards:
Below dashboard answer 4 questions:
- The Promotion attribution; i.e. how effective is the marketing campaign in bringing paying customers
- Top 10 most revenue generating products
- Top locations from where most users are logged in to the application
- Month wise total sales of last year


![arch](./documentation/dashboard.png)

## How the project can be scaled
The Orchestration is done using Airflow - which can be easily scaled when there is an increase inneed to parallel execution.
The processing/ modelling is done using DBT - which can be plugged to SPARK on EMR/ Databricks cluster to process bulk of data

## Data Modelling
The 3 major Facts tables generated from the pipeline which powers the above dashboard are as below:
- facts__leads

![arch](./documentation/dbt-dag.png)

- fact__sales

![arch](./documentation/dbt-dag%20(1).png)

- fact__user_journey
- 
![arch](./documentation/dbt-dag%20(2).png)



