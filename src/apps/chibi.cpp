/* chibi.cpp
 * Copyright 2016 Mac Radigan
 * All Rights Reserved
 */

#define SEXP_USE_PRINT_BACKTRACE_ON_SEGFAULT (1)

#include "modules/io/file.h"
#include <stdio.h>
#include <cstdlib>
#include <libtecla.h>
#include <chibi/eval.h>
#include <chibi/sexp.h>

#if SEXP_USE_PRINT_BACKTRACE_ON_SEGFAULT
#include <execinfo.h>
#include <signal.h>
  void sexp_segfault_handler(int sig) {
    void *array[10];
    size_t size;
    size = backtrace(array, 10);
    fprintf(stderr, "Error: signal %d:\n", sig);
    backtrace_symbols_fd(array, size, STDERR_FILENO);
    exit(1);
  }
#endif

  static sexp sexp_param_ref(sexp ctx, sexp env, sexp name) 
  {
    sexp res = sexp_env_ref(ctx, env, name, SEXP_FALSE);
    return sexp_opcodep(res) ? sexp_parameter_ref(ctx, res) : NULL;
  }

  static void load(sexp ctx, sexp env, const char * const filename) 
  {
    sexp_gc_var1(s_filename);
    sexp_gc_preserve1(ctx, s_filename);
    s_filename = sexp_c_string(ctx, filename, -1);
    //fprintf(stdout, "load %s\n", filename);
    sexp_load(ctx, s_filename, NULL);
    fflush(stdout);
    sexp_gc_release1(s_filename);
  }

  static void repl(sexp ctx, sexp env) 
  {
    const size_t max_line = 2048;
    char response[max_line];
    char *buffer;
    GetLine *gl;
    gl = new_GetLine(500, 5000);
    sexp_gc_var6(obj, s_result, res, in, out, err);
    sexp_gc_preserve6(ctx, obj, s_result, res, in, out, err);
    sexp_context_tracep(ctx) = 1;
    in  = sexp_param_ref(ctx, env, sexp_global(ctx, SEXP_G_CUR_IN_SYMBOL));
    out = sexp_param_ref(ctx, env, sexp_global(ctx, SEXP_G_CUR_OUT_SYMBOL));
    err = sexp_param_ref(ctx, env, sexp_global(ctx, SEXP_G_CUR_ERR_SYMBOL));
    if(in == NULL || out == NULL) {
      fprintf(stderr, "Standard I/O ports not found, aborting.\n");
      exit(EXIT_FAILURE);
    }
    if(err == NULL) err = out;
    sexp_port_sourcep(in) = 1;
    const bool do_repl = true;
    while(do_repl) 
    {
      buffer = gl_get_line(gl, "> ", NULL, 0);
      if ((buffer[0] != '\n') || (strlen(buffer) > 1))
      {                            
        snprintf(response, sizeof(response), "%s", buffer);
        s_result = sexp_eval_string(ctx, response, -1, env);
        if (sexp_exceptionp(s_result)){
          sexp_print_exception(ctx, s_result, sexp_current_error_port(ctx));
        }else{
          s_result = sexp_write_to_string(ctx, s_result);
          if(sexp_stringp(s_result)) 
          {
            fprintf(stdout, "%s\n", sexp_string_data(s_result));
          }
        }
      }
    }
    gl = del_GetLine(gl);
    sexp_gc_release6(ctx);
  }

  static sexp sexp_meta_env(sexp ctx) {
  if(sexp_envp(sexp_global(ctx, SEXP_G_META_ENV)))
    return sexp_global(ctx, SEXP_G_META_ENV);
  return sexp_context_env(ctx);
  }

  static sexp sexp_add_import_binding(sexp ctx, sexp env) {
    sexp_gc_var2(s_symbol, s_result);
    sexp_gc_preserve2(ctx, s_symbol, s_result);
    s_symbol = sexp_intern(ctx, "repl-import", -1);
    s_result = sexp_env_ref(ctx, sexp_meta_env(ctx), s_symbol, SEXP_VOID);
    s_symbol = sexp_intern(ctx, "import", -1);
    sexp_env_define(ctx, env, s_symbol, s_result);
    sexp_gc_release3(ctx);
    return env;
  }

  static sexp sexp_load_standard_params(sexp ctx, sexp env) {
    sexp_gc_var1(s_result);
    sexp_gc_preserve1(ctx, s_result);
    sexp_load_standard_ports(ctx, env, stdin, stdout, stderr, 0);
    s_result = sexp_make_env(ctx);
    sexp_env_parent(s_result) = env;
    sexp_context_env(ctx) = s_result;
    sexp_set_parameter(ctx, sexp_meta_env(ctx), sexp_global(ctx, SEXP_G_INTERACTION_ENV_SYMBOL), s_result);
    sexp_gc_release1(ctx);
    return s_result;
  }

  int main(int argc, char *argv[])
  {
#if SEXP_USE_PRINT_BACKTRACE_ON_SEGFAULT
    signal(SIGSEGV, sexp_segfault_handler); 
#endif
    sexp ctx = sexp_make_eval_context(NULL, NULL, NULL, 0, 0);
    sexp_gc_var2(env, s_tmp);
    sexp_gc_preserve2(ctx, env, s_tmp);
    env = sexp_context_env(ctx);
    sexp_load_standard_env(ctx, env, SEXP_SEVEN);
    env = sexp_add_import_binding(ctx, env);
    env = sexp_load_standard_params(ctx, env);
    const char * const include_path = getenv("CHIBI_INCLUDE_PATH");
    if(nullptr != include_path) sexp_add_module_directory(ctx,s_tmp=sexp_c_string(ctx,include_path,-1), SEXP_FALSE);
    const char * const module_path = getenv("CHIBI_MODULE_PATH");
    if(nullptr != module_path) sexp_add_module_directory(ctx,s_tmp=sexp_c_string(ctx,module_path,-1), SEXP_TRUE);
    if(argc == 2)
    {
      const char * const &filename = argv[1];
      load(ctx, env, filename);
    }
    else 
    {
      repl(ctx, env);
    }
    sexp_destroy_context(ctx);
    return EXIT_SUCCESS;
  }

  
/* *EOF* */
