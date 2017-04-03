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
	$(MAKE) -C ecl

configure: ./tecla/Makefile ./nanomsg/Makefile ./ecl/Makefile

./ecl/Makefile:
	(cd ./ecl; ./configure)

./tecla/Makefile:
	(cd ./tecla; ./configure)

./nanomsg/Makefile:
	(cd ./nanomsg; cmake .)

post-install:
	(cd ../mod; ln -fs ../submodules/dispmodule/mod/*.mod .)

clean:
	$(MAKE) -C tecla        $@
	$(MAKE) -C ecl          $@
	$(MAKE) -C s7           $@
	$(MAKE) -C chibi-scheme $@
	$(MAKE) -C nanomsg      $@

clobber: clean

## *EOF*
