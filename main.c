#include <libos.h>
#include "coremark.h"

int coremain(void);

static uint32_t heap[0x100000];

void kmain() {
  bfree(heap, sizeof(heap));
  printf("Calling coremain\n");
  coremain();
}
