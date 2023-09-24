# Airflow

### Preparations

Required steps:
1. Ensure the Docker network `garudanet` with subnet `10.10.17.0/24` exists. If using different network name and/or subnet, adjust the network in [compose.yaml](/airflow/compose.yaml) accordingly
1. Copy `.env.sample` to `.env`, and update the values. Note that the value for `POSTGRES_HOSTNAME` should match the container name for [postgres](/postgres/). Alternatively, set it to point to the hostname for the PostgreSQL server
1. Ensure the database user and schema is created in the linked PostgreSQL instance. This can be done by executing the followings (note to match the username and password to the one specified in your [.env file](/airflow/.env.sample)):
  ```
    CREATE USER your_airflow_username with password 'sample-strong-password--j_d2agwGzHTrP4h3e--please replace'
    CREATE DATABASE your_airflow_username OWNER your_airflow_username;
  ```

### Startup

Once done, perform the initialization step for Airflow:
```
docker compose up airflow-init
```

Followed by starting up Airflow container (with `-d` to start in background):
```
docker compose up -d
```

For more information, please visit the documentation page for [running Airflow in Docker](https://airflow.apache.org/docs/apache-airflow/stable/howto/docker-compose/index.html).
