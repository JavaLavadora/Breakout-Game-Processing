import controlP5.*;


/*
------ 1: RANDOM MODE ADDED ---------
 If the toggle is activated then the box 
 postions are completely random they can
 be even on top of each other
*/


ControlP5 cp5, con;
GameState gs;
int w, h;
boolean playing = false;
Button play;
boolean lost = false, won = false;
int finalScore;
Toggle toggRan;

PFont font;

//TO PREVENT FAKE CLICKS ON PLAY BUTTON
int fake = 0;

PShader fragShader;
float t = 0;

void setup(){
  //set the size and renderer to P2D
  size(800, 800, P2D);
  //Call init()
  init();
}

void init(){
  //set w, h, gs, play
  println("Entered init with playing: " + playing);
  w = width;
  h = height;
  
  
  play = playButton();
  
  con = new ControlP5(this);
  toggRan = con.addToggle("toggleRandom")
                      .setPosition(5, 5)
                      .setSize(40, 40)
                      .setColorBackground(#7b7900);
     toggRan.setCaptionLabel("KAOS MODE");     
     
  gs = new GameState(w, h, "walls.jpg", toggRan.getBooleanValue());
  
  font = createFont("Arial", 32);
  textFont(font);
  //Source: http://glslsandbox.com/e#50232.8
  fragShader = loadShader("test.glsl");
}

void draw() {
  //reset background
  background(0);
  //if the game is playing, update and draw, otherwise just draw 
   t+=0.01;
   resetShader();
   fragShader.set("resolution", width, height);
   //fragShader.set("mouse", mouseX/(width*1.0), 1 - mouseY/(height*1.0));
   fragShader.set("time", t);
   filter(fragShader);
  if(playing){
    gs.update();
    if(gs.ball.y > height){
      finalScore = gs.checkWin();
      lost = true;
      playing = false;
      fake = 0;
      init();
    }
    
    if(gs.checkWin() == -1){
      //RESTART
      won = true;
      playing = false;
      fake = 0;
      init();
    }
  }
  else{
    gs.draw();
  }
  //if the ball position exceeds the window height, call init() (to reset)
}

Button playButton(){
  //Create a Button, return it.
  //Use createFont, ControlFont, and setFont 
  //Center the font by subtracting half of the size from the position
  cp5 = new ControlP5(this);
  play = cp5.addButton("toggle")
             .setValue(0)
             .setPosition(width/2 - width/8, height/2)
             .setSize(width/4, height/8)
             .setColorBackground(#7b7900);
   if(won){
     play.setSize(width/2, height/8)
         .setPosition(width/2 - width/4, height/2)
         .getCaptionLabel().setSize(20).set("WINNER WINNER CHICKEN DINNER");
   }       
   else if(lost){
     play.setSize(width/2, height/8)
         .setPosition(width/2 - width/4, height/2)
         .getCaptionLabel().setSize(20).set("YOUR SCORE IS: "+str(finalScore)+". CLICK TO PLAY AGAIN");
   }
   else{
    play.getCaptionLabel().setSize(20).set("PLAY");
   }
   
   
   return play;
}


void toggle(){
  //Flip the value of the boolean
  if(fake > 1){
    playing = !playing;
    lost = false;
    won = false;
    
    //Check toggle
    if(toggRan.getBooleanValue()){
      gs = new GameState(w, h, "walls.jpg", toggRan.getBooleanValue());
      gs.draw();
    }
    
    println("PLAYING IS: " + playing);
    //If the game is playing, hide the button, otherwise show it
    if(playing){
      play.hide();
    }
    else{
      play.show();
    }
    //use the button's hide and show functions
  }
  fake++;
}



void keyPressed(){
  //call the GameState's keyPressed command
  //press 'p' to pause/unpause (via toggle())
  //if(key == '`') saveFrame("screenshots/screenshot-####.png");
  if(keyCode == 80){
    toggle();
  }
  gs.kPressed(keyCode);
}
void keyReleased(){
  //call the GameState's keyReleased command
  gs.kReleased();
}

void showWin(){
   textSize(30);
   fill(0, 102, 153);
   text("WINNER WINNER CHICKEN DINNER", width/2, 80);
}
