TRIPLET = riscv32-unknown-elf
CC = $(TRIPLET)-gcc
CFLAGS = -IbareOS/include -O2 -fno-builtin -march=rv32i -nostdinc -mbranch-cost=7 -DITERATIONS=0 -DCORE_DEBUG=0
AS = $(TRIPLET)-as
ASFLAGS = -march=rv32i
CPP = $(TRIPLET)-g++
CCFLAGS = $(CFLAGS)
LD = $(TRIPLET)-gcc
LDFLAGS = -nostdlib -march=rv32i -Tqdi-riscv.ld
OBJCOPY = $(TRIPLET)-objcopy
OBJDUMP = $(TRIPLET)-objdump

PROGNAME = coremark

SRC_FILES = crt0.s \
	arch.s \
	softmul.c \
	core_list_join.c \
	core_matrix.c \
	core_portme.c \
	core_state.c \
	core_util.c \
	ee_printf.c \
	core_main.c

BIN_FILES = $(addsuffix .bin, $(PROGNAME))
LST_FILES = $(addsuffix .lst, $(PROGNAME))
ELF_FILES = $(addsuffix .elf, $(PROGNAME))
OBJ_FILES = $(patsubst %.s, %.o, $(patsubst %.c, %.o, $(SRC_FILES)))

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

$(ELF_FILES): $(OBJ_FILES)
	$(LD) -o $@ $+ $(LDFLAGS)

clean :
	rm -f $(BIN_FILES) $(LST_FILES) $(OBJ_FILES) $(ELF_FILES) $(wildcard *~)
