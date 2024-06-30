# Metabase

### Preparations

Required steps:
1. Ensure the Docker network `garudanet` with subnet `10.10.17.0/24` exists. If using different network name and/or subnet, adjust the network in [compose.yaml][url-metabase-compose] accordingly.
1. The backend for this Metabase installation will use postgreSQL.
1. Copy `.env.sample` to `.env`, and update the values. Note that the value for `POSTGRES_HOSTNAME` should match the container name for [`postgres`][url-postgres]. Alternatively, set it to point to the hostname for the servers accordingly.
1. For the database connectivity, ensure the values for all `METABASE_PG_*` variables in [`.env` file][url-metabase-dotenv] are set correctly.
1. Ensure the database user and schema is created in the linked PostgreSQL instance. This can be done by executing the followings (note to match the username and password to the one specified in your [`.env` file][url-metabase-dotenv]):
  ```
    CREATE USER your_metabase_username with password 'sample-strong-password--j_d2agwGzHTrP4h3e--please replace'
    CREATE DATABASE your_metabase_username OWNER your_metabase_username;
  ```


### Configuration

Configuration should be set up in the [environment variables][url-metabase-dotenv].


### Database users

In Metabase's *Databases* configuration, we can define the databases we want to connect to.

It is recommended to create a read-only database user reserved for reading data for use in Metabase.

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
[url-metabase-compose]: /metabase/compose.yaml "Metabase compose file"
[url-metabase-dotenv]: /metabase/.env.sample "Metabase sample environment file"

