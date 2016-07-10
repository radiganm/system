/* chibi.cpp
 * Mac Radigan
 */

#include "modules/io/file.h"
#include <stdio.h>
#include <cstdlib>

  int main(int argc, char *argv[])
  {
    fprintf(stderr, "testing...\n");
    const char * const filename = "101";
    size_t size = 101;
    status_t status = mmfile(filename, size);
    return EXIT_SUCCESS;
  }

/* *EOF* */
