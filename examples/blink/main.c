#include <util/delay.h>
#include "blink_driver.h"

int main(void) {
    init_standard_blink();

    // Starta blinkning efter 2 sekunder
    //_delay_ms(2000);
    start_blink();

    // Blinka i 10 sekunder
    
    //stop_blink();

    while (1) {
        // Do nothing
        _delay_ms(10000);
    }
}
