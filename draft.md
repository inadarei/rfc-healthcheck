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
    uri: http://www.freshblurbs.com

normative:
  RFC2119:
  RFC3986:
  #RFC5226:
  RFC5988:
  RFC7234:
  RFC8259:

informative:
  RFC7230:
  RFC6838:
  RFC7231:
  RFC3339:

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
use HTTP {{RFC7230}} as their protocol. The health and uptime of these
APIs determine availability of the applications themselves. In distributed
systems built with a number of APIs, understanding the health status of the APIs
and making corresponding decisions, for failover or circuit-breaking, are
essential for providing highly available solutions.

There exists a wide variety of operational software that relies on the ability
to read health check response of APIs. There is currently no standard for the
health check output response, however, so most applications either rely on the
basic level of information included in HTTP status codes {{RFC7231}} or use
task-specific formats.

Usage of task-specific or application-specific formats creates significant
challenges, disallowing any meaningful interoperability across different
implementations and between different tooling.

Standardizing a format for health checks can provide any of a number of
benefits, including:

* Flexible deployment - since operational tooling and API clients can rely on
  rich, uniform format, they can be safely combined and substituted as needed.

* Evolvability - new APIs, conforming to the standard, can safely be introduced
  in any environment and ecosystem that also conforms to the same standard,
  without costly coordination and testing requirements.

This document defines a "health check" format using the JSON format {{RFC8259}}
for APIs to use as a standard point for the health information they offer.
Having a well-defined format for this purpose promotes good practice and
tooling.

# Notational Conventions

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD",
"SHOULD NOT", "RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be
interpreted as described in {{RFC2119}}.

# API Health Response

