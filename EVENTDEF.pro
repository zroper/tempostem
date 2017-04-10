// These codes are the numbers they are for historic reasons.
// Many are not currently being used and could be discarded.
// This is hold over garbage from the bad old days.
//
// written by david.c.godlove@vanderbilt.edu 	January, 2011, edited by Zachary J.J. Roper z.roper@vanderbilt.edu	April 10, 2017

declare hide constant FixSpotOn_		= 2301;
declare hide constant Fixate_			= 2660;
declare hide constant PlacOn_			= 2320;
declare hide constant Target_			= 2651; //Must Check to be sure.
declare hide constant FixSpotOff_		= 2300;
declare hide constant StopSignal_		= 2653;
declare hide constant TrialStart_		= 1666;
declare hide constant FixError_			= 2750; //Must Check to be sure.
declare hide constant GoSaccade_		= 2751; //Must Check to be sure.
declare hide constant GoError_			= 2752; //Must Check to be sure.
declare hide constant NOGOWrong_		= 2753; //Must Check to be sure.
declare hide constant GoTargFixError_	= 2754; //Must Check to be sure.
declare hide constant Abort_ 			= 2620;
declare hide constant Correct_ 			= 2600;
declare hide constant GOCorrect_ 		= 2755;
declare hide constant NOGOCorrect_ 		= 2756;
declare hide constant Reward_ 			= 2727;
declare hide constant Tone_				= 2001;
declare hide constant Error_tone		= 776;  //Strobe for Neuro Explorer
declare hide constant Reward_tone		= 777;	//Strobe for Neuro Explorer
declare hide constant Error_sacc		= 887;  //Strobe for Neuro Explorer
declare hide constant Correct_sacc		= 888;	//Strobe for Neuro Explorer
//Note that reward SIZE is being sent after this as it's own strobe
declare hide constant ExtraReward_ 		= 2777;
//Note that reward SIZE is being sent after this as it's own pulse
declare hide constant SoundOnReward_ 	= 2778;
declare hide constant SoundNoReward_ 	= 2779;
declare hide constant Eot_ 				= 1667;
declare hide constant CmanHeader_ 		= 1501;
declare hide constant MemHeader_		= 1502;
declare hide constant GONOGOHeader_		= 1503;
declare hide constant DelayedHeader_    = 1504;
declare hide constant SearchHeader_     = 1507;
declare hide constant Identify_Room_	= 1500;
declare hide constant Stimulation_ 		= 666;
//Note that this is followed by a 1 or a 2 if MultElectrodeStimFlag is set depending on the stim channel
declare hide constant ZeroEyePosition_ 	= 2302;
declare hide constant VSyncSynced_		= 999; //This is a bit weird.  Looks like we are waiting to hear back from videosync that all commands are out of buffer?
declare hide constant Saccade_ 			= 2810;
//Note followed by another TTL == 2820 + trials[1] (looks like it classifies trial type)
declare hide constant Decide_ 			= 2811;
declare hide constant MouthBegin_ 		= 2655;
declare hide constant MouthEnd_ 		= 2656;
declare hide constant MapHeader_ 		= 1503;
declare hide constant FixWindow_ 		= 2770;
declare hide constant TargetWindow_		= 2771;

/* MUST CHECK ALL THAT FOLLOWS IN TRANSLATED VARIABLES (MY VERSION DIED WITHOUT NETWORK) */
declare hide constant Staircase_ 		= 2772;
declare hide constant Neg2Reinforcement_= 2773; //?????
declare hide constant Feedback_ 		= 2774; //????? 
declare hide constant RewardSize_ 		= 2927;
declare hide constant TrialInBlock 		= 2928;
// declare hide constant SendStimInfo_ 	= 7000; // MUST CHANGE. TOO BIG
declare hide constant SendPenatrInfo_ 	= 2929;
declare hide constant TargetPre_ 		= 2650; //?????
declare hide constant StopOn_ 			= 2654; //?????
declare hide constant StimFailed_ 		= 667;

declare hide constant StartInfos_		= 2998;
declare hide constant EndInfos_			= 2999;
declare hide float 	  InfosZero			= 3000.0;

/*  DEPRICATED, SEE 3 VARIABLES ABOVE
//Infos_ variables (all actual strobed flags follow event codes)
	declare hide constant NPOS_ 		= 2721; // next strobe == # of possible target positions
	declare hide constant Pos_ 			= 2722; // next strobe == curr target position
	//Note that 1DR curr rewarded target is sent in raw form
	declare hide constant SOUND_ 		= 2723; //Accoustic Stop Sig (needs better naming convention in future)
	//Note that a flag for central or peripheral stop signal presentation is sent in raw form
	declare hide constant ISNOTNOGO_ 	= 2724; // next strobe == flag indicating an aborted(?) stimulated stop trial
	declare hide constant BIG_REWARD_ 	= 2725; // strobe follows
	declare hide constant TRIG_CHANGE_ 	= 2726;
	declare hide constant REWARD_RATIO_ = 2728;
	declare hide constant NOGO_RATIO_ 	= 2729;
	declare hide constant ISNOGO_ 		= 2730;
	declare hide constant STOP_ZAP_ 	= 2731;
	declare hide constant STIM_DUR_ 	= 2732;
	declare hide constant EXP_HOLDTIME_ = 2733;
	declare hide constant HOLDTIME_ 	= 2734; // Named incorrectly should be GAP_
	declare hide constant HOLD_JITTER_ 	= 2735; // Named incorrectly should be GAP_JITTER_
	declare hide constant MAX_RESP_TIME_= 2736;
	declare hide constant SOA_ 			= 2737; //Named incorrectly should be SSD
	declare hide constant MAX_SOA_ 		= 2738; //Named incorrectly see above
	declare hide constant MIN_SOA_ 		= 2739; //Named incorrectly see above
	declare hide constant SOA_STEP_ 	= 2740; //Named incorrectly see above
*/


