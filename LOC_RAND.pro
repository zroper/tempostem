//--------------------------------------------------------------------------------------------
// This code selects RANDOM array locations 
// 
//
// written by joshua.d.cosman@vanderbilt.edu 	July, 2013, edited by Zachary J.J. Roper z.roper@vanderbilt.edu	April 10, 2017


//declare hide int 	pos_jitter = 10;   //  1-15 pixels position jitter 
declare hide int	numAngles = 12;
declare hide int	numEcc = 12;
declare hide 		TgAng;

//move to ALLVARS.pro
	declare Rand_targ_angle;
	declare Rand_d1_angle;
	declare Rand_d2_angle;
	declare Rand_d3_angle;
	declare Rand_d4_angle;
	declare Rand_d5_angle;
	declare Rand_d6_angle;
	declare Rand_d7_angle;
	declare Rand_d8_angle;
	declare Rand_d9_angle;
	declare Rand_d10_angle;
	declare Rand_d11_angle;

	declare Rand_targ_ecc;
	declare Rand_d1_ecc;
	declare Rand_d2_ecc;
	declare Rand_d3_ecc;
	declare Rand_d4_ecc;
	declare Rand_d5_ecc;
	declare Rand_d6_ecc;
	declare Rand_d7_ecc;
	declare Rand_d8_ecc;
	declare Rand_d9_ecc;
	declare Rand_d10_ecc;
	declare Rand_d11_ecc;	


declare RandomizeRAngles();
declare RandomizeREccentricities();

declare LOC_RAND();


process RandomizeRAngles() 
	{
	
	int	i, j, temp;
	i = 0;
	while (i < numAngles)			//Run loop while i < total # items in locX array
		{
		j = random(numAngles) ; 			//randomly select one of six positions in X location array
		temp = Ang_list[i];			//stick one of the other locations in temp
		Ang_list[i] = Ang_list[j];
		Ang_list[j] = temp;
		i = i + 1;
		}
	}	

process RandomizeREccentricities()	
	{
	
	int	i, j, temp;
	i = 0;
	while (i < numEcc)			//Run loop while i < total # items in locX array
		{
		j = random(numEcc); 			//randomly select one of six positions in X location array
		temp = Ecc_list[i];			//stick one of the other locations in temp
		Ecc_list[i] = Ecc_list[j];
		Ecc_list[j] = temp;
		i = i + 1;
		}
	}	


// The processes below use the shuffled arrays, and select values from those arrays to produce either trial by trial coordinates 
// in random arrays) or experiment-wide trial coordinates (for repeated arrays, selected at beginning of trial).


process LOC_RAND
	{

 	spawn RandomizeRAngles;                         // Runs RandomizeRAngles
    waitforprocess RandomizeRAngles;                // Waits for it to finish
	
	spawn RandomizeREccentricities;                         // Runs RandomizeREccentricities
    waitforprocess RandomizeREccentricities;                // Waits for it to finish
	
	 
	// use a for loop to state determine that if (Ang_list[X] = Rand_targ_angle 
	// that gets selected AT THE BEGINNING OF THE SESSION, switch it to location Ang_list[setsize - 1]. would have to 
	// add a thirteenth location for this to work with setsize twelve, this would allow me to select locations for targets in the random session without acceindetal overlap between targets and later 'random' distractors
	
	//Random Array Angles
	
	if (Train == 1)
		{	
 		if (TargTrainSet == 1)
			{
			TgAng = Random(8);
			
	 		if (TgAng == 0)
				{
				Rand_targ_angle = Angle_list[0];      
				Rand_d1_angle = Angle_list[1];	//See DEFAULT.pros for setting each of these variables
				Rand_d2_angle = Angle_list[2];
				Rand_d3_angle = Angle_list[3]; 
				Rand_d4_angle = Angle_list[4];	//See DEFAULT.pros for setting each of these variables
				Rand_d5_angle = Angle_list[5];
				Rand_d6_angle = Angle_list[6]; 
				Rand_d7_angle = Angle_list[7]; 
				}
			else if (TgAng == 1)
				{
				Rand_targ_angle = Angle_list[1];      
				Rand_d1_angle = Angle_list[2];	//See DEFAULT.pros for setting each of these variables
				Rand_d2_angle = Angle_list[3];
				Rand_d3_angle = Angle_list[4];
				Rand_d4_angle = Angle_list[5];	//See DEFAULT.pros for setting each of these variables
				Rand_d5_angle = Angle_list[6];
				Rand_d6_angle = Angle_list[7]; 
				Rand_d7_angle = Angle_list[0]; 	
				}
			else if (TgAng == 2)
				{
				Rand_targ_angle = Angle_list[2];      
				Rand_d1_angle = Angle_list[3];	//See DEFAULT.pros for setting each of these variables
				Rand_d2_angle = Angle_list[4];
				Rand_d3_angle = Angle_list[5]; 
				Rand_d4_angle = Angle_list[6];	//See DEFAULT.pros for setting each of these variables
				Rand_d5_angle = Angle_list[7];
				Rand_d6_angle = Angle_list[0]; 
				Rand_d7_angle = Angle_list[1]; 
				}
			else if (TgAng == 3)
				{
				Rand_targ_angle = Angle_list[3];      
				Rand_d1_angle = Angle_list[4];	//See DEFAULT.pros for setting each of these variables
				Rand_d2_angle = Angle_list[5];
				Rand_d3_angle = Angle_list[6];
				Rand_d4_angle = Angle_list[7];	//See DEFAULT.pros for setting each of these variables
				Rand_d5_angle = Angle_list[0];
				Rand_d6_angle = Angle_list[1]; 
				Rand_d7_angle = Angle_list[2]; 				
				} 
			
// Target angles for other 4 training locations, to give all 8 in one session
			else if (TgAng == 4)
				{
				Rand_targ_angle = Angle_list[4];      
				Rand_d1_angle = Angle_list[5];	//See DEFAULT.pros for setting each of these variables
				Rand_d2_angle = Angle_list[6];
				Rand_d3_angle = Angle_list[7]; 
				Rand_d4_angle = Angle_list[0];	//See DEFAULT.pros for setting each of these variables
				Rand_d5_angle = Angle_list[1];
				Rand_d6_angle = Angle_list[2]; 
				Rand_d7_angle = Angle_list[3]; 
				}
			else if (TgAng == 5)
				{
				Rand_targ_angle = Angle_list[5];      
				Rand_d1_angle = Angle_list[6];	//See DEFAULT.pros for setting each of these variables
				Rand_d2_angle = Angle_list[7];
				Rand_d3_angle = Angle_list[0];
				Rand_d4_angle = Angle_list[1];	//See DEFAULT.pros for setting each of these variables
				Rand_d5_angle = Angle_list[2];
				Rand_d6_angle = Angle_list[3]; 
				Rand_d7_angle = Angle_list[4]; 	
				}
			else if (TgAng == 6)
				{
				Rand_targ_angle = Angle_list[6];      
				Rand_d1_angle = Angle_list[7];	//See DEFAULT.pros for setting each of these variables
				Rand_d2_angle = Angle_list[0];
				Rand_d3_angle = Angle_list[1]; 
				Rand_d4_angle = Angle_list[2];	//See DEFAULT.pros for setting each of these variables
				Rand_d5_angle = Angle_list[3];
				Rand_d6_angle = Angle_list[4]; 
				Rand_d7_angle = Angle_list[5]; 
				}
			else if (TgAng == 7)
				{
				Rand_targ_angle = Angle_list[7];      
				Rand_d1_angle = Angle_list[0];	//See DEFAULT.pros for setting each of these variables
				Rand_d2_angle = Angle_list[1];
				Rand_d3_angle = Angle_list[2];
				Rand_d4_angle = Angle_list[3];	//See DEFAULT.pros for setting each of these variables
				Rand_d5_angle = Angle_list[4];
				Rand_d6_angle = Angle_list[5]; 
				Rand_d7_angle = Angle_list[6]; 				
				} 						
			}
			
		else if (TargTrainSet == 2)
			{
			Rand_targ_angle = Angle_list[0];      
			Rand_d1_angle = Angle_list[1];	//See DEFAULT.pros for setting each of these variables
			Rand_d2_angle = Angle_list[2];
			Rand_d3_angle = Angle_list[3];
			Rand_d4_angle = Angle_list[4];
			Rand_d5_angle = Angle_list[5];
			Rand_d6_angle = Angle_list[6];
			Rand_d7_angle = Angle_list[7];
			}
		else if (TargTrainSet == 3)
			{
			Rand_targ_angle = Angle_list[1];      
			Rand_d1_angle = Angle_list[2];	//See DEFAULT.pros for setting each of these variables
			Rand_d2_angle = Angle_list[3];
			Rand_d3_angle = Angle_list[4];
			Rand_d4_angle = Angle_list[5];
			Rand_d5_angle = Angle_list[6];
			Rand_d6_angle = Angle_list[7];
			Rand_d7_angle = Angle_list[0];
			}
		else if (TargTrainSet == 4)
			{
			Rand_targ_angle = Angle_list[2];      
			Rand_d1_angle = Angle_list[3];	//See DEFAULT.pros for setting each of these variables
			Rand_d2_angle = Angle_list[4];
			Rand_d3_angle = Angle_list[5];
			Rand_d4_angle = Angle_list[6];
			Rand_d5_angle = Angle_list[7];
			Rand_d6_angle = Angle_list[0];
			Rand_d7_angle = Angle_list[1];
			}
		else if (TargTrainSet == 5)
			{
			Rand_targ_angle = Angle_list[3];      
			Rand_d1_angle = Angle_list[4];	//See DEFAULT.pros for setting each of these variables
			Rand_d2_angle = Angle_list[5];
			Rand_d3_angle = Angle_list[6];
			Rand_d4_angle = Angle_list[7];
			Rand_d5_angle = Angle_list[0];
			Rand_d6_angle = Angle_list[1];
			Rand_d7_angle = Angle_list[2];
			}
		else if (TargTrainSet == 6)
			{
			Rand_targ_angle = Angle_list[4];      
			Rand_d1_angle = Angle_list[5];	//See DEFAULT.pros for setting each of these variables
			Rand_d2_angle = Angle_list[6];
			Rand_d3_angle = Angle_list[7]; 
			Rand_d4_angle = Angle_list[0];	//See DEFAULT.pros for setting each of these variables
			Rand_d5_angle = Angle_list[1];
			Rand_d6_angle = Angle_list[2]; 
			Rand_d7_angle = Angle_list[3]; 			
			}
		else if (TargTrainSet == 7)
			{
			Rand_targ_angle = Angle_list[5];      
			Rand_d1_angle = Angle_list[6];	//See DEFAULT.pros for setting each of these variables
			Rand_d2_angle = Angle_list[7];
			Rand_d3_angle = Angle_list[0];
			Rand_d4_angle = Angle_list[1];	//See DEFAULT.pros for setting each of these variables
			Rand_d5_angle = Angle_list[2];
			Rand_d6_angle = Angle_list[3]; 
			Rand_d7_angle = Angle_list[4]; 				
			}
		else if (TargTrainSet == 8)
			{
			Rand_targ_angle = Angle_list[6];      
			Rand_d1_angle = Angle_list[7];	//See DEFAULT.pros for setting each of these variables
			Rand_d2_angle = Angle_list[0];
			Rand_d3_angle = Angle_list[1]; 
			Rand_d4_angle = Angle_list[2];	//See DEFAULT.pros for setting each of these variables
			Rand_d5_angle = Angle_list[3];
			Rand_d6_angle = Angle_list[4]; 
			Rand_d7_angle = Angle_list[5]; 			
			}
		else if (TargTrainSet == 9)
			{
			Rand_targ_angle = Angle_list[7];      
			Rand_d1_angle = Angle_list[0];	//See DEFAULT.pros for setting each of these variables
			Rand_d2_angle = Angle_list[1];
			Rand_d3_angle = Angle_list[2];
			Rand_d4_angle = Angle_list[3];	//See DEFAULT.pros for setting each of these variables
			Rand_d5_angle = Angle_list[4];
			Rand_d6_angle = Angle_list[5]; 
			Rand_d7_angle = Angle_list[6]; 				
			}
		
		
		Rand_targ_ecc = SearchEcc;	//Sets fixed eccentricity for all training items. See DEFAULT.pros for setting each of these variables
		Rand_d1_ecc = SearchEcc;
		Rand_d2_ecc = SearchEcc;
		Rand_d3_ecc = SearchEcc;
		Rand_d4_ecc = SearchEcc;
		Rand_d5_ecc = SearchEcc;
		Rand_d6_ecc = SearchEcc;
		Rand_d7_ecc = SearchEcc;

		}
	else
		{
		Rand_targ_angle = Ang_list[0];					// Set random target/distractor locations each trial
		Rand_d1_angle = Ang_list[1];
		Rand_d2_angle = Ang_list[2];
		Rand_d3_angle = Ang_list[3];
		Rand_d4_angle = Ang_list[4];
		Rand_d5_angle = Ang_list[5];
		Rand_d6_angle = Ang_list[6];
		Rand_d7_angle = Ang_list[7];
		Rand_d8_angle = Ang_list[8];
		Rand_d9_angle = Ang_list[9];
		Rand_d10_angle = Ang_list[10];
		Rand_d11_angle = Ang_list[11];
		
		//Random Array Eccentricities
		Rand_targ_ecc = Ecc_List[0];
		Rand_d1_ecc = Ecc_List[1];
		Rand_d2_ecc = Ecc_List[2];
		Rand_d3_ecc = Ecc_List[3];
		Rand_d4_ecc = Ecc_List[4];
		Rand_d5_ecc = Ecc_List[5];
		Rand_d6_ecc = Ecc_List[6];
		Rand_d7_ecc = Ecc_List[7];
		Rand_d8_ecc = Ecc_List[8];
		Rand_d9_ecc = Ecc_List[9];
		Rand_d10_ecc = Ecc_List[10];
		Rand_d11_ecc = Ecc_List[11];
		}
	}