#!/usr/bin/make
## makefile (for system applications)
## Copyright 2016 Mac Radigan
## All Rights Reserved

.PHONY: clean clobber
.DEFAULT_GOAL := all

include ./build/rules.mk

all: build

APPS = \
  $(APPDIR)/chibi.cpp \
  $(APPDIR)/s7.cpp \
  $(APPDIR)/guile.cpp \
  $(APPDIR)/tcl.cpp 
BINS = $(patsubst $(APPDIR)/%,$(BINDIR)/%, $(APPS:.cpp=))

CLAPPS = \
  $(APPDIR)/lisp.cl \
  $(APPDIR)/swank.cl
CLBINS = $(patsubst $(APPDIR)/%,$(BINDIR)/%, $(CLAPPS:.cl=))

build: $(BINS) $(CLBINS)

$(BINDIR)/chibi: $(APPDIR)/chibi.cpp
	$(CCC) $(C11FLAGS) -o $@ $^ $(LDFLAGS)

$(BINDIR)/s7: $(APPDIR)/s7.cpp
	$(CCC) $(C11FLAGS) -o $@ $^ $(LDFLAGS)

$(BINDIR)/guile: $(APPDIR)/guile.cpp
	$(CCC) $(C11FLAGS) -o $@ $^ $(LDFLAGS)

$(BINDIR)/tcl: $(APPDIR)/tcl.cpp
	$(CCC) $(C11FLAGS) -o $@ $^ $(LDFLAGS)

$(BINDIR)/lisp: $(APPDIR)/lisp.cl
	./build/sbclc -o $@ -c $^

$(BINDIR)/swank: $(APPDIR)/swank.cl
	./build/sbclc -o $@ -c $^

clobber: clean
	-rm -f $(BINS)
	-rm -f $(CLBINS)
	-rm -f $(BINDIR)/system

## *EOF*
