#include <stdio.h>
#include <stdlib.h>

long a[40000000];

long last(long top) {
  long x = a[top];
  for (long i = 1; i <= top; i++)
    if (x == a[top - i]) return i;
  return 0;
}

int main(int argc, char **argv) {
  long end;
  long n = 0;
  
  if (argc < 3) {
    printf("USAGE: %s STEPS NUM1 NUM2 ...\n", *argv);
    return 1;
  }
 
  for (; n < argc - 2; n++)
    a[n] = atol(argv[n + 2]);
      
  end = atol(argv[1]);

  for (; n < end; n++) {
    if (n % 100000 == 0){
      printf("%ld...", n / 100000);
      fflush(NULL);
    }
    a[n] = last(n - 1);
  }

  printf("\n%ld\n", a[n - 1]);
}
