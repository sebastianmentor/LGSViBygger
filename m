############################################
# AVR-gcc Makefile för Arduino Mega2560
############################################

### Hårdvaruinställningar ###
MCU      = atmega2560
F_CPU    = 16000000UL

### Sökvägar ###
SRC_DIR  = drivers
BUILD    = build
INC      = -I$(SRC_DIR)

### Filnamn ###
TARGET   = $(BUILD)/main
SRCS     := $(wildcard $(SRC_DIR)/**/*.c) $(wildcard $(SRC_DIR)/**/*.cpp)
OBJS     := $(SRCS:%.c=$(BUILD)/%.o)
OBJS     := $(OBJS:%.cpp=$(BUILD)/%.o)

### Kompilatorflaggor ###
CFLAGS   = -Wall -Os -mmcu=$(MCU) -DF_CPU=$(F_CPU) $(INC)
CPPFLAGS = -Wall -Os -mmcu=$(MCU) -DF_CPU=$(F_CPU) $(INC)
LDFLAGS  = -mmcu=$(MCU)

### Verktyg ###
CC       = "C:\avr\bin\avr-gcc"
CXX      = "C:\avr\bin\avr-g++"
OBJCOPY  = "C:\avr\bin\avr-objcopy"
AVRDUDE  = "C:\avr\bin\avrdude"
AVRDUDE_FLAGS = -c wiring -p $(MCU) -P /dev/ttyACM0 -b 115200

### Målregler ###
.PHONY: all upload clean

all: $(TARGET).hex

# Länkning
$(TARGET).elf: $(OBJS)
	@mkdir -p $(dir $@)
	$(CXX) $(LDFLAGS) $^ -o $@

# Generera HEX
$(TARGET).hex: $(TARGET).elf
	$(OBJCOPY) -O ihex -R .eeprom $< $@

# Kompilera C-källor
$(BUILD)/%.o: %.c
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) -c $< -o $@

# Kompilera C++-källor
$(BUILD)/%.o: %.cpp
	@mkdir -p $(dir $@)
	$(CXX) $(CPPFLAGS) -c $< -o $@

# Ladda upp med avrdude
upload: all
	$(AVRDUDE) $(AVRDUDE_FLAGS) -U flash:w:$(TARGET).hex:i

# Rensa build-katalog
clean:
	rm -rf $(BUILD)

EXAMPLES := $(wildcard examples/*)

.PHONY: $(EXAMPLES:%=build-%)

build-%:
	$(MAKE) MCU=$(MCU) F_CPU=$(F_CPU) \
         SRC_DIR=examples/$* \
         TARGET=$(BUILD)/$*/main \
         all