#!/usr/bin/make
## submodules.mk
## Copyright 2016 Mac Radigan
## All Rights Reserved

.PHONY: submodules clean clobber

submodules: 
	$(MAKE) -C tecla
	$(MAKE) -C s7 libs7.a
	$(MAKE) -C chibi-scheme libchibi-scheme.a
	$(MAKE) -C dispmodule
	$(MAKE) -C nanomsg

configure: ./tecla/Makefile ./nanomsg/Makefile

./tecla/Makefile:
	(cd ./tecla; ./configure)

./nanomsg/Makefile:
	(cd ./nanomsg; ./configure)

post-install:
	(cd ../mod; ln -fs ../submodules/dispmodule/mod/*.mod .)

clean:
	$(MAKE) -C tecla        $@
	$(MAKE) -C s7           $@
	$(MAKE) -C chibi-scheme $@
	$(MAKE) -C nanomsg $@

clobber: clean

## *EOF*
