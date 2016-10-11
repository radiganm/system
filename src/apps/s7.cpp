/* s7.cpp
 * Copyright 2016 Mac Radigan
 * All Rights Reserved
 */

#include "modules/io/file.h"
#include <stdio.h>
#include <cstdlib>
#include <string.h>
#include <libtecla.h>
#include "s7.h"

  int main(int argc, char **argv)
  {
    s7_scheme *s7;
    char *buffer;
    const size_t max_line = 1024;
    char response[max_line];
    GetLine *gl;
    gl = new_GetLine(500, 5000);
    s7 = s7_init();  
    if(argc == 2)
    {
      const char * const &filename = argv[1];
      fprintf(stderr, "load %s\n", filename);
      s7_load(s7, filename);
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
          s7_eval_c_string(s7, response);
          fprintf(stdout, "\n");
        }
      }
      gl = del_GetLine(gl);
    }
    return EXIT_SUCCESS;
  }

/* *EOF* */
