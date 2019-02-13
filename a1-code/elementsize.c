#include <stdio.h>
#include <stdlib.h>
#include <sys/stat.h>

int main() {
  struct stat sb;                                    // struct to hold
  int result = stat("deltas.txt", &sb);                     // unix system call to determine size of named file
  if(result==-1 || sb.st_size < sizeof(int)){        // if something went wrong or bail if file is too small
    return -1;

  }
  int total_bytes = sb.st_size;  // size of file in bytes
  printf("%d\n", total_bytes);
}
