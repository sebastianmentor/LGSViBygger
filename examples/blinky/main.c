#include <avr/io.h>
#include <util/delay.h>

int main(void) {
    // Sätt PB7 (digital pin 13) som utgång
    DDRB |= (1 << PB7);

    while (1) {
        // Sätt PB7 hög (tänd LED)
        PORTB |= (1 << PB7);
        _delay_ms(1000);

        // Sätt PB7 låg (släck LED)
        PORTB &= ~(1 << PB7);
        _delay_ms(1000);
    }
}
