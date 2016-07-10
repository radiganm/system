// PythonInterpreter.hpp
// Mac Radigan

#include "modules/common/namespace.hpp"

#include <sstream>
#include <iostream>

#ifdef __cplusplus
extern "C" {
#endif
#include <Python.h>
#ifdef __cplusplus
}
#endif

#ifndef PythonInterpreter_hpp
#define PythonInterpreter_hpp

using namespace std;

NS_RADIGAN_BEGIN

  class PythonInterpreter
  {
   public:
    static PythonInterpreter &instance(const char * const name)
    {
      static PythonInterpreter interp(name); 
      return interp;
    }
    ~PythonInterpreter();
    void interact();
    void add_module(const char * const filename, 
      const PyMethodDef *methods);
    void run_file_simple(const char * const filename);
    void run_file(const char * const filename);
   private:
    PythonInterpreter(const char * const name);
    PyObject *globals;
    PyObject *locals;
  };

NS_RADIGAN_END

#endif

// *EOF*
