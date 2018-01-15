---
title: Healtch Check Response for HTTP APIs
abbrev:
docname: draft-inadarei-api-healthcheck-00
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
    organization:
    email: inadarei@users.noreply.github.com
    uri: http://www.freshblurbs.com/

normative:
  RFC2119:
  RFC3986:
  RFC5226:
  RFC5988:
  RFC7159:
  RFC7234:

informative:
  RFC7230:
  RFC6838:
  RFC7231:

--- abstract

This document proposes a "health check response" format for API HTTP clients.

--- note_Note_to_Readers

*RFC EDITOR: please remove this section before publication*

The issues list for this draft can be found at <https://github.com/inadarei/rfc-healthcheck/issues>.

The most recent draft is at <https://inadarei.github.io/rfc-healthcheck/>.

Recent changes are listed at <https://github.com/inadarei/rfc-healthcheck/commits/master>.

See also the draft's current status in the IETF datatracker, at
<https://datatracker.ietf.org/doc/draft-inadarei-api-healthcheck/>.

--- middle

# Introduction

Vast majority of modern APIs, that drive data to web and mobile applications use
HTTP {{RFC7230}} as a transport protocol. The health and uptime of these APIs
determine availability of the applications themselves. In distributed systems
built with a number of APIs, understanding the health status of the APIs and
making corresponding decisions, for failover or circuit-breaking, are essential
for providing highly available solutions.

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


## Notational Conventions

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD",
"SHOULD NOT", "RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be
interpreted as described in {{RFC2119}}.


# API Health Response

An API Health Response Format (or, interchangeably, "health check response")
uses the format described in {{RFC7159}} and has the media type
"application/vnd.health+json".

**Note: this media type is not final, and will change before final publication.**

Its content consists of a root object with:

* lorem

* ipsum.

For example:

~~~
  GET / HTTP/1.1
  Host: example.org
  Accept: application/vnd.health+json

  HTTP/1.1 200 OK
  Content-Type: application/vnd.health+json
  Cache-Control: max-age=3600
  Connection: close

  {
    "foo" : "bar"
  }
~~~



# Another subtitle

Lorem Ipsum

# Final subtitle

Lorem ipsum

# Security Considerations

Clients need to exercise care when reporting health information. Malicious
actors could use this information for orchestrating attacks. In some cases the
health check endpoints may need to be authenticated and institute role-based
access control.

# IANA Considerations


## Media Type Registration

TODO: application/vnd.health+json


--- back

# Acknowledgements

Thanks to  Mike Amundsen, Erik Wilde, Justin Bachorik and Randall Randall for
their suggestions and feedback. And to Mark Nottingham for blueprint for
authoring RFCs easily.

# Creating and Serving Health Responses

When making an health check endpoint available, there are a few things to keep
in mind:

* A health response endpoint is best located at a memorable and commonly-used
  URI, such as _health because it will help self-discoverability by clients.
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


# Frequently Asked Questions

## Why not use (insert other health check format)?

There are a fair number of existing health check formats. However, these formats
have generally been optimised for particular use-cases, and less capable of
fitting into general scenarios, optimized for interoperability.

## Why doesn't the format allow references or inheritance?

Implementing them would add considerable complexity and the associated
potential for errors (both in the specification and by its users). For the sake
of interoperability and ease of implementation this specification doesn't
attempt to create the most powerful format possible.