/* file.h
 * Copyright 2016 Mac Radigan
 * All Rights Reserved
 */

#include "../common/status.h"
#include <stdlib.h>

#ifndef file_h
#define file_h

#ifdef __cplusplus
extern "C" {
#endif

  status_t mmfile(const char * const filename, void **data, size_t &size);

#ifdef __cplusplus
}
#endif

#endif

/* *EOF* */
