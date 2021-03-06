#include <stdlib.h>
#include "QueueHelpers.cu"

////////////////////////////////////////////////////////////
// Constructor and Deconsturctor
////////////////////////////////////////////////////////////

Queue CreateQueue(int MaxElements) {
  Queue Q = (Queue) malloc (sizeof(struct QueueRecord));

  Q->Array = (JobPointer *) gemtcMalloc(sizeof(JobPointer)*MaxElements);

  Q->Capacity = MaxElements;
  Q->Front = 1;
  Q->Rear = 0;
  Q->ReadLock = 0;

  Queue d_Q = (Queue) gemtcMalloc(sizeof(struct QueueRecord));
  cudaSafeMemcpy(d_Q, Q, sizeof(struct QueueRecord), 
                 cudaMemcpyHostToDevice, stream_dataIn, 
                 "Copying initial queue to device");
  free(Q);
  return d_Q;
}

void DisposeQueue(Queue d_Q) {
  Queue h_Q = (Queue) malloc(sizeof(struct QueueRecord));
  cudaSafeMemcpy(h_Q, d_Q, sizeof(struct QueueRecord), 
                 cudaMemcpyDeviceToHost, stream_dataIn,
                 "DisposeQueue, Copying Queue to get array pointer");
  gemtcFree((void *)h_Q->Array);
  free(h_Q);
  gemtcFree(d_Q);
}

////////////////////////////////////////////////////////////
// Host Functions to Change Queues
////////////////////////////////////////////////////////////

void EnqueueJob(JobPointer h_JobDescription, Queue Q) {
//called by CPU

  int copySize= sizeof(struct QueueRecord);

  Queue h_Q = (Queue) malloc(sizeof(struct QueueRecord));
  cudaSafeMemcpy(h_Q, Q, copySize, cudaMemcpyDeviceToHost, stream_dataIn,
                 "EnqueueJob, Getting Queue");

  int c=0;
  while(h_IsFull(h_Q)){
    pthread_yield();
    cudaSafeMemcpy(h_Q, Q, copySize, cudaMemcpyDeviceToHost, stream_dataIn,
                    "EnqueueJob, Getting Queue again...");
    c++;
  }

  // floating point exception from mod capacity if 0 or -n
  h_Q->Rear = (h_Q->Rear+1)%(h_Q->Capacity);

  JobPointer d_JobDescription = 
      (JobPointer) gemtcMalloc(sizeof(struct JobDescription));

  cudaSafeMemcpy( d_JobDescription,
                  h_JobDescription, 
                  sizeof(struct JobDescription),
                  cudaMemcpyHostToDevice, 
                  stream_dataIn,
                  "EnqueueJob, Writing JobDescription");
  // set job description
  cudaSafeMemcpy( (void *)&h_Q->Array[h_Q->Rear],
                  &d_JobDescription, 
                  sizeof(JobPointer),
                  cudaMemcpyHostToDevice, 
                  stream_dataIn,
                  "EnqueueJob, Writing JobPointer");

  cudaSafeMemcpy(movePointer(Q, 12), movePointer(h_Q, 12), 
		 sizeof(int), cudaMemcpyHostToDevice, stream_dataIn,
                 "EnqueueJob, Updating Queue");
  free(h_Q);
}

void EnqueueJobBatch(JobDescription *buffer, int jobs, Queue Q) {
//called by CPU

  int copySize= sizeof(struct QueueRecord);

  Queue h_Q = (Queue) malloc(sizeof(struct QueueRecord));
  cudaSafeMemcpy(h_Q, Q, copySize, cudaMemcpyDeviceToHost, stream_dataIn,
                 "EnqueueJob, Getting Queue");

  int c=0;
  while(h_openSpace(h_Q) < jobs){
    pthread_yield();
    cudaSafeMemcpy(h_Q, Q, copySize, cudaMemcpyDeviceToHost, stream_dataIn,
                    "EnqueueJob, Getting Queue again...");
    c++;
  }
  // floating point exception from mod capacity if 0 or -n

  JobDescription *d_buffer = 
      (JobDescription *) gemtcMalloc(jobs*sizeof(struct JobDescription));

  cudaSafeMemcpy( d_buffer,
                  buffer, 
                  jobs*sizeof(struct JobDescription),
                  cudaMemcpyHostToDevice, 
                  stream_dataIn,
                  "EnqueueJobbatch, Writing All JobDescriptions");
  // set job description

  JobDescription *pointers[jobs];
  int i;
  for(i=0; i<jobs; i++) pointers[i]=d_buffer+i;

  if(h_Q->Capacity-h_Q->Rear > jobs){
    cudaSafeMemcpy( (void *)&h_Q->Array[(h_Q->Rear+1)%h_Q->Capacity],
                    pointers, 
                    jobs*sizeof(JobPointer),
                    cudaMemcpyHostToDevice, 
                    stream_dataIn,
                    "EnqueueJob, Writing All JobPointers");
  }else{
    int jobs_before_wrap = h_Q->Capacity - h_Q->Rear - 1;
    cudaSafeMemcpy( (void *)&h_Q->Array[(h_Q->Rear+1)%h_Q->Capacity],
                    pointers, 
                    jobs_before_wrap*sizeof(JobPointer),
                    cudaMemcpyHostToDevice, 
                    stream_dataIn,
                    "EnqueueJob, Writing First Half of JobPointers");
    cudaSafeMemcpy( (void *)&h_Q->Array[0],
                    pointers+jobs_before_wrap, 
                    (jobs - jobs_before_wrap)*sizeof(JobPointer),
                    cudaMemcpyHostToDevice, 
                    stream_dataIn,
                    "EnqueueJob, Writing Second Half of JobPointers");
  }

  h_Q->Rear = (h_Q->Rear+jobs)%(h_Q->Capacity);
  cudaSafeMemcpy(movePointer(Q, 12), movePointer(h_Q, 12), 
		 sizeof(int), cudaMemcpyHostToDevice, stream_dataIn,
                 "EnqueueJob, Updating Queue");
  free(h_Q);
}

JobPointer MaybeFandD(Queue Q){
  int copySize= sizeof(struct QueueRecord);

  Queue h_Q = (Queue) malloc(sizeof(struct QueueRecord));
  
  cudaSafeMemcpy(h_Q, Q, copySize, cudaMemcpyDeviceToHost, stream_dataOut,
                 "MaybeFandDJob, Getting Queue");
  //printf("Reading queue\n");
  //printf("Front %d\n", h_Q->Front);
  //printf("Rear %d\n", h_Q->Rear);

  if(h_IsEmpty(h_Q)){
    free(h_Q);
    return NULL;
  }else{
    JobPointer *resultP = (JobPointer *) malloc(sizeof(JobPointer));
    JobPointer result = (JobPointer) malloc(sizeof(struct JobDescription));

    //Read task Description Location
    cudaSafeMemcpy(resultP, (void *)&h_Q->Array[h_Q->Front], sizeof(JobPointer), 
                   cudaMemcpyDeviceToHost, stream_dataOut,
                   "FandDJob, Getting JobPointer");
    //Read task description
    cudaSafeMemcpy(result, (void *)*resultP, sizeof(struct JobDescription), 
                   cudaMemcpyDeviceToHost, stream_dataOut,
                   "FandDJob, Getting JobDescription");
    //Free task description
    gemtcFree(*resultP);

    //Update Queue metadata
    h_Q->Front = (h_Q->Front+1)%(h_Q->Capacity);
    cudaSafeMemcpy( movePointer(Q, 16), movePointer(h_Q, 16), 
                    sizeof(int), cudaMemcpyHostToDevice, stream_dataOut,
                    "FandDJob, Updating Queue");

    free(h_Q);
    free(resultP);
    return result;
  }
}
int FrontAndDequeueBatch(JobDescription *outBuffer, int max, Queue Q){
  int copySize= sizeof(struct QueueRecord);

  Queue h_Q = (Queue) malloc(sizeof(struct QueueRecord));
  
  cudaSafeMemcpy(h_Q, Q, copySize, cudaMemcpyDeviceToHost, stream_dataOut,
                 "FandDJobBatch, Getting Queue");

  if(h_IsEmpty(h_Q)){
    free(h_Q);
    return 0;
  }else{
    int jobs = h_Q->Capacity-1 - h_openSpace(h_Q);
    if(jobs>max)jobs=max;
    JobPointer results[jobs];
    //Read task Description Location
    if(h_Q->Capacity - h_Q->Front > jobs){
      cudaSafeMemcpy(results, (void *)&h_Q->Array[h_Q->Front], 
                     jobs*sizeof(JobPointer), 
                     cudaMemcpyDeviceToHost, stream_dataOut,
                     "FandDJobBatch, Getting All JobPointers");
    }else{
      int jobs_before_wrap = h_Q->Capacity - h_Q->Front-1;
      cudaSafeMemcpy(results, (void *)&h_Q->Array[h_Q->Front], 
                     jobs_before_wrap*sizeof(JobPointer), 
                     cudaMemcpyDeviceToHost, stream_dataOut,
                     "FandDJobBatch, Getting All JobPointers");
      cudaSafeMemcpy(results + jobs_before_wrap, (void *)&h_Q->Array[0],
                     (jobs-jobs_before_wrap)*sizeof(JobPointer), 
                     cudaMemcpyDeviceToHost, stream_dataOut,
                     "FandDJobBatch, Getting All JobPointers");
    }
    //Read task descriptions
    int i;
    for(i=0; i<jobs; i++){
      cudaSafeMemcpy(&outBuffer[i], (void *)results[i], sizeof(struct JobDescription), 
                     cudaMemcpyDeviceToHost, stream_dataOut,
                     "FandDJobBatch, Getting A JobDescriptions");

      //Free task description
      //gemtcFree(*resultP);     Fix me, memory leak, some descriptions allocated as large array. Problems
    }
    //Update Queue metadata
    h_Q->Front = (h_Q->Front+jobs)%(h_Q->Capacity);
    cudaSafeMemcpy( movePointer(Q, 16), movePointer(h_Q, 16), 
                    sizeof(int), cudaMemcpyHostToDevice, stream_dataOut,
                    "FandDJob, Updating Queue");
    free(h_Q);
    return jobs;
  }
}

