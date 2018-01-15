
id_base = .
xml2rfc ?= xml2rfc
# saxpath ?= /usr/local/share/saxon-b/saxon9.jar
saxpath ?= ./bin/saxon9he.jar
kramdown-rfc2629 ?= kramdown-rfc2629
bootstrap ?= ./Tools/rfcbootstrap/rfcbootstrap.xslt
idnits ?= idnits

#title = nottingham-$(shell basename ${CURDIR})
title = inadarei-api-healthcheck
latest = $(shell (ls draft-${title}-*.xml || echo "draft-${title}-00.xml") | sort | tail -1)
version = $(shell basename ${latest} .xml | awk -F- '{print $$NF}')

target = draft-$(title)-$(version)
prev = draft-$(title)-$(shell printf "%.2d" `echo ${version}-1 | bc`)
next = draft-$(title)-$(shell printf "%.2d" `echo ${version}+1 | bc`)

.PHONY: latest clean next diff idnits update

latest: $(target).html $(target).txt index.html index.txt

clean:
	rm -f $(target).html $(target).txt

next: 
	cp $(target).xml $(next).xml
	sed -i '' -e"s/$(target)/$(next)/" draft.md

diff: 
	rfcdiff $(prev).txt $(target).txt

idnits: $(target).txt
	$(idnits) $<

%.xml: draft.md
	$(kramdown-rfc2629) $< > $@
	
%.html: %.xml
	sed -i '' -e"s/\"rfc2629.dtd/\"$(id_base)\/Tools\/rfcbootstrap\/rfc2629.dtd/" $<
	java -classpath $(saxpath) net.sf.saxon.Transform -l $< $(bootstrap) \
	bootstrapJsUrl='../Tools/bower_components/bootstrap/dist/js/bootstrap.min.js' \
	bootstrapCssUrl='../Tools/bower_components/bootstrap/dist/css/bootstrap.min.css' \
	jqueryJsUrl='../Tools/bower_components/jquery/dist/jquery.min.js' \
	navbar='../Tools/navbar.html' \
	> $@
#	$(xml2rfc) --html $< $@

%.txt: %.xml
	$(xml2rfc) $< $@

index.html: $(target).html
	cp $< $@

index.txt: $(target).txt
	cp $< $@

update:
	cp $(id_base)/Tools/skel/Makefile .
