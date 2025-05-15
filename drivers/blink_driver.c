#include <avr/io.h>
#include <avr/interrupt.h>

#define LED_PIN PB7  // Pin 13 på Arduino MEGA (PORTB7)

// Initiera pinMode och timer-resurser
void init_standard_blink() {
    // Sätt LED_PIN som output
    DDRB |= (1 << LED_PIN);
    
    // Sätt LED av initialt
    PORTB &= ~(1 << LED_PIN);
    
    // Förbered Timer1 men starta inte än
    TCCR1A = 0;           // Normal operation
    TCCR1B = 0;           // Timer avstängd initialt
    TIMSK1 = 0;           // Inga interrupts aktiva
}

// Starta timer och aktivera interrupt för blinkning
void start_blink() {
    cli();  // Inaktivera globala interrupts

    // CTC-läge
    TCCR1B |= (1 << WGM12);

    // Prescaler 64 (16 MHz / 64 = 250 kHz)
    TCCR1B |= (1 << CS11) | (1 << CS10);

    // 500 ms => 250000 * 0.5 = 125000 ticks
    // OCR1A är 16-bit => max 65535, så vi måste dela upp det:
    // Nytt mål: 250000 / 4 = 62500 ticks => prescaler 256 (16 MHz / 256 = 62500)
    TCCR1B &= ~((1 << CS11) | (1 << CS10));  // Rensa prescaler-bitar
    TCCR1B |= (1 << CS12); // Prescaler 256

    OCR1A = 31250;  // 500 ms (62500 ticks per sekund / 2)

    TCNT1 = 0;  // Nollställ timer
    TIMSK1 |= (1 << OCIE1A);  // Aktivera Compare Match A interrupt

    sei();  // Aktivera globala interrupts
}

// Stoppa timer och interrupt
void stop_blink() {
    cli();
    TCCR1B = 0;          // Stoppa timer
    TIMSK1 &= ~(1 << OCIE1A);  // Inaktivera interrupt
    sei();
}

// Interrupt rutin: toggla LED
ISR(TIMER1_COMPA_vect) {
    PORTB ^= (1 << LED_PIN);  // Toggle LED
}
