
TEXTS := language-function.text references.text

default: bibliography.i

INDXBIB := $(if $(wildcard /usr/local/bin/indxbib), \
	/usr/local/bin/indxbib,indxbib)

bibliography.i: bibliography.list $(TEXTS)
	$(INDXBIB) -f $< -o bibliography


bibliography.list: $(TEXTS)
	printf '%s\n' $^ > $@

.PHONY: default

