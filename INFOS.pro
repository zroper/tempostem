// This file is responsilbe for sending TTL codes for the various task parameters.
//
// NOTES:
// 1) The order of these params is very important.  Matlab translation code identifies these parameters based on their
// order, so if you add more events, make sure to keep them in the same order in the matlab translation code.  (
// 2) This process relies heavily on globals (since it is grabbing stuff from all over the protocol).
//
// written by Zachary J.J. Roper z.roper@vanderbilt.edu 	April 06, 2017

declare int fixation_color_r, fixation_color_g, fixation_color_b;
declare int target_color_r, target_color_g, target_color_b;
declare int fixation_color_r, fixation_color_g, fixation_color_b;
declare int target_color_r, target_color_g, target_color_b;

declare INFOS();

	process INFOS()
			{
			if (State == run_search_sess)
			{
				Event_fifo[Set_event] = StartInfos_;								// Let Matlab know that trial infos are going to start streaming in...
				Set_event = (Set_event + 1) % Event_fifo_N;							// ...incriment event queue.
					
				//---------------------------------------------------------------------------------------------------------------------------------------
					
					Event_fifo[Set_event] = InfosZero + 999;						// 4000'set a strobe to identify the start of Search Vars (4000) not specfic to search and...	
					Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
					
					Event_fifo[Set_event] = ArrStruct + 4001;						// Set a strobe to identify the type of search (typical vs. contextual cue) and...	
					Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
					
					Event_fifo[Set_event] = SearchType + 4050;						// Set a strobe to identify the type of search (homo, hetero, etc.) and...	
					Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
					
					Event_fifo[Set_event] = SingMode + 4060;						// Set a strobe to tell us if we should expect a singleton distractor 
					Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue
					
					Event_fifo[Set_event] = SetSize + 4100;							// Set a strobe to identify Set Size and...	
					Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event
					
					Event_fifo[Set_event] = TargetType + 4150;						// Set a strobe to identify the identity of the target and...	
					Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event
				
					Event_fifo[Set_event] = TrialTp + 4200;							// Set a strobe to identify Trial Type (random vs repeated displays) (set in SEL_LOCS)	
					Set_event = (Set_event + 1) % Event_fifo_N;	
					
					Event_fifo[Set_event] = SearchEcc + 4250;						// Set a strobe to identify Trial Type (random vs repeated displays) (set in SEL_LOCS)	
					Set_event = (Set_event + 1) % Event_fifo_N;	
					
					Event_fifo[Set_event] = DistPres + 4300;								// Set a strobe to identify Singleton presence (set in LOC_RAND)	
					Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event
					
					Event_fifo[Set_event] = THemi + 4350;									// Set a strobe to identify the target hemifield (set in LOC_RAND)	
					Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event
					
					Event_fifo[Set_event] = DHemi + 4400;									// Set a strobe to identify the distractor hemifield (set in LOC_RAND)	
					Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event
					
					Event_fifo[Set_event] = Rand_targ_angle + 5000;					// Set a strobe to identify actual target location	
					Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event
					
					Event_fifo[Set_event] = Rand_d1_angle + 5500;					// Set a strobe to identify actual distractor location	
					Set_event = (Set_event + 1) % Event_fifo_N;	
					
					Event_fifo[Set_event] = CatchCode + 3800;						// Set a strobe to identify catch trials	
					Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event 
					
					Event_fifo[Set_event] = SingCol + 4650;							// Send event and... 
					Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue
					
					Event_fifo[Set_event] = DistOrt + 4660;							// Send event and... 
					Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue
					
					Event_fifo[Set_event] = TargOrt + 4670;							// Send event and... 
					Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queu
					
					Event_fifo[Set_event] = PercSingTrl + 4700;						// Send event and... 
					Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue
					
					Event_fifo[Set_event] = Perc_catch + 4800;						// Send event and... 
					Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue
					
					Event_fifo[Set_event] = Block_number + 4900;					// Send event and... 
					Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue
									
					Event_fifo[Set_event] = Curr_soa + 6000;						// Send event and... 
					Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue
									
					Event_fifo[Set_event] = InfosZero + Trl_Outcome;				// Send event and...	
					Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
							
					Event_fifo[Set_event] = InfosZero + Max_sacc_duration;			// Send event and...	
					Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
							
					Event_fifo[Set_event] = InfosZero + Max_saccade_time;			// Send event and...	
					Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
							
					Event_fifo[Set_event] = InfosZero + Punish_time;				// Send event and...	
					Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
							
					Event_fifo[Set_event] = InfosZero + Reward_Duration;			// Send event and...	
					Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
							
					Event_fifo[Set_event] = InfosZero + Reward_Offset;				// Send event and...	
					Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
							
					Event_fifo[Set_event] = InfosZero + Targ_hold_time;				// Send event and...	
					Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
							
					Event_fifo[Set_event] = InfosZero + Tone_Duration;				// Send event and...	
					Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
							
					Event_fifo[Set_event] = InfosZero + (X_Gain * 100) + 1000;		// Send event and...	
					Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
						
					Event_fifo[Set_event] = InfosZero + (X_Offset * 100) + 1000;	// Send event and...	
					Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
							
					Event_fifo[Set_event] = InfosZero + (Y_Gain * 100) + 1000;		// Send event and...	
					Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
						
					Event_fifo[Set_event] = InfosZero + (Y_Offset * 100) + 1000;	// Send event and...	
					Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.

				   // Event_fifo[Set_event] = DistFix + 4680;							// Send event and... 
					// Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queu

				    Event_fifo[Set_event] = ProbCue + 4690;							// Send event and... 
					Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queu
					
				    Event_fifo[Set_event] = ProbSide + 4790;							// Send event and... 
					Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queu		

				  //  Event_fifo[Set_event] = StimTm + 5100;							// Send event and... 
					//Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queu						
				//---------------------------------------------------------------------------------------------------------------------------------------
					
				Event_fifo[Set_event] = EndInfos_;									// Let Matlab know that trial infos are finished streaming in...
				Set_event = (Set_event + 1) % Event_fifo_N;							// ...incriment event queue.	
				
				}
			}	