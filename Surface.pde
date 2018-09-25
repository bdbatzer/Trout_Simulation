/*
* Class representing the outer surface of the trout that interact with external forces 
*/
class Surface {
  ArrayList<Mass> neighbors = new ArrayList<Mass>(); // nearby masses used to determine whether force is facing the wrong way
  float Area; // area of surface 
  PVector unit_normal; // outward-facing unit vector for the force acting on this surface
  PVector force; // the total external force
  ArrayList<Mass> associated_masses = new ArrayList<Mass>(); // three masses associated with a surface
  
  /*
  * Constructor for a Surface 
  *
  * @params m1, m2, m3 - masses that comprise the boundaries of the surface
  * @param nbrs - the neighboring masses of this surface
  */
  Surface(Mass m1, Mass m2, Mass m3, Mass [] nbrs) {
    associated_masses.add(m1);
    associated_masses.add(m2);
    associated_masses.add(m3);
    for (int i = 0; i < nbrs.length; i++) {
      neighbors.add(nbrs[i]);
    }
    
    PVector AB = PVector.sub(m2.position, m1.position);
    PVector AC = PVector.sub(m3.position, m1.position);
    unit_normal = AB.cross(AC);
    Area = 0.5 * unit_normal.mag();
  }
  
  /**
  * Updates the external force acting upon the surface
  */
  void update() {
    
    // Determine velocity of surface, including current
    PVector AB = PVector.sub(associated_masses.get(1).position, associated_masses.get(0).position);
    PVector AC = PVector.sub(associated_masses.get(2).position, associated_masses.get(0).position);
    PVector avg_veloc = PVector.add(associated_masses.get(0).velocity, associated_masses.get(1).velocity).add(associated_masses.get(2).velocity);
    PVector curr_force = new PVector(-current, 0.0, 0.0);
    PVector curr_accel = PVector.div(curr_force, associated_masses.get(0).mass + associated_masses.get(1).mass + associated_masses.get(2).mass);
    avg_veloc.div(3.0).add(curr_accel);
    
    // Find a unit normal to the surface. Will determine whether it is an inward or outward normal in the next step and change it if necessary
    unit_normal = AB.cross(AC);
    Area = 0.5 * unit_normal.mag();
    unit_normal.normalize();
    
    // Use the neighboring masses to determine whether the force is going in the correct direction. It is suppposed to be an outward normal
    PVector midpoint = PVector.add(associated_masses.get(0).position, associated_masses.get(1).position).add(associated_masses.get(2).position);
    midpoint.div(3.0);
    PVector center = new PVector(0.0, 0.0);
    for (Mass nbr : neighbors) {
      center.add(nbr.position);
    }
    center.div(neighbors.size());
    if (PVector.add(midpoint, unit_normal).dist(center) < midpoint.dist(center)) {
      unit_normal.mult(-1.0);
    }
    float a = -0.001 * Area * avg_veloc.mag() * unit_normal.dot(avg_veloc);
    force = PVector.mult(unit_normal, a);
  }
  
  /**
  * Debugging method that draws the unit outward normal on the screen to ensure it's facing the correct direction 
  */
  void display() {
    PVector midpoint = PVector.add(associated_masses.get(0).position, associated_masses.get(1).position).add(associated_masses.get(2).position);
    midpoint.div(3.0);
    line(midpoint.x, midpoint.y, midpoint.z, midpoint.x + 10*unit_normal.x, midpoint.y + 10*unit_normal.y, midpoint.z + 10*unit_normal.z);
  }
}

/**
* Compares the angles of two vectors and determines if they are facing roughly the same direction.
* This will be used to find out if a surface's velocity and the external force being exerted on it
* are counteracting each other
*
* @params a, b - the angles to compare 
* @return boolean
*/
boolean oppositeDirections(float a, float b) {
  if (a < 0.0) {
    a += TWO_PI;
  }
  if (b < 0.0) {
    b += TWO_PI;
  }
  
  float difference = abs(a - b);
  if (difference <= PI/6.0 || TWO_PI - difference <= PI/6.0) {
    return false;
  }
  
  return true;
}
