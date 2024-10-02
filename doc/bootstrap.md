# Boostrap System

Before the system can be run, the components must be properly initialized. The
**boostrap system** provides a modular way to initialize the required system
components. Bootstrap modes can include one or more reusable stages, and are
called by the various system entry points.

## Modes

Boostrap modes define one or more stages that are executed in order. Modes can
be used to define the initialization process for different system entry points.

The following modes are available:

* `API`: Initializes components required to run the API
* `Console`: Initializes components required to use the developer console
* `Rake`: Initializes components required to run rake tasks
* `Worker`: Initializes components required to run the worker

### Implementation

Boostrap modes are defined in the `lib/bootstrap`. Each mode is represented by a
class that extends `DocumentTransfer::Bootstrap::Mode`.

To create a new bootstrap mode, create a new class that extends
`DocumentTransfer::Bootstrap::Mode` and implement the `#bootstrap` method. This
method should execute the stages required to initialize the system, along with
performing any other necessary startup tasks.

!!! tip "Stage Ordering"

    The order in which stages are executed is determined by the order in which
    they are defined in the `#bootstrap` method. Some stages may depend on
    others being executed first; however, there is no built-in dependency
    management for stages.

For example, to initialize the logger and a database, you would define your
`#bootstrap` method as follows:

```ruby
def bootstrap
  Stage::Logger.new(config).bootstrap
  Stage::Database.new(config).bootstrap
end
```

Note that `config` comes from the base class and is an [application
configuration object][config].

## Stages

Stages are the individual components that make up a bootstrap mode. Each stage
is responsible for initializing a specific component of the system.

!!! tip "Reusable Stages"

    Stages are designed to be reusable across multiple bootstrap modes. This
    allows you to define a stage once and use it in multiple modes.

The following stages are currently implemented:

* `Database`: Initializes the database connection
* `Jobs`: Initializes the job queue and ensures recurring jobs are scheduled
* `Logger`: Initializes the logger
* `Models`: Load models into memory. This is useful for preloading models in
  environments where lazy loading is not desired.
* `Prompt`: Configures the prompt for the developer console
* `RakeTasks`: Loads custom rake tasks
* `Telemetry`: Configures OpenTelemetry for distributed tracing
* `Worker`: Creates a thread to monitor the job queue

## Implementation

Bootstrap stages are defined in the `lib/bootstrap/stage` directory. Each stage
is represented by a class that extends
`DocumentTransfer::Bootstrap::Stage::Base`.

To create a new bootstrap stage, create a new class that extends
`DocumentTransfer::Bootstrap::Stage::Base` and implement the `#bootstrap`
method. This method should perform the necessary initialization tasks for the
component the stage is responsible for.


[config]: configuration.md
