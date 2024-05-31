//Exit if there is no player
	if (!instance_exists(oPlayer)) exit;

//Get camera dimensions and store them in _camHeight and _camWidth
	var _camWidth = camera_get_view_width(view_camera[0]);
	var _camHeight = camera_get_view_height(view_camera[0]);

//Get the target coordinates for the camera and store them in _camX and _camY
	//The camera draws itself from the top corner...
	//so to center on the player we subtract half the camera size from the player position.
	var _camX = oPlayer.x - _camWidth/2;
	var _camY = oPlayer.y - _camHeight/2;

//Constrain the Camera to the borders of the room by clamping any values outside
	_camX = clamp(_camX, 0, room_width - _camWidth);
	_camY = clamp(_camY, 0, room_height - _camHeight);

//Set camera coordinate variables
	//To create a smooth camera movement we make the camera move in the direction of it's desired position.
	//We do this by creating storing the difference of the cam's target coords and it's current coords.
	//And then we multiply that difference by our desired cam speed.
	finalCamX += (_camX - finalCamX) * camTrailSpd;
	finalCamY += (_camY - finalCamY) * camTrailSpd;

//set camera coordinates
	camera_set_view_pos(view_camera[0], finalCamX, finalCamY)