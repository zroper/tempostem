//------------------------------------------------------------------------
// process JUICE(int channel, int duration)
// Deliver a juice reward to the animal
// INPUT
//	 channel  = rig specific TTL channel connected to solenoid (channel 9 in 028)
//	 duration = amount of time (in ms) to leave solenoid open
//
// written by david.c.godlove@vanderbilt.edu 	January, 2011, edited by Zachary J.J. Roper z.roper@vanderbilt.edu	April 10, 2017

declare JUICE(int channel, int duration);

process JUICE(int channel, int duration)
	{
	declare hide int open   = 1;	
	declare hide int closed = 0;	
	
	mio_dig_set(channel,open);		// Start sending the TTL
	wait(duration);					// Wait for user defined period of time (ms)
	mio_dig_set(channel,closed);	// Stop sending the TTL
	}