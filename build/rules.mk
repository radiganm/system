#!/usr/bin/make
## makefile (for libsystem)
## Copyright 2016 Mac Radigan
## All Rights Reserved

.PHONY: clean clobber init
.DEFAULT_GOAL := all

all: build

VPATH = ./src:./src/modules

CCC = g++
FC = gfortran
CYC = cython

BINDIR    = ./bin
SRCDIR    = ./src
LIBDIR    = ./lib
TESTDIR   = ./tests
SCRIPTDIR = ./scripts
FMODDIR   = ./mod
MODDIR    = ./$(SRCDIR)/modules
APPDIR    = ./$(SRCDIR)/apps
TESTSDIR  = ./$(SRCDIR)/tests
SUBDIR    = ./submodules

TARGET = system

LIBS = \
  $(LIBDIR)/lib$(TARGET).a

ARCH = -m64
ININC = \
  -I$(SUBDIR)/tecla \
  -I$(SUBDIR)/ecl/build \
  -I$(SUBDIR)/s7 \
  -I$(SUBDIR)/chibi-scheme/include
EXINC = \
  -I/usr/include/hdf5/serial \
  -I/usr/include/readline \
  -I/usr/include/tcl8.6 \
  -I/usr/include/root \
  $(shell pkg-config --cflags guile-2.0) \
  $(shell /usr/bin/python2.7-config --cflags)
INC = -I./include
CFLAGS = -fPIC -O2 $(ARCH) -g3 $(INC) $(ININC) $(EXINC)
C11FLAGS = -fPIC -O2 $(ARCH) -g3 -std=c++11 $(INC) $(ININC) $(EXINC)
FFLAGS = -J$(FMODDIR) -cpp -fPIC -O2 $(ARCH) -g3 $(INC) $(ININC)
LIBPATH = \
  -L/lib/x86_64-linux-gnu \
  -L/usr/lib/x86_64-linux-gnu \
  -L$(SUBDIR)/tecla \
  -L$(SUBDIR)/ecl/build \
  -L$(SUBDIR)/s7 \
  -L$(SUBDIR)/chibi-scheme \
  -L$(SUBDIR)/dispmodule/lib \
  -L/usr/lib/x86_64-linux-gnu/root5.34
EXLIBS = \
  -lm \
  -ldl \
  -lgmp \
  -latomic \
  -lcurses \
  -lreadline \
  -ltcl \
  -llapack \
  -lblas 
INLIBS = \
  -lecl \
  -l:libtecla.a \
  -l:libs7.a \
  -l:libchibi-scheme.a \
  -l:libdispmodule.a \
  $(shell pkg-config --libs guile-2.0) \
  -lCore \
  $(shell /usr/bin/python2.7-config --ldflags)
# -lchibi-scheme
LDFLAGS = -O2 $(ARCH) -g $(LIBPATH) $(INLIBS) $(EXLIBS) $(LIBS)

init:
	@-mkdir -p $(BINDIR)
	@-mkdir -p $(LIBDIR)
	@-mkdir -p $(TESTDIR)
	@-mkdir -p $(FMODDIR)
	@-(cd $(BINDIR); ln -fs ../$(SCRIPTDIR)/system .)

%.oC11: %.cpp
	$(CCC) $(C11FLAGS) -c -o $@ $^

%.oF90: %.f90
	$(FC) $(FFLAGS) -c -o $@ $^

## *EOF*
