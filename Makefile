OBJDIR = ./obj
SRCDIR = ./src

SRCS = parse sort convert mergesort merge copy combine sort hexToAscii
OBJS = $(addprefix $(OBJDIR)/, $(SRCS:=.o))
TARGET = mergesort

all: $(TARGET)

$(TARGET): $(OBJS)
	ld -m elf_i386 $^ -o $@

$(OBJDIR)/%.o: $(SRCDIR)/%.s | $(OBJDIR)
	as $< -o $@ --32 -g 

$(OBJDIR):
	mkdir -p $(OBJDIR)

clean: 
	rm -f $(OBJDIR)) $(TARGET)

.PHONY: all clean
