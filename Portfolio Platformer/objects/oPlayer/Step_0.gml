//Control Inputs

//Directional Inputs
	//Picks up inputs from WASD and directional keys on keyboard, as well as a gamepad's D-pad and horizontal joystick inputs. (ONLY TESTED WITH PLAYSTATION CONTROLLER)
	rightKey = keyboard_check(ord("D")) + keyboard_check(vk_right) + gamepad_button_check(4, gp_padr) + (gamepad_axis_value(4, gp_axislh) > 0.5);
		rightKey = clamp(rightKey, 0, 1);
	leftKey = keyboard_check(ord("A")) + keyboard_check(vk_left) + gamepad_button_check(4, gp_padl) + (gamepad_axis_value(4, gp_axislh) < -0.5);
		leftKey = clamp(leftKey, 0, 1);
	upKey = keyboard_check(ord("W")) + keyboard_check(vk_up);
		upKey = clamp(upKey, 0, 1);
	downKey = keyboard_check(ord("S")) + keyboard_check(vk_down);
		downKey = clamp(downKey, 0, 1);
	
//ACTION INPUTS

//Jump

	//These three variables form the basis for a 3 frame timer that will be used to buffer the input window for jumps.
	//The number of frames the buffer will last
	jumpBufferTime = 3;
	//The variable that will decrement each frame, forming a timer
	jumpKeyBufferTimer = 0;
	//The variable that will be set to 1 while the input is being buffered.
	jumpKeyBuffered = 0;

	//Detects ONLY the first frame that the jump button is pressed.
	jumpKeyPressed = keyboard_check_pressed(vk_space) + gamepad_button_check_pressed(4, gp_face1);
		jumpKeyPressed = clamp(jumpKeyPressed, 0, 1);
	//Detects when the jump button is pressed or held. This will be used for variable jump height.
	jumpKey = keyboard_check(vk_space) + gamepad_button_check(4, gp_face1);
		jumpKey = clamp(jumpKey, 0, 1);

	//Jump Key Buffering
	//This code will turn the single frame that jumpKeyPressed returns true for a wider input window.
	if (jumpKeyPressed)
	{
		//if the jump key is pressed, set the timer length.
		jumpKeyBufferTimer = jumpBufferTime;
	}
	if (jumpKeyBufferTimer > 0)
	{
		//if the timer length is set... 
		//set jumpKeyBuffered to true and decrement the timer count each frame until it hits 0.
		jumpKeyBuffered = 1;
		jumpKeyBufferTimer--;
	} else {
		jumpKeyBuffered = 0;
	}

//Dash
	dashKey = keyboard_check_pressed(vk_shift) + gamepad_button_check_pressed(4, gp_shoulderr);




//Resart game if you fall out the bottom of the room
if (y > room_height) game_restart();


state();