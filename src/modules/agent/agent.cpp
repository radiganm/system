/* agent.cpp
 * Mac Radigan
 * Copyright 2016 Mac Radigan
 * All Rights Reserved
 */

#include "modules/agent/agent.h"
#include <sys/types.h>
#include <stdio.h>

  static void* agent_fn(void *arg)
  {
    agent_t &agent = *reinterpret_cast<agent_t*>(arg);
    fprintf(stdout, "agent_fn\n");
    return nullptr;
  }

  agent_t* agent_new()
  {
    agent_t &agent = *(new agent_t);
    agent.fn = agent_fn;
    int status = pthread_create(&agent.tid, NULL, agent.fn, &agent);
    ck("could not create thread", status, 0);
    return &agent;
  }

  void agent_send(const agent_t &agent)
  {
  }

/* *EOF* */
