# README

### Preparations

Required steps:
1. Ensure the Docker network `garudanet` with subnet `10.10.17.0/24` exists. If using different network name and/or subnet, adjust the network in [compose.yaml][url-minio-compose] accordingly
1. Copy `.env.sample` to `.env`, and update the values

### Configuration

#### Webserver and Proxy

Eventually, we want to serve [MinIO via Nginx reverse proxy][url-minio-proxy].

To ensure the reverse proxy matches properly, we need to define the appropriate `MINIO_SERVER_URL` and `MINIO_BROWSER_REDIRECT_URL` to match the end URL accessible by the users in the [environment variable file][url-minio-dotenv]:

```
MINIO_SERVER_URL="https://subdomain.example.xyz"
MINIO_BROWSER_REDIRECT_URL="https://subdomain.example.xyz/ui"
```


### Startup

Once done, start MinIO with the following (with `-d` to start in background):
```
docker compose up -d
```


<!-- Links -->
[url-minio-compose]: /minio/compose.yaml "MinIO compose file"
[url-minio-proxy]: https://min.io/docs/minio/linux/integrations/setup-nginx-proxy-with-minio.html "Configure NGINX Proxy for MinIO Server"
[url-minio-dotenv]: /minio/.env.sample "Sample MinIO environment file"

