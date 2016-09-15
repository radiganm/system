#!/usr/bin/make
## submodules.mk
## Copyright 2016 Mac Radigan
## All Rights Reserved

.PHONY: submodules clean clobber

submodules: configure
	$(MAKE) -C tecla
	$(MAKE) -C s7 libs7.a
	$(MAKE) -C chibi-scheme libchibi-scheme.a
	$(MAKE) -C dispmodule

configure: ./tecla/Makefile
	(cd ./tecla; ./configure)

clean:
	$(MAKE) -C tecla        $@
	$(MAKE) -C s7           $@
	$(MAKE) -C chibi-scheme $@

clobber: clean

## *EOF*
