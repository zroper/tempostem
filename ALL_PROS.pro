//----------------------------------------------------------------------------
// ALL_PROS.pro is meant to contain all of the protocols run in a particular rig.
// The protocols contained here have been written with the following principles.
// If one expands or changes this protocol, it is recommended that these
// principles continue to be followed to save headaches and poor data collection.
// This requires an additional time commitment on the front end, but the 
// investment will pay dividends on the back end. 
//
// PRINCIPLE 1) MODULARITY
// As much as possible, each process in the ProcLib (Process Library) has been 
// written to stand on its own and function without needing other processes.
// This is good for at least three reasons.  First, processes can be recycled in
// the protocol across multiple tasks minimizing valuable coding space.  Second,
// using these processes as a set of tools, protocols can be developed rapidly.
// Third and most important, modularity allows for unit testing.  All of the 
// processes here have been tested as individual units.
//
// PRINCIPLE 2) VARIABLE SCOPE
// Wherever possible, variables have been kept local in scope.  At first glance,
// this may seem like a big waste of time.  Short protocols are easily written 
// with shared globals (see ACQUIRE.pro), and maintaining local variable scope 
// leads to cumbersome process calls.  However, once a protocol reaches any
// real level of complexity, global variables lead to unstable behavior and 
// untraceable bugs (see cman_f.pro, the predecessor of CMANDING.pro).  By 
// carefully tracking variables and keeping their scope local we can simplify the
// behavior of the task greatly.  Throughout the code...  
// -ALL_CAPS refer to process calls,
// -Capitilized variables refer to Globals,
// -lowercase variables refer to locals.
//
// PRINCIPLE 3) STIMULUS PRECISION
// Drawing on the current viewing screen leads to sloppiness.  If an object is 
// drawn in the middle of the refresh cycle stimulus "tear" can occur, and if 
// stimuli and photodiode marker drawing are initiated in the wrong stage of the
// vertical retrace the photodiode marker may be drawn before the stimulus rather
// than after.  One approach is to use pallete swapping to make stimuli visible 
// or invisible, but this approach is time consuming and the timing is somewhat 
// variable since it reallocates video memory.  The approach used here is to  
// allocate a chunk of video memory to every page which will be viewed on a given 
// trial during the inter-trial interval, and then to use page flipping to present  
// the stimuli with precision and speed.
//
// PRINCIPLE 4) UNIT CONVERSION 
// Many different units may refer to the same measurement at different stages in 
// the task.  For instance, eye position may be dealt with in degrees, voltage, 
// analog card units, or pixels depending on the reference frame.  In the past, 
// the burden of conversion fell to the user and translation code had to deal 
// with this problem post-hoc (see cman_f.pro).  Here, pains have been taken to
// convert eye traces, stimuli, and fixation boxes into a standard reference 
// frame (visual degrees) "under the hood" so that the user is not forced to 
// consult a slide rule every time they want to move the target location.
//
// PRINCIPLE 5) TASK SWITCHING
// while() loops have been used below to pause between tasks and pause at task 
// intitiation so users can select variables.  This allows a user to set up a GUI 
// which will switch gracefully between tasks.  Following this principle saves
// the user from having to start and stop the clock every time a new task is to be 
// run, and keeps the user from making costly mistakes like freezing the solonoid 
// open or failing to close the last trial before saving to plexon and ruining the 
// session.
//
// PRINCIPLE 6) HARDWARE FLEXIBILITY
// The protocol has been designed with a mechanism for switching between recording
// setups in place.  Variables which are necessary for the protocol to work in a 
// particular room have not been hard coded.  Instead, they reside in a file called
// RIGSETUP.pro.  By opening and changing the values of the rig specfic hardware 
// variables in this file, one is able to port ALL_PROS.pro to a new recording
// setup easily.
//
// Written by Zachary J.J. Roper, z.roper@vanderbilt.edu, April 2017

#pragma declare = 1                     // require declarations of all variables

declare IDLE();							// must be declared in top because it is called by other processes below

declare int State;						// The State global variable allows the control structure to run tasks...
										// ...depending on the current stystem state. The beginning state is idling.
declare int OK;							// Starts tasks after setting variables;
declare int Set_monkey;
declare int Monkey;	
declare int Pause;						// Gives user ability to pause task with a button press
declare int Last_task;					// Keeps track of the last task which was run to hold onto default variable values
declare int Event_fifo_N = 1000;		// Length of strobed event buffer
declare int Event_fifo[Event_fifo_N];	// Global first in first out buffer for event codes
declare int Set_event = 0;              // Current index of Event_fifo buffer to set
declare int fix_manual = 1;				//auto fixation task = 1