FROM quay.io/astronomer/astro-runtime:8.8.0

WORKDIR "/usr/local/airflow"
COPY dbt-requirements.txt ./

RUN python -m venv dbt_venv && source dbt_venv/bin/activate && \
    pip install --no-cache-dir -r dbt-requirements.txt && deactivate

RUN mkdir /tmp/logs /tmp/leads
