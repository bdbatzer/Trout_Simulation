/**
* Class representing a food item for a trout such as an insect
*/
class Food {
  PVector location;
  float size;
  
  /**
  * Constructor for food 
  *
  * @param x - x-coordinate of food
  * @param y - y-coordinate of food
  * @param z - z-coordinate of food
  */
  Food(float x, float y, float z) {
    location = new PVector(x, y, z);
    size = 5;
  }
  
  /**
  * Update this food's postion based on current
  */
  void update() {
    location.sub(new PVector(current, 0.0, 0.0));
  }
  
  /**
  * Displays food on the screen
  */
  void display() {
    fill(190, 80, 15);
    pushMatrix();
    beginShape();
    sphere(size);
    translate(location.x, location.y, location.z);
    endShape();
    popMatrix();
  }
}

/**
* Creates new food object and deletes ones that are moving off screen 
*/
void release_fly() {
  if (!flies.isEmpty()) {
    for (Food fly : flies) {
      if (fly.location.x < -300.0) {
        int i = flies.indexOf(fly);
        flies.remove(i);
        break;
      }
    }
  }
  
  if (frameCount % time == 0) {
    float randomY = random(0.25*height, 0.75*height);
    float randomZ = random(-300, 300);
    Food f = new Food(width+500, randomY, randomZ);
    flies.add(f);
  }
  
  if (!flies.isEmpty()) {
    for (Food f : flies) {
      f.update();
      f.display();
    }
  }
}

/**
* Method that returns 
*/
float myatan(float y, float x) {
  
  float ang = 0.0;
  if (x > 0.0) {
    ang = atan(y/x);
  }
  if (y >= 0.0 && x < 0.0) {
    ang = PI + atan(y/x);
  }
  if (y < 0.0 && x < 0.0) {
    ang = -1.0 * PI + atan(y/x);
  }
  if (y > 0.0 && x == 0.0) {
    ang = PI/2;
  }
  if (y < 0.0 && x == 0.0) {
    ang = -1.0 * PI/2;
  }
  if (ang < 0.0) {
    ang += TWO_PI;
  }
  
  return ang;
}
