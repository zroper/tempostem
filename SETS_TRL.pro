//-----------------------------------------------------------------------------------
// process SETS_TRL(int n_targ_pos,
				// float go_weight,
				// float stop_weight,
				// float ignore_weight,
				// int stop_sig_color,
				// int ignore_sig_color,
				// int staircase,
				// int n_SSDs,
				// int min_holdtime,
				// int max_holdtime,
				// int expo_jitter);
// Calculates all variables needed to run a search trial based on user defined
// space.  See DEFAULT.pro and ALL_VARS.pro for an explanation of the global input variables
//
// written by joshua.d.cosman@vanderbilt.edu 	July, 2013, edited by Zachary J.J. Roper z.roper@vanderbilt.edu	April 10, 2017

#include C:/TEMPO/ProcLib/TSCH_PGS.pro						// sets all pgs of video memory up for the impending trial
#include C:/TEMPO/ProcLib/LSCH_PGS.pro						// sets all pgs of video memory up for the impending trial 

#include C:/TEMPO/ProcLib/STAIR.pro							// staircases the SSD based on the last stop trial outcome

declare hide int Curr_target;								// OUTPUT: next trial target
declare hide int Sig_color;									// next signal color (could be either stop or ignore)
declare hide int Trl_type;									// stop, go, or ignore
declare hide int Curr_SSD;									// SSD on next stop or ignore trial
declare hide int Curr_holdtime;								// next trial time between fixation and target onset
declare hide int Decide_SSD;
 

declare SETS_TRL(int n_targ_pos,							// see DEFAULT.pro and ALL_VARS.pro for explanations of these globals
				float go_weight,
				float stop_weight,
				float ignore_weight,
				int staircase,
				int n_SSDs,
				int min_holdtime,
				int max_holdtime,
				int expo_jitter);

process SETS_TRL(int n_targ_pos,							// see DEFAULT.pro and ALL_VARS.pro for explanations of these globals
				float go_weight,
				float stop_weight,
				float ignore_weight,
				int staircase,
				int n_SSDs,
				int min_holdtime,
				int max_holdtime,
				int expo_jitter)
	{
	
	declare hide float decide_trl_type; 	
	declare hide float CatchNum;	
	declare hide float per_jitter, jitter, decide_jitter, holdtime_diff, plac_diff, plac_jitter;
	declare hide int fixation_color 			= 255;			// see SET_CLRS.pro
	declare hide int stop_sig_color 			= 254;			// see SET_CLRS.pro
	declare hide int ignore_sig_color 			= 253;			// see SET_CLRS.pro
	declare hide int constant nogo_correct		= 4;			// code for successfully canceled trial (see CMDTRIAL.pro)
	declare hide int constant go_correct		= 7;			// code for correct saccade on a go trial (see CMDTRIAL.pro)
	declare hide int constant dr1_buff_length 	= 9;			// see Reward_weight_list in DEFAULT.pro
	declare hide float first_buff_value;
	declare hide float next_buff_value;
	
	declare hide int ii;
	
	
	// -----------------------------------------------------------------------------------------------
	// 0) If we are doing 1DR version of cmanding, check to see if we are at the end of a block, and, 
	//    if so, reevaluate weights.  (This works like a ring buffer allowing lots of user flexibility.)
	if (Correct_trls == Trls_per_block)								// if we have completed the number of correct trials needed per block
		{
		first_buff_value = Reward_weight_list[0];				// will end up being last value in buffer
		ii = 0;
		while(ii < dr1_buff_length)								// <, not <= b/c we will handle last value differently
			{
			next_buff_value = Reward_weight_list[ii+1];			// shift all vaulues up in the buffer by one
			Reward_weight_list[ii] = next_buff_value;
			ii = ii+1;
			}
		Reward_weight_list[dr1_buff_length] = first_buff_value;	// make the last buffer value the previous first (ring)
		Block_number = Block_number + 1;						// incriment Block_number for strobing in INFOS.pro
		Correct_trls = 0;										// reset the block counter
		}
	
	// -----------------------------------------------------------------------------------------------
	// 1) Pick a target (But don't pick a new target if the DR1_flag is on and the subject got it wrong)
	if (!DR1_flag ||										// If we are not doing 1DR...
	Trl_Outcome == nogo_correct ||							// ...or if we are doing 1DR but the last trial was correct...
	Trl_Outcome == go_correct)								// ...or correct in another way, then...
		{
		Curr_target = random(n_targ_pos);					// pick a new target.
		}													// 	COULD WEIGHT THIS IF NEED BE (see logic below)

	// -----------------------------------------------------------------------------------------------
	// 2) Pick a trial type
															// Pick a number and then assess user defined weights to see what type of trial will be presented.
	decide_trl_type = (1.0 + random(9999)) / 100.0;			// random number from 1-100
															// Think of the if statement below as a number line with user defined divisions (weights).
	if (decide_trl_type <= go_weight)						// If we are on the left of the number line...
		{
		Trl_type = Go_Trl;									// ...its a go trial.
		}
	else if (decide_trl_type > go_weight 
			&& decide_trl_type <= go_weight + stop_weight)	// If we are in the middle of the number line...
		{
		Trl_type  = Stop_Trl;								// ...it is a stop trial, and...
		Sig_color = stop_sig_color;							// ...the signal color will reflect this fact.
		}
	else													// Else we must be on the right of the number line.
		{													// NOTE: based on user input, ignore trials may not... 
		Trl_type  = Ignore_Trl;								// ...exist and the number line may not have anything... 
		Sig_color = ignore_sig_color;						// ...to the right of stop_weights.  (Same holds for...
		}													// ...stop trials above.
		
	if (Classic)											// We are emulating the old stop signal task
		{
		Sig_color = Fixation_Color;							// the stop signal is just the fixation point coming back on.
		}
	


	
	// -----------------------------------------------------------------------------------------------
	// 3) Set up catch trial based on Perc_catch parameter in DEFAULT.pro
	

	CatchNum = random(100);
	if (CatchNum > Perc_catch)
		{
		Catch = 0;
		}
	else	
		{
		Catch = 1;
		} 
	
	// -----------------------------------------------------------------------------------------------
	// 4) Set up all vdosync pages for the upcoming trial using globals defined by user and setc_trl
	
 	if(TargetType == 1)
		{ 
		spawnwait LSCH_PGS(curr_target,							// set above
				fixation_size, 								// see DEFAULT.pro and ALL_VARS.pro
				fixation_color, 							// see SET_CLRS.pro
				sig_color, 									// see DEFAULT.pro and ALL_VARS.pro
				scr_width, 									// see RIGSETUP.pro
				scr_height, 								// see RIGSETUP.pro
				pd_left, 									// see RIGSETUP.pro
				pd_bottom, 									// see RIGSETUP.pro
				pd_size,									// see RIGSETUP.pro
				deg2pix_X,									// see SET_COOR.pro
				deg2pix_Y,									// see SET_COOR.pro
				unit2pix_X,									// see SET_COOR.pro
				unit2pix_Y,									// see SET_COOR.pro
				object_targ);								// see GRAPHS.pro	
		}			
	else if(TargetType == 2)
		{
		spawnwait TSCH_PGS(curr_target,							// set above
				fixation_size, 								// see DEFAULT.pro and ALL_VARS.pro
				fixation_color, 							// see SET_CLRS.pro
				sig_color, 									// see DEFAULT.pro and ALL_VARS.pro
				scr_width, 									// see RIGSETUP.pro
				scr_height, 								// see RIGSETUP.pro
				pd_left, 									// see RIGSETUP.pro
				pd_bottom, 									// see RIGSETUP.pro
				pd_size,									// see RIGSETUP.pro
				deg2pix_X,									// see SET_COOR.pro
				deg2pix_Y,									// see SET_COOR.pro
				unit2pix_X,									// see SET_COOR.pro
				unit2pix_Y,									// see SET_COOR.pro
				object_targ);								// see GRAPHS.pro	
		} 		

	// -----------------------------------------------------------------------------------------------
	// 5) Set Up Target and Fixation Windows and plot them on animated graphs
	spawnwait WINDOWS(curr_target,							// see above
				fix_win_size,								// see DEFAULT.pro and ALL_VARS.pro
				targ_win_size,								// see DEFAULT.pro and ALL_VARS.pro
				object_fixwin,								// animated graph object
				object_targwin,								// animated graph object
				deg2pix_X,									// see SET_COOR.pro
	            deg2pix_Y);                                 // see SET_COOR.pro
		
	// -----------------------------------------------------------------------------------------------
	// 6) Select current holdtime
	
	holdtime_diff 	= max_holdtime - min_holdtime;			// Min and Max holdtime defined in DEFAULT.pro
	per_jitter 		= random(1001) / 1000.0;				// random number 0-100 (percentages)	
	jitter 			= holdtime_diff * per_jitter;			// multiply range of holdtime differences by percentage above
	
	Curr_holdtime 	= round(min_holdtime + jitter);			// gives randomly jittered holdtime between min and max holdtime 
	//Curr_holdtime 	= 500;
	
	// -----------------------------------------------------------------------------------------------
	// 7) Select current fixation offset SOA
	
		//per_jitter = random(7);  //returns random number between 0 and n-1
		//search_fix_time = SOA_list[per_jitter];
		
	// -----------------------------------------------------------------------------------------------
	// 8) Set placeholder duration
	
	plac_diff 		= max_plactime - min_plactime;			// Min and Max holdtime defined in DEFAULT.pro
	plac_jitter 	= plac_diff * per_jitter;			// multiply range of holdtime differences by percentage above
	
	plac_duration 	= round(min_plactime + plac_jitter);			// gives randomly jittered holdtime between min and max holdtime 

		
	}
	
	
	