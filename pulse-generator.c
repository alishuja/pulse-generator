#include <avr/io.h>
#include <avr/interrupt.h>
#include "iocompat.h"
int main(void){
	DDRB|= (1<<DDB6);

	TCCR1B |= (1<<WGM12); // Configure timer 1 for CTC mode
	TIMSK  |= (1 << OCIE1A);
	sei();

	//Setting up prescaler for 1Hz of 14745600
	//Note: CKDIV8 is enabled so effective frequency is 1843200
	OCR1A = 28800;


	TCCR1B |= ((1<<CS11) | (1<<CS10)) ;
	for(;;){
	}
}
ISR(TIMER1_COMPA_vect)
{
	PORTB ^= (1 << PB6);
}

