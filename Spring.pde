/**
* Class representing the springs between masses on the trout's body
*/
class Spring {
  float k; // spring constant
  float len; // current resting length
  PVector rest_len; // original resting length
  PVector force; // force from spring
  ArrayList<Mass> associated_masses = new ArrayList<Mass>(); // two masses associated with this spring 
  
  /**
  * Constructor for spring 
  *
  * @params mass_1, mass_2 - the masses that stand on either end of the spring
  * @param spring - the spring constant as described in Hooke's Law
  */
  Spring(Mass mass_1, Mass mass_2, float spring) {
    // assign constants
    k = spring;
    rest_len = PVector.sub(mass_2.position, mass_1.position); 
    len = rest_len.mag();
    
    // assign masses
    associated_masses.add(mass_1);
    associated_masses.add(mass_2);
  }
  
  /**
  * Set new spring stiffness 
  *
  * @param spring - spring constant
  */
  void setSpring(float spring) {
    k = spring;
  }
  
  /**
  * Change spring's resting length by a contraction factor between 0 and 1
  *
  * @param x - contraction factor
  */
  void setStretch_1(float x) {
    len = rest_len.mag() * x;
  }
  
  /**
  * Change spring's resting length by adding or subtracting from the original rest length
  *
  * @param x - amount that spring's resting length will expand or contract by
  */
  void setStretch_2(float x) {
    len = rest_len.mag() + x;
  }
  
  /**
  * Change spring's resting length by adding or subtracting from current rest length. 
  * This will be used to permit gradual turning behavior
  * 
  * @param x - amount that spring's resting length will expand or contract by
  */
  void setStretch_3(float x) {
    len += x;
  }
  
  /**
  * Reset current resting length of spring to its original resting length
  */
  void resetStretch() {
    len = rest_len.mag();
  }
  
  /**
  * Updates the force emanating from this spring. Derived from Hooke's Law
  */
  void update() {
    PVector curr_len = PVector.sub(associated_masses.get(1).position, associated_masses.get(0).position);
    float deformation = curr_len.mag() - len;
    force = PVector.div(curr_len, curr_len.mag());
    force.mult(-k * deformation);
  }
}
