############################################
# AVR-gcc Makefile för Arduino Mega2560 på Windows
############################################

### Hårdvaruinställningar ###
MCU      = atmega2560
F_CPU    = 16000000UL

### Port (Windows) ###
PORT     = COM3        # Ändra till din port, t.ex. COM4

### Sökvägar ###
SRC_DIR  = .
BUILD    = build
INC      = -I$(SRC_DIR)

### Filnamn ###
TARGET   = $(BUILD)/main
SRCS     := $(wildcard $(SRC_DIR)/*.c) $(wildcard $(SRC_DIR)/**/*.cpp)
OBJS     := $(SRCS:%.c=$(BUILD)/%.o)
OBJS     := $(OBJS:%.cpp=$(BUILD)/%.o)

### Kompilatorflaggor ###
CFLAGS   = -std=gnu11 -Wall -Os -mmcu=$(MCU) -DF_CPU=$(F_CPU) $(INC)
CPPFLAGS = -std=gnu++11 -Wall -Os -mmcu=$(MCU) -DF_CPU=$(F_CPU) $(INC)
LDFLAGS  = -mmcu=$(MCU)

### Verktyg (Windows) ###
CC       = "C:\avr\bin\avr-gcc"
CXX      = "C:\avr\bin\avr-g++"
OBJCOPY  = "C:\avr\bin\avr-objcopy"
AVRDUDE  = "C:\avr\bin\avrdude.exe"
AVRDUDE_FLAGS = -c wiring -p $(MCU) -P $(PORT) -b 115200

### Målregler ###
.PHONY: all upload clean list-boards

# 1. Lista kort (om du vill)
list-boards:
	@echo "Ingen automatisk lista på Windows; kontrollera Enhetshanteraren eller Arduino IDE"

# 2. Huvudmål: bygg HEX
all: $(TARGET).hex

# Länkning
$(TARGET).elf: $(OBJS)
	@mkdir $(dir $@) 2>nul || rem
	$(CXX) $(LDFLAGS) $^ -o $@

# Generera HEX
$(TARGET).hex: $(TARGET).elf
	$(OBJCOPY) -O ihex -R .eeprom $< $@

# Kompilera C-källor
$(BUILD)/%.o: %.c
	@mkdir $(dir $@) 2>nul || rem
	$(CC) $(CFLAGS) -c $< -o $@

# Kompilera C++-källor
$(BUILD)/%.o: %.cpp
	@mkdir $(dir $@) 2>nul || rem
	$(CXX) $(CPPFLAGS) -c $< -o $@

# 3. Ladda upp med avrdude
upload: all
	$(AVRDUDE) $(AVRDUDE_FLAGS) -U flash:w:$(TARGET).hex:i

# 4. Rensa build-katalog
clean:
	if exist $(BUILD) rd /s /q $(BUILD)

################################################################################
# 5. Kompilera exempel från examples/ – placera denna sektion längst ned i Makefile
################################################################################

EXAMPLE_DIR = examples
EXAMPLES   := $(notdir $(wildcard $(EXAMPLE_DIR)/*))

.PHONY: $(EXAMPLES:%=build-%) build-all

# Bygger ett specifikt exempel: t.ex. `make build-led_button`
build-%:
	@echo "Bygger exempel '$*'..."
	$(MAKE) \
	  MCU=$(MCU) \
	  F_CPU=$(F_CPU) \
	  SRC_DIR=$(EXAMPLE_DIR)/$* \
	  TARGET=$(BUILD)/$*/main \
	  all

# Alternativt: bygg alla exempel med `make build-all`
.PHONY: build-all
build-all: $(EXAMPLES:%=build-%)
