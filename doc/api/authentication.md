# API Authentication

The API uses [bearer tokens][bearer] for any endpoints that require
authentication. Two pieces of information must be passed in the `authorization`
header with your request in order to properly authenticate:

1. The "realm" must be set to your consumer id
2. Your unique authentication token

A properly formatted header will similar to the following:

```http request
authorization: Bearer realm="c57a46d7-d053-4eea-a6c5-1ec4e3d2f267" MYVJvZ7ay1ecAPU7aXMb26E6bpL5qX57BYY8q7KSyYU= 
```

## Creating

See the [create auth key][create] runbook for information on how to create a new
consumer and/or authentication key.

[bearer]: https://datatracker.ietf.org/doc/html/rfc6750
[create]: ../runbooks/create_auth_key.md
