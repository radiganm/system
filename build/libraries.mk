#!/usr/bin/make
## makefile (for libsystem)
## Copyright 2016 Mac Radigan
## All Rights Reserved

.PHONY: clean clobber init
.DEFAULT_GOAL := all

include ./build/rules.mk

all: init build

build: $(LIBS)

C11SRC = \
  $(MODDIR)/io/file.cpp \
  $(MODDIR)/hdf5/Hdf5Tree.cpp \
  $(MODDIR)/python/PythonInterpreter.cpp
C11OBJ = $(C11SRC:.cpp=.oC11)

FSRC =
FOBJ = $(FSRC:.f90=.oF90)

$(LIBDIR)/lib$(TARGET).a: $(C11OBJ) $(FOBJ)
	ar rvs $@ $^

clean:
	-rm -f $(C11OBJ)
	-rm -f $(FOBJ)

clobber: clean
	-rm -f $(LIBS)

## *EOF*
