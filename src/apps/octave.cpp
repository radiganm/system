/* octave.cpp
 * Copyright 2016 Mac Radigan
 * All Rights Reserved
 */

#include <stdio.h>
#include <cstdlib>
#include <string.h>
#include <libtecla.h>

#include <octave/oct.h>
#include <octave/octave.h>
#include <octave/parse.h>
#include <octave/oct-map.h>
#include <octave/toplev.h>

  int main(int argc, char **argv)
  {
    int status;
    char *buffer;
    const size_t max_line = 1024;
    char response[max_line];
    GetLine *gl;
    gl = new_GetLine(500, 5000);
    string_vector sargv(2);
    sargv(0) = "embedded";
    sargv(1) = "-q";
    octave_main(2, sargv.c_str_vec(), 1);
    if(argc == 2)
    {
      const char * const &filename = argv[1];
      fprintf(stderr, "load %s\n", filename);
    }
    else 
    {
      const bool do_repl = true;
      while(do_repl) 
      {
         buffer = gl_get_line(gl, "> ", NULL, 0);
         if ((buffer[0] != '\n') || (strlen(buffer) > 1))
         {                            
           sprintf(response, "(write %s)", buffer);
           eval_string(response, false, status, 0);
           fprintf(stdout, "\n");
         }
      }
      gl = del_GetLine(gl);
      eval_string("close all", false, status, 0);
      //do_octave_atexit();
    }
    return EXIT_SUCCESS;
  }

/* *EOF* */
