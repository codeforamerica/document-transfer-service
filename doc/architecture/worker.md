# Worker Architecture

The **Worker** is responsible for processing all background jobs. It is a key
component of the Document Transfer Service, as it is responsible for the actual
transfer of documents between the source and destination.

We use [Delayed::Job][delayed_job] to manage background jobs. It uses the same
PostgreSQL database as the rest of the system to store job information through a
custom backend implementation.

# Components

The worker can be broken down into the following components:

* **Delayed::Job**: Background job processing
* **Job**: Background task to be processed
* **Source**: Document source
* **Destination**: Document destination
* **Sequel**: Database ORM

```plantuml
!include https://raw.githubusercontent.com/plantuml-stdlib/C4-PlantUML/master/C4_Component.puml

title Document Transfer Service - Worker Component Diagram
AddRelTag("optional", $textColor="gray", $lineColor="gray", $lineStyle = DashedLine())
AddBoundaryTag("system", $borderColor="#1168bd", $fontColor="#1168bd", $bgColor="transparent")
AddBoundaryTag("container", $borderColor="#438dd5", $fontColor="#438dd5", $bgColor="transparent")

System_Ext(benefits_app, "Benefits Application", "Digital application for benefits")
System_Ext(benefits_system, "Benefits System", "System that processes benefits applications")

System_Boundary(doc_transfer, "Document Transfer Service") {
  Container(api, "API", "Handles incoming requests")
  ContainerDb(postgres, "PostgreSQL", "Stores transfer requests")

  Container_Boundary(worker, "Worker") {
    Component(delayed_job, "Delayed::Job", "Background job processing")
    Component(sequel, "Sequel", "Database ORM")
    Component(job, "Job", "Document transfer job")
    Component(source, "Source", "Document source")
    Component(destination, "Destination", "Document destination")

    Rel_D(delayed_job, sequel, "Claims job")
    Rel_L(sequel, postgres, "Read/Write")
    Rel_R(delayed_job, job, "Processes")
    Rel_D(job, source, "Retrieves")
    Rel_R(job, destination, "Transfers")
    Rel_D(job, sequel, "Updates request")
    Rel_U(destination, benefits_system, "Sends")
  }

  Rel_D(api, postgres, "Records")
}

Rel_R(benefits_app, benefits_system, "Submits", $tags="optional")
Rel_D(benefits_app, api, "Requests")

footer Last updated 2024-09-04 for Document Transfer Service v1.0.0
```

## Delayed::Job

!!! note "Alternative Backends"

    We chose a background processing library that uses a database to store job
    information. While other backends such as Valkey or Dragonfly may allow for
    faster queue processing, our current traffic volume does not require such
    optimizations, and we prefer the simplicity and resiliency of a
    database-backed solution.

[Delayed::Job][delayed_job] is a background job processing library for Ruby that
utilizes a database to store job information. It is run as a daemon process that
polls the database for new jobs to process. Jobs are claimed by a worker
instance, locking it to prevent other workers from processing the same job.

If a job fails, **Delayed::Job** will automatically add the job back to the
queue so that it can be retried, using an [exponential backoff][backoff]
strategy. This increases the likelihood of the job succeeding on subsequent
attempts in the case of transient failures -- such as the source or destination
being temporarily unavailable.

If a job succeeds, **Delayed::Job** will remove the job from the queue.

## Job

The **job** component is a background task that is processed by the worker. The
data required to process the job is deserialized automatically when it is loaded
by the worker.

The actions performed by the job differ depending on the type of job. For
details on how the different job types are processed, see the
[Jobs Architecture][jobs].

## Source

Used by document transfer jobs to retrieve the source document. The source
component is responsible for fetching the document from the source location,
as well as exposing necessary metadata about the document.

See the [Sources Architecture][sources] for more details.

## Destination

Used by document transfer jobs to transfer the document to the configured
destination.

See the [Destinations Architecture][destinations] for more details.

[backoff]: https://en.wikipedia.org/wiki/Exponential_backoff
[delayed_job]: https://github.com/collectiveidea/delayed_job
[destinations]: destinations.md
[jobs]: jobs.md
[sources]: sources.md
