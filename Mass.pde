/**
* Class representing the masses that make up the fish's body
*/
class Mass {
  PVector position;
  PVector acceleration;
  PVector velocity;
  float mass;
  ArrayList<Spring> associated_springs = new ArrayList<Spring>(); // Data structure containing springs for which this mass is a member
  ArrayList<Surface> associated_surfaces = new ArrayList<Surface>(); // Data structure containing surfaces for which this mass is a member
  PVector net_damping;
  
  /**
  * Constructor for mass
  *
  * @param x - x-coordinate of mass
  * @param y - y-coordinate of mass
  * @param z - z-coordinate of mass
  * @param mass - the uh... mass... of the mass
  */
  Mass(float x, float y, float z, float m) {
    position = new PVector(x, y, z);
    velocity = new PVector(0.0, 0.0, 0.0);
    acceleration = new PVector(0.0, 0.0, 0.0);
    mass = m;
  }
  
  /**
  * Establish that this mass is part of this spring 
  *
  * @param sprg - a spring this mass is part of 
  */
  void associate_with_spring(Spring sprg) {
    associated_springs.add(sprg);
  }
  
  /**
  * Establish that this mass is part of this surface 
  *
  * @param surf - a surface this mass is part of 
  */
  void associate_with_surface(Surface surf) {
    associated_surfaces.add(surf);
  }
  
  /**
  * Determines the net effect that frictional forces
  * (typically called damping) have on trout's final velocity
  *
  * @return net_damping - PVector that represents all damping on this mass
  */
  PVector calculateDampForce() {
    PVector net_damping = new PVector(0.0, 0.0, 0.0);
    for (Spring sprg : associated_springs) {
      for (Mass m : sprg.associated_masses) {
        if (this.isSame(m)) {
          continue;
        } else {
          net_damping.add(PVector.mult(m.velocity, damp));
        }
      }
    }
    net_damping.sub(PVector.mult(this.velocity, damp));
    
    return net_damping;
  }
  
  /**
  * Helper method that determines whether the mass that uses this method
  * is the same as the one it is being called on
  *
  * @param m - mass to compare with 
  * @return boolean 
  */
  boolean isSame(Mass m) {
    
    if (this.velocity.x != m.velocity.x) {
      return false;
    } else if (this.velocity.y != m.velocity.y) {
      return false;
    } else if (this.velocity.z != m.velocity.z) {
      return false;
    }
    
    if (this.acceleration.x != m.acceleration.x) {
      return false;
    } else if (this.acceleration.y != m.acceleration.y) {
      return false;
    } else if (this.acceleration.z != m.acceleration.z) {
      return false;
    }  
    
    if (this.position.x != m.position.x) {
      return false;
    } else if (this.position.y != m.position.y) {
      return false;
    } else if (this.position.z != m.position.z) {
      return false;
    }
    
    if (this.mass != m.mass) {
      return false;
    }
    
    return true;
  }
}

/**
* Determines whether a mass is exposed to the current.
* This ensures that a fish that isn't forward-facing 
* will have to fight the current more than otherwise and
* is also the explanation for why fish, and stream fish in
* particular have streamlined bodies
*
* @param masses - array list of a trout's masses
* @return boolean
*/
boolean inCurrent(Mass mss, ArrayList<Mass> masses) {
  float minZ = mss.position.z;
  float maxZ = mss.position.z;
  float minY = mss.position.y;
  float maxY = mss.position.y;
  for (Mass m : masses) {
    if (mss.isSame(m) || m.position.x < mss.position.x) {
      continue;
    }
    
    if (m.position.z < minZ) {
      minZ = m.position.z;
    }
    if (m.position.z > maxZ) {
      maxZ = m.position.z;
    }
    if (m.position.y < minY) {
      minY = m.position.y;
    }
    if (m.position.y < maxY) {
      maxY = m.position.y;
    }
    
    if (minZ < mss.position.z && maxZ > mss.position.z && minY < mss.position.y && maxY > mss.position.y) {
      return false;
    }
  }
  
  return true;
}
