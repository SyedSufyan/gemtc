#ifndef __SUPER_K_MIC_H_
#define __SUPER_K_MIC_H_

#include "gemtc_types.h"
#include "QueueJobs.h"

struct SuperKernelParameter {
  Queue incoming;
  Queue results;
  int *kill;
};

typedef struct SuperKernelParameter SuperKernelParameter_t;

JobPointer execute_job(JobPointer currentJob);
void *super_kernel(void* params);

#endif