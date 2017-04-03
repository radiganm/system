#!/usr/bin/make
## makefile (for system)
## Copyright 2016 Mac Radigan
## All Rights Reserved

.PHONY: clean clobber submodules libraries applications tests experimental
.DEFAULT_GOAL := all

BLDDIR=./build

all: submodules libraries applications tests

submodules:
	$(MAKE) -C $@

libraries:
	$(MAKE) -f $(BLDDIR)/$@.mk

applications:
	$(MAKE) -f $(BLDDIR)/$@.mk

tests:
	$(MAKE) -f $(BLDDIR)/$@.mk

experimental: submodules libraries applications
	$(MAKE) -f $(BLDDIR)/$@.mk

clean:
	$(MAKE) -C ./submodules              $@
	$(MAKE) -f $(BLDDIR)/libraries.mk    $@
	$(MAKE) -f $(BLDDIR)/applications.mk $@
	$(MAKE) -f $(BLDDIR)/experimental.mk $@

clobber:
	$(MAKE) -C ./submodules              $@
	$(MAKE) -f $(BLDDIR)/libraries.mk    $@
	$(MAKE) -f $(BLDDIR)/applications.mk $@
	$(MAKE) -f $(BLDDIR)/experimental.mk $@

link-modules:
	(cd ./mod; find ../submodules -name "*.mod" | xargs -I {} ln -fs {} .)

## *EOF*
