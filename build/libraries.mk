#!/usr/bin/make
## makefile (for libsystem)
## Mac Radigan

.PHONY: clean clobber
.DEFAULT_GOAL := all

include ./build/rules.mk

all: build

LIBS = \
  $(LIBDIR)/lib$(TARGET).a

$(LIBDIR)/lib$(TARGET).a: $(C11OBJ)
	ar rvs $@ $^

clean:
	-rm -f $(C11OBJ)

clobber: clean
	-rm -f $(LIBS)

## *EOF*
