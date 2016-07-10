/* file.cpp
 * Mac Radigan
 */

#include "modules/io/file.h"
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <stdio.h>
#include <sys/mman.h>

  status_t mmfile(const char * const filename, void **data, size_t &size)
  {
    struct stat sb;
    void *p;
    int fd;
    fd = open(filename, O_RDONLY);
    if(-1 == fd)
    {
      perror("cannot open file");
      return Status::FAILURE;
    }
    if(-1 == fstat(fd, &sb)) {
      perror("cannot stat file");
      return Status::FAILURE;
    }
    if(!S_ISREG(sb.st_mode)) {
      fprintf(stderr, "%s is not a file\n", filename);
      return Status::FAILURE;
    }
    p = mmap(0, sb.st_size, PROT_READ, MAP_SHARED, fd, 0);
    if(p == MAP_FAILED) {
      perror("cannot mmap file");
      return Status::FAILURE;
    }
    if(-1 == close(fd))
    {
      perror("cannot close file");
      return Status::FAILURE;
    }
    size = sb.st_size;
    *data = p;
    return Status::SUCCESS;
  }

/* *EOF* */
