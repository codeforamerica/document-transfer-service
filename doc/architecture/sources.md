# Sources Architecture

**Sources** represent the origin of a document. They are responsible for
providing the document content and metadata for a transfer. The source
architecture is designed to be extensible, allowing for the addition of new
source types with minimal changes to existing code.

For information on specifying a source for a transfer request, see [Document
Sources][sources].

## Implementation

Sources are defined in `lib/source`. Each source type is represented by a class
that extends `DocumentTransfer::Source::Base`. The base class provides common
functionality, along consistent interface for all source types to implement.

To create a new source type, create a new class that extends
`DocumentTransfer::Source::Base` and implements the following methods:

* `#fetch`: Fetches the document content from the source
* `#filename`: Returns the filename of the document at the source
* `#mime_type`: Returns the MIME type of the document
* `#size`: Returns the size of the document in bytes

To add your new source to the system, update the factory method in
`DocumentTransfer::Source.load`. If your source adds new parameters, update the
endpoint at `DocumentTransfer::API::Transfer` and the source configuration at
`DocumentTransfer::Config::Source`.

## Source types

The currently available source types are:

* `DocumentTransfer::Source::Url`: Represents a document available at a remote
  URL

[sources]: ../api/sources.md
