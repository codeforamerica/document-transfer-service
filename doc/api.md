# Document Transfer Service API

```mermaid
sequenceDiagram
    critical Request a document transfer
        activate Consumer
        activate API
        activate Database
        Consumer->>API: Request transfer
        API->>Database: Record transfer
        API->>Database: Enqueue background job
        API->>Consumer: Return transfer id
        deactivate Consumer
    end

    critical Background job processing
        activate Worker
        loop until success or max attempts
            Worker->>Database: Reserve job
            activate Source
            Worker->>Source: Fetch document
            deactivate Source
            activate Destination
            Worker->>Destination: Transfer document
            deactivate Destination
            alt Transfer succeeded
                Worker->>Database: Update request status
                Worker->>Database: Mark job complete
            else Transfer failed
                alt Max attempts reached
                    rect rgb(191, 223, 255)
                    Worker->>Database: Update request status
                    Worker->>Database: Mark job failed
                    end
                else Retry transfer
                    Worker->>Database: Mark job failed
                end
            end
        end
        deactivate Worker
    end

    opt Check transfer status
        activate Consumer
        Consumer->>API: Check transfer status
        API->>Database: Retrieve transfer status
        API->>Consumer: Return transfer status
        deactivate Database
        deactivate API
        deactivate Consumer
    end
```

Interacting with the Document Transfer Service is done through a RESTful API.
All requests and responses should be in JSON format, unless otherwise indicated.

See the [authentication] documentation for information on how to authenticate.

Full API documentation can be found in the [OpenAPI specification][spec].

## GET /health

A basic health endpoint that will return a 200 status code if the API is
running.

_Note: This endpoint does not require authentication._

Example response:

```json
{ "status": "ok" }
```

## POST /transfer

Initiate a document transfer. This is a synchronous request that will return
once the transfer is complete or a failure occurs.

The required parameters for this request will vary based on the [source] and
[destination] types.

Successful requests will always include a `status` and `destination` field.
Additional fields may be included based on the destination type.

### Example request

```json
{
  "source": {
    "type": "url",
    "url": "https://example.com/document.pdf"
  },
  "destination": {
    "type": "onedrive",
    "path": "/document/path"
  }
}
```

### Example response:

```json
{
  "status": "success",
  "destination": "onedrive",
  "path": "/document/path/document.pdf"
}
```

## Instrumentation

The following metrics are reported for each API call using the
`DocumentTransfer::API::Middleware::Instrument` middleware for rack.

| Metric Name                  | Description                                                |
|------------------------------|------------------------------------------------------------|
| `endpoint.requests.count`    | Counter incremented with each request to a valid endpoint. |
| `endpoint.requests.duration` | Request duration, in milliseconds, for valid endpoints.    |

## Logging

All requests are logged using the `DocumentTransfer::API::Middleware::Logger`
middleware for rack. The logger utilizes [semantic logging][semantic_logger] in
JSON format to provide easily parsable log entries.

[authentication]: ./api/authentication.md
[destination]: ./api/destinations.md
[semantic_logger]: https://logger.rocketjob.io/
[source]: ./api/sources.md
[spec]: https://github.com/codeforamerica/document-transfer-service/blob/main/openapi.yaml
