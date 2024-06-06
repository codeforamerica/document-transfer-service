# Document Transfer Service API

Interacting with the Document Transfer Service is done through a RESTful API.
All requests and responses should be in JSON format, unless otherwise indicated.

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

[destination]: destination.md
[source]: source.md
[spec]: ../openapi.yaml
