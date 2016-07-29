#!/usr/bin/make
## makefile (for system)
## Mac Radigan

.PHONY: clean clobber submodules libraries applications experimental
.DEFAULT_GOAL := all

BLDDIR=./build

all: submodules libraries applications

submodules:
	$(MAKE) -C $@

libraries:
	$(MAKE) -f $(BLDDIR)/$@.mk

applications:
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

## *EOF*
