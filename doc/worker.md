# Document Transfer Service Worker

The Document Transfer Service utilizes [delayed_job] to schedule and execute
background tasks. The worker is responsible for processing those tasks.

## Starting

The worker can be started by running the following from the root of the
repository:

```bash
./script/worker run
```

This will run the worker in the foreground, allowing you to see the output
in your console. To run the worker in the background, you can use the `start`
and `stop` commands.

```bash
./script/worker start
./script/worker stop
```

## Configuration

The worker requires little configuration, and the defaults will be appropriate
for most deployments. If you'd like to customize the configuration, you can set
the following environment variables:

| Name                   | Description                                       | Default |
|------------------------|---------------------------------------------------|---------|
| `QUEUE_STATS_INTERVAL` | Interval, in seconds, to report queue statistics. | `30`    |

## Instrumentation

The following metrics are collected and reported by StatsD regularly (default is
every 30 seconds). They are gathered by a separate thread that is created when
bootstrapping the worker in `DocumentTransfer::Bootstrap::Stage::Worker`.

| Metric Name                 | Description                                                                                                      |
|-----------------------------|------------------------------------------------------------------------------------------------------------------|
| `jobs.queue.oldest.age`     | Age, in seconds, of the oldest job in the queue. Does not include recurring jobs scheduled to run in the future. |
| `jobs.queue.size.recurring` | Total number of recurring jobs in the queue.                                                                     |
| `jobs.queue.size.running`   | Number of jobs currently being processed by a worker.                                                            |
| `jobs.queue.size.total`     | Total number of jobs in the queue, including recurring jobs.                                                     |
| `jobs.queue.size.waiting`   | Number of jobs waiting to be processed, excluding recurring jobs scheduled to run in the future.                 |

Additionally, the following metrics are reported for each job:

| Metric Name               | Description                                            |
|---------------------------|--------------------------------------------------------|
| `jobs.queued.count`       | This counter is incremented each time a job is queued. |
| `jobs.completed.duration` | Execution time for individual jobs.                    |

## Tooling

The following [rake] tasks are available to help with managing the queue:

- `rake jobs:queue` - Print information about the queue in JSON format.
- `rake jobs:schedule` - Schedule all recurring jobs.

[delayed_job]: https://github.com/collectiveidea/delayed_job
[rake]: https://ruby.github.io/rake/
