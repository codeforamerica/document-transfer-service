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
image.

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

You will also need a database for the service to store data. The service is
designed to work with a PostgreSQL database. You can configure the database
using the `DATABASE_URL` environment variable. The `sample.env` file assumes
you can connect to a database at `localhost:5432`. You can update this in your
`.env` file.

With ruby installed and the database configured, install gem dependencies and
set up the database with the following:

```bash
bundle install
bundle exec rake db:setup
```

You should now be able to start the service with:

```sh
bundle exec rackup
```

The service should now be available at `http://localhost:9292`.

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

[.env]: ./sample.env
[api]: ./doc/api.md
[create-key]: ./doc/runbooks/create_auth_key.md
[destination]: ./doc/destinations.md
[Dockerfile]: ./Dockerfile
[docker compose]: ./docker-compose.yaml
[Docker Desktop]: https://docs.docker.com/desktop/
[omz]: https://ohmyz.sh/
[ruby-version]: ./.ruby-version
[rvm]: https://rvm.io/
[source]: ./doc/sources.md
