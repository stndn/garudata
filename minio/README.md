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

#### Additional User and Buckets

To create additional user(s) and bucket(s), we can add the corresponding commands accordingly via [MinIO init script][url-minio-init-script]. This requires additional configurations to be defined in the [environment variable file][url-minio-dotenv] for all keys prefixed by `MINIO_EXTRA_*`.


#### Service Account

For security, applications should connect to our MinIO instance using [MinIO Access Keys][url-minio-access-keys].

To allow the `minio-init` task to create the access key, set `MINIO_EXTRA_CREATE_ACCESS_KEY` to `Y` in the [environment variable file][url-minio-dotenv].
```
MINIO_EXTRA_CREATE_ACCESS_KEY='Y'
```

When enabled, the credentials will be stored in `./volumes/credentials`.


### Startup

Once done, start MinIO with the following (with `-d` to start in background):
```
docker compose up -d
```

Once the server is started, we can create our main bucket/s and user/s via the [init script][url-minio-init-script]:
```
docker compose up minio-init
```


<!-- Links -->
[url-minio-compose]: /minio/compose.yaml "MinIO compose file"
[url-minio-proxy]: https://min.io/docs/minio/linux/integrations/setup-nginx-proxy-with-minio.html "Configure NGINX Proxy for MinIO Server"
[url-minio-dotenv]: /minio/.env.sample "Sample MinIO environment file"
[url-minio-init-script]: /minio/volumes/init/minio-init.sh
[url-minio-access-keys]: https://min.io/docs/minio/linux/administration/identity-access-management/minio-user-management.html#access-keys "MinIO Service Accounts"
