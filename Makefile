

ifneq ($(wildcard /usr/local/bin/groff),)
    # If found, force pdfroff to use the /usr/local/bin toolchain
    export GROFF_BIN_PATH := /usr/local/bin
endif

TEXTS := language-function.text references.text

default: bibliography.i

bibliography.list: $(TEXTS)
	printf '%s\n' $^ > $@

bibliography.i: bibliography.list $(TEXTS)
	indxbib -f $< -o bibliography

.PHONY: default

