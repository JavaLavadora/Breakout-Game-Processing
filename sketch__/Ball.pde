PShader ballShader;

class Ball {
  //Declare position, velocity, diameter, speed, score
  float x, y, d, speed, score;
  PVector v;
  
  Ball(float x_, float y_, float d_){
    //Initialize position, velocity, diameter, speed
    x = x_;
    y = y_;
    d = d_;
    v = new PVector(-1, -1);
    speed = 6;
    //Source http://glslsandbox.com/e#49798.0
    ballShader = loadShader("ball.glsl"); 
  }
  
  void update(){
    //update the position
    x = x + v.x * speed;
    y = y + v.y * speed;
    draw();
  }
  
  void collide_circle(Paddle pad){
    
    
    if(paddleCollision(pad)){
      //Calculate the reflection vector R where n is the normal
      PVector normal = new PVector((x - pad.p.x), (y - pad.p.y));
      normal.normalize();
      
      float dot = v.dot(normal);
            
      PVector reflection = new PVector(v.x - 2*normal.x*dot, v.y - 2*normal.y*dot);
      
      PVector paddleArea = reflection;
      
      //The while is used to prevent the ball from getting suck inside the paddle
      //Otherwise in many cases the result angle was unpredictable
      while(paddleCollision(pad)){
        x = x + paddleArea.x;
        y = y + paddleArea.y;
    
      }
      
      v.x = reflection.x;
      if(reflection.y < 0){
        v.y = reflection.y;
      }
      else{
        v.y = -reflection.y;
      }

    }
  }

  void collide_box(Box b){
    PVector newPos;
    if(b.isAlive){
      newPos = new PVector(x + v.x, y + v.y);


      float DeltaX = x - max(b.tlx, min(x, b.tlx + b.w));
      float DeltaY = y - max(b.tly, min(y, b.tly + b.h));
      
      boolean collides = false;

      if((DeltaX * DeltaX + DeltaY * DeltaY) < (d/2 * d/2)){
        collides = true;
      }
  
      if(collides){

        if(!b.isWall){
          //If it's not a wall, make it not alive, increase score
          b.isAlive = false;
          score++;
        }

        //HORIZONTAL COLLISION
        if((newPos.y > b.tly) && (newPos.y < b.tly + b.h)){ 
          v.x = v.x * -1;          
        }
        else{ //In some cases the center coordinate does not collide but the external part of the circle does
          if(v.y > 0){ //GOING DOWN
            if(newPos.y - d/2 < b.tly + b.h && !((newPos.x > b.tlx) && (newPos.x < b.tlx + b.w))){ //
              v.x = v.x * -1;
            }
          }
          else{ //GOING UP
            if(newPos.y + d/2 > b.tly && !((newPos.x > b.tlx) && (newPos.x < b.tlx + b.w))){ 
              v.x = v.x * -1;
            }
          }
        }
        
        //VERTICAL COLLISION
        if((newPos.x > b.tlx) && (newPos.x < b.tlx + b.w)){ 
          //If it's on the top or bottom, flip the y velocity
          v.y = v.y * -1; 
        }
        else{ //In some cases the center coordinate does not collide but the external part of the circle does
          if(v.x > 0){ //GOING RIGHT
            if(newPos.x - d/2 < b.tlx + b.w && !((newPos.y > b.tly) && (newPos.y < b.tly + b.h))){
              v.y = v.y * -1; 
            }
          }
          else{ //GOING LEFT
            if(newPos.x + d/2 > b.tlx && !((newPos.y > b.tly) && (newPos.y < b.tly + b.h))){
              v.y = v.y * -1; 
            }
          }
        }
 
      }      
    
    }

  }
  
  void draw (){
    //draw an ellipse, or draw with the shader via GameState
    stroke(0);
    ballShader.set("resolution", d/2, d/2);
    ballShader.set("time", t);
    shader(ballShader);
    ellipse(x, y, d, d);
    resetShader();
  }
  
  
  boolean paddleCollision(Paddle pad){
    //Check that the distance between the centers 
    //  is less than the sum of the radii.
    float distX = x - pad.p.x;
    distX = distX * distX;
    
    float distY = y - pad.p.y;
    distY = distY * distY;
    
    float dist = sqrt(distX + distY);
    
    if(dist < (d/2 + pad.d/2)){
      return true;
    }
    
    return false;
  }
  
}
