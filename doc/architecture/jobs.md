# Job Architecture

**Jobs** are the background tasks that are processed by the worker. There are
multiple types of jobs, each with its own responsibilities. While some jobs are
queued to be run immediately, others are scheduled to run recurring at a set
interval.

## Implementation

Individual jobs are defined in `lib/job`. To implement a new, non-recurring job,
create a new class that extends `DocumentTransfer::Job::Base` and implements the
`#perform` method. The `#perform` method should contain the logic to be executed
when the job is processed.

To create a new recurring job, create a new class under `lib/job/cron` that
extends `DocumentTransfer::Job::Cron::Base` and implements the `#perform` method
as described above. Additionally, set `self.cron_expression` at the top of your
class to a valid [cron expression][cron].

The base classes will handle queuing, initializing the `logger`, and recording
metrics. To add your new job to the system, require the class in
`DocumentTransfer::Job.load`.

Cron jobs are automatically scheduled at boot time by the api and worker. To
ensure your jobs is scheduled, make sure it uses the
`DocumentTransfer::Job::Cron` namespace. You can find the scheduling logic in
`DocumentTransfer::Job.schedule`.

## Job types

The currently available job types are:

* `DocumentTransfer::Job::Cron::ExpireKey`: Deactivates expired authentication
  keys

### Cron::ExpireKey

!!! note

    The authentication component of the API ensures keys are not expired before
    authorizing a request. This job is a safety net to ensure that any keys that
    have expired are deactivated, and helps to keep the database clean and
    accurate.

The `DocumentTransfer::Job::Cron::ExpireKey` job is responsible for deactivating
expired authentication keys. It is scheduled to run once a day at midnight UTC.

This job will search for any keys that have expired and are still marked as
`active`. It will update the `active` flag to `false` for all matching keys.

[cron]: https://crontab.guru/
