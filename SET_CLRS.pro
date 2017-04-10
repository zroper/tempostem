// This sets all of the colors up which will be needed for the protocol based on user input
// specified elsewhere
//
// written by david.c.godlove@vanderbilt.edu 	January, 2011, edited by Zachary J.J. Roper z.roper@vanderbilt.edu	April 10, 2017

declare SET_CLRS(n_targ_pos);

process SET_CLRS(n_targ_pos)
	{
	declare hide int color_num,r_, g_, b_;
	r_ = 0; g_ = 1; b_ = 2;
	
	color_num = 0;
		
	while (color_num <=  n_targ_pos)				// set each target color to the matching color number 
		{
		dsendf("cm %d %d %d %d;\n",
						color_num + 1,				// 0 remains black
						Color_list[color_num,r_],	// GLOBAL ALERT; Color_list is an array so it cannot be passed
						Color_list[color_num,g_],
						Color_list[color_num,b_]);
		color_num = color_num + 1;
		nexttick;									// if we have a large number of targets we don't want to overflow the buffer
		}
		
		/*if (expo_jitter_soa == 0) 
		{
		Fixation_color[r_]		= 0;
		Fixation_color[g_]		= 36;
		Fixation_color[b_]		= 0;
		}
		else if (expo_jitter_soa == 1)
		{
		Fixation_color[r_]		= 0;
		Fixation_color[g_]		= 0;
		Fixation_color[b_]		= 59;
		}
		*/
		
	dsendf("cm 255 %d %d %d;\n",					// set the color of the fixation point to 255 (leaves room for many target colors)
						Fixation_color[r_],			// GLOBAL ALERT; Fixation_color is an array so it cannot be passed
	                    Fixation_color[g_],
						Fixation_color[b_]);
	
	dsendf("cm 254 %d %d %d;\n",					// set the color of the fixation point to 255 (leaves room for many target colors)
						Stop_sig_color[r_],			// GLOBAL ALERT; Fixation_color is an array so it cannot be passed
	                    Stop_sig_color[g_],
						Stop_sig_color[b_]);
	
	dsendf("cm 253 %d %d %d;\n",					// set the color of the fixation point to 255 (leaves room for many target colors)
						Ignore_sig_color[r_],		// GLOBAL ALERT; Fixation_color is an array so it cannot be passed
	                    Ignore_sig_color[g_],
						Ignore_sig_color[b_]);
						
	dsendf("cm 252 %d %d %d;\n",					// set the color of the fixation point to 255 (leaves room for many target colors)
						Mask_sig_color[r_],		// GLOBAL ALERT; Fixation_color is an array so it cannot be passed
	                    Mask_sig_color[g_],
						Mask_sig_color[b_]);
	}