# Apache Superset

### Preparations

Required steps:
1. Ensure the Docker network `garudanet` with subnet `10.10.17.0/24` exists. If using different network name and/or subnet, adjust the network in [compose.yaml][url-superset-compose] accordingly
1. Copy `.env.sample` to `.env`, and update the values. Note that the value for `DATABASE_HOST` and `REDIS_HOST` should match the container names for [`postgres`][url-postgres] and [`redis`][url-redis]. Alternatively, set it to point to the hostname for the servers accordingly
1. For the database connectivity, ensure the values for all `DATABASE_*` variables in [`.env` file][url-superset-dotenv] are set correctly
1. Ensure the database user and schema is created in the linked PostgreSQL instance. This can be done by executing the followings (note to match the username and password to the one specified in your [`.env` file][url-superset-dotenv]):
  ```
    CREATE USER your_superset_username with password 'sample-strong-password--j_d2agwGzHTrP4h3e--please replace'
    CREATE DATABASE your_superset_username OWNER your_superset_username;
  ```

### Configuration

Apart from setting the [environment variables][url-superset-dotenv], additional configurations can be specified and customized via a python file in [`volumes/docker/pythonpath/`][url-pythonpath]. This will overwrite the configurations specified in [`volumes/docker/pythonpath/superset_config.py`][url-pythonpath-superset-config].


### Database users

In Superset's *Settings > Database Connections*, we can define the databases we want to connect to.

It is recommended to create a read-only database user reserved for reading data for use in Superset.

For PostgreSQL, the followings are the commands needed to create read-only user:
```
CREATE USER readonlyuser WITH PASSWORD 'a_v3ry_str0ng_p455w0rd';

-- The followings need to be done for all schemas which we want readonlyuser to use

-- Grant access on existing tables
GRANT USAGE ON SCHEMA public TO readonlyuser;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO readonlyuser;

-- Grant access to future tables
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO readonlyuser;
```


### Startup

Once done, start the container (with -d flag to make it run as daemon)
```
docker compose up -d
```


<!-- Links -->
[url-postgres]: /postgres "PostgreSQL"
[url-redis]: /redis "Redis"
[url-superset-dotenv]: /superset/.env.sample "Apache Superset sample environment file"
[url-superset-compose]: /superset/compose.yaml "Apache Superset compose file"
[url-pythonpath]: /superset/volumes/docker/pythonpath/ "Pythonpath for additional configuration directory"
[url-pythonpath-superset-config]: /superset/volumes/docker/pythonpath/superset_config.py
