# Document Transfer Service

A microservice to securely transfer documents.

## Configuration

The service is configured using a series of environment variables. The actual
variables required will depend on the [source] and [destination] types you wish
to support.

A [sample `.env` file][.env] has been included to help you get started. Simply
copy this file to `.env` and update the values as needed.

Make sure this file is then loaded into your environment before running the
service. This can be done automatically through various shell tools (such as
[Oh My Zsh][omz]), or manually by running the following:

```bash
source .env
```

_Note: Your `.env` file will contain sensitive information. This file is ignored
by git, but it is your responsibility to ensure this file remains safe and
secure._

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

## Usage

See the [API documentation][api] for information on how to interact with the
service.

[.env]: ./sample.env
[api]: ./doc/api.md
[destination]: ./doc/destinations.md
[Dockerfile]: ./Dockerfile
[docker compose]: ./docker-compose.yaml
[Docker Desktop]: https://docs.docker.com/desktop/
[omz]: https://ohmyz.sh/
[source]: ./doc/sources.md
