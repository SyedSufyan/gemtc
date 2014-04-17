#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>
#define BIN_COUNT 256
#define NUM_RUNS 6 

void print(unsigned int *histo){
int i;
for(i=0;i<BIN_COUNT;i++){
printf("%d\t",histo[i]);
}
}

int main(int argc, char *argv[])
{
 unsigned char * h_data;
 unsigned int h_histogram[BIN_COUNT];
 unsigned char * d_data;
 unsigned int * d_histogram;
 unsigned int byteCount = 1024;
 size_t size; 
 struct timeval tim;
 double t1,t2;
 int iter, i;
 for(iter =0 ; iter< NUM_RUNS;iter++){
 srand (2009);
 size = sizeof(unsigned char) * byteCount;
 h_data = (unsigned char *) malloc(sizeof(unsigned char) * byteCount);
 for (i = 0; i < byteCount; i++)
 {
        h_data[i] = rand() % 256;
 }
 gettimeofday(&tim, NULL);
 t1=tim.tv_sec+(tim.tv_usec/1000000.0);
 int j,k;
 for(j=0; j < 10; j++) {
 	for(k=0;k<size;k++){
	h_histogram[h_data[i]]++;
	}
 }
  gettimeofday(&tim, NULL);
  t2=tim.tv_sec+(tim.tv_usec/1000000.0);
 free(h_data); 
 double dAvgSecs = (t2-t1) / 10.0;
 printf("%u\t%.4f\t%.5f\n",
                        byteCount,(1.0e-6 * (double)byteCount / dAvgSecs), dAvgSecs);
 byteCount = byteCount * 10;
 
 }
// Print timing information

}
