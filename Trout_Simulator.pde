float damp = 0.05; // damping factor
float max_velocity_magnitude = 60; // maximum velocity allowed
float timestep = 0.055; // used to calculate acceleration
int time = 300; // # of frames between food releases 
float current = 0.5; // force from current

boolean behind = false; // change camera to back of scene (fish face away from you)
boolean birds_eye = false; // change camera to overhead view
boolean front = false; // change camera to front of scene (fish face towards you)
boolean side = true; // change camera to side view (default)

ArrayList<Trout> trout = new ArrayList<Trout>(); // array of trout
ArrayList<Food> flies = new ArrayList<Food>(); // array of food to eat

void setup() {
  size(1800, 1000, P3D); // Setting up for 3D environment
  background(125, 180, 220);
  
  Trout t1 = new Trout(0.35*width, 0.5*height, 0.0);
  trout.add(t1);
  Trout t2 = new Trout(0.5*width, 0.65*height, -200);
  trout.add(t2);
  Trout t3 = new Trout(0.65*width, 0.35*height, 200);
  trout.add(t3);
  Trout t4 = new Trout(0.75*width, 0.425*height, -100);
  trout.add(t4);
  Trout t5 = new Trout(0.25*width, 0.575*height, 100);
  trout.add(t5);
  
  for (int i = 1; i < 13; i++) {
    t1.masses.get(i).velocity.add(new PVector(1.0, 0.0, 0.0));
    t2.masses.get(i).velocity.add(new PVector(1.0, 0.0, 0.0));
    t3.masses.get(i).velocity.add(new PVector(1.0, 0.0, 0.0));
    t4.masses.get(i).velocity.add(new PVector(1.0, 0.0, 0.0));
    t5.masses.get(i).velocity.add(new PVector(1.0, 0.0, 0.0));
  }
}

void draw() {
  
  background(125, 180, 220);
  if (behind) {
    camera(-200, height/2, 0, width/2, height/2, 0, -1, 1, 0);
  } else if (birds_eye) {
    camera(width/2, -0.75*height, 0, width/2, height/2, 0, 0, 0, 1);
  } else if (front) {
    camera(width+500, height/2, 0, width/2, height/2, 0, 1, 1, 0);
  } else if (side) {
    camera(width/2, height/2, 0.625*width, width/2, height/2, 0, 0, 1, 0);
  }
  
  // introduce food
  release_fly();
  for (Food fly : flies) {
    fly.display();
  }
  
  for (Trout t: trout) {
    
    PVector separation = t.separate(trout);
    
    t.check_for_Food();
    if (t.masses.get(20).position.x > width+500 && t.masses.get(21).position.x > width+500) { // wrapping
      t.wrap();
      t.unfollow();
    }
    if (t.abort) { // This means we have just stopped purusing the target food item
      t.abort = false;
      t.braking = false;
      t.gliding = false;
      t.repositioning = true;
      t.intercepting = false;
      t.relax();
      t.turning = false;
      t.turning_time = 0;
    }
    
    // Establish new destination if not intercepting
    if (t.repositioning) {
      float x_y = 5.8*abs(t.masses.get(0).position.y - t.startY);
      float x_z = 5.8*abs(t.masses.get(0).position.z - t.startZ);
      float x = max(x_y, x_z);
      if (x < 50.0) x = 50.0;
      t.destination.set(t.masses.get(0).position.x + x, t.startY - (t.masses.get(0).position.y - t.startY), t.startZ - (t.masses.get(0).position.z - t.startZ));
    } else if (t.gliding || t.braking) {
      t.destination.set(t.masses.get(0).position);
    }
    
    // Determine orientation of trout including whether body alignment is at a bad angle - i.e. one that would push the fish to the side if a braking force is applied
    PVector orientation = t.findOrientation();
    PVector Tail = PVector.add(t.masses.get(13).position, t.masses.get(14).position).add(PVector.add(t.masses.get(15).position, t.masses.get(16).position));
    Tail.add(PVector.add(t.masses.get(17).position, t.masses.get(18).position).add(PVector.add(t.masses.get(19).position, t.masses.get(20).position)));
    Tail.div(8.0);
    PVector bdy_ali = PVector.sub(t.masses.get(0).position, Tail);
    float theta = asin(bdy_ali.y / bdy_ali.mag());
    if (theta < 0.0 && bdy_ali.x < 0.0) {
      theta = -PI - theta;
    } else if (theta > 0.0 && bdy_ali.x < 0.0) {
      theta = PI - theta;
    }
    if (theta < 0.0) theta += TWO_PI;
    float phi = asin(bdy_ali.z / (bdy_ali.mag() * cos(theta)));
    if (phi < 0.0) phi += TWO_PI;
    boolean wellPositioned = (phi < PI/18 || phi > 35*PI/18) && (t.ang_Z <= PI/18 || t.ang_Z >= 35*PI/18) && (t.ang_Y <= PI/18 || t.ang_Y >= 35*PI/18);
    if (t.seeSomething && wellPositioned && !t.braking && !t.gliding && !t.repositioning) t.intercepting = true;
    if (!t.seeSomething && t.intercepting) t.intercepting = false;
    
    // Slow down if going too fast
    if (orientation.z > 20.0) t.update(orientation, 4, separation);
    System.out.println("\nTrout #: " + trout.indexOf(t));
    System.out.println("Speed: " + orientation.z);
    System.out.println("Angle elevation: " + t.ang_Y);
    System.out.println("Angle turn: " + t.ang_Z);
    System.out.println("Target elevation: " + orientation.x);
    System.out.println("Target turn: " + orientation.y);
    System.out.println("Right tilt: " + t.right_tilt);
    System.out.println("Left tilt: " + t.left_tilt);
    System.out.println("Braking? " + t.braking);
    System.out.println("Gliding? " + t.gliding);
    System.out.println("Repositioning " + t.repositioning);
    System.out.println("See something? " + t.seeSomething);
    System.out.println("Turning? " + t.turning);
    System.out.println("Turn time: " + t.turning_time);
    
   if (t.braking) { // Applies braking force to move backwards as long as we're maintaining a forward orientation
   
     if (t.seeSomething && wellPositioned) {
        t.braking = false;
        t.gliding = false;
        t.repositioning = false;
        t.relax();
        t.turning = false;
        t.turning_time = 0;
        t.update(orientation, 0, separation);
      } else if (phi > PI/18.0 && phi < 35*PI/18.0) {
        t.braking = false;
        t.gliding = false;
        t.repositioning = true;
        t.relax();
        t.turning = false;
        t.turning_time = 0;
        t.update(orientation, 0, separation);
      } else {
        if (orientation.z >= -1.0) {
          t.glide(2.0, 145);
          t.update(orientation, 2, separation);
        } else if (orientation.z < -20.0) {
          t.glide(2.0, 100);
          t.update(orientation, 3, separation);
        } else if (orientation.z < -1.0) {
          t.glide(2.0, 120);
          t.update(orientation, 0, separation);
        }
      }
      
    } else if (t.gliding) { // Rebalances back into a forward orientation 
      
      if ((phi < PI/120.0 || phi > 239.0*PI/120) && (t.ang_Z <= PI/120.0 || t.ang_Z >= 239.0*PI/120) && (t.ang_Y <= PI/120.0 || t.ang_Y >= 239.0*PI/120)) {
        
        t.braking = true;
        t.gliding = false;
        t.repositioning = false;
        t.relax();
        t.turning = false;
        t.turning_time = 0;
        
      } else {
      
        if ((t.ang_Z > PI/120.0 && t.ang_Z < 239.0*PI/120) && t.turning_time == 0) {
          t.turning = true;
          t.right = (t.ang_Z > PI) ? true : false;
        } else if ((t.right_tilt > PI/12 && t.right_tilt < 23*PI/12) && (t.left_tilt > PI/12 && t.left_tilt < 23*PI/12)) {
          t.relax();
          t.turning = false;
          t.turning_time = 0;
        } else if (t.ang_Z <= PI/120.0 || t.ang_Z >= 239.0*PI/120) {
          t.turning = false;
        }
        t.execute_turns();
        
        if (orientation.z <= 0.0) {
          t.glide(2.0, 100);
          t.update(orientation, 3, separation);
        } else {
          t.glide(2.0, 120);
          t.update(orientation, 0, separation);
        }
        
      }
        
    } else if (t.repositioning) { // Move back to original depth
      
      if ((t.masses.get(0).position.y > height/2.0 - 100.0 && t.masses.get(0).position.y < height/2.0 + 100.0) && (t.masses.get(0).position.z > -100.0 && t.masses.get(0).position.z < 100.0)) {
        t.braking = false;
        t.gliding = true;
        t.repositioning = false;
        t.relax();
        t.turning = false;
        t.turning_time = 0;
        t.update(orientation, 0, separation);
      } else {
        if ((orientation.y > PI/18 && orientation.y < 35*PI/18) && t.turning_time == 0) {
          t.turning = true;
          t.right = (orientation.y > PI) ? true : false;
        } else if ((t.right_tilt > PI/12 && t.right_tilt < 23*PI/12) && (t.left_tilt > PI/12 && t.left_tilt < 23*PI/12)) {
          t.relax();
          t.turning = false;
          t.turning_time = 0;
        } else if (orientation.y <= PI/18  || orientation.y >= 35*PI/18) {
          t.turning = false;
        }
        t.execute_turns();
        
        if (orientation.z <= 0.0) {
          t.glide(2.0, 100);
          t.update(orientation, 3, separation);
        } else {
          t.glide(2.0, 120);
          t.update(orientation, 1, separation);
        }
      }
      
    } else { // If intercepting, continue pursuing the target, and if not restart the cyle by repositioning
      
      if (t.intercepting) {
        if ((orientation.y > PI/180 && orientation.y < 359*PI/180) && t.turning_time == 0) {
          t.turning = true;
          t.right = (orientation.y > PI) ? true : false;
        } else if ((t.right_tilt > PI/12 && t.right_tilt < 23*PI/12) && (t.left_tilt > PI/12 && t.left_tilt < 23*PI/12)) {
          t.relax();
          t.turning = false;
          t.turning_time = 0;
        } else if (orientation.y <= PI/180  || orientation.y >= 359*PI/180) {
          t.turning = false;
        }
        t.execute_turns();
        
        if (orientation.z <= 0.0) {
          t.glide(2.0, 100);
          t.update(orientation, 3, separation);
        } else {
          t.glide(2.0, 120);
          t.update(orientation, 1, separation);
        }
      } else {
        t.braking = false;
        t.gliding = false;
        t.repositioning = true;
        t.relax();
        t.turning = false;
        t.turning_time = 0;
        t.update(orientation, 0, separation);
      }
    }
    
    t.display();
  }
}

void keyPressed() {
  
  if (key == 'b' || key == 'B') {
    behind = true;
    birds_eye = false;
    front = false;
    side = false;
  } else if (key == 'e' || key == 'E') {
    birds_eye = true;
    behind = false;
    front = false;
    side = false;
  } else if (key == 'f' || key == 'F') {
    behind = false;
    birds_eye = false;
    front = true;
    side = false;
  } else if (key == 's' || key == 'S') {
    behind = false;
    birds_eye = false;
    front = false;
    side = true;
  } else if (key == 'p' || key == 'P') {
    if (looping) noLoop();
    else loop();
  }
}
