# Garudata

Garudata is a simplified showcase of various tools coming together to build an end-to-end data platform.

It is designed to streamline data ingestion, transformation, access, and sharing, allowing data users to easily understand data throughout its journey.


## Technology

The data platform will be built on top of the followings:
* [Apache Airflow][url-airflow]
* [Apache Spark][url-spark]
* [Apache Superset][url-superset]
* [DataHub][url-datahub]
* [Docker + Compose][url-docker]
* [MinIO][url-minio]
* [Nginx][url-nginx]
* [PostgreSQL][url-psql]

All tools (except for Nginx) will be deployed in containers. Host OS is [Ubuntu Server 22.04][url-ubuntu].


## Usage

### Requirements

1. Install Docker and Compose
2. Setup Docker network to connect and share the network among various containers. In this project, `garudanet` in `10.10.17.0/24` is used:
    ```
    docker network create -d bridge --subnet 10.10.17.0/24 --gateway 10.10.17.1 garudanet
    ```


## Roadmap

The list is not exhaustive and may change along the way:
- [X] Design end-to-end data platform architecture
- [ ] Setup the server and the components
- [ ] Develop a data journey use case
- [ ] Design data model
- [ ] Develop data extraction script
- [ ] Deploy workflow using Airflow
- [ ] Design simple dashboards
- [ ] Manage metadata
- [ ] Other improvements along the way


## License

The data platform is a self-learning project, shared under [MIT License](/LICENSE).

All included applications follow their respective licenses.


## References

(References organization in progress)


<!-- Links -->
[url-airflow]: https://airflow.apache.org/ "Apache Airflow"
[url-datahub]: https://datahubproject.io/ "DataHub"
[url-docker]: https://docs.docker.com/compose/ "Docker + Compose"
[url-minio]: https://min.io/ "MinIO"
[url-nginx]: https://nginx.org/ "Nginx"
[url-psql]: https://www.postgresql.org/ "PostgreSQL"
[url-spark]: https://spark.apache.org/ "Apache Spark"
[url-superset]: https://superset.apache.org/ "Apache Superset"
[url-ubuntu]: https://discourse.ubuntu.com/t/jammy-jellyfish-release-notes/24668 "Ubuntu 22.04 - Jammy Jellyfish"
