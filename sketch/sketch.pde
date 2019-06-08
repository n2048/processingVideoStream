float textHeight;

Follower f1;
Follower f2;

int numFollowers = 200;
ArrayList<Follower> followers = new ArrayList<Follower>(); 
int fps = 30;

void setup() {
  fullScreen(P3D);
  frameRate(fps);
  //pixelDensity(2); // Not suported when using Xvfb as virtual display 
  background(0);
  stroke(255);
  fill(255);

  textHeight = height/100.;
  textSize(textHeight);
  textAlign(LEFT);

  f1 = new Follower(2., color(255));
  f2 = new Follower(1., color(255, 0, 0));

  for (int n = 0; n< numFollowers; n++) {
    color c = color (random(255));
    if (random(1)<0.01) c = color(255, 0, 0);
    followers.add(new Follower(1/(1.+n), c));
  }
  followers.get(0).c = color(255, 0, 0);
}


void draw() {
  background(0);

  PVector center = new PVector(height/2*(1.+sin(frameCount/1000.)), height/2*(1.+cos(frameCount/1000.)), -height);
  PVector camPos = new PVector(height/2, height/2, height/2*(1.+cos(frameCount/1000.)));

  camera(camPos.x, camPos.y, camPos.z, 
    center.x, center.y, center.z, 
    0, 1, 0);

  PVector mainTarget = new PVector(cos(frameCount/1000.), sin(frameCount/1000.), cos(frameCount/1000.)).mult(height).add(new PVector(height, height, height)).div(2);

  followers.get(0).follow(mainTarget);
  followers.get(0).draw();

  for (int n = 1; n<numFollowers; n++) {
    followers.get(n).follow(followers.get(n-1).cursor);
    followers.get(n).draw();
  }
}


class Follower {
  PVector cursor;
  color c;
  float speed;

  Follower( float speed, color c) {
    this.speed = speed;
    this.cursor = new PVector(random(height), random(height), random(height));
    this.c = c;
  }

  void follow(PVector target) {
    PVector direction = target.copy().sub(this.cursor);
    direction.setMag(noise(this.cursor.x, this.cursor.y, this.cursor.z) + this.speed);
    this.cursor.add(direction);
  }

  void draw () {
    stroke(this.c);
    line(this.cursor.x, 0, this.cursor.z, this.cursor.x, height, this.cursor.z);
    line(0, this.cursor.y, this.cursor.z, height, this.cursor.y, this.cursor.z);
    line(this.cursor.x, this.cursor.y, 0, this.cursor.x, this.cursor.y, height);
    fill(0);
    push();
    translate(this.cursor.x, this.cursor.y, this.cursor.z);
    box(textHeight);
    fill(this.c);
    text((int)this.cursor.x + " " + (int)this.cursor.y+ " " + (int)this.cursor.z, textHeight, - textHeight);
    pop();


    if (frameCount%100 == 0)
      this.cursor = new PVector(random(height), random(height), random(height));
  }
}
