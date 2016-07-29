#!/usr/bin/make
## makefile (for system tests)
## Mac Radigan

.PHONY: clean clobber init submodules
.DEFAULT_GOAL := all

include ./build/rules.mk

all: build

TESTSRC = \
  $(TESTSDIR)/test-file.cpp
TESTS = $(patsubst $(TESTSDIR)/%,$(TESTDIR)/%, $(TESTSRC:.cpp=))

build: $(TESTS)

$(TESTDIR)/test-file: $(TESTSDIR)/test-file.cpp
	$(CCC) $(C11FLAGS) -o $@ $^ $(LDFLAGS)

clean:
	-rm -f $(C11OBJ)

clobber: clean
	-rm -f $(TESTS)

## *EOF*
