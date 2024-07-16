# Console

The Document Transfer Service includes a console that can be used for
administrative purposes and system debugging. The console uses [pry] and sets up
the environment so that can access the service's internal state.

## Usage

To access the console, you can run the following command:

```sh
bundle exec pry
```

This will drop you into the console where you can interact directly with the
classes of the service. You can use models to create and query data, and you can
directly interact with the document transfer mechanisms.

The color of the prompt with change based on the environment you are connected
to. This should provider an easy visual indicator if you are connected to a
production environment.

* Production environments will have a red prompt
* Production-like environments (e.g. staging, demo) will have a yellow prompt
* Development and testing environments will have a green prompt

### From docker

If you are running the service from docker, you can access the console through
either the running container, or an ephemeral container.

To use an ephemeral container, you can run the following command:

```bash
docker compose run api bundle exec pry
```

To use the currently running container, use the following instead:

```bash
docker compose exec api bundle exec pry
```

### From ECS

If the service is running on Amazon's Elastic Container Service (ECS), you can
use the AWS CLI to access the console. You will need the following in order to
proceed:

* The name of the ECS cluster
* The id of a running task in the cluster
* The name of the container in the task
* [ECS exec][ecs-exec] enabled on the ECS service
* The [AWS CLI][aws-cli] installed and configured
* Credentials with appropriate permissions to access the ECS service

This these satisfied, you can run the following commands to connect to the
console:

```bash
aws ecs execute-command \
  --cluster <cluster-name> \
  --task <task-id> \
  --container <container-name> \
  --command 'bundle exec pry' \
  --interactive
```

[aws-cli]: https://aws.amazon.com/cli/
[ecs-exec]: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-exec.html
[pry]: https://github.com/pry/pry
