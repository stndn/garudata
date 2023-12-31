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

#### Webserver and Proxy
Eventually, we want to serve [Airflow via Nginx proxy][url-airflow-proxy].

To ensure the reverse proxy matches properly, there are several additional [configuration for Airflow][url-airflow-configs] to be set. This can be done in Airflow's configuration file ([airflow.cfg][url-airflow-cfg]) or as [environment variables][url-airflow-dotenv] as such:

```
AIRFLOW__WEBSERVER__BASE_URL='http://example.xyz'
AIRFLOW__WEBSERVER__FLOWER_URL_PREFIX='/myorg/flower'
AIRFLOW__WEBSERVER__ENABLE_PROXY_FIX='True'
```

#### Timezone

Other optional configuration can be added such as:
```
# To set default timezone used (instead of UTC)
AIRFLOW__CORE__DEFAULT_TIMEZONE='Asia/Kuala_Lumpur'
```

#### Non-default UID

To simplify mounted directory and file sharing, we can use non-default Airflow UID instead of the recommended `50000`. To do so, set the `AIRFLOW_UID` to match the host user's UID in the [environment variables file][url-airflow-dotenv]. Example:
```
AIRFLOW_UID=1234
```

For more information, refer to the documentation on [environment variables supported by Docker Compose][url-airflow-compose-envvars]


#### SSH keys

When adding a new SSH connection (via *Admin* > *Connections*, with *Connection Type = SSH*), we can specify the SSH private key to be used to connect to remote server. One of the ways is to specify the key file, which needs to be available from within the container.

To simplify the setup, we can [create the key(s)][url-ssh-keygen] externally, and mount the directory containing the key file(s) by adding the following to the `volumes` section of our [compose.yaml][url-airflow-compose]:
```
    - ${AIRFLOW_PROJ_DIR:-.}/ssh-keys:/opt/airflow/ssh-keys
```


#### Examples

By default, Airflow comes with example DAG's for reference. To disable the examples, make sure to:
1. Set `load_examples = False` in [airflow.cfg][url-airflow-cfg]
1. Set `AIRFLOW__CORE__LOAD_EXAMPLES: 'false'` in [compose.yaml][url-airflow-compose]


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
[url-airflow-compose-envvars]: https://airflow.apache.org/docs/apache-airflow/stable/howto/docker-compose/index.html#environment-variables-supported-by-docker-compose "Environment variables supported by Docker Compose"
[url-ssh-keygen]: https://www.ssh.com/academy/ssh/keygen "Using ssh-keygen to generate new SSH key"
