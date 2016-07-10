/* python.cpp
 * Mac Radigan
 */

#include "modules/common/namespace.hpp"
#include "modules/python/PythonInterpreter.hpp"
#include <cstdlib>

USING_RADIGAN

  int main(int argc, char *argv[])
  {
    // NB:  Python API marked as non-const, but there is no mutation
    PythonInterpreter interp = PythonInterpreter::instance("Python");
    interp.interact();
    return EXIT_SUCCESS;
  }

/* *EOF* */
