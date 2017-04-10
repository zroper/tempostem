//-------------------------------------------------------------------------------------------------------
// 1) Look at the outcome from the last trial
// 2) Roll the dice a few times to mix up reward and punish times if the user asked for it
// 3) Call the appropriate processes to end the trial with the calculated timings
// written by david.c.godlove@vanderbilt.edu 	January, 2011, edited by Zachary J.J. Roper z.roper@vanderbilt.edu	April 10, 2017

#include C:/TEMPO/ProcLib/ABORT.pro
#include C:/TEMPO/ProcLib/SUCCESS.pro
#include C:/TEMPO/ProcLib/FAILURE.pro


declare END_TRL(int trl_outcome);

process END_TRL(int trl_outcome)
	{	
	// Code all possible outcomes (both cmanding and mem guided)
	declare hide int constant no_fix		= 1;		// never attained fixation
	declare hide int constant broke_fix		= 2;		// attained and then lost fixation before target presentation
	declare hide int constant go_wrong		= 3;		// never made saccade on a go trial (cmanding)
	declare hide int constant nogo_correct	= 4;		// successfully canceled trial (cmanding)
	declare hide int constant sacc_out		= 5;		// made an inaccurate saccade out of the target box
	declare hide int constant broke_targ	= 6;		// didn't hold fixation at the target for long enough
	declare hide int constant go_correct	= 7;		// correct saccade on a go trial (cmanding)
	declare hide int constant nogo_wrong	= 8;		// error noncanceled trial 
	declare hide int constant early_sacc	= 9;		// made a saccade before fixation offset
	declare hide int constant no_sacc		= 10;		// didn't make a saccade after cued to do so (mem guided)
	declare hide int constant correct_sacc	= 11;		// correct saccade (mem guided)
	declare hide int constant body_move		= 12;		// error body movement (for training stillness)	
	declare hide int constant anticip_sacc  = 13;
	declare hide int constant too_fast      = 14;		// made a saccade too quickly while in training to slow down
	declare					  now;			

	declare hide float play_the_odds;					// see if subject will randomly be rewarded or punished on this trial and by how much
	
	//declare hide int run_search_sess = 7;
	
	
	play_the_odds = random(10001)/100.0;				// choose medium small or large outcome
	if (play_the_odds <= SmlR_weight)					// the number line is divided by the weights the user chooses
		{
		Reward_duration = Base_Reward_time / 2;			//GLOBAL for use in INFOS.pro
		Success_tone = Success_Tone_smlR;				//GLOBAL for use in INFOS.pro
		}
	else if(play_the_odds > SmlR_weight &&
			play_the_odds < SmlR_weight + MedR_weight)
		{
		Reward_duration = Base_Reward_time;				//GLOBAL for use in INFOS.pro
		Success_tone = Success_Tone_medR;               //GLOBAL for use in INFOS.pro
		}
	else
		{
		Reward_duration = Base_Reward_time * 2;			//GLOBAL for use in INFOS.pro
		Success_tone = Success_Tone_bigR;               //GLOBAL for use in INFOS.pro
		}
	
	
	if (play_the_odds <= SmlP_weight)					// choose medium small or large outcome	
		{                                               // the number line is divided by the weights the user chooses
		Punish_time = Base_Punish_time / 2;				//GLOBAL for use in INFOS.pro
		Failure_tone = Failure_Tone_smlP;               //GLOBAL for use in INFOS.pro
		}
	else if(play_the_odds > SmlP_weight &&
			play_the_odds < SmlP_weight + MedP_weight)
		{
		Punish_time = Base_Punish_time;					//GLOBAL for use in INFOS.pro
		Failure_tone = Failure_Tone_medP;               //GLOBAL for use in INFOS.pro
		}
	else
		{
		Punish_time = Base_Punish_time * 2;				//GLOBAL for use in INFOS.pro
		Failure_tone = Failure_Tone_bigP;               //GLOBAL for use in INFOS.pro
		}
	
	play_the_odds = random(10001)/100.0;				// probability of an outcome reversal
		
	if (Curr_SSD <= SSD_floor)							// this disrupts the reward rate loophole... 
		{												// ...otherwise monks can miss 50% at earliest ssd and...
		Punish_time = Base_Punish_time * 4;				// ...make maximum reward rate.
		}
	else if (Curr_SSD >= SSD_ceil)
		{
		Punish_time = Base_Punish_time / 4;
		}
		
	//----------------------------------------------------------------------------------------------------
	// 1) Aborted trial
	if (	trl_outcome == no_fix 			||			// If the subject failed to initiate the trial properly...
			trl_outcome == broke_fix		||
			trl_outcome == body_move)	
		{
		spawnwait ABORT;								// ...abort the trial (no intertrial interval or punish time).
		}

	//----------------------------------------------------------------------------------------------------
	// 2) Correct trial
	else if (	trl_outcome == go_correct 	||			// If the subject got the trial right...
				trl_outcome == nogo_correct	||
				trl_outcome == correct_sacc	||
				play_the_odds < Bonus_weight)			// ...or if the trial is chosen as a surprise rewarded trial...
		{

				
		if (State == run_search_sess) 
			{
			if (Catch == 0)
				{
				if (TrialTp == 1)
					{
					Rand_Comp_Trl_number = Rand_Comp_Trl_number + 1;	
					}
				else
					{
					Rep_Comp_Trl_number = Rep_Comp_Trl_number + 1;
					}	
				}
			else if(Catch == 1)
				{
				if (TrialTp == 1)
					{
					Rand_Comp_NG_Trl = Rand_Comp_Trl_number + 1;	
					}
				else
					{
					Rep_Comp_NG_Trl = Rep_Comp_Trl_number + 1;
					}	
				}
			}	
		else
			{
			Comp_Trl_number = Comp_Trl_number + 1;			// THIS IS PLACED INCORRECTLY.  IF THE TRIAL WAS CORRECT BUT UNREWARDED THIS WILL NOT COUNT
			}											// DON'T HAVE TIME TO FIX RIGHT NOW
				
			spawnwait SUCCESS(trial_length,					// ...give rewards and wait for the proper iti.
			inter_trl_int,
			trl_start_time,
			fixed_trl_length,
			success_tone,
			tone_duration,
			reward_offset);
		
		}

	//----------------------------------------------------------------------------------------------------
	// 3) Error trial
	else if (	trl_outcome	== go_wrong		||			// If the subject made an error after trial initiation...
				trl_outcome == no_sacc		||
				trl_outcome == sacc_out		||
				trl_outcome == broke_targ	||
				trl_outcome == nogo_wrong	||
				trl_outcome == early_sacc	||
				trl_outcome == anticip_sacc	||
				trl_outcome == too_fast		||
				play_the_odds < Dealer_wins_weight)		// ...or if the trial is chosen as a surprise punished trial...
		{

				
		if (State == run_search_sess) 
			{
			
			if (TrialTp == 1)
				{
					rand_inacc_sacc = rand_inacc_sacc + 1;
				}
			else
				{
					rep_inacc_sacc = rep_inacc_sacc + 1;
				}
			}	
		else
			{
			Comp_Trl_number = Comp_Trl_number + 1;			// THIS IS PLACED INCORRECTLY.  IF THE TRIAL WAS CORRECT BUT UNREWARDED THIS WILL NOT COUNT
			}	
		
		spawnwait FAILURE(trial_length,					// ...give negative reinforcement and wait for iti +  timeout.
				inter_trl_int,
				trl_start_time,
				fixed_trl_length,
				failure_tone,
				punish_time);
						
		
		}
	
	// Calculate accuracy for each type of search trial individually, used to display ACC to user in SCHTRIAL.pro
	RandPerAcc = (Rand_Comp_Trl_number/(Rand_Comp_Trl_number + rand_inacc_sacc))*100;
	RepPerAcc = (Rep_Comp_Trl_number/(Rep_Comp_Trl_number + rep_inacc_sacc))*100;
	//-----------------------------------------------------------------------------------------------------
	// 4) If the animal moved, and we are training stillness, impose a punishment
	while (Move_ct > 0)
		{
		now = time();
		while (time() < now + bmove_tout)
			{
			nexttick;
			}
		Move_ct = Move_ct - 1;
		}
		
	Trl_number = Trl_number + 1;
	
	}