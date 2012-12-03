#include <avr/io.h>
#include <util/delay.h>
#include "iocompat.h"

int COUNT = 0;

int main(void){
	DDRB|= (1<<DDB6); //Setting up the direction for port B pin 6 to output.

	while(1){
		PORTB |= (1 <<PB6);
		_delay_us(337);
		PORTB &= (0 << PB6);
		_delay_us(356);
		PORTB |= (1 << PB6);
		_delay_us(278);
		PORTB &= (0 << PB6);
		_delay_ms(850); 
	}
}
	
