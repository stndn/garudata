# Airflow

### Preparations

Required steps:
1. Ensure the Docker network `garudanet` with subnet `10.10.17.0/24` exists. If using different network name and/or subnet, adjust the network in [compose.yaml][url-airflow-compose] accordingly
1. Copy `.env.sample` to `.env`, and update the values. Note that the value for `POSTGRES_HOSTNAME` should match the container name for [postgres][url-postgres]. Alternatively, set it to point to the hostname for the PostgreSQL server
1. Ensure the database user and schema is created in the linked PostgreSQL instance. This can be done by executing the followings (note to match the username and password to the one specified in your [.env file][url-airflow-dotenv]):
  ```
    CREATE USER your_airflow_username with password 'sample-strong-password--j_d2agwGzHTrP4h3e--please replace'
    CREATE DATABASE your_airflow_username OWNER your_airflow_username;
  ```

### Configuration

Eventually, we want to serve [Airflow via Nginx proxy][url-airflow-proxy].

To ensure the reverse proxy matches properly, there are several additional [configuration for Airflow][url-airflow-configs] to be set. This can be done in Airflow's configuration file ([airflow.cfg][url-airflow-cfg]) or as [environment variables][url-airflow-dotenv] as such:

```
AIRFLOW__WEBSERVER__BASE_URL='http://example.xyz'
AIRFLOW__WEBSERVER__FLOWER_URL_PREFIX='/myorg/flower'
AIRFLOW__WEBSERVER__ENABLE_PROXY_FIX='True'
```

Other optional configuration can be added such as:
```
# To set default timezone used (instead of UTC)
AIRFLOW__CORE__DEFAULT_TIMEZONE='Asia/Kuala_Lumpur'
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

For more information, please visit the documentation page for [running Airflow in Docker][url-airflow-in-docker].


<!-- Links -->
[url-airflow-proxy]: https://airflow.apache.org/docs/apache-airflow/stable/howto/run-behind-proxy.html "Running Airflow behind a reverse proxy"
[url-airflow-configs]: https://airflow.apache.org/docs/apache-airflow/stable/configurations-ref.html "Airflow configuration reference"
[url-airflow-in-docker]: https://airflow.apache.org/docs/apache-airflow/stable/howto/docker-compose/index.html "Running Airflow in Docker"
[url-airflow-cfg]: /airflow/volumes/airflow.cfg.sample "Airflow configuration file"
[url-airflow-dotenv]: /airflow/.env.sample "Airflow sample environment file"
[url-airflow-compose]: /airflow/compose.yaml "Airflow compose file"
[url-postgres]: /postgres "PostgreSQL"
