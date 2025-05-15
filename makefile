# === Användardefinierade inställningar ===
MCU = atmega2560
F_CPU = 16000000UL
PROGRAMMER = arduino
PORT = COM3         # ⚠️ Ändra till rätt COM-port
BAUD = 115200

# === Verktyg ===
CC = avr-gcc
OBJCOPY = avr-objcopy

# === Flaggor ===
CFLAGS = -Wall -Os -DF_CPU=$(F_CPU) -mmcu=$(MCU) -MMD -MP $(INCLUDES)

# === Kataloger ===
EXAMPLE ?= blink
EXAMPLE_DIR = examples/$(EXAMPLE)
DRIVER_DIR = drivers
BUILD_DIR = build

# === Filupptäckt ===
SRCS := $(wildcard $(EXAMPLE_DIR)/*.c) $(wildcard $(DRIVER_DIR)/*.c)
OBJS := $(patsubst %.c,$(BUILD_DIR)/%.o,$(SRCS))
DEPS := $(OBJS:.o=.d)

INCLUDES = -I$(DRIVER_DIR)

# === Utdatafiler ===
ELF = $(BUILD_DIR)/$(EXAMPLE).elf
HEX = $(BUILD_DIR)/$(EXAMPLE).hex

# === Felhantering om ingen källa finns i EXAMPLE ===
ifeq ($(words $(wildcard $(EXAMPLE_DIR)/*.c)), 0)
$(error Inga .c-filer hittades i examples/$(EXAMPLE)/ - är EXAMPLE rätt?)
endif

# === Mål ===
all: $(HEX)

# HEX från ELF
$(HEX): $(ELF)
	$(OBJCOPY) -O ihex -R .eeprom $< $@

# ELF från objektfiler
$(ELF): $(OBJS)
	@if not exist "$(dir $@)" mkdir "$(dir $@)"
	$(CC) $(CFLAGS) -o $@ $^

# Objektfiler
$(BUILD_DIR)/%.o: %.c
	@if not exist "$(dir $@)" mkdir "$(dir $@)"
	$(CC) $(CFLAGS) -c $< -o $@

# Flash med avrdude
flash: $(HEX)
	avrdude -c $(PROGRAMMER) -p $(MCU) -P $(PORT) -b $(BAUD) -U flash:w:$(HEX)

# Rensa
clean:
	@if exist $(BUILD_DIR) rmdir /s /q $(BUILD_DIR)

# Lista tillgängliga exempel
list-drivers:
	@echo Tillgängliga drivers:
	@for /D %%d in (drivers\*) do @echo  - %%~nxd

# Lista tillgängliga exempel
list-examples:
	@echo Tillgängliga exempel:
	@for /D %%d in (examples\*) do @echo  - %%~nxd

ALL_EXAMPLES := $(notdir $(wildcard examples/*))

build-all:
	@for %%e in ($(ALL_EXAMPLES)) do make EXAMPLE=%%e

-include $(DEPS)

.PHONY: all clean flash list