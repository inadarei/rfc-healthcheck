---
title: Health Check Response Format for HTTP APIs
abbrev:
docname: draft-inadarei-api-health-check-00
date: 2018
category: info

ipr: trust200902
area: General
workgroup:
keyword: Internet-Draft

stand_alone: yes
pi: [toc, tocindent, sortrefs, symrefs, strict, compact, comments, inline]

author:
 -
    ins: I. Nadareishvili
    name: Irakli Nadareishvili
    street: 114 5th Avenue
    city: New York
    country: United States
    email: irakli@gmail.com
    uri: http://www.freshblurbs.com/

normative:
  RFC2119:
  RFC3986:
  #RFC5226:
  RFC5988:
  RFC7159:
  RFC7234:

informative:
  RFC7230:
  RFC6838:
  RFC7231:

--- abstract

This document proposes a service health check response format for HTTP APIs.

--- note_Note_to_Readers

**RFC EDITOR: please remove this section before publication**

The issues list for this draft can be found at <https://github.com/inadarei/rfc-healthcheck/issues>.

The most recent draft is at <https://inadarei.github.io/rfc-healthcheck/>.

Recent changes are listed at <https://github.com/inadarei/rfc-healthcheck/commits/master>.

See also the draft's current status in the IETF datatracker, at
<https://datatracker.ietf.org/doc/draft-inadarei-api-health-check/>.

--- middle

# Introduction

The vast majority of modern APIs driving data to web and mobile applications
use HTTP {{RFC7230}} as a transport protocol. The health and uptime of these
APIs determine availability of the applications themselves. In distributed
systems built with a number of APIs, understanding the health status of the APIs
and making corresponding decisions, for failover or circuit-breaking, are
essential for providing highly available solutions.

There exists a wide variety of operational software that relies on the ability
to read health check response of APIs. There is currently no standard for the
health check output response, however, so most applications either rely on the
basic level of information included in HTTP status codes {{RFC7231}} or use
task-specific formats.

Usage of task-specific or application-specific rformats creates significant
challenges, disallowing any meaningful interoprerability across different
implementations and between different tooling.

Standardizing a format for health checks can provide any of a number of
benefits, including:

* Flexible deployment - since operational tooling and API clients can rely on
  rich, uniform format, they can be safely combined and substituted as needed.

* Evolvability - new APIs, conforming to the standard, can safely be introduced
  in any environment and ecosystem that also conforms to the same standard,
  without costly coordination and testing requirements.

This document defines a "health check" format using the JSON format {{RFC7159}}
for APIs to use as a standard point for the health information they offer.
Having a well-defined format for this purpose promotes good practice and
tooling.

# Notational Conventions

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD",
"SHOULD NOT", "RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be
interpreted as described in {{RFC2119}}.

# API Health Response

An API Health Response Format (or, interchangeably, "health check response")
uses the format described in {{RFC7159}} and has the media type
"application/vnd.health+json".

**Note: this media type is not final, and will change before final publication.**

Its content consists of a single mandatory root field ("status") and several
optional fields:

* status: (required) indicates whether the service status is acceptable or not.
  API publishers SHOULD use following values for the field: 
  
  - "pass": healthy, 
  - "fail": unhealthy, and
  - "warn": healthy, with some concerns. 
  
  For "pass" and "warn" statuses HTTP response code in the 2xx - 3xx range MUST
  be used. for "fail" status HTTP response code in the 4xx - 5xx range MUST be
  used. In case of the "warn" status, additional information SHOULD be provided,
  utilizing optional fields of the response.

* version: (optional) public version of the service.
* release_id: (optional) in well-designed APIs, backwards-compatible changes in
  the service should not update a version number. APIs usually change their
  version number as infrequently as possible, to preserve stable interface.
  However implementation of an API may change much more frequently, which leads
  to the importance of having separate "release number" or "release_id" that is
  different from the public version of the API.
* memory: (optional) array of sizes for the  currently utilized resident memory
  (in kilobytes) on each of the logical nodes backing the service. Logical node
  can be a physical server, VM, a container or any other logical unit that makes
  sense for service publisher.
* cpu: (optional) array of cpu utiliation percentage on each of the logical
  nodes backing the service. Logical node can be a physical server, VM, a
  container or any other logical unit that makes sense for service publisher.
* uptime: (optional) current uptime in seconds since the last restart
* connections: (optional) current number of active connections
* notes: (optional) array of notes relevant to current state of health
* output: (optional) raw error output, in case of "fail" or "warn" states. This
  field SHOULD be omitted for "pass" state.
* details: (optional) an array of objects optionally providing additional information
  regarding the various sub-components of the service.
* links: (optional) an array of objects containing link relations and URIs 
  {{RFC3986}} for external links that MAY contain more information about the 
  health of the endpoint. Per web-linking standards {{RFC5988}} a link relationship
  SHOULD either be a common/registered one or be indicated as a URI, to avoid
  name clashes. 
* serviceID: (optional) unique identifier of the service, in the application
  scope.
* description: (optional) human-friendly description of the service.

For example:

~~~
  GET /health HTTP/1.1
  Host: example.org
  Accept: application/vnd.health+json

  HTTP/1.1 200 OK
  Content-Type: application/vnd.health+json
  Cache-Control: max-age=3600
  Connection: close

  {
    "status": "pass",
    "version" : "1",
    "release_id" : "1.2.2",
    "memory": [4096, 1024, 3456],
    "cpu": [20, 40, 50],
    "uptime": "1209600.245",
    "connections" : 25,
    "notes": [""],
    "output": "",
    "details": [
      {
        "id": "dfd6cf2b-1b6e-4412-a0b8-f6f7797a60d2",
        "name": "sub-component-X",
        "value": "12313",
        "status": "pass",
        "output": ""
      },
      {
        "id": "3c1f048c-a4be-4aa2-83e6-2629073d19dc",
        "name": "Cassandra test query duration in ms",
        "value": "250",
        "status": "warn",
        "output": "Response time over target of less than 100ms"
      }
    ],
    "links": [
      {"rel": "about", "uri": "http://api.example.com/about/authz"},
      {
        "rel": "http://api.example.com/rel/thresholds",
        "uri": "http://api.example.com/about/authz/thresholds"
      }
    ],
    "serviceID": "f03e522f-1f44-4062-9b55-9587f91c9c41",
    "description": "health of authz service"
  }
~~~

# Security Considerations

Clients need to exercise care when reporting health information. Malicious
actors could use this information for orchestrating attacks. In some cases the
health check endpoints may need to be authenticated and institute role-based
access control.

# IANA Considerations

## Media Type Registration

TODO: application/vnd.health+json is being submitted for registration per
{{RFC6838}}


--- back

# Acknowledgements

Thanks to  Mike Amundsen, Erik Wilde, Justin Bachorik and Randall Randall for
their suggestions and feedback. And to Mark Nottingham for blueprint for
authoring RFCs easily.

# Creating and Serving Health Responses

When making an health check endpoint available, there are a few things to keep
in mind:

* A health response endpoint is best located at a memorable and commonly-used
  URI, such as "health" because it will help self-discoverability by clients.
* Health check responses can be personalized. For example, you could advertise
  different URIs, and/or different kinds of link relations, to afford different
  clients access to additional health check information. 
* Health check responses must be assigned a freshness lifetime (e.g.,
  "Cache-Control: max-age=3600") so that clients can determine how long they
  could cache them, to avoid overly frequent fetching and unintended DDOS-ing of
  the service. 
* Custom link relation types, as well as the URIs for variables, should lead to
  documentation for those constructs.


# Consuming Health Check Responses

Clients might use health check responses in a variety of ways.

Note that the health check response is a "living" document; links from the
health check response MUST NOT be assumed to be valid beyond the freshness
lifetime of the health check response, as per HTTP's caching model {{RFC7234}}.

As a result, clients ought to cache the health check response (as per
{{RFC7234}}), to avoid fetching it before every interaction (which would
otherwise be required).

Likewise, a client encountering a 404 (Not Found) on a link is encouraged obtain
a fresh copy of the health check response, to assure that it is up-to-date.
