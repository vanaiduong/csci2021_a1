#include <stdlib.h>
#include <stdio.h>
#include <sys/stat.h>

void display_array(int* int_array, int length) {
  for (int i = 0; i < length; i++) {
    printf("%d\n", int_array[i]); 
  }
}

int* read_text_deltas(char *fname, int *len){
	//open file
	FILE *fp;
	fp = fopen(fname, "r");
	
  if (fp == NULL) { // if file cannot be opened with  fopen()
		*len = -1;
		return NULL;
	}

	printf("Opened file\n");
  // Stores each integer read from the file
	int temp; 
	//scan and count how many text integers exist
	int count = 0;
	if (fscanf(fp, "%d", &temp) == EOF) {
		*len = -1;
    fclose(fp);
		return NULL;
	}
  // Increment count since the first number has been read
  count++;
	while (fscanf(fp, "%d", &temp) != EOF) {
		count = count + 1;
	}
  
  printf("The number of integers is: %d\n", count);
  *len = count;
	//allocates an array of appropriate size using malloc()
	int* nums = malloc(count * sizeof(int));
	//uses rewind to go back to the beginning of the file and then reads
	//integers into the allocated array
	rewind(fp);
	
  int i = 0;
	while( fscanf(fp, "%d", &temp) != EOF){	
    if (i != 0) {
		  nums[i]= nums[i - 1] + temp;
    }
    else {
      nums[i] = temp;
    }
    i = i + 1;
	}
	//closes the file after reading all the ints
	fclose(fp);
	//returns a pointer to the allocated array

	return nums;
}

int* read_int_deltas(char* fname, int* len) {
  FILE *fp;
  fp = fopen(fname, "r");

  if (fp == NULL) {
    *len = -1;
    return NULL;
  }

  printf("File %s is not empty", fname);

  struct stat sb;
  int result = stat(fname, &sb);
  if (result == -1 || sb.st_size < sizeof(int)) {
    *len = -1;

    fclose(fp);
    return NULL;
  }

  // Set the number of integers
  *len = sb.st_size / 4;
  
  int* int_array = malloc(*len * 4);

  int i = 0, temp = 0;
  while (i < *len) {
    fread((void*) &temp, sizeof(int), 1, fp);
    int_array[i] = (i == 0) ? temp : int_array[i - 1] + temp;
    i++;
  }
  fclose(fp);
  return int_array;

}



// Reads integers in text delta format from the file named by fname
// and returns an array of them. The first integer in the file gives
// the starting point and subsequent integers are changes from the
// previous total.
// 
// Opens the file with fopen() and scans through its contents using
// fscanf() counting how many text integers exist in it.  Then
// allocates an array of appropriate size using malloc(). Uses
// rewind() to go back to the beginning of the file then reads
// integers into the allocated array. Closes the file after reading
// all ints.  Returns a pointer to the allocated array.
// 
// The argument len is a pointer to an integer which is set to the
// length of the array that is allocated by the function.
//
// If the file cannot be opened with fopen() or if there are no
// integers in the file, sets len to -1 and returns NULL.