The API Health Response Format (or, interchangeably, "health check response
format") uses the JSON format described in {{RFC8259}} and has the media type
"application/vnd.health+json".

Its content consists of a single mandatory root field ("status") and several
optional fields:

* status: (required) indicates whether the service status is acceptable or not.
  API publishers SHOULD use following values for the field:

  - "pass": healthy,
  - "fail": unhealthy, and
  - "warn": healthy, with some concerns.

  The value of the status field is tightly related with the HTTP response code
  returned by the health endpoint. For “pass” and “warn” statuses HTTP response
  code in the 2xx range MUST be used. For “fail” status HTTP response code
  in the 4xx range MUST be used. In case of the “warn” status, additional
  information SHOULD be provided, utilizing optional fields of the response.

  A health endpoint is only meaningful in the context of the component it
  indicates the health of. It has no other meaning or purpose. As such, its
  health is a conduit to the health of the component. Clients SHOULD assume that
  the HTTP response code returned by the health endpoint is applicable to the
  entire component (e.g. a larger API or a microservice). This is compatible
  with the behavior that current infrastructural tooling expects:
  load-balancers, service discoveries and others utilizing health-checks.

* version: (optional) public version of the service.
* releaseID: (optional) in well-designed APIs, backwards-compatible changes in
  the service should not update a version number. APIs usually change their
  version number as infrequently as possible, to preserve stable interface.
  However implementation of an API may change much more frequently, which leads
  to the importance of having separate "release number" or "releaseID" that is
  different from the public version of the API.
* notes: (optional) array of notes relevant to current state of health
* output: (optional) raw error output, in case of "fail" or "warn" states. This
  field SHOULD be omitted for "pass" state.
* details: (optional) an object representing status of sub-components of the
  service in question. Please refer to the "The Details Object" section for more
  information.
* links: (optional) an array of objects containing link relations and URIs
  {{RFC3986}} for external links that MAY contain more information about the
  health of the endpoint. Per web-linking standards {{RFC5988}} a link relationship
  SHOULD either be a common/registered one or be indicated as a URI, to avoid
  name clashes.  If a "self" link is provided, it MAY be used by clients to
  check health via HTTP response code, as mentioned above.

* serviceID: (optional) unique identifier of the service, in the application
  scope.
* description: (optional) human-friendly description of the service.

# The Details Object

The "details" object MAY have a number of unique keyes, one for each logical
sub-components. Since each sub-component may be backed by several nodes with
varying health statuses, the key points to an array of objects. In case of a
single-node sub-component (or if presence of nodes is not relevant), a
single-element array should be used as the value, for consistency.

The key identifying an element in the object should be a unique string within
the details section. It MAY have two parts: "{componentName}:{metricName}", in
which case the meaning of the parts SHOULD be as follows:

* componentName: (optional) human-readable name for the component. MUST not 
  contain a colon, in the name, since colon is used as a separator.
* metricName: (optional) name of the metrics that the status is reported for.
  MUST not contain a colon, in the name, since colon is used as a separator and
  can be one of:
  * Pre-defined value from this spec. Pre-defined values include:
    * utilization
    * responseTime
    * connections
    * uptime
  * A common and standard term from a well-known source such as schema.org, IANA
    or microformats.
  * A URI that indicates extra semantics and processing rules that MAY be
    provided by a resource at the other end of the URI. URIs do not have to be
    dereferenceable, however. They are just a namespace, and the meaning of a
    namespace CAN be provided by any convenient means (e.g. publishing an RFC,
    Swagger document or a nicely printed book).

On the value eside of the equation, each "component details" object in the array
MAY have one of the following object keys:

* componentId: (optional) unique identifier of an instance of a specific
  sub-component/dependency of a service. Multiple objects with the same
  componentID MAY appear in the details, if they are from different nodes.
* componentType: (optional) SHOULD be present if componentName is present. Type
  of the component. Could be one of:
  * Pre-defined value from this spec. Pre-defined values include:
    * component
    * datastore
    * system
  * A common and standard term from a well-known source such as schema.org, IANA
    or microformats.
  * A URI that indicates extra semantics and processing rules that MAY be
    provided by a resource at the other end of the URI. URIs do not have to be
    dereferenceable, however. They are just a namespace, and the meaning of a
    namespace CAN be provided by any convenient means (e.g. publishing an RFC,
    Swagger document or a nicely printed book).    
* metricValue: (optional) could be any valid JSON value, such as: string, number,
  object, array or literal.
* metricUnit: (optional) SHOULD be present if metricValue is present. Could be
  one of:
  * A common and standard term from a well-known source such as schema.org, IANA,
    microformats, or a standards document such as {{RFC3339}}.
  * A URI that indicates extra semantics and processing rules that MAY be
    provided by a resource at the other end of the URI. URIs do not have to be
    dereferenceable, however. They are just a namespace, and the meaning of a
    namespace CAN be provided by any convenient means (e.g. publishing an RFC,
    Swagger document or a nicely printed book).
* time: the date-time, in ISO8601 format, at which the reading of the
  metricValue was recorded. This assumes that the value can be cached and the
  reading typically doesn't happen in real time, for performance and scalability
  purposes.
* output: (optional) has the exact same meaning as the top-level "output"
  element, but for the sub-component.
* links: (optional) has the exact same meaning as the top-level "output"
  element, but for the sub-component.

# Example Output

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
  "version": "1",
  "releaseID": "1.2.2",
  "notes": [""],
  "output": "",
  "serviceID": "f03e522f-1f44-4062-9b55-9587f91c9c41",
  "description": "health of authz service",
  "details": {
    "cassandra:responseTime": [
      {
        "componentId": "dfd6cf2b-1b6e-4412-a0b8-f6f7797a60d2",
        "componentType": "datastore",
        "metricValue": 250,
        "metricUnit": "ms",
        "status": "pass",
        "time": "2018-01-17T03:36:48Z",
        "output": ""
      }
    ],
    "cassandra:connections": [
      {
        "componentId": "dfd6cf2b-1b6e-4412-a0b8-f6f7797a60d2",
        "type": "datastore",
        "metricValue": 75,
        "status": "warn",
        "time": "2018-01-17T03:36:48Z",
        "output": "",
        "links": {
          "self": "http://api.example.com/dbnode/dfd6cf2b/health"
        }
      }
    ],
    "uptime": [
      {
        "componentType": "system",
        "metricValue": 1209600.245,
        "metricUnit": "s",
        "status": "pass",
        "time": "2018-01-17T03:36:48Z"
      }
    ],
    "cpu:utilization": [
      {
        "componentId": "6fd416e0-8920-410f-9c7b-c479000f7227",
        "node": 1,
        "componentType": "system",
        "metricValue": 85,
        "metricUnit": "percent",
        "status": "warn",
        "time": "2018-01-17T03:36:48Z",
        "output": ""
      },
      {
        "componentId": "6fd416e0-8920-410f-9c7b-c479000f7227",
        "node": 2,
        "componentType": "system",
        "metricValue": 85,
        "metricUnit": "percent",
        "status": "warn",
        "time": "2018-01-17T03:36:48Z",
        "output": ""
      }
    ],
    "memory:utilization": [
      {
        "componentId": "6fd416e0-8920-410f-9c7b-c479000f7227",
        "node": 1,
        "componentType": "system",
        "metricValue": 8.5,
        "metricUnit": "GiB",
        "status": "warn",
        "time": "2018-01-17T03:36:48Z",
        "output": ""
      },
      {
        "componentId": "6fd416e0-8920-410f-9c7b-c479000f7227",
        "node": 2,
        "componentType": "system",
        "metricValue": 5500,
        "metricUnit": "MiB",
        "status": "pass",
        "time": "2018-01-17T03:36:48Z",
        "output": ""
      }
    ]
  },
  "links": {
    "about": "http://api.example.com/about/authz",
    "http://api.x.io/rel/thresholds":
      "http://api.x.io/about/authz/thresholds"
  }
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

Likewise, a client encountering a 404 (Not Found) on a link is encouraged to obtain
a fresh copy of the health check response, to assure that it is up-to-date.
