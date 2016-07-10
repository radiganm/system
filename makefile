#!/usr/bin/make
## makefile (for libsystem)
## Mac Radigan

.PHONY: clean clobber init
.DEFAULT_GOAL := all

all: submodules build

VPATH = ./src:./src/modules

CCC = g++

BINDIR    = ./bin
SRCDIR    = ./src
LIBDIR    = ./lib
TESTDIR   = ./tests
SCRIPTDIR = ./scripts
MODDIR    = ./$(SRCDIR)/modules
APPDIR    = ./$(SRCDIR)/apps
TESTSDIR  = ./$(SRCDIR)/tests

TARGET = system

LIBS = \
  $(LIBDIR)/lib$(TARGET).a

APPS = \
  $(APPDIR)/chibi.cpp \
  $(APPDIR)/s7.cpp \
  $(APPDIR)/guile.cpp \
  $(APPDIR)/tcl.cpp \
  $(APPDIR)/root.cpp
# $(APPDIR)/octave.cpp
# $(APPDIR)/python.cpp
BINS = $(patsubst $(APPDIR)/%,$(BINDIR)/%, $(APPS:.cpp=))

TESTSRC = \
  $(TESTSDIR)/test-file.cpp
TESTS = $(patsubst $(TESTSDIR)/%,$(TESTDIR)/%, $(TESTSRC:.cpp=))

C11SRC = \
  $(MODDIR)/io/file.cpp \
  $(MODDIR)/hdf5/Hdf5Tree.cpp \
  $(MODDIR)/python/PythonInterpreter.cpp
C11OBJ = $(C11SRC:.cpp=.o)

ARCH = -m64
ININC = -I./tecla -I./s7 -I./chibi-scheme/include
EXINC = \
  -I/usr/include/hdf5/serial \
  -I/usr/include/readline \
  -I/usr/include/tcl8.6 \
  -I/usr/include/root \
  $(shell pkg-config --cflags guile-2.0) \
  $(shell /usr/bin/python2.7-config --cflags)
# -I/usr/include/octave-4.0.0 
# -I/usr/include/octave-4.0.0/octave 
INC = -I./include
CFLAGS = -fPIC -O2 $(ARCH) -g3 $(INC) $(ININC) $(EXINC)
C11FLAGS = -fPIC -O2 $(ARCH) -g3 -std=c++11 $(INC) $(ININC) $(EXINC)
LIBPATH = \
  -L/lib/x86_64-linux-gnu \
  -L/usr/lib/x86_64-linux-gnu \
  -L./tecla \
  -L./s7 \
  -L./chibi-scheme \
  -L/usr/lib/x86_64-linux-gnu/root5.34
EXLIBS = \
  -lm \
  -ldl \
  -lcurses \
  -lreadline \
  -ltcl
# -loctave 
INLIBS = \
  -l:libtecla.a \
  -l:libs7.a \
  -lchibi-scheme \
  $(shell pkg-config --libs guile-2.0) \
  -lCore \
  $(shell /usr/bin/python2.7-config --ldflags)
LDFLAGS = -O2 $(ARCH) -g $(LIBPATH) $(INLIBS) $(EXLIBS) $(LIBS)

build: init $(C11OBJ) $(LIBDIR)/lib$(TARGET).a $(BINS) $(TESTS)

submodules:
	$(MAKE) -f submodules.mk

init:
	@-mkdir -p $(BINDIR)
	@-mkdir -p $(LIBDIR)
	@-mkdir -p $(TESTDIR)
	@-(cd $(BINDIR); ln -fs ../$(SCRIPTDIR)/system .)

%.o: %.cpp
	$(CCC) $(C11FLAGS) -c -o $@ $^

$(LIBDIR)/lib$(TARGET).a: $(C11OBJ)
	ar rvs $@ $^

$(BINDIR)/chibi: $(APPDIR)/chibi.cpp
	$(CCC) $(C11FLAGS) -o $@ $^ $(LDFLAGS)

$(BINDIR)/s7: $(APPDIR)/s7.cpp
	$(CCC) $(C11FLAGS) -o $@ $^ $(LDFLAGS)

$(BINDIR)/guile: $(APPDIR)/guile.cpp
	$(CCC) $(C11FLAGS) -o $@ $^ $(LDFLAGS)

$(BINDIR)/python: $(APPDIR)/python.cpp
	$(CCC) $(C11FLAGS) -o $@ $^ $(LDFLAGS)

$(BINDIR)/octave: $(APPDIR)/octave.cpp
	$(CCC) $(C11FLAGS) -o $@ $^ $(LDFLAGS)

$(BINDIR)/tcl: $(APPDIR)/tcl.cpp
	$(CCC) $(C11FLAGS) -o $@ $^ $(LDFLAGS)

$(BINDIR)/root: $(APPDIR)/root.cpp
	$(CCC) $(C11FLAGS) -o $@ $^ $(LDFLAGS)

$(TESTDIR)/test-file: $(TESTSDIR)/test-file.cpp
	$(CCC) $(C11FLAGS) -o $@ $^ $(LDFLAGS)

clean:
	-rm -f $(C11OBJ)

clobber: clean
	-rm -f $(LIBS)
	-rm -f $(BINS)
	-rm -f $(TESTS)
	-rm -f $(BINDIR)/system

## *EOF*
