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

Follow the documentation below for your preferred method of running the service.
Once you have the service running, see [Create Auth Key][create-key] to set up
credentials to use the [API].

### Docker

This service is designed to be run in a containerized environment. As such, it
includes a [Dockerfile] and a [docker compose] file to facilitate running the
service.

Using docker compose, the application code will be mounted from your local
system to the running container. This will allow you to make changes to the
code and see them reflected in the running service without having to rebuild the
image. Using docker compose will launch the api, the worker, and a database.

To run the service with docker compose, make sure you have [Docker Desktop]
installed and run the following:

```sh
docker compose up -d
```

The service should now be available at `http://localhost:3000`.

#### Updating the docker image

When you run `docker compse up -d`, the service will be updated to match the
latest state defined in compose file. However, it will not detect changes that
may require a rebuild of the image. In order to force a rebuild, you can pass
the `--build` flag to the command:

```bash
docker compose up -d --build
```

You can also update _just_ the api service by specifying the service name:

```bash
docker compose up -d --build api
```

### Locally

In order to run the service locally, you will need to have Ruby installed. We
recommend using a virtual environment manager such as [RVM] to manage your Ruby
installations. The required version of Ruby is defined in the
[`.ruby-version`][ruby-version] file.

You will also need a database for the service to store data. Please review the
[database documentation][database] for more information on how to configure the
service to connect to your database before proceeding.

With ruby installed and the database configured, install gem dependencies and
set up the database with the following:

```bash
bundle install
bundle exec rake db:setup
```

You should now be able to start the service with:

```sh
./script/api
```

The service should now be available at `http://localhost:9292`.

#### Running the worker

The worker is a separate process that is responsible for processing background
jobs. Depending on the parts of the service you're using, you may need to run
the worker alongside the API.

To run the worker, see the [worker documentation][worker] for more information.

#### Updating the service

When you update the service locally, you will need to install any new
dependencies and run any database migrations before you can start the service.
You can do this by running the following:

```bash
bundle install
bundle exec rake db:migrate
```

#### Dropping or resetting the database

If you need to reset the database to it's initial state, you can use the
following:

```bash
bundle exec rake db:reset
```

If you'd like to drop the database entirely, you can do so with:

```bash
bundle exec rake db:drop
```

## Usage

See the [API documentation][api] for information on how to interact with the
service.

## Documentation

Necessary documentation to operate, use, maintain, and contribute to the service
is included in this repository. The majority of these documents are written in
Markdown and can be rendered directly in GitHub or you favorite IDE. However,
the documentation as a whole is meant to be converted to a static site using
[MkDocs].

In order to view the documentation in its intended form locally, you can use the
included docker container. Simply run the following:

```bash
docker compose --profile docs up -d
```

The documentation should then be available at http://localhost:8000.

[.env]: https://github.com/codeforamerica/document-transfer-service/blob/main/sample.env
[api]: ./api.md
[create-key]: ./runbooks/create_auth_key.md
[database]: ./database.md
[destination]: ./api/destinations.md
[Dockerfile]: https://github.com/codeforamerica/document-transfer-service/blob/main/Dockerfile
[docker compose]: https://github.com/codeforamerica/document-transfer-service/blob/main/docker-compose.yaml
[Docker Desktop]: https://docs.docker.com/desktop/
[mkdocs]: https://www.mkdocs.org/
[omz]: https://ohmyz.sh/
[ruby-version]: https://github.com/codeforamerica/document-transfer-service/blob/main/.ruby-version
[rvm]: https://rvm.io/
[source]: ./api/sources.md
[worker]: ./worker.md
