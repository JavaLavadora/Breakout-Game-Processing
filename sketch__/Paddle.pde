class Paddle {
  //position vector
  PVector p;
  PShader paddShader;
  //diameter
  float d, t = 0;
  //flags for moving left or right
  boolean right = false, left = false, nothingPressed = true;
  //set the speed
  float speed = 10;
  //set the yoffset
  float yoffset = width/2;
  
  
  Paddle(PVector p_, float d_){
    //Set the initial position and diameter
    p = p_;
    d = d_;
    //Source http://glslsandbox.com/e#49740.11
    paddShader = loadShader("paddle.glsl");
  }
  void update(Ball b){ //Maybe call collision with circle on ball
    //If the flag is set, update that direction
    if(right || left){
      move();
    }
    draw();
  }
  
  float move(){
    //return the change in x based off of movement flags
    if(right){
      p.x = p.x + speed;
      if(p.x > width){
        p.x = width;
      }
    }
    if(left){
      p.x = p.x - speed;
      if(p.x < 0){
        p.x = 0;
      }
    }
    return p.x;
  }

  boolean moveable(Ball b){
    //Check that the distance between the centers 
    //  is less than the sum of the radii.
    float distX = b.x - p.x;
    distX = distX * distX;
    
    float distY = b.y - p.y;
    distY = distY * distY;
    
    float dist = sqrt(distX + distY);
    
    if(dist < (b.d/2 + d/2)){
      return false;
    }
    else{
      return true;
    }
  }


  void draw(){
    t++;
    //Draw an arc using the CHORD parameter from theta past PI to theta shy of 2*PI
    //fill(255);
    arc(p.x, p.y, d, d, PI, 2*PI, CHORD);
    //Add the radius to the y position and subtract the y offset.
    //p.y = p.y + d/2 - yoffset;
    paddShader.set("resolution", d/2, d/2);
    paddShader.set("time", t);
    shader(paddShader);
    ellipse(p.x, p.y, d,d);
    resetShader();
  }
  
  
  void movePressed(int valueKey){
    //Set movement 'key' flags to true
    if(valueKey == RIGHT && nothingPressed){ //M value, right
     // println("RIGHT");
      left = false;
      right = true;
      nothingPressed = false;
    }
    if(valueKey == LEFT && nothingPressed){ //N value, left
      //println("LEFT");
      right = false;
      left = true;
      nothingPressed = false;
    }
  }
  void moveReleased(){
    //Set movement 'key' flags to false
    left = false;
    right = false;
    nothingPressed = true;
  }
}
