// buile.cpp
// Copyright 2016 Mac Radigan
// All Rights Reserved

#include "modules/common/namespace.hpp"
//#include "bindings/guile/core.hpp"
#include <stdio.h>
#include <cstdlib>
#include <string.h>
#include <libtecla.h>
#include <libguile.h>

  static void inner_main(void *data, int argc, char **argv)
  {
    scm_shell (argc, argv);
  }

  int main (int argc, char *argv[])
  {
    scm_boot_guile(argc, argv, inner_main, 0);
    return EXIT_SUCCESS;
  }

// *EOF*
