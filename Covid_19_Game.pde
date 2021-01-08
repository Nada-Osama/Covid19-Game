
PImage background;
PImage finish[];
PImage end;
boolean isStartPage = false;
Ball[] balls = new Ball[50];
ArrayList<Line> lines   = new ArrayList(); 
float coX[], coY[];
int fallingspeedY=7;
float t=0;
int x=100;
int y=100;
int xspeed=5;
int yspeed=5;
int healthy=0;
int cured=0;
int deadballs=0;

void setup() {
  size(900, 700);
  textSize(20);
  surface.setTitle("Coronavirus Game");
  background = loadImage("coronavirus.jpg");
  for (int i=0; i< balls.length; i++) {
    balls[i] = new Ball(random(width), random(height));
  }
  finish = new PImage[2];
  end = loadImage("sterilization4.jpg");
  //finish[0] = loadImage("hygiene.png");
  finish[1] = loadImage("surgical-mask.png");
  coX = new float[80];
  coY = new float[80];
  for (int i=0; i<80; i++) {
    coX[i] = 30*i;
    coY[i] = random(0, 1000);
  }
}

void draw()
{
  if (isStartPage == false)
    start_Page();
  else if (isStartPage == true)
  {
    //game started
    background(255);
    for (int i=0; i< lines.size(); i++) {
      lines.get(i).move();
      if (dist(mouseX, mouseY, lines.get(i).x, lines.get(i).y)<70 && keyPressed && key == ' ') {
        lines.remove(i);
        i--;
      }
    }
    for (int i=0; i<balls.length; i++) {
      balls[i].move();
      for (int j=0; j<balls.length; j++) {
        float d=dist(balls[i].x, balls[i].y, balls[j].x, balls[j].y);
        if (d<20 && i!= j) {
          if (balls[i].inf && !balls[j].inf && round(random(50))==1) {
            balls[j].inf=true;
          }
        }
        if (d<20 && i!= j) {
          if (balls[j].inf && !balls[i].inf && round(random(50))==1) {
            balls[i].inf=true;
          }
        }
      }
    }
    push();
    strokeWeight(30);
    if (mousePressed) { 
      lines.add(new Line(mouseX, mouseY, pmouseX, pmouseY));
    }
    pop();
    healthy=0;
    cured=0;
    deadballs=0;
    for (int i=0; i< balls.length; i++) {
      if (balls[i].healthy) {
        healthy++;
      }
      if (balls[i].dead) {
        deadballs++;
      }
      if (healthy+deadballs == balls.length) {
        background(255);
        display();
      }
    }
  }
}

/////////////////////////////////////////////////////
void start_Page()
{
  image(background, 0, 0, width, height);
  push();
  fill(255);
  //fill(0);
  text("Healthy \nInfected \nRecovered \nDead", width-170, 55);
  noStroke();
  fill(0, 255, 0);
  ellipse(width-200, 50, 20, 20);
  fill(255, 0, 0);
  ellipse(width-200, 80, 20, 20); //height+30 of the above ball
  fill(255, 255, 0);
  ellipse(width-200, 110, 20, 20);
  fill(0);
  ellipse(width-200, 140, 20, 20);
  pop();
  fill(255);
  text(" Rules: \n Draw lines to isolate the infected. \n Spacebar to erase lines.", 50, 50);
  push();
  fill(255);
  noStroke();
  rect(80, 150, 200, 200);
  fill(0, 255, 0);
  ellipse(120, 250, 20, 20);
  fill(255, 0, 0);
  ellipse(240, 250, 20, 20);
  pop();
  fill(0);
  strokeWeight(8);
  line(180, 150, 180, frameCount%(200)+150);
  //start button
  push();
  noStroke();
  fill(0);
  ellipse(width/2, height-200, 150, 100);
  fill(255);
  textSize(40);
  text("Start", width/2 -40, height-190);
  pop();
  if (mouseX > (width/2)-75 && mouseX < (width/2)+75 && mouseY > height-250 && mouseY < height-150 && mousePressed)
    isStartPage = true;
}

/////////////////////////////////////////////////////
void display() {
  push();
  background(255);
  image(end, 100, 100, width-200, height-100);
  fill(0);
  textSize(70);
  text("DONE!!  ALL IS CLEAN", 120, height-600);
  for (int i=0; i<80; i++) {
    image(finish[1], coX[i], coY[i], 70, 70);
    if (coY[i] > height) {
      coY[i] = 0;
    }
  }
  for (int i=0; i<80; i++) {
    coY[i] += fallingspeedY;
  }
  pop();
  //restart button
  push();
  noStroke();
  fill(0);
  ellipse(width-175, height-280, 150, 100);
  fill(255);
  textSize(30);
  text("Re-Start", width-230, height-270);
  if (mouseX > width-250 && mouseX < width-100 && mouseY > height-330 && mouseY < height-230 && mousePressed)
    isStartPage = false;
  pop();
  //exit button
  push();
  noStroke();
  fill(0);
  ellipse(width-175, height-150, 150, 100);
  fill(255);
  textSize(30);
  text("Exit", width-200, height-140);
  pop();
  if (mouseX > width-250 && mouseX < width-100 && mouseY > height-200 && mouseY < height-100 && mousePressed)
    exit();
}

/////////////////////////////////////////////////////

class Ball {
  float x; // x_coordiante 
  float y; // y_coordinate
  int time_to_recover=round(random(1000, 3000)); // this variable is initialized ith some random number and if the ball is infected this counter decreased each time draw is called until reach zero and ball is cured and turned yellow
  boolean dead=false;  // if ball dead it turn to black and do not move
  boolean movee=true; // check if ball move or stop
  boolean inf = (round(random(0, 5))==1) ? true : false;  // check if ball infected or not
  int die =round(random(20)); // initialize die variable randomly
  boolean healthy=true;
  float speedx = random(-1, 1);  // speed in x_direction
  float speedy = random(-1, 1); // spead in y_direction
  Ball(float xx, float yy) {
    x = xx;
    y = yy;
  }
  void move() {
    push();
    // check if balls collide with black line , then apply bouncing   
    if (get(int(x)+5, int(y)+5) == color(0, 0, 0)) {  
      speedx  *= -1;
      speedy  *= -1;
    }
    //  check boundry of screen to change direction
    if ((x > width) || (x < 0)) { 
      speedx  *= -1;
    }

    if ((y > height) || (y < 0)) {
      speedy  *= -1;
    }

    this.speedx += random(-0.1, 0.1);
    this.speedy += random(-0.1, 0.1);

    // if ball is infected then change color to read otherwise change color to green & reduce time_to_recover by 1
    if (this.inf) {
      fill(255, 0, 0);
      this.healthy=false ;
      this.time_to_recover--;
    } else 
    fill(0, 255, 0); 

    // if time_to_recover less than zero , then ball is cured and its color is yellow
    if (this.time_to_recover <= 0) {
      this.inf = false;
      this.time_to_recover--;
      fill(255, 255, 0);
    }
    //check if all balls are recovered, color them with green
    if (this.time_to_recover<=-1000) {
      this.healthy=true;
      fill(0, 255, 0);
    }
    // if ball is moving change x ,y to simulate motion
    if (this.movee) {
      this.x += this.speedx;
      this.y += this.speedy;
    }
    noStroke();
    // if ball is already infected and die random variale is 1 and time_to_recover < 2000 , then the ball is dead
    if (this.inf && this.die==1 && this.time_to_recover<2000) {
      this.dead=true;
    }
    if (this.dead) {
      this.movee=false;
      fill(0);
    }
    ellipse(this.x, this.y, 20, 20);

    pop();
  }
}

/////////////////////////////////////////////////////////

// line is a class used to define a line using  start_point(x,y) and end_point(px,py)  
class Line {
  float x;
  float y;
  float px;
  float py;
  Line(float xx, float yy, float px, float py) {
    this. x =xx;
    this.y =yy;
    this.px =px;
    this.py =py;
  }
  void move() {
    strokeWeight(10);
    line(x, y, px, py);
  }
}
