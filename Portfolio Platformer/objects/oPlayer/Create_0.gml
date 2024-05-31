//Movement
moveDir = 0;//The direction of movement, -1 is left, 1 is right.
moveSpd = 2;
xspd = 0;//Current speed on x axis
yspd = 0;//Current speed on y axis


//Jumping
grav = 0.3//Gravity
termVel = 6;//Terminal velocity
jspd = -4;//Jump speed (Negative because the y-axis points downwards in GMS)


jumpMax = 2;//Maximum amount of jumps you can make, set to 2 to allow for a double jump
jumpCount = 0;//Counter Variable that increments when you jump
jumpHoldTimer = 0;//A timer variable to limit the length of time the jump button can be held while affecting jump height
//The amount of frames that jumpHoldTimer will last. Made into an array to lower frame count after the first jump.
	jumpHoldFrames[1] = 10;//first array entry gives largest amount of hold time for first jump
	jumpHoldFrames[2] = 5;//second array entry gives smaller amount of hold time for midair jumps
onGround = true;//Whether or not you are on the ground, resets certain variables when true


//Dashing
canDash = false;
dashDir = 1;
dashDistance = 48;
dashTime = 15
resistCoefficient = 0.2;
xMomentum = 0;
xResistance = 0;


//Sprite Manipulation
xCurrentScale = image_xscale; //current player x-axis scale



//These sections of code are the state machine for oPlayer
freeState = function()
{
//dashState setup
{
	if (moveDir != 0) {dashDir = moveDir;};
	if (onGround) {canDash = true;};
	if (canDash) && (dashKey)
	{
		canDash = false;
		dashSpeed = dashDistance/dashTime;
		dashEnergy = dashDistance;
		state = dashState;
	}
}
//X Movement
{
	//Direction
		moveDir = rightKey - leftKey;
		//Update Sprite Direction based on current movement
		if (moveDir != 0) {image_xscale = xCurrentScale * moveDir;}
	
	//Calculate Loss of Momentum, will decrement by xResistance each frame while it doesn't equal 0
	if (abs(xMomentum) != 0)
	{
		xMomentum -= xResistance;
	}
	if (xMomentum == 0)
	{
		xMomentum = 0;
		
	}

	//Get xspd by multiplying the movement direction by your movespeed and adding momentum, which already has a direction applied.
	xspd = (moveDir * moveSpd) + xMomentum;

	//X Collision
		//We initialize a variable called _subPixel
		var _subPixel = .5;
		//our basic collision if statement, if the player will hit a wall on the next frame, set speed to 0.
		if place_meeting(x + xspd, y, oWall)
		{
			//HOWEVER, this creates an issue. with the code as it stands, the player may collide before they even hit the wall.
			//So, we then create a variable that applies a direction to subPixel and stores it
			var _pixelCheck = _subPixel * sign(xspd);
			//and while the player isn't less than half a pixel away from the wall...
			while !place_meeting(x + _pixelCheck, y, oWall)
			{
				//we move the player closer to the wall, scooching them right up against it.
				x += _pixelCheck;
			}

			//Set xspd to zero to "collide"
			xspd = 0;
			xMomentum = 0;
		}

	//Move
	x += xspd;
}

//Y Movement
{
	//Gravity
		yspd += grav;
		//Cap Fall Speed at Terminal Velocity
		if (yspd > termVel) {yspd = termVel;};
	
	//reset jump count when on the ground
		if (onGround)
		{
			jumpCount = 0;
			jumpHoldTimer = 0;
		} else {
			if (jumpCount == 0) {jumpCount = 1;};
		}
	
	//Jump
		if (jumpKeyBuffered) && (jumpCount < jumpMax)
		{
			//Resetting the Buffer
			jumpKeyBuffered = false;
			jumpKeyBufferTimer = 0;
		
			//increment the jump count
			jumpCount++;
		
			//Set the jump hold timer
			jumpHoldTimer = jumpHoldFrames[jumpCount];
		}
		//Cut off the jump by releasing the jump button
		if (!jumpKey)
		{
			jumpHoldTimer = 0;
		}
		//Jump based on timer/holding the button
		if (jumpHoldTimer > 0)
		{
			//constantly set the yspd to jump speed while holding the jump key
			yspd = jspd;
			//count down the timer
			jumpHoldTimer--;
		}
	
	
	//Y Collision
		var _subPixel = .5;
		if place_meeting(x, y + yspd, oWall)
		{
			//Scoot up to the wall
			var _pixelCheck = _subPixel * sign(yspd);
			while !place_meeting(x, y + _pixelCheck, oWall)
			{
				y += _pixelCheck;
			}
		
			//Set yspd to 0 for collision
			yspd = 0;
		}
	
	//Set if the object is on the ground
		if yspd >= 0 && place_meeting(x, y+1, oWall)
		{
			onGround = true;
		} else {
			onGround = false;
		}
	
	
	//Move
	y += yspd;
}	
}
dashState = function()
{
	//Reset Jump timer
	jumpHoldTimer = 0;
	
	
	//Move via Dash
	xspd = dashSpeed * dashDir;
	
	//Trail Effect
		//This works by creating a new instance of oTrail just below oPlayer each frame and modifying it with the following parameters
		with (instance_create_depth(x, y, depth+1, oTrail))
		{
			sprite_index = other.sprite_index;
			image_blend = c_fuchsia;
			image_alpha = 0.7;
		}
	//Collide and Move
	//X Collision
		var _subPixel = .5;
		if place_meeting(x + xspd, y, oWall)
		{
			//Scoot right up to the wall
			var _pixelCheck = _subPixel * sign(xspd);
			while !place_meeting(x + _pixelCheck, y, oWall)
			{
				x += _pixelCheck;
			}

			//Set xspd to zero to "collide"
			xMomentum = 0;
			xspd = 0;
		}

	//Move
	x += xspd;
	
	//Ending the State
	dashEnergy -= dashSpeed;
	if (dashEnergy <= 0)
	{
		//we exit the dash state;
		state = freeState;
		//set vertical speed to 0 to negate any interupted dashes
		yspd = 0;
		//and then we set our momentum and resistances. so we don't just stop dead after moving quickly.
		xMomentum = 3 * dashDir;
		xResistance = resistCoefficient * dashDir;
	}
	
}

state = freeState;