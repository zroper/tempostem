//--------------------------------------------------------------------------------------------------------------------------
// declare SUCCESS(int trial_length,						
				// int inter_trl_int,
				// int trl_start_time,
				// int fixed_trl_length,
				// int success_tone,
				// int tone_duration,
				// int reward_offset,
				// int reward_duration);
// Give primary and secondary reinforcement, set up the variables 
// for the next trial, send all trial event codes to plexon, and 
// impose the correct inter trial interval.
//
// written by david.c.godlove@vanderbilt.edu 	January, 2011, edited by Zachary J.J. Roper z.roper@vanderbilt.edu	April 10, 2017

#include C:/TEMPO/ProcLib/JUICE.pro

declare SUCCESS(int trial_length,						// see DEFAULT.pro and ALL_VARS.pro for explanations of these globals
				int inter_trl_int,
				int trl_start_time,
				int fixed_trl_length,
				int success_tone,
				int tone_duration,
				int reward_offset);

process SUCCESS(int trial_length,						// see DEFAULT.pro and ALL_VARS.pro for explanations of these globals
				int inter_trl_int,
				int trl_start_time,
				int fixed_trl_length,
				int success_tone,
				int tone_duration,
				int reward_offset)
	{
	declare hide int trl_end_time, tone_time;	

	declare hide int run_cmd_sess = 1;					// state 1 is countermanding
	declare hide int run_mg_sess = 3;					// state 3 is mem guided sacc
	declare hide int run_gonogo_sess = 4;
	declare hide int run_delayed_sess = 6;
	declare hide int run_search_sess = 7;
	
	declare float	 reward_weight = 1.0;				// for 1DR
	
	
	//
	declare hide float decidejuice;
	declare hide float juice_jitter;
	declare hide int 	go_trl 		= 0;
	declare hide int 	stop_trl 	= 1;
	declare hide int 	ignore_trl 	= 2;
	
	
	spawn TONE(success_tone,tone_duration);				// give the secondary reinforcer tone
	tone_time = time();									// record the time
	
	Event_fifo[Set_event] = Tone_;						// ...queue strobe...
	Set_event = (Set_event + 1) % Event_fifo_N;			// ...incriment event queue...
	
	Event_fifo[Set_event] = Reward_tone;				// ...queue strobe for Neuro Explorer...
	Set_event = (Set_event + 1) % Event_fifo_N;			// ...incriment event queue...
	
	while (time() < tone_time + reward_offset)			// wait until it is OK to give reward
		{		
		nexttick;										// wait for it... wait for it...
		}
		
	
	reward_weight = Reward_weight_list[Curr_target];	// GLOBAL ALERT
	Reward_duration = Reward_duration * Reward_weight;	// for setting up 1DR.
	
	// if (Exp_juice && State == run_mg_sess)
	// {
		// if (trl_type == go_trl)
		// {
			// decidejuice = floor((900 - ReactionTime)/10);
			juice_jitter = exp(-1.0*(decidejuice/0.25));	
			reward_weight = Reward_weight_list[Curr_target];	// GLOBAL ALERT
			
			// Reward_duration = floor((decidejuice * decidejuice) / 100);
			// Reward_duration = (Reward_duration * Reward_weight);
			// printf("            Reward_duration = %d\n",Reward_duration);	// ...debugging...
		// }
		// else if (trl_type == stop_trl)
		// {
			// Reward_duration = 20 + (per_soa_jitter * 10);
			// printf("            Reward_duration = %d\n",Reward_duration);
		// }

	// }
	
	spawn JUICE(juice_channel,reward_duration);			// YEAH BABY!  THAT'S WHAT IT'S ALL ABOUT!
	trl_end_time = time();								// record the time b/c this is the end of the trial events
	
	Event_fifo[Set_event] = Reward_;					// ...queue strobe...
	Set_event = (Set_event + 1) % Event_fifo_N;			// ...incriment event queue...
	
	Event_fifo[Set_event] = Eot_;						// ...queue strobe...
	Set_event = (Set_event + 1) % Event_fifo_N;			// ...incriment event queue...	
	
	
	spawnwait INFOS();									// ...queue a big ole` pile-o-strobes for plexon
	nexttick 10;										// Give TEMPO a chance to catch its breath before attempting.. 
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
		
	if(State == run_search_sess)
		{
		spawn UPD8_SCH();
		}
														// Impose the correct intertrial interval based on user input
	if (fixed_trl_length)								// Did you want a fixed trial length?
		{
		while(time() < trl_start_time + trial_length)	// Then figure out how much time has elapsed since trial start...
			{
			nexttick;									// ...and continue to wait until time is up.
			}
		}
	else												// Did you want a fixed intertrial interval?
		{
		while (time() < trl_end_time + inter_trl_int)	// Then watch the time since trial end...
			{
			nexttick;									// ...and wait until time is up.
			}		
		}
	}