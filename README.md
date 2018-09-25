# api-healthcheck

Health Check Response RFC Draft for HTTP APIs

RFC Draft: https://tools.ietf.org/html/draft-inadarei-api-health-check-01

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
