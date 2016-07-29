#!/usr/bin/make
## submodules.mk
## Mac Radigan

.PHONY: submodules clean clobber

submodules:
	$(MAKE) -C tecla
	$(MAKE) -C s7 libs7.a
	$(MAKE) -C chibi-scheme libchibi-scheme.a

clean:
	$(MAKE) -C tecla        $@
	$(MAKE) -C s7           $@
	$(MAKE) -C chibi-scheme $@

clobber: clean

## *EOF*
