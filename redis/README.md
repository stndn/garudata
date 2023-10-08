# Redis

### Preparations

Required steps:
1. Ensure the Docker network `garudanet` with subnet `10.10.17.0/24` exists. If using different network name and/or subnet, adjust the network in [compose.yaml](/redis/compose.yaml) accordingly

Optional steps:

1. Change the image used in [compose.yaml](/redis/compose.yaml) according to the available image in [dockerhub](https://hub.docker.com/_/redis/)

### Startup

Once done, start the container (with -d flag to make it run as daemon)
```
docker compose up -d
```

