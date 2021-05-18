TRIPLET = riscv32-unknown-elf
CC = $(TRIPLET)-gcc
CFLAGS = -IbareOS/include -O2 -fno-builtin -march=rv32i -nostdinc -mbranch-cost=5 -DITERATIONS=1
AS = $(TRIPLET)-as
ASFLAGS = -march=rv32i
CPP = $(TRIPLET)-g++
CCFLAGS = $(CFLAGS)
LD = $(TRIPLET)-gcc
LDFLAGS = -nostdlib -march=rv32i -Tqdi-riscv.ld
OBJCOPY = $(TRIPLET)-objcopy
OBJDUMP = $(TRIPLET)-objdump

PROGNAME = coremark

BIN_FILES = $(addsuffix .bin, $(PROGNAME))
LST_FILES = $(addsuffix .lst, $(PROGNAME))

BARE_OS = bareOS/crt0.o \
	bareOS/arch.o \
	bareOS/libos.o \
	bareOS/malloc.o \
	bareOS/softmul.o

COREMARK = core_list_join.o \
	core_matrix.o \
	core_portme.o \
	core_state.o \
	core_util.o \
	ee_printf.o \
	core_main.o

all : $(BIN_FILES) $(LST_FILES)

%.bin : %.elf
	$(OBJCOPY) -O binary $< $@

%.lst : %.elf
	$(OBJDUMP) -d $< > $@

%.o: %.c
	$(CC) $(CFLAGS) -o $@ -c $<

%.o: %.cpp
	$(CPP) $(CCFLAGS) -o $@ -c $<

%.o: %.s
	$(AS) $(ASFLAGS) -o $@ $<

coremark.elf: $(BARE_OS) $(COREMARK)
	$(LD) -o $@ $+ $(LDFLAGS)

clean :
	rm -f $(BIN_FILES) $(LST_FILES) $(BARE_OS) $(wildcard *~) $(wildcard *.o) coremark.elf
