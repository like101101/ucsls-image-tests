#include <stdlib.h>
#include <stdio.h>
#include <sys/stat.h>
#include <errno.h>
#include <unistd.h>

char *waldos[] = {
		  "waldo",
		  "Waldo",
		  "wAlDo",
		  "WaLdO",
		  "waLdo",
		  "wALDO",
		  "WALDO"
};

#define MAX_DIRS 19
#define MAX_FILES 42

#define LEN 80
#define FILE_WALDO_BASEDIR "PuzzleDir"
#define DIR_PERM  S_IRWXU | S_IRWXG
#define FILE_PERM  S_IRWU | S_IRWG

char *waldo() {
  return waldos[random() % 7];
}

int
stream_waldos(FILE *stream, int n, int target, int num)
{
  long int j;
  int rc=0;
  
  if (n == target) {
    for (int k=0; k<num; k++) {
      for (j=0; j<random()%20; j++) {
	fprintf(stream, "I am not here...\n");
      }
      
      fprintf(stream, "%s is here!!!\n", waldo());
      
      for (j=0; j<random()%20; j++) {
	fprintf(stream, "I am not here...\n");
      }
    }
    rc=1;
  } else {
    for (j=0; j<random()%100; j++) {
      fprintf(stream, "I am not here...\n");
    }
  }
  return rc;
}

int
mkfiles(int num, int n, int target,
	int contentsnum, int thecontentsfile,
	int *filenum)
{
  int i;
  char filename[LEN];
  FILE *thefile;
  int rc = 0;
  
  for (i=0; i<num; i++) {
    snprintf(filename, LEN, "mystery_%d", i);
    
    thefile = fopen(filename, "w+");
    if (thefile == NULL) {
      perror(filename);
      exit(-1);
    }
    
    if (*filenum == thecontentsfile) {
      rc = stream_waldos(thefile, n, target, contentsnum);
    } else {
      stream_waldos(thefile, n, -1, contentsnum); // force no match (only put contents into chosen file)
    }
    fclose(thefile);
    (*filenum)++;
  }
  return rc;
}

int
file_waldos(char *basedir, int n, int target, int contentsnum, int namenum)
{
  pid_t mypid;
  char dirname[LEN];
  
  int rc = 0;
  int numdir;
  int numfiles;
  int numsubdir;
  int numsubfiles;
  
  int filenum = 0;
  int thecontentsfile = -1;
  int i;
  
  numdir = (random()) % MAX_DIRS + 1;
  numfiles = (random() % MAX_FILES) + 1 + namenum;
  mypid = getpid();
  
  if (n == target) {
    thecontentsfile = random() % numfiles;
    rc = 1;
  }
    
  if (mkdir(basedir, DIR_PERM) < -1) {
    if (errno != EEXIST) {
      perror(basedir);
      exit(-1);
    }
  }

  // cd $basedir
  if (chdir(basedir)<0) {
    perror(basedir);
    exit(-1);
  }
  
  while(numdir>0) {
    // pick a number of subdirectories and files to create in current dir
    numsubdir=(random() % numdir) + 1; // at least one subdir
    numsubfiles=random() % numfiles;
    
    // create the files for this directory
    mkfiles(numsubfiles, n, target, contentsnum, thecontentsfile, &filenum);
    numfiles = numfiles - numsubfiles; // update number files left to create
    
    // created all the sub directories required
    for (i=0; i<numsubdir; i++) {
      snprintf(dirname, LEN, "%d_mystery_%d", mypid, i);
      mkdir(dirname, DIR_PERM);
    }
    numdir = numdir - numsubdir; // update number of directories left to create
    
    // pick a random subdir and cd into it
    i = random() % numsubdir;
    snprintf(dirname, LEN, "%d_mystery_%d", mypid, i);
    if (chdir(dirname) < 0 ) {
      perror(dirname);
      exit(-1);
    }
  }
  // created all the directories needed
  // if we have not created all the files then create any left over here
  mkfiles(numfiles, n, target, contentsnum, thecontentsfile, &filenum);

  if (n==target && namenum > 0) {
    char *wfilename = waldo();
    FILE *wf = fopen(wfilename, "w+");
    if (wf == NULL) {
      perror(wfilename);
      exit(-1);
    }
    fclose(wf);
  }
 
  return rc;
}


int
main(int argc, char **argv)
{
  int rc=-2;
  int n;
  
  if (argc != 2) {
    fprintf(stderr, "USAGE: %s <n>\n"
	            "     Where n is an integer value with 0<=n<=99.\n",
	    argv[0]);
    exit(-1);
  }

  n = atoi(argv[1]);

  if (n<0 || n>99) {
    fprintf(stderr, "ERROR: n=%d not within bounds of 0 and 99\n", n);
    exit(-1);
  }
  
  if (stream_waldos(stdout, n, STDOUT_WALDO_TARGET, STDOUT_WALDO_NUM)) rc = 0;

  if (stream_waldos(stderr, n, STDERR_WALDO_TARGET, STDERR_WALDO_NUM)) rc = 0;
  
  if (file_waldos(FILE_WALDO_BASEDIR, n, FILE_WALDO_TARGET,
		  FILE_WALDO_CONTENTS_NUM,
		  FILE_WALDO_NAME_NUM)) rc = 0;
  
  return rc;
}
