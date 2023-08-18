FROM quay.io/astronomer/astro-runtime:8.8.0

RUN python -m venv dbt_venv && source dbt_venv/bin/activate && \
    pip install --no-cache-dir dbt-redshift==1.6.0 && deactivate