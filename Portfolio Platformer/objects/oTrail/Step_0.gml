//Each frame oTrail becomes more transparent.
image_alpha -= 0.1;
//and when it it is no longer visible it destroys itself.
if (image_alpha <= 0) instance_destroy();