# api-healthcheck

Health Check Endpoint for HTTP APIs

## Workspace Setup 

```
> git clone https://github.com/inadarei/rfc-healthcheck.git
> gem install kramdown-rfc2629
> sudo easy_install pip # optional, if you don't already have it
> sudo pip install xml2rfc
```
## Using

1. Edit draft.md
2. To regenerate a specific version of the XML RFC from draft.md (e.g.);

    ```
    make draft-inadarei-api-healthcheck-00.xml
    ```