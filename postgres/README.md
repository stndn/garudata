# PostgreSQL

### Preparations

Required steps:
1. Ensure the Docker network `garudanet` with subnet `10.10.17.0/24` exists. If using different network name and/or subnet, adjust the network in [compose.yaml](/compose.yaml) accordingly
1. Copy `.env.sample` to `.env`, and update the values for `POSTGRES_USER`, `POSTGRES_PASSWORD`, and `POSTGRES_DB`. Leave the `POSTGRES_HOST` as-is, as it refers to the service name in [compose.yaml](/compose.yaml)

Optional steps:

1. Change the image used in [compose.yaml](/compose.yaml) according to the available image in [dockerhub](https://hub.docker.com/_/postgres/)
2. Adjust the allowed networks in [volumes/config/pg_hba.conf](/volumes/config/pg_hba.conf) as necessary to allow additional incoming connections
3. Specify additional database user/s and corresponding database/s to be created during initialization in [volumes/init/02-init-db-users.sql](/volumes/init/02-init-db-users.sql)

### Startup

Once done, start the container
```
docker compose up
```
