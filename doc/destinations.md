# Document Destinations

Document destinations are the final location for a document transfer. When
making a transfer request, the parameters you provide will depend on the source
type.

Unlike sources, the selected destination will also influence the response.

_Note: Some destination types may require additional configuration of the
service._

## OneDrive

With the OneDrive destination, the service will upload the document to a
configured [Microsoft OneDrive][onedrive] account.

### Configuration

_**The OneDrive destination requires additional configuration of the service in
order to function properly.**_

Before you can use the OneDrive destination, you must create a new application
in the Azure Portal, with read and write permissions to the appropriate OneDrive
account. Created a client id and secret for the application to use for
authenticating.

The following environment variables must be set on the service:

| Name                   | Description                                                         |
|------------------------|---------------------------------------------------------------------|
| ONEDRIVE_CLIENT_ID     | The client ID of the OneDrive application.                          |
| ONEDRIVE_CLIENT_SECRET | The client secret of the OneDrive application.                      |
| ONEDRIVE_DRIVE_ID      | The drive ID of the OneDrive account documents will be uploaded to. |
| ONEDRIVE_TENANT_ID     | The tenant ID of the OneDrive application.                          |

### Request Parameters

| Name     | Description                                  | Type     | Default           | Required |
|----------|----------------------------------------------|----------|-------------------|----------|
| filename | The path in the drive to upload the file to. | `string` | `source.filename` | NO       |
| path     | The path in the drive to upload the file to. | `string` | `""`              | NO       |

If the `filename` parameter is not provided, the service will use the filename
from the source. If the source URL does not contain a filename, such as when
using an S3 presigned url, this may result in your transfer failing.

### Example request

```json
{
  "source": {
    ...
  },
  "destination": {
    "type": "onedrive",
    "path": "/document/path"
  }
}
```

### Response parameters

| Name | Description                                                   | Type     |
|------|---------------------------------------------------------------|----------|
| path | The path, including filename, of the file on the destination. | `string` |

### Example response

```json
{
  "status": "success",
  "destination": "onedrive",
  "path": "/document/path/document.pdf"
}
```

[onedrive]: https://www.microsoft.com/en-us/microsoft-365/onedrive/onedrive-for-business