JobPointer FrontResult(Queue Q) {
//called by CPU
  int copySize= sizeof(struct QueueRecord);

  Queue h_Q = (Queue) malloc(sizeof(struct QueueRecord));
  
  cudaSafeMemcpy(h_Q, Q, copySize, cudaMemcpyDeviceToHost, stream_dataOut,
                 "FandDJob, Getting Queue");
  while(h_IsEmpty(h_Q)){
    pthread_yield();
    cudaSafeMemcpy(h_Q, Q, copySize, cudaMemcpyDeviceToHost, stream_dataOut,
                   "FandDJob, Getting Queue again...");
  }
  //  printf("job pointer start\n");
  JobPointer *resultP = (JobPointer *) malloc(sizeof(JobPointer));
  JobPointer result = (JobPointer) malloc(sizeof(struct JobDescription));
  // printf("job pointer end\n");

  cudaSafeMemcpy(resultP, (void *)&h_Q->Array[h_Q->Front], sizeof(JobPointer), 
                 cudaMemcpyDeviceToHost, stream_dataOut,
                 "FandDJob, Getting JobPointer");

  cudaSafeMemcpy(result, (void *)*resultP, sizeof(struct JobDescription), 
                 cudaMemcpyDeviceToHost, stream_dataOut,
                 "FandDJob, Getting JobDescription");
  // printf("free begin\n");
  free(h_Q);

  free(resultP);

  return result;
}
void DequeueResult(Queue Q) {
//called by CPU
  int copySize= sizeof(struct QueueRecord);

  Queue h_Q = (Queue) malloc(sizeof(struct QueueRecord));

  cudaSafeMemcpy(h_Q, Q, copySize, cudaMemcpyDeviceToHost, stream_dataOut,
                 "FandDJob, Getting Queue");

  while(h_IsEmpty(h_Q)){
    pthread_yield();
    cudaSafeMemcpy(h_Q, Q, copySize, cudaMemcpyDeviceToHost, stream_dataOut,
                   "FandDJob, Getting Queue again...");
  }

  JobPointer *resultP = (JobPointer *) malloc(sizeof(JobPointer));
  //Pointer to Front task description

  cudaSafeMemcpy(resultP, (void *)&h_Q->Array[h_Q->Front], sizeof(JobPointer), 
                 cudaMemcpyDeviceToHost, stream_dataOut,
                 "FandDJob, Getting JobPointer");
  
  gemtcFree(*resultP);


  h_Q->Front = (h_Q->Front+1)%(h_Q->Capacity);

  cudaSafeMemcpy( movePointer(Q, 16), movePointer(h_Q, 16), 
		  sizeof(int), cudaMemcpyHostToDevice, stream_dataOut,
                  "FandDJob, Updating Queue");

  free(h_Q);
}


////////////////////////////////////////////////////////////
// Device Functions to Change Queues
////////////////////////////////////////////////////////////
__device__ void FrontAndDequeueJob(volatile Queue Q, volatile JobPointer *pResult, 
                                   volatile int *kill) {
//called by GPU
  getLock(Q, kill);
  if(*kill)return;

  int count = 0;
  while(d_IsEmpty(Q)){
    if(*kill)return;
    count++;
  }
  volatile int *front = &Q->Front;

  volatile JobPointer *ppResult = Q->Array + *front;

  *pResult = *ppResult;

  *front = (*front+1)%(Q->Capacity);

  releaseLock(Q);
}

__device__ void EnqueueResult(volatile JobPointer X, volatile Queue Q, volatile int *kill) {
//called by GPU
  getLock(Q, kill);
  if(*kill)return;

  int count =0;
  while(d_IsFull(Q)){
    if(*kill)return;
    count++;
  }
  volatile int *rear = &Q->Rear;
  int temp = (*rear + 1)%(Q->Capacity);

  volatile JobPointer *pLoc = Q->Array + temp;
  *pLoc = X;

  *rear = temp;

  releaseLock(Q);
}




