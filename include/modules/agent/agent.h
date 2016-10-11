/* agent.h
 * Copyright 2016 Mac Radigan
 * All Rights Reserved
 */

#include "../common/status.h"
#include <pthread.h>

#ifndef agent_h
#define agent_h

#ifdef __cplusplus
extern "C" {
#endif

  typedef struct agent_s {
    pthread_t tid;
    void* (*fn)(void*);
  } agent_t;

  agent_t* agent_new();

  status_t agent_start(agent_t &agent);

  void agent_send(const agent_t &agent);

  //status_t agent_stop(agent_t &agent);

  //status_t agent_wait(agent_t &agent);

  static void agent_fn();

#ifdef __cplusplus
}
#endif

#endif

/* *EOF* */
