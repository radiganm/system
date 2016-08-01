/* status.h
 * Mac Radigan
 * Copyright 2016 Mac Radigan
 * All Rights Reserved
 */

#include <stdint.h>

#ifndef status_h
#define status_h

  enum Status : uint32_t
  {
    SUCCESS = 0,
    FAILURE = 1
  };

#ifdef __cplusplus
extern "C" {
#endif

  typedef Status status_t;

#ifdef __cplusplus
}
#endif

#endif

/* *EOF* */
