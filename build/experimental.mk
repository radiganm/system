#!/usr/bin/make
## makefile (for system experimental)
## Mac Radigan

.PHONY: clean clobber
.DEFAULT_GOAL := all

include ./build/rules.mk

all: build

APPS = \
  $(APPDIR)/root.cpp
# $(APPDIR)/octave.cpp
# $(APPDIR)/python.cpp
BINS = $(patsubst $(APPDIR)/%,$(BINDIR)/%, $(APPS:.cpp=))

build: $(BINS)

$(BINDIR)/python: $(APPDIR)/python.cpp
	$(CCC) $(C11FLAGS) -o $@ $^ $(LDFLAGS)

$(BINDIR)/octave: $(APPDIR)/octave.cpp
	$(CCC) $(C11FLAGS) -o $@ $^ $(LDFLAGS)

$(BINDIR)/root: $(APPDIR)/root.cpp
	$(CCC) $(C11FLAGS) -o $@ $^ $(LDFLAGS)

clobber: clean
	-rm -f $(BINS)
	-rm -f $(BINDIR)/system

## *EOF*
