// PythonInterpreter.cpp
// Copyright 2016 Mac Radigan
// All Rights Reserved

#include "modules/python/PythonInterpreter.hpp"
#include "modules/common/namespace.hpp"

#include <sstream>
#include <iostream>
#include <fstream>
#include <streambuf>
#include <string.h>

#include <readline.h>
#include <history.h>

USING_RADIGAN
using namespace std;

NS_RADIGAN_BEGIN

  void PythonInterpreter::add_module(const char * const name, const PyMethodDef * methods)
  {
    Py_InitModule(const_cast<char*>(name),
      const_cast<PyMethodDef*>(methods));
  }

  void PythonInterpreter::run_file_simple(const char * const filename) 
  {
    FILE *fp = fopen(filename, "r");
    PyRun_SimpleFile(fp, filename);
    fclose(fp);
  }

  void PythonInterpreter::run_file(const char * const filename) 
  {
    ifstream t(filename);
    string script((istreambuf_iterator<char>(t)), 
                   istreambuf_iterator<char>());
    //PyObject *result = PyRun_String(script.c_str(), 
    //  Py_file_input, globals, locals);
    PyRun_String(script.c_str(), Py_file_input, globals, locals);
  }

  void PythonInterpreter::interact()
  {
    int i, j, done = 0;
    char ps1[100];
    char ps2[] = "...";
    char *prompt = ps1;
    char *msg, *line, *code = NULL;
    PyObject *src;
    PyObject *exc, *val, *trb, *obj;
    PyObject *dum;
    while(!done)
    {
      snprintf(ps1, sizeof(ps1), 
        "[0;31;40m[[0;33;40m%s[0;31;40m][0;32;40m %s@%s[0;35;40m>[0;37;40m ", 
        "py", getenv("USER"), "system");
      line = readline(prompt);
      if(NULL == line)
      {
        done = 1;
      }
      else
      {
        i = strlen(line);
        if(i>0)
        {
          add_history(line);
        }
        if(NULL == code)
        {
          j = 0;
        }
        else
        {
          j = strlen(code);
        }
        code = static_cast<char*>(realloc(code, i+j+2));
        if(NULL == code)
        {
          exit(1);
        }
        if(0 == j)
        {
          code[0] = '\0';
        }
        strncat(code, line, i);
        code[i+j] = '\n';
        code[i+j+1] = '\0';
        src = Py_CompileString(code, "<stdin>", Py_single_input);
        if(NULL != src)
        {
          if(ps1==prompt || '\n'==code[i+j-1])
          {
            dum = PyEval_EvalCode((PyCodeObject*)src, globals, locals);
            Py_XDECREF(dum);
            Py_XDECREF(src);
            free(code);
            code = NULL;
            if(PyErr_Occurred())
            {
              PyErr_Print();
            }
            prompt = ps1;
          }
        }
        else if(PyErr_ExceptionMatches(PyExc_SyntaxError))
        {
          PyErr_Fetch(&exc, &val, &trb);
          if(PyArg_ParseTuple(val, "sO", &msg, &obj) 
             && !strcmp(msg, "unexpected EOF while parsing"))
          {
            Py_XDECREF(exc);
            Py_XDECREF(val);
            Py_XDECREF(trb);
            prompt = ps2;
          }
          else if(PyArg_ParseTuple(val, "sO", &msg, &obj) 
             && !strcmp(msg, "expected an indented block"))
          {
            Py_XDECREF(exc);
            Py_XDECREF(val);
            Py_XDECREF(trb);
            prompt = ps2;
          }
          else
          {
            PyErr_Restore(exc, val, trb);
            PyErr_Print();
            free(code);
            code = NULL;
            prompt = ps1;
          }
        }
        else
        {
          PyErr_Print();
          free(code);
          code = NULL;
          prompt = ps1;
        }
        free(line);
      }
    }
  }

  PythonInterpreter::PythonInterpreter(const char * const name)
  {
    char mname[1024];
    snprintf(mname, sizeof(mname), "%s", name);
    Py_SetProgramName(mname);
    Py_Initialize();
    globals = PyDict_New();
    locals = PyDict_New();
    Py_INCREF(globals);
    Py_INCREF(locals);
    PyDict_SetItemString(globals, "__builtins__", 
      PyEval_GetBuiltins());
  }

  PythonInterpreter::~PythonInterpreter()
  {
    Py_XDECREF(globals);
    Py_XDECREF(locals);
    Py_Finalize();
  }

NS_RADIGAN_END

// *EOF*
