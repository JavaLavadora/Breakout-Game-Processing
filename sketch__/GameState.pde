class GameState {
  //create a PShader (fragment shader) and PImage (texture)
  //SHADER IS ON MAIN. Otherwise it wouldn't run
  PImage tex;
  //create some helper variables (s,w,h). 
  float s, w, h;
  //time variable
  float time;
  //Declare a: Ball, Paddle, Box[] walls, and Box[] level
  Ball ball;
  Paddle pad;
  Box[] walls;
  Box[] level;
  
  int numBoxes = 44;
  boolean randomBox; 
  
  GameState(int w_, int h_, String texture, boolean ran){
    //set variables
    w = w_;
    h = h_;
   
    tex = loadImage(texture);
    randomBox = ran;
    //create ball, paddle, walls, level
    ball = new Ball(w/2, h-90, 25);
    PVector padd_pos = new PVector(w/2, h+60);
    pad = new Paddle(padd_pos, 200);
    walls = new Box[3];
    level = new Box[numBoxes];
    level0();
  }

  Box[] level0(){
    
   println("RANDOM IS: "+ randomBox);
  
   float rx, ry;
    if(randomBox){
      for(int i = 0; i < numBoxes; i++){
         rx = random(90, 640);
         ry = random(100, height - 300);
        level[i] = new Box(rx, ry, rx + 50, ry + 50, false, tex);
      }
      
    }
    else{
      //Create a grid of boxes
      int x1 = 90, x2 = 140, y1 = 100, y2 = 150;
      int offVert = 0;
      int offHor = 0;
      for(int i = 0; i< numBoxes; i++){
        if(i % 11 == 0){ //New line of boxes
          x1 = 90;
          x2 = 140;
          y1 = 100;
          y2 = 150;
          offVert = offVert + 60;
          offHor = 0;
        }
        x1 = x1 + 5;
        x2 = x2 + 5;
        level[i] = new Box(x1 + offHor * 50, y1 + offVert, x2 + offHor * 50, y2 + offVert, false, tex);
  
        offHor++;
      }
    }
    return level;
  }

  void update(){
    //update ball and paddle, call collisions, increase time, and draw
    ball.update();
    pad.update(ball);
    collisions();
    time++;
    draw();
  }
  
  void collisions(){
    //collide walls, levels, and ball-paddle
    ball.collide_box(walls[0]);
    ball.collide_box(walls[1]);
    ball.collide_box(walls[2]);
    
    ballBoxCollisions(level);
    
    ball.collide_circle(pad);
  }
  
  void draw(){
    //draw shader, draw boxes
    makeWalls(tex);
    boxArrDraw(level);
  }
  
  Box[] makeWalls(PImage img){
    //Make 3 boxes (left, top, right) as walls
    noStroke();
    walls[0] = new Box(0, 0, 50, h, true, img);
    walls[0].draw(img);
    walls[1] = new Box(50, 0, w-50, 50, true, img);
    walls[1].draw(img);
    walls[2] = new Box(w-50, 0, w, h, true, img);
    walls[2].draw(img);
    
    return walls;
  }
  

  void ballBoxCollisions(Box[] boxes){
    //collide for each in an array of boxes
    for(int i = 0; i< numBoxes; i++){
      ball.collide_box(boxes[i]);
    }
  }

  void boxArrDraw(Box[] boxes){
    //draw for each in an array of boxes
    for(int i = 0; i < numBoxes; i++){
      if(boxes[i].isAlive){
        boxes[i].draw(tex);
      }
    }
  }
  
  int checkWin(){
    //if there aren't any boxes left, print "You Win"
    //otherwise print the current score
    if(!hasAlive(level)){ //WINNER WINNER CHICKEN DINNER  
      return -1;
    }
    else{
      textSize(40);
      fill(0, 102, 153);
      text("score: " + str((int)(ball.score)), 10 * width/16, 90); 
      fill(255);
      return (int)ball.score;
    }
  }
  
  boolean hasAlive(Box[] boxes){
    //Check to see if the level has a box left
    for(int i = 0; i < numBoxes; i++){
      if(boxes[i].isAlive){
        return true;
      }
    }
    return false;
  }
  
  void kPressed(int value){
    //call the paddle's keyPressed command
    pad.movePressed(value);
  }
  void kReleased(){
    //call the paddle's keyReleased command
    pad.moveReleased();
  }
}
