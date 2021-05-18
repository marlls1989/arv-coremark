#include <libos.h>
#include "coremark.h"

extern void coremain(void);

void kmain() {
  coremain();

	// Terminates execution
	for(;;) halt();
}
