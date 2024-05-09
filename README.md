# Document Transfer Service

A microservice to securely transfer documents.

## Running

### Docker

This service is designed to be run in a containerized environment. As such, it
includes a [Dockerfile] and a [docker compose] file to facilitate running the
service.

Using docker compose, the application code will be mounted from your local
system to the running container. This will allow you to make changes to the
code and see them reflected in the running service without having to rebuild the
image.

To run the service with docker compose, make sure you have [Docker Desktop]
installed and run the following:

```sh
docker compose up -d
```

The service should now be available at `http://localhost:3000`.

### Locally

To run the service locally, install dependencies using `bundle install`, then
run the following:

```sh
bundle exec rackup
```

The service should now be available at `http://localhost:9292`.

[Dockerfile]: ./Dockerfile
[docker compose]: ./docker-compose.yaml
[Docker Desktop]: https://docs.docker.com/desktop/
