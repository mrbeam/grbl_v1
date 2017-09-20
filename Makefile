#  Part of Grbl
#
#  Copyright (c) 2009-2011 Simen Svale Skogsrud
#  Copyright (c) 2012 Sungeun K. Jeon
#
#  Grbl is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 3 of the License, or
#  (at your option) any later version.
#
#  Grbl is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with Grbl.  If not, see <http://www.gnu.org/licenses/>.


# This is a prototype Makefile. Modify it according to your needs.
# You should at least check the settings for
# DEVICE ....... The AVR device you compile for
# CLOCK ........ Target AVR clock rate in Hertz
# OBJECTS ...... The object files created from your source files. This list is
#                usually the same as the list of source files with suffix ".o".
# PROGRAMMER ... Options to avrdude which define the hardware you use for
#                uploading to the AVR and the interface where this hardware
#                is connected.
# FUSES ........ Parameters for avrdude to flash the fuses appropriately.

GIT_HASH := $(shell git describe --abbrev=7 --dirty --always --tags)
DEVICE     ?= atmega328p
CLOCK      = 16000000
PROGRAMMER ?= -c avrisp2 -P usb
OBJECTS    = main.o motion_control.o gcode.o spindle_control.o coolant_control.o serial.o \
             protocol.o stepper.o eeprom.o settings.o planner.o nuts_bolts.o limits.o \
             print.o probe.o report.o system.o
FUSES      = -U hfuse:w:0xde:m -U lfuse:w:0xff:m -U efuse:w:0xfd:m -U lock:w:0xff:m
GRBL_HEX_FILE  = hex/grbl_$(GIT_HASH).hex
OPTI_HEX_FILE  = hex/optiboot_atmega328.hex
GRBL_OPTI_FILE = hex/grbl_optiboot_$(GIT_HASH).hex

# Tune the lines below only if you know what you are doing:

AVRDUDE = avrdude $(PROGRAMMER) -p $(DEVICE) -B 10 -F
override CFLAGS += -DGIT_VERSION=\"$(GIT_HASH)\"
COMPILE = avr-gcc -Wall -Os -DF_CPU=$(CLOCK) $(CFLAGS) -mmcu=$(DEVICE) -I. -ffunction-sections

# symbolic targets:
all:	$(GRBL_HEX_FILE) $(GRBL_OPTI_FILE)

.c.o:
	$(COMPILE) -c $< -o $@
	@$(COMPILE) -MM  $< > $*.d

.S.o:
	$(COMPILE) -x assembler-with-cpp -c $< -o $@
# "-x assembler-with-cpp" should not be necessary since this is the default
# file type for the .S (with capital S) extension. However, upper case
# characters are not always preserved on Windows. To ensure WinAVR
# compatibility define the file type manually.

.c.s:
	$(COMPILE) -S $< -o $@

flash:	all
	$(AVRDUDE) -U flash:w:$(GRBL_OPTI_FILE):i

fuse:
	$(AVRDUDE) $(FUSES)

# Xcode uses the Makefile targets "", "clean" and "install"
install: flash fuse

# if you use a bootloader, change the command below appropriately:
load: all
	bootloadHID $(GRBL_HEX_FILE)

clean:
	rm -f grbl_*.hex main.elf $(OBJECTS) $(OBJECTS:.o=.d)

# file targets:
main.elf: $(OBJECTS)
	$(COMPILE) -o main.elf $(OBJECTS) -lm -Wl,--gc-sections

$(GRBL_HEX_FILE): main.elf
	avr-objcopy -j .text -j .data -O ihex main.elf $(GRBL_HEX_FILE)
	avr-size --format=berkeley main.elf

$(GRBL_OPTI_FILE): $(GRBL_HEX_FILE)
	head -n -1 $(GRBL_HEX_FILE) > $(GRBL_OPTI_FILE)
	cat $(OPTI_HEX_FILE) >> $(GRBL_OPTI_FILE)

# If you have an EEPROM section, you must also create a hex file for the
# EEPROM and add it to the "flash" target.

# Targets for code debugging and analysis:
disasm:	main.elf
	avr-objdump -d main.elf

cpp:
	$(COMPILE) -E main.c

# include generated header dependencies
-include $(OBJECTS:.o=.d)
