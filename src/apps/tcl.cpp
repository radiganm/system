// tcl.cpp
// Copyright 2016 Mac Radigan
// All Rights Reserved

#include "modules/common/namespace.hpp"
#include <stdio.h>
#include <cstdlib>
#include <string.h>
#include <iostream>
#include <libtecla.h>
#include <tcl.h>

  int main(int argc, char *argv[])
  {
    Tcl_Interp *tcl;
    Tcl_FindExecutable(argv[0]);
    tcl = Tcl_CreateInterp();
    if(TCL_OK != Tcl_Init(tcl))
    {
      std::cerr << "error: " 
           << "Could not initialize TCL interpreter." 
           << std::endl;
      exit(EXIT_FAILURE);
    }
    Tcl_Main(argc, argv, Tcl_AppInit);
    return EXIT_SUCCESS;
  }

  int Tcl_AppInit(Tcl_Interp *interp) 
  {
     if(Tcl_Init(interp) == TCL_ERROR) 
     {
        return TCL_ERROR;
     }
     return TCL_OK;
  }

// *EOF*
