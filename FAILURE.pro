//---------------------------------------------------------------------------------------------------------------------
// declare FAILURE(int trial_length,
				// int inter_trl_int,
				// int trl_start_time,
				// int fixed_trl_length,
				// int failure_tone,
				// int punish_time);
// Give negative reinforcement, set variables for the next trial, 
// send all trial event codes to plexon, and impose the correct 
// inter trial interval + timeout.
//
// written by david.c.godlove@vanderbilt.edu 	January, 2011, edited by Zachary J.J. Roper z.roper@vanderbilt.edu	April 10, 2017

declare FAILURE(int trial_length,									// see DEFAULT.pro and ALL_VARS.pro for explanations of these globals
				int inter_trl_int,
				int trl_start_time,
				int fixed_trl_length,
				int failure_tone,
				int punish_time);
				
process FAILURE(int trial_length,									// see DEFAULT.pro and ALL_VARS.pro for explanations of these globals
				int inter_trl_int,
				int trl_start_time,
				int fixed_trl_length,
				int failure_tone,
				int punish_time)
	{
	declare hide int trl_end_time;
	
	declare hide int run_cmd_sess = 1;								// state 1 is countermanding
	declare hide int run_mg_sess = 3;								// state 3 is mem guided sacc
	declare hide int run_gonogo_sess = 4;
	declare hide int run_delayed_sess = 6;
	declare hide int run_search_sess = 7;


	spawn TONE(failure_tone,tone_duration);							// present negative tone
	
	Event_fifo[Set_event] = Tone_;									// ...queue strobe...
	Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue...
	
	Event_fifo[Set_event] = Error_tone;								// ...queue strobe for Neuro Explorer...
	Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue...
	
	trl_end_time = time();											// record the time b/c the trial is now over
	
	Event_fifo[Set_event] = Eot_;									// ...queue strobe... for end of trial
	Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue...
	
	
	spawnwait INFOS();												// ...queue a big ole` pile-o-strobes for plexon
	nexttick 10;													// Give TEMPO a chance to catch its breath before attempting.. 
                                                                    // ...RDX communication with vdosync.
	                                                                // NOTE: if you add a bunch more strobes to INFOS.pro and you...
	                                                                // start getting buffer overflow errors increase the number of nextticks.
	
		if (State == run_search_sess)
		{
		spawnwait SETS_TRL(n_targ_pos,			
					go_weight,				
					stop_weight,        				// see DEFAULT.pro and ALL_VARS.pro for explanations of these globals
					ignore_weight,              
					staircase,                      
					n_SSDs,                         
					min_holdtime,                   
					max_holdtime,                   
					expo_jitter);  
		}	

		
	if(LastStopOutcome != 2)										// quick way to check if last trial was a stop trial
		{
		spawn UPD8_INH(curr_ssd, 									// update the inh graph
				laststopoutcome,
				decide_ssd);
		}
				
																	// Impose the correct intertrial interval and timeout based on user input
	if (fixed_trl_length)											// Did you want a fixed trial length?
		{                                                           
		while(time() < trl_start_time + trial_length + punish_time) // Then figure out how much time has elapsed since trial start...
			{                                                       
			nexttick;                                               // ...and continue to wait until time is up + timeout.
			}                                                       
		}                                                           
	else                                                            // Did you want a fixed intertrial interval?
		{                                                           
		while (time() < trl_end_time + inter_trl_int + punish_time) // Then watch the time since trial end...
			{                                                       
			nexttick;                                               // ...and wait until time is up + timeout.
			}		                                                
		}
	}