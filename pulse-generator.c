#include <avr/io.h>
#include <avr/interrupt.h>
#include "iocompat.h"
int COUNT = 0;
int main(void){
	DDRB|= (1<<DDB6); //Setting up the direction for port B pin 6 to output.
	PORTB |= (1 <<PB6);


	TCCR1B |= (1<<WGM12); // Configure timer 1 for CTC mode
	TIMSK  |= (1 << OCIE1A); // Enabling interrupt
	sei();

	//Setting up prescaler 1 
	//Note: CKDIV8 is enabled so effective frequency is 1843200
	OCR1A = 461;
	TCCR1B |= (1<<CS10) ;
	for(;;){
	}
}
ISR(TIMER1_COMPA_vect)
{
	if(COUNT<3)
	{
	}
	else if(COUNT==3)
	{
		TCCR1B = 0;
		cli();
		TIMSK |=(0 << OCIE1A);
		OCR1A = 28797;
		TIMSK |=(1<<OCIE1A);
		sei();
		TCCR1B = (1 << CS11) | (1 << CS10);
	}
	else
	{
		TCCR1B = 0;
		cli();
		TIMSK |=(0 << OCIE1A);
		OCR1A = 461;
		TIMSK |=(1<<OCIE1A);
		sei();
		TCCR1B = (1 << CS10);
	}

	if (COUNT>3)
		COUNT=0;
	else{
		PORTB ^= (1 << PB6);
		COUNT++;
	}
}

