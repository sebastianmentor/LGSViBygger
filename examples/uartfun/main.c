#include <avr/io.h>
#include <util/delay.h>
#include <string.h>

#define F_CPU 16000000UL
#define BAUD 9600
#define MYUBRR ((F_CPU / (16UL * BAUD)) - 1)

// Initiera UART0
void uart_init(void) {
    // Sätt baud rate
    UBRR0H = (unsigned char)(MYUBRR >> 8);
    UBRR0L = (unsigned char)(MYUBRR);

    // Aktivera sändning och mottagning
    UCSR0B = (1 << TXEN0) | (1 << RXEN0);

    // Sätt ramformat: 8 data, 1 stopbit
    UCSR0C = (1 << UCSZ01) | (1 << UCSZ00);
}

// Skicka en byte via UART
void uart_transmit(unsigned char data) {
    // Vänta tills sändningsbufferten är tom
    while (!(UCSR0A & (1 << UDRE0)));
    // Skicka data
    UDR0 = data;
}

// Skicka en sträng via UART
void uart_print(const char* str) {
    for (size_t i = 0; i < strlen(str); ++i) {
        uart_transmit(str[i]);
    }
}

int main(void) {
    uart_init(); // Initiera UART

    uart_print("Startar blinkprogram med UART!\r\n");

    // Sätt pin 13 (PORTB5) som utgång
    DDRB |= (1 << DDB7);

    while (1) {
        PORTB ^= (1 << PORTB7); // Toggla LED
        uart_print("LED växlad!\r\n");
        _delay_ms(1000);
    }
}
