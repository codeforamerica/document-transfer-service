# Database

The Document Transfer service is designed to work with a PostgreSQL database.

## Configuration

You can configure the database using the environment variables below. The
`sample.env` file assumes that you can connect to a database at
`localhost:5432`. You can update this in your `.env` file.

| Name                | Description                                                                   | Default             | Required |
|---------------------|-------------------------------------------------------------------------------|---------------------|----------|
| `BASE_DATABASE`     | The base database to use when the expected database has not yet been created. | `postgres`          | no       |
| `DATABASE_ADAPTER`  | The adapter to use for the database connection.                               | `postgresql`        | no       |
| `DATABASE_HOST`     | The host of the database server.                                              | `localhost`         | no       |
| `DATABASE_NAME`     | The name of the database to connect to.                                       | `document_transfer` | no       |
| `DATABASE_PASSWORD` | The password for the database user.                                           | `""`                | no       |
| `DATABASE_PORT`     | The port of the database server.                                              | `5432`              | no       |
| `DATABASE_USER`     | The user to connect to the database as.                                       | `postgres`          | no       |

Note that while the adapted can be changed, the service is designed to work with
PostgreSQL, and therefore only bundles the `pg` gem by default in production.
`sqlite3` is included in test environments for testing purposes, and is not
supported for production use.

## Creating, updating, and dropping the database

Once you have the database configured, you can use the included [rake] commands
to manage the database.

To create the database, run the following command. If the database exists, this
command will still exit 0 without making any changes, making it safe to run
repeatedly.

```bash
bundle exec rake db:create
```

To update the schema by running [migrations]:

```bash
bundle exec rake db:migrate
```

You can also run these steps together:

```bash
bundle exec rake db:setup
```

You can restore the database to its initial state with the command below. This
will drop all existing tables and recreate the schema.

```bash
bundle exec rake db:reset
````

Finally, you can drop the entire database with:

```bash
bundle exec rake db:drop
```

Note that both `db:reset` and `db:drop` will refuse to run in production.

## Schema and migrations

The service uses the [sequel] gem to manage the database schema via
[migrations][sequel-migrations]. These migrations are stored in the
[`db/migrate`][migrate] directory and are prefixed with a timestamp to ensure
they run in proper order and avoid collisions.

Migrations can be run using the following command:

```bash
bundle exec rake db:migrate
```

You can migrate to a specific version (up or down) by passing the version
number:

```bash
bundle exec rake db:migrate\[202407082156]
```

[migrate]: ./db/migrate
[migrations]: #schema-and-migrations
[rake]: https://ruby.github.io/rake/
[sequel]: https://sequel.jeremyevans.net/
[sequel-migrations]: https://sequel.jeremyevans.net/rdoc/files/doc/migration_rdoc.html
