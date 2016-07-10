#!/usr/bin/make
## submodules.mk
## Mac Radigan

.PHONY: submodules

submodules:
	$(MAKE) -C tecla libtecla.a
	$(MAKE) -C s7 libs7.a
	$(MAKE) -C chibi-scheme libchibi-scheme.a

## *EOF*
