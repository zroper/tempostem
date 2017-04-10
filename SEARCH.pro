//--------------------------------------------------------------------------------------------------
//This is the main search protocol.  It works like this.
// 1) Define all varialbes
// 2) Setup variables needed for a trial
// and start loop
// 3) Run a trial
// 4) End the trial
// 		a) deliver rewards and punishments
//		b) take care of ITI
// 		c) set up variables for next run
//
// written by joshua.d.cosman@vanderbilt.edu 	July, 2013, edited by Zachary J.J. Roper z.roper@vanderbilt.edu	April 10, 2017
	
	
declare SEARCH();						

process SEARCH()     
	{
	declare hide int run_search_sess = 7;
	declare hide int run_idle		 = 0;
			
	Trl_number				= 1;
	Rand_Comp_Trl_number	= 0;
	Rep_Comp_Trl_number		= 0;
	Block_number			= 1;
	rand_inacc_sacc 		= 0;
	rep_inacc_sacc			= 0;
	RandPerAcc				= 0;
	RepPerAcc				= 0;
	Correct_trls 			= 0;
	
	if (Last_task != run_search_sess)			// Only do this if we have gone into another task or if this is first run of day.
		{
		system("dialog Select_Monkey");
		spawnwait DEFAULT(State,				// Set all globals to their default values.
						Monkey,					
						Room);				
		Last_task = run_search_sess;
		}
		
	dsend("DM RFRSH");                			// This code sets up a vdosync macro definition to wait a specified ...
	if (Room == 23)                   			// ...number of vertical retraces based on the room in which we are    ...
		{                             			// ...recording.  This kluge is necessary because vdosync operates     ...
		dsendf("vw %d:\n",1);         			// ...differently in the different rooms.  In 028 a command to wait    ...
		}                             			// ...2 refresh cycles usually only waits for one and a command to     ...
	else                              			// ...wait for 1 usually only waits for 0.  Room 029 and 023 appear to ...
		{                             			// ...work properly.
		dsendf("vw %d:\n",2);
		}
	dsend("EM RFRSH");
	
	
	
	while(!OK)									
		{
		nexttick;
		if(Set_monkey)
			{
			spawnwait DEFAULT(State,			// Set all globals to their default values for a particular monkey.
						Monkey,						
						Room);	
			Set_monkey = 0;
			}
		}
	
	//spawnwait GOODVARS(State);
	
	spawnwait SET_SCH();						// sets up search RT graph
					
	spawnwait SET_CLRS(n_targ_pos);             // calls SET_CLRS.pro, which sets all colors for all tasks based on input
	
	if (!Train)
		{
		spawnwait REP_ORT;							// sets repeated orientations once at beginning of task
		spawnwait LOC_REP;							// sets repeated locations once outside the trial loop at the beginning of task
		}
		
	spawnwait SETS_TRL(n_targ_pos,				// Select variables for the first search...
				go_weight,						// ...trial.  This happens once outside of the while...
				stop_weight,					// ...loop just to set up for the first iteration. After...
				ignore_weight,					// ...that SETC_TRL.pro will be called by END_TRL.pro.
				staircase,
				n_SSDs,
				min_holdtime,
                max_holdtime,
				expo_jitter);

				
	Event_fifo[Set_event] = SearchHeader_;		// Set a strobe to identify this file as a Cmanding session and...	
	Set_event = (Set_event + 1) % Event_fifo_N;	// ...incriment event queue.
	Event_fifo[Set_event] = Identify_Room_;		// Set a strobe to identify this file as a Cmanding session and...	
	Set_event = (Set_event + 1) % Event_fifo_N;	// ...incriment event queue.
	Event_fifo[Set_event] = Room;				// Set a strobe to identify this file as a Cmanding session and...	
	Set_event = (Set_event + 1) % Event_fifo_N;	// ...incriment event queue.
	Event_fifo[Set_event] = SearchType;				// Set a strobe to identify this file as a Cmanding session and...	
	Set_event = (Set_event + 1) % Event_fifo_N;	// ...incriment event queue.
	Event_fifo[Set_event] = SetSize;				// Set a strobe to identify this file as a Cmanding session and...	
	Set_event = (Set_event + 1) % Event_fifo_N;	// ...incriment even
	Event_fifo[Set_event] = TargetType;				// Set a strobe to identify this file as a Cmanding session and...	
	Set_event = (Set_event + 1) % Event_fifo_N;	// ...incriment even
	
	nexttick 10;								// to prevent buffer overflows after task reentry.
	
	CheckMotion = 1;							// set global for watching the motion detector
	spawn WATCHMTH;								// start watching the mouth motion detector if present
	spawn WATCHBOD;								// start watching motion detector for body if present
	
	while (state == run_search_sess)				// while the user has not yet terminated the countermanding task
		{
		 
		 //Pre-trial business
		 spawnwait RAND_ORT;						// sets orientations of random stimuli
		 spawnwait LOC_RAND;						 // sets random locations at the beginning of each new trial
		 
		 spawnwait SEL_LOCS;						// selects locations to be used on the current trial
		 
		 //Spawn the trial
		 spawnwait SCHTRIAL(allowed_fix_time, 	// run a trial with variables defined in SETC_TRL.pro
							curr_holdtime, 
							trl_type, 
							max_saccade_time, 
							curr_ssd, 
							cancl_time, 
							max_sacc_duration, 
							targ_hold_time,
							object_fix);		
		
		spawnwait END_TRL(trl_outcome);			// end a trial with trl_outcome set in SEARCH.pro

		nexttick 5;								// wait at least five cycles and do it all again
		
		while(Pause)							// gives the user the ability to pause the task without ending it
			{
			nexttick;
			}
		
		}

												// the State global variables allow a control structure...
												// ...to impliment the task.
	State = run_idle;							// If we are out of the while loop the user wanted...
												// ...to stop cmanding.
	CheckMotion = 0;							// stop watching for motion detector.
												
	oDestroy(object_fixwin);					// destroy all task graph objects
	oDestroy(object_targwin);
	oDestroy(object_fix);
	oDestroy(object_targ);
	oDestroy(object_eye);
	
	oSetGraph(gleft,aCLEAR);					// clear the left graph
	
	oDestroy(object_repeat);						// destroy all RT graph objects
	oDestroy(object_random);						

	
	oSetGraph(gleft,aCLEAR);					// clear the right graph
		
	spawn IDLE;									// return control to IDLE.pro
    
	}