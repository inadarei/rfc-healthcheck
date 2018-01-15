# RFCbootstrap

This is an XSLT Stylesheet for transforming
[xml2rfc](http://greenbytes.de/tech/webdav/draft-reschke-xml2rfc-latest.html)
markup into [Bootstrap](http://getbootstrap.com)-based HTML. It is based upon
Julian Reschke's
[rfc2629.xslt](https://github.com/reschke/xml2rfc).

For an example of its output, see
[RFC7230](http://httpwg.github.io/specs/rfc7230.html).

A typical invocation might look like this (assuming use of
[Bower](http://bower.io) and [Jekyll](http://jekyllrb.com)):

    java -classpath lib/saxon9.jar net.sf.saxon.Transform -novw -l \
	input.xml rfcbootstrap.xslt \
	bootstrapJsUrl='/components/bootstrap/dist/js/bootstrap.min.js' \
	bootstrapCssUrl='/components/bootstrap/dist/css/bootstrap.min.css' \
	jqueryJsUrl='/components/jquery/dist/jquery.min.js' \
	siteCssUrl='/asset/site.css' \
	navbar='../../_includes/navbar.html

By default, it will use CDN versions of bootstrap and jQuery; however, these
can be overridden with the `bootstrapJsUrl`, `bootstrapCssUrl` and
`jqueryJsUrl` parameters.
