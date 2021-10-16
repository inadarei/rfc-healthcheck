xml2rfc ?= xml2rfc
kramdown-rfc2629 ?= kramdown-rfc2629
idnits ?= idnits

title = inadarei-api-health-check
latest = $(shell (ls draft-${title}-*.xml || echo "draft-${title}-00.xml") | sort | tail -1)
version = $(shell basename ${latest} .xml | awk -F- '{print $$NF}')

target = draft-$(title)-$(version)
prev = draft-$(title)-$(shell printf "%.2d" `echo ${version}-1 | bc`)
next = draft-$(title)-$(shell printf "%.2d" `echo ${version}+1 | bc`)

.PHONY: latest clean next diff idnits update

latest:
	$(kramdown-rfc2629) draft.md > $(target).xml
	$(xml2rfc) $(target).xml --text --html
	cp $(target).html index.html
	cp $(target).txt index.txt

#latest: $(target).html $(target).txt index.html index.txt

clean:
	rm -f $(target).html $(target).txt

next: 
	cp $(target).xml $(next).xml
	sed -i '' -e"s/$(target)/$(next)/" draft.md

diff: 
	rfcdiff $(prev).txt $(target).txt

idnits: $(target).txt
	$(idnits) $<

# %.xml: draft.md
# 	$(kramdown-rfc2629) $< > $@
# 
# %.html: %.xml
# 	$(xml2rfc) --html --text $< 
# 
# %.txt: %.xml
# 	$(xml2rfc) $< 
# 
# index.html: $(target).html
# 	cp $< $@
# 
# index.txt: $(target).txt
# 	cp $< $@
