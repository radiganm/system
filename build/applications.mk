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
  $(APPDIR)/scm.cpp \
  $(APPDIR)/tcl.cpp 
BINS = $(patsubst $(APPDIR)/%,$(BINDIR)/%, $(APPS:.cpp=))

CLAPPS = \
  $(APPDIR)/lisp.cl \
  $(APPDIR)/swank.cl
CLBINS = $(patsubst $(APPDIR)/%,$(BINDIR)/%, $(CLAPPS:.cl=))

CYAPPS = \
  $(APPDIR)/python.pyx
CYBINS = $(patsubst $(APPDIR)/%,$(BINDIR)/%, $(CYAPPS:.pyx=))

build: $(BINS) $(CLBINS) $(CYBINS)

$(BINDIR)/chibi: $(APPDIR)/chibi.cpp
	$(CCC) $(C11FLAGS) -o $@ $^ $(LDFLAGS)

$(BINDIR)/scm: $(APPDIR)/scm.cpp
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

$(BINDIR)/python: $(APPDIR)/python.pyx
	$(CYC) --embed -a $^
	$(CCC) -shared -pthread -fPIC -fwrapv -O2 -Wall -fno-strict-aliasing -I/usr/include/python2.7 -o $(^:.pyx=.so) $(^:.pyx=.c)
	$(CCC) -o $@ $(^:.pyx=.c) -pthread -fPIC -fwrapv -O2 -Wall -fno-strict-aliasing -I/usr/include/python2.7 -L/usr/lib/x86_64-linux-gnu -lpython2.7 

clobber: clean
	-rm -f $(BINS)
	-rm -f $(CLBINS)
	-rm -f $(BINDIR)/system

## *EOF*
