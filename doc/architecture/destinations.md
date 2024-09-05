# Destination Architecture

**Destinations** represent the target location for a document transfer. They are
responsible for ensuring the document is successfully delivered. Like [sources],
destinations are designed to be easily extensible.

For information on specifying a destination for a transfer request, see
[Document Destinations][destinations].

## Implementation

Destinations are defined in `lib/destination`. Each destination type is
represented by a class that extends `DocumentTransfer::Destination::Base`. The
base class provides common functionality, along with a consistent interface for
all destination types to implement.

To create a new destination type, create a new class that extends
`DocumentTransfer::Destination::Base` and implements the following methods:

* `#transfer`: Transfers the source document to the destination

To add your new destination to the system, update the factory method in
`DocumentTransfer::Destination.load`. If your destination adds new parameters,
update the endpoint at `DocumentTransfer::API::Transfer` and the destination
configuration at `DocumentTransfer::Config::Destination`.

## Destination types

The currently available destination types are:

* `DocumentTransfer::Destination::OneDrive`: Transfer a document to a [OneDrive]
  or [SharePoint] folder.

[destinations]: ../api/destinations.md
[onedrive]: https://www.microsoft.com/en-us/microsoft-365/onedrive/onedrive-for-business
[sharepoint]: https://www.microsoft.com/en-us/microsoft-365/sharepoint/collaboration
[sources]: sources.md
