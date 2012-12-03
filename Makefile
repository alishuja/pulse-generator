### application  specific entries #############################################

# name of executable
TARGET = pulse-generator

# list of modules
SRC = .
MODULES = $(TARGET)

# list of additional libraries to link against
LIBS = 

# type of AVR controller (for gcc and avrdude)
MCU = atmega1280

# user specific compiler options
COPTS = -g -O2 -DF_CPU=1843200 -Wno-parentheses -fgnu89-inline
#COPTS = -g -O2 -DF_CPU=1000000 -Wno-parentheses -fgnu89-inline

#  user specific linker options
LOPTS =

# list of additional directories to be searched for header files
INCPATH = $(SRC)

# list of additional directories to be searched for libraries
LIBPATH = 


### common entries ############################################################

CC = avr-gcc
OBJCOPY = avr-objcopy
CTAGS = ctags
#UISP=uisp -dt_sck=200 -v=3 -dlpt=/dev/parport0 -dprog=dapa
UISP=uisp -v=3 -dlpt=/dev/parport0 -dprog=dapa
AVRDUDE_P=avrdude -p $(MCU) -c dapa -P /dev/parport0 -i 30
AVRDUDE_U=avrdude -p $(MCU) -c butterfly -P /dev/ttyUSB0 -b 230400
#AVRDUDE_U=avrdude -p $(MCU) -c butterfly -P com1 -b 230400
CFLAGS = -std=c99 -pedantic -Wall $(INCPATH:%=-I%) -mmcu=$(MCU) \
         -mcall-prologues $(COPTS)
LDFLAGS = $(LIBPATH:%=-L%) $(LIBS:%=-l%) -mmcu=$(MCU) $(LOPTS)
DEPS = $(foreach f, $(MODULES),$(dir $(f)).$(notdir $f).d)
OBJS = $(MODULES:%=%.o)
.PHONY: tags

.%.d: %.c
	@echo "D $*"
	@echo $*.o $@: $(wordlist 2, 99999, $(shell $(CC) $(CFLAGS) -MM $<)) >$@

%.o: %.c
	@echo "C $*"
	@$(CC) -c -o $@ $(CFLAGS) $<
#	@$(CC) -c -Wa,-ahld -o $@ $(CFLAGS) $< >$*.lss

%.o: %.S
	@echo "C $*"
	@$(CC) -c -o $@ $(CFLAGS) $<

%.s: %.c
	@echo "C $*"
	$(CC) -S $(CFLAGS) $<

%.lss: %.c
	@echo "C $*"
	$(CC) -Wa,-ahld $(CFLAGS) $< >$@

$(TARGET).elf: $(OBJS)
	@echo "L $(TARGET)"
	@$(CC) -o $@ $^ $(LDFLAGS)

%.hex: %.elf
	@echo "H $*"
	@$(OBJCOPY) -R .eeprom -O ihex $< $@

tags:
	@$(CTAGS) $(sort $(filter-out %: \, $(shell $(CC) $(CFLAGS) -M \
                $(MODULES:%=%.c))))

load: $(TARGET).hex
	@echo "P $(TARGET)"
	@$(AVRDUDE_P) -U flash:w:$<:i

config:
	@$(AVRDUDE_P) -t

clean:
	@rm $(OBJS) $(DEPS) $(TARGET).elf $(TARGET).hex tags 2>/dev/null || true

-include $(DEPS)
