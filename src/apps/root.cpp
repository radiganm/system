// root_unit.cpp
// Mac Radigan

#include <stdio.h>
#include <cstdlib>
#include <string.h>
#include <TCint.h>
#include "TROOT.h"
#include "TSystem.h"
#include <libtecla.h>

  int main(int argc, char **argv)
  {
    int status = EXIT_SUCCESS;
    gROOT->ProcessLine("#include <iostream>");
    gROOT->ProcessLine(".include ../System/include");
    gROOT->ProcessLine(".include ./include");
    gROOT->ProcessLine(".include /usr/include");
    gROOT->ProcessLine(".include /usr/include/boost");
    gROOT->ProcessLine(".L /usr/lib64/libboost_system-mt.so");
    gROOT->ProcessLine(".L /usr/lib64/libboost_thread-mt.so");
    char *buffer;
    const size_t max_line = 1024;
    char response[max_line];
    GetLine *gl;
    gl = new_GetLine(500, 5000);
    const bool do_repl = true;
    while(do_repl) 
    {
      buffer = gl_get_line(gl, "> ", NULL, 0);
      if ((buffer[0] != '\n') || (strlen(buffer) > 1))
      {                            
        snprintf(response, sizeof(response), "%s", buffer);
        status = (int)gROOT->ProcessLine(response);
        fprintf(stdout, "\n");
      }
    }
    gl = del_GetLine(gl);
    return status;
  }

// *EOF*
