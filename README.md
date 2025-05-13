````markdown
# Projekt för Lindas Gröna Sköna 
## !(Work in progress)!

Det här projektet har tagits fram på förfrågan av **Lindas Gröna Sköna**, som överväger att anlita oss för ett storskaligt inomhusodlingssystem. Syftet med projektet är att visa vår kompetens inom inbyggda system och sensorintegration, som en del i deras framtida odlingslösning.

## Översikt
- **Plattform**: Arduino Mega2560 Rev3 (ATmega2560)
- **Verktygskedja**: `avr-gcc` enligt Zak's Electronics Blog (https://blog.zakkemble.net/avr-gcc-builds/)
- **Versionshantering**: Git + GitHub
- **Simulering**: Wokwi Online Simulator

## Innehållsförteckning

```text
/ (root)
├── drivers/            # Drivrutinsmoduler per sensor eller periferienhet
├── tests/              # Enhetstester och integrationstester
├── docs/               # Dokumentation, arkitekturdiagram, API-specifikation
├── examples/           # Katalog med alla exempelmoduler
├── Makefile            # Bygg- och uppladdningsskript (avr-gcc + avrdude)
├── README.md           # Denna fil
└── LICENSE             # Licens (t.ex. MIT)
````

## Kom igång

1. **Installera avr-toolchain** enligt Zak's Electronics Blog:

   ```bash
   # På Linux (Ubuntu/Debian)
   sudo apt update
   sudo apt install avr-gcc avr-libc avrdude make
   ```

2. **Klona repot**

   ```bash
   git clone https://github.com/ditt-team/inomhusodling-embedded.git
   cd inomhusodling-embedded
   ```

3. **Bygg huvudprojektet**

   ```bash
   make
   ```

4. **Bygg ett exempel**

   ```bash
   make build-<exempelnamn>
   # t.ex. make build-led_button
   ```

5. **Ladda upp till Arduino Mega2560** (justera port om nödvändigt)

   ```bash
   make upload
   ```

6. **Rensa byggfiler**

   ```bash
   make clean
   ```

## Versionshantering och bidrag

* **Branch-strategi**:

  * `main`: stabil kod
  * `feature/<sensor>-driver`: utvecklingsgrenar
* **Pull Requests**: kodgranskning, CI kör Makefile och Wokwi-test
* **Kodstandard**: Google C++ Style Guide + clang-format


## Kontakt

För frågor eller vidare diskussion, kontakta projektledare.

```
```
