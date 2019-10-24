# api-healthcheck

Health Check Response RFC Draft for HTTP APIs

Published RFC Draft: <https://tools.ietf.org/html/draft-inadarei-api-health-check>

## Workspace Setup 

```
> git clone https://github.com/inadarei/rfc-healthcheck.git
> sudo -H gem install kramdown-rfc2629
> sudo -H easy_install pip # optional, if you don't already have it
> sudo -H sudo pip install xml2rfc
> .githooks/install.sh # to enable automated rebuilds on git push
```

## Using

1. Edit draft.md
2. To regenerate the latest version of XML/TXT/HTML;

    ```
    make latest
    ```

## Known Implementations

1. Node.js: https://github.com/inadarei/maikai
2. Golang: https://github.com/nelkinda/health-go
3. .NET: https://github.com/RockLib/RockLib.HealthChecks

## References

In creation of this RFC following existing standards were reviewed and taken
into account:

1. [Kubernetes health](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-probes/#define-a-liveness-http-request)
1. [Azure health](https://docs.microsoft.com/en-us/azure/architecture/patterns/health-endpoint-monitoring)
1. [Spring Boot](https://docs.spring.io/spring-boot/docs/current/reference/html/production-ready-endpoints.html#_writing_custom_healthindicators)
1. [Node Terminus](https://github.com/godaddy/terminus)