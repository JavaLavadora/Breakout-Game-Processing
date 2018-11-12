class Box {
 //top left corner
 float tlx, tly;
 //width and height
 float w, h;
 //bools for alive and wall
 boolean isAlive, isWall;
 //vector for image's source location
 PImage img;
 
 Box(float x1, float y1, float x2, float y2, boolean wall_, PImage pimg){
   //Set the vectors for the top right, and the width and height
   tlx = x1;
   tly = y1;
   w = x2 - x1;
   h = y2 - y1;
   //Set the wall boolean
   isWall = wall_;
   isAlive = true;
   //Set the src x and y positions from the pimage
   img = pimg;
   //Make sure to subtract the pimg's width and height to stay within the image
 }


 void draw(PImage pimg){
   //If it's alive, draw the rect
   if(isAlive){
     //Draw a box
     //Use copy to crop part of the pimage
     image(pimg, 0, 0, w, h);
     copy(0, 0, 50, 50, (int)tlx, (int)tly, (int)w, (int)h);
     stroke(255);
     noFill();
     rect(tlx, tly, w, h);
   

   }
 }
 
}
