# Document Sources

Document sources are the starting point for a document transfer. The source
document must be accessible by the Document Transfer Service. When making a
transfer request, the parameters you provide will depend on the source type.

_Note: Some source types may require additional configuration of the service._

## URL

Using a URL as a source, the service will retrieve the document from the
specified url. If your source document is in an Amazon S3 bucket, or something
similar, it's recommended that you use a short-lived pre-signed URL.

### Parameters

| Name | Description                     | Type     | Default | Required |
|------|---------------------------------|----------|---------|----------|
| url  | The URL of the source document. | `string` |         | YES      |

### Example request

```json
{
  "source": {
    "type": "url",
    "url": "https://example.com/document.pdf"
  },
  "destination": {
    ...
  }
}
```
