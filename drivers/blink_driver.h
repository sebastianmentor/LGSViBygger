#ifndef STANDARD_BLINK_H
#define STANDARD_BLINK_H

#include <avr/io.h>
#include <avr/interrupt.h>

#define LED_PIN PB5  // Pin 13 på Arduino Uno (PORTB5)

/**
 * @brief Initierar LED-pin och timerresurser.
 * Sätter LED_PIN som output och stänger av timer.
 */
void init_standard_blink(void);

/**
 * @brief Startar timer och aktiverar interrupt för att blinka LED var 500 ms.
 */
void start_blink(void);

/**
 * @brief Stoppar timer och inaktiverar blink-interrupt.
 */
void stop_blink(void);

/**
 * @brief Interrupt service routine för Timer1 Compare Match A.
 * Togglar LED.
 */
ISR(TIMER1_COMPA_vect);

#endif // STANDARD_BLINK_H
