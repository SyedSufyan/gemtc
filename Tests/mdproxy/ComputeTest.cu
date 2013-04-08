#include "../../gemtc.cu"
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

int main(int argc, char **argv){
  gemtcSetup(25600, 0);
  
  int np = 32; //Feel free to modify this variable. 
  int nd = 2;  //This value should only be 2 or 3!
  const double mass = 1.0;

  int a_size = np * nd; 
  int a_mem = sizeof(double) * a_size;

  double darray[a_size];

  int mem_needed = sizeof(int)*2 + sizeof(double) + a_mem*5;
  
  void *d_mem = gemtcGPUMalloc(mem_needed);
  void *h_mem = malloc(mem_needed);

  memcpy( h_mem                , &np   , sizeof(int));
  memcpy( (((int*)h_mem)+1)    , &nd   , sizeof(int)); 
  memcpy( (((double*)h_mem)+1) , &mass , sizeof(double));
  
  //Creates arrays for pos, vel, f, pe, ke. 
  int i;
  for(i=0; i<5; i++){
    memcpy( (((double*)h_mem) + (a_size*i) + 2), darray, a_mem);
  }

  gemtcMemcpyHostToDevice(d_mem, h_mem, mem_needed);
  gemtcPush(16, 1, 12000, d_mem); 
 
  void *ret = NULL;
  int id;
  while(ret==NULL){
    gemtcPoll(&id, &ret);
  }
  printf("Got the results!");
  void* results = malloc(mem_needed);
  gemtcMemcpyDeviceToHost(results, ret, mem_needed);

  int *p_np = (int*)results;
  int *p_nb = ((int*)results)+1;
  printf("np is: %d\n nb is: %d\n", *p_np, *p_nb);

  double *p_mass = (double *)((int*)results+2);
  printf("Mass is: %f\n", *p_mass);

  double *pos = p_mass + 1; 
  double *vel = pos + a_size;
  double *f = vel + a_size;

  double *pe = f + a_size;
  double *ke = pe + a_size;
  
  for(i=0; i<a_size; i++){
    printf("%f %f %f %f %f\n", pos[i], vel[i], f[i], pe[i], ke[i]);
  }

  gemtcGPUFree(results);
  ret = NULL;

  gemtcCleanup();
}

//This code is used if you want to check any of 
//the parameters that you passed in earlier. 


 
