#!/usr/bin/make
## makefile (for system tests)
## Copyright 2016 Mac Radigan
## All Rights Reserved

.PHONY: clean clobber
.DEFAULT_GOAL := all

include ./build/rules.mk

all: build

TESTCSRC = \
  $(TESTSDIR)/test-file.cpp
CTESTS = $(patsubst $(TESTSDIR)/%,$(TESTDIR)/%, $(TESTCSRC:.cpp=))

TESTFSRC = \
  $(TESTSDIR)/test-la.f90 \
  $(TESTSDIR)/test-fact.f90 \
  $(TESTSDIR)/test_dispmodule.f90
FTESTS = $(patsubst $(TESTSDIR)/%,$(TESTDIR)/%, $(TESTFSRC:.f90=))

build: $(CTESTS) $(FTESTS)

$(TESTDIR)/test-file: $(TESTSDIR)/test-file.cpp
	$(CCC) $(C11FLAGS) -o $@ $^ $(LDFLAGS)

$(TESTDIR)/test-la: $(TESTSDIR)/test-la.f90
	$(FC) $(FEXINC) $(FFLAGS) -o $@ $^ $(LDFLAGS)

$(TESTDIR)/test-fact: $(TESTSDIR)/test-fact.f90
	$(FC) $(FEXINC) $(FFLAGS) -o $@ $^ $(LDFLAGS)

$(TESTDIR)/test_dispmodule: $(TESTSDIR)/test_dispmodule.f90
	$(FC) $(FEXINC) $(FFLAGS) -o $@ $^ $(LDFLAGS)

clean:
	-rm -f $(CTESTS)
	-rm -f $(FTESTS)

clobber: clean
	-rm -f $(CTESTS)
	-rm -f $(FTESTS)

## *EOF*
