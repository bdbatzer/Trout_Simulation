PVector debug1 = new PVector(0.0, 0.0, 0.0);
PVector debug2 = new PVector(0.0, 0.0, 0.0);
PVector debug3 = new PVector(0.0, 0.0, 0.0);
PVector debug4 = new PVector(0.0, 0.0, 0.0);
PVector debug5 = new PVector(0.0, 0.0, 0.0);

/**
* Class representing a stream-dwelling fish such as a trout
*/
class Trout {
  
  ArrayList<Mass> masses = new ArrayList<Mass>(); // Data structure that contains all masses
  ArrayList<Spring> springs = new ArrayList<Spring>(); // Data structure that contains all springs
  ArrayList<Surface> surfaces = new ArrayList<Surface>(); // Data structure that contains all surfaces
  
  boolean turning = false; // true if trout is currently executing turn
  int turning_time = 0; // number of frames over which a turn took place 
  boolean right = true; // true = trout turns right; false = trout turns false
  
  boolean repositioning = true; // true if trout needs to return to starting depth and position 
  boolean braking = false;  // true if trout should back up 
  boolean gliding = false; // true if trout should maintain its current trajectory
  boolean intercepting = false; // true if trout should move to eat a food item
  boolean abort = false; // true if trout has just stopped intercepting or otherwise decided to stop pursuing food
  boolean seeSomething = false; // true if trout has food item in its line of sight
  
  float finArea = 0.0; // size of pectoral fins
  float ang_Z = 0.0; // angle of trout upwards or downwards
  float ang_Y = 0.0; // angle of trout sideways  
  float right_tilt = 0.0; // angle of rightward imbalance 
  float left_tilt = 0.0; // angle of leftward imbalance
  
  PVector destination = new PVector(width, height/2.0, 0.0); // default destination 
  Food target; // food object that this trout is currently pursuing
  float startY; // initial y-coordinate of trout 
  float startZ; // initial z-coordinate of trout
  
  PVector center_mass = new PVector(0.0, 0.0, 0.0); // center of mass of trout
  
  /**
  * Constructor that instantiates all the masses, springs, and surfaces 
  * that comprise the structure of the trout
  *
  * @param x - x coordinate of desired position
  * @param y - y coordinate of desired position
  * @param z - z coordinate of desired position
  */
  Trout(float x, float y, float z) {
    
    // Store the starting position for when the trout tries to reposition itself
    startY = y;
    startZ = z;
    
    // Create the masses and springs that make up the trout
    Mass m0 = new Mass(x, y, z, 1.1);
    Mass m1 = new Mass(x-20, y+10, z-10, 6.6);
    Mass m2 = new Mass(x-20, y+10, z+10, 6.6);
    Mass m3 = new Mass(x-20, y-10, z+10, 6.6);
    Mass m4 = new Mass(x-20, y-10, z-10, 6.6);
    Spring sp_0_1 = new Spring(m0, m1, 30.0);
    Spring sp_0_2 = new Spring(m0, m2, 30.0);
    Spring sp_0_3 = new Spring(m0, m3, 30.0);
    Spring sp_0_4 = new Spring(m0, m4, 30.0);
    Spring sp_1_2 = new Spring(m1, m2, 30.0);
    Spring sp_1_3 = new Spring(m1, m3, 30.0); 
    Spring sp_1_4 = new Spring(m1, m4, 30.0);
    Spring sp_2_3 = new Spring(m2, m3, 30.0);
    Spring sp_2_4 = new Spring(m2, m4, 30.0);
    Spring sp_3_4 = new Spring(m3, m4, 30.0);
    
    Mass m5 = new Mass(x-50, y+12.5, z-12.5, 11.0);
    Mass m6 = new Mass(x-50, y+12.5, z+12.5, 11.0);
    Mass m7 = new Mass(x-50, y-12.5, z+12.5, 11.0);
    Mass m8 = new Mass(x-50, y-12.5, z-12.5, 11.0);
    Spring sp_1_5 = new Spring(m1, m5, 28.0);
    Spring sp_1_6 = new Spring(m1, m6, 38.0);
    Spring sp_1_8 = new Spring(m1, m8, 38.0);
    Spring sp_2_5 = new Spring(m2, m5, 38.0);
    Spring sp_2_6 = new Spring(m2, m6, 28.0);
    Spring sp_2_7 = new Spring(m2, m7, 38.0);
    Spring sp_3_6 = new Spring(m3, m6, 38.0);
    Spring sp_3_7 = new Spring(m3, m7, 28.0);
    Spring sp_3_8 = new Spring(m3, m8, 38.0);
    Spring sp_4_5 = new Spring(m4, m5, 38.0);
    Spring sp_4_7 = new Spring(m4, m7, 38.0);
    Spring sp_4_8 = new Spring(m4, m8, 28.0);
    Spring sp_5_6 = new Spring(m5, m6, 30.0);
    Spring sp_5_7 = new Spring(m5, m7, 30.0); 
    Spring sp_5_8 = new Spring(m5, m8, 30.0);  
    Spring sp_6_7 = new Spring(m6, m7, 30.0);
    Spring sp_6_8 = new Spring(m6, m8, 30.0);
    Spring sp_7_8 = new Spring(m7, m8, 30.0);
    
    Mass m9 = new Mass(x-80, y+10, z-10, 6.6);
    Mass m10 = new Mass(x-80, y+10, z+10, 6.6);
    Mass m11 = new Mass(x-80, y-10, z+10, 6.6);
    Mass m12 = new Mass(x-80, y-10, z-10, 6.6);
    Spring sp_5_9 = new Spring(m5, m9, 28.0);
    Spring sp_5_10 = new Spring(m5, m10, 38.0);
    Spring sp_5_12 = new Spring(m5, m12, 38.0);
    Spring sp_6_9 = new Spring(m6, m9, 38.0);
    Spring sp_6_10 = new Spring(m6, m10, 28.0);
    Spring sp_6_11 = new Spring(m6, m11, 38.0);
    Spring sp_7_10 = new Spring(m7, m10, 38.0);
    Spring sp_7_11 = new Spring(m7, m11, 28.0);
    Spring sp_7_12 = new Spring(m7, m12, 38.0);
    Spring sp_8_9 = new Spring(m8, m9, 38.0);
    Spring sp_8_11 = new Spring(m8, m11, 38.0);
    Spring sp_8_12 = new Spring(m8, m12, 28.0);
    Spring sp_9_10 = new Spring(m9, m10, 30.0);
    Spring sp_9_11 = new Spring(m9, m11, 30.0);
    Spring sp_9_12 = new Spring(m9, m12, 30.0);
    Spring sp_10_11 = new Spring(m10, m11, 30.0);
    Spring sp_10_12 = new Spring(m10, m12, 30.0);
    Spring sp_11_12 = new Spring(m11, m12, 30.0);
    
    Mass m13 = new Mass(x-110, y+7.5, z-7.5, 1.1);
    Mass m14 = new Mass(x-110, y+7.5, z+7.5, 1.1);
    Mass m15 = new Mass(x-110, y-7.5, z+7.5, 1.1);
    Mass m16 = new Mass(x-110, y-7.5, z-7.5, 1.1);
    Spring sp_9_13 = new Spring(m9, m13, 28.0);
    Spring sp_9_14 = new Spring(m9, m14, 38.0);
    Spring sp_9_16 = new Spring(m8, m16, 38.0);
    Spring sp_10_13 = new Spring(m10, m13, 38.0);
    Spring sp_10_14 = new Spring(m10, m14, 28.0);
    Spring sp_10_15 = new Spring(m10, m15, 38.0);
    Spring sp_11_14 = new Spring(m11, m14, 38.0);
    Spring sp_11_15 = new Spring(m11, m15, 28.0);
    Spring sp_11_16 = new Spring(m11, m16, 38.0);
    Spring sp_12_13 = new Spring(m12, m13, 38.0);
    Spring sp_12_15 = new Spring(m12, m15, 38.0);
    Spring sp_12_16 = new Spring(m12, m16, 28.0);
    Spring sp_13_14 = new Spring(m13, m14, 30.0);
    Spring sp_13_15 = new Spring(m13, m15, 30.0);
    Spring sp_13_16 = new Spring(m13, m16, 30.0);
    Spring sp_14_15 = new Spring(m14, m15, 30.0);
    Spring sp_14_16 = new Spring(m14, m16, 30.0);
    Spring sp_15_16 = new Spring(m15, m16, 30.0);
    
    Mass m17 = new Mass(x-130, y+5, z-5, 1.1);
    Mass m18 = new Mass(x-130, y+5, z+5, 1.1);
    Mass m19 = new Mass(x-130, y-5, z+5, 1.1);
    Mass m20 = new Mass(x-130, y-5, z-5, 1.1);
    Spring sp_13_17 = new Spring(m13, m17, 30.0);
    Spring sp_13_18 = new Spring(m13, m18, 30.0);
    Spring sp_13_20 = new Spring(m13, m20, 30.0);
    Spring sp_14_17 = new Spring(m14, m17, 30.0);
    Spring sp_14_18 = new Spring(m14, m18, 30.0);
    Spring sp_14_19 = new Spring(m14, m19, 30.0);
    Spring sp_15_18 = new Spring(m15, m18, 30.0);
    Spring sp_15_19 = new Spring(m15, m19, 30.0);
    Spring sp_15_20 = new Spring(m15, m20, 30.0);
    Spring sp_16_17 = new Spring(m16, m17, 30.0);
    Spring sp_16_19 = new Spring(m16, m19, 30.0);
    Spring sp_16_20 = new Spring(m16, m20, 30.0);
    Spring sp_17_18 = new Spring(m17, m18, 30.0);
    Spring sp_17_19 = new Spring(m17, m19, 30.0);
    Spring sp_17_20 = new Spring(m17, m20, 30.0);
    Spring sp_18_19 = new Spring(m18, m19, 30.0);
    Spring sp_18_20 = new Spring(m18, m20, 30.0);
    Spring sp_19_20 = new Spring(m19, m20, 30.0);
    
    Mass m21 = new Mass(x-160, y+15, z, 0.66);
    Mass m22 = new Mass(x-160, y-15, z, 0.66);
    Spring sp_17_21 = new Spring(m17, m21, 30.0);
    Spring sp_17_22 = new Spring(m17, m22, 30.0);
    Spring sp_18_21 = new Spring(m18, m21, 30.0);
    Spring sp_18_22 = new Spring(m18, m22, 30.0);
    Spring sp_19_21 = new Spring(m19, m21, 30.0);
    Spring sp_19_22 = new Spring(m19, m22, 30.0);
    Spring sp_20_21 = new Spring(m20, m21, 30.0);
    Spring sp_20_22 = new Spring(m20, m22, 30.0);
    Spring sp_21_22 = new Spring(m21, m22, 30.0);
    
    
    // List of masses 
    masses.add(m0); // index 0
    masses.add(m1); // index 1
    masses.add(m2); // index 2
    masses.add(m3); // index 3
    masses.add(m4); // index 4
    masses.add(m5); // index 5
    masses.add(m6); // index 6
    masses.add(m7); // index 7
    masses.add(m8); // index 8
    masses.add(m9); // index 9
    masses.add(m10); // index 10
    masses.add(m11); // index 11
    masses.add(m12); // index 12
    masses.add(m13); // index 13
    masses.add(m14); // index 14
    masses.add(m15); // index 15
    masses.add(m16); // index 16
    masses.add(m17); // index 17
    masses.add(m18); // index 18
    masses.add(m19); // index 19
    masses.add(m20); // index 20
    masses.add(m21); // index 21
    masses.add(m22); // index 22
    
    
    // List of springs
    springs.add(sp_0_1); // index 0
    springs.add(sp_0_2); // index 1
    springs.add(sp_0_3); // index 2
    springs.add(sp_0_4); // index 3
    
    m0.associate_with_spring(sp_0_1);
    m0.associate_with_spring(sp_0_2);
    m0.associate_with_spring(sp_0_3);
    m0.associate_with_spring(sp_0_4);
    
    springs.add(sp_1_2); // index 4
    springs.add(sp_1_3); // index 5
    springs.add(sp_1_4); // index 6
    springs.add(sp_1_5); // index 7
    springs.add(sp_1_6); // index 8
    springs.add(sp_1_8); // index 9
    
    m1.associate_with_spring(sp_0_1);
    m1.associate_with_spring(sp_1_2);
    m1.associate_with_spring(sp_1_3);
    m1.associate_with_spring(sp_1_4);
    m1.associate_with_spring(sp_1_5);
    m1.associate_with_spring(sp_1_6);
    m1.associate_with_spring(sp_1_8);
    
    springs.add(sp_2_3); // index 10
    springs.add(sp_2_4); // index 11
    springs.add(sp_2_5); // index 12
    springs.add(sp_2_6); // index 13
    springs.add(sp_2_7); // index 14
    
    m2.associate_with_spring(sp_0_2);
    m2.associate_with_spring(sp_1_2);
    m2.associate_with_spring(sp_2_3);
    m2.associate_with_spring(sp_2_4);
    m2.associate_with_spring(sp_2_5);
    m2.associate_with_spring(sp_2_6);
    m2.associate_with_spring(sp_2_7);
    
    springs.add(sp_3_4); // index 15
    springs.add(sp_3_6); // index 16
    springs.add(sp_3_7); // index 17
    springs.add(sp_3_8); // index 18
    
    m3.associate_with_spring(sp_0_3);
    m3.associate_with_spring(sp_1_3);
    m3.associate_with_spring(sp_2_3);
    m3.associate_with_spring(sp_3_4);
    m3.associate_with_spring(sp_3_6);
    m3.associate_with_spring(sp_3_7);
    m3.associate_with_spring(sp_3_8);
    
    springs.add(sp_4_5); // index 19
    springs.add(sp_4_7); // index 20
    springs.add(sp_4_8); // index 21
    
    m4.associate_with_spring(sp_0_4);
    m4.associate_with_spring(sp_1_4);
    m4.associate_with_spring(sp_2_4);
    m4.associate_with_spring(sp_3_4);
    m4.associate_with_spring(sp_4_5);
    m4.associate_with_spring(sp_4_7);
    m4.associate_with_spring(sp_4_8);
    
    springs.add(sp_5_6); // index 22
    springs.add(sp_5_7); // index 23
    springs.add(sp_5_8); // index 24
    springs.add(sp_5_9); // index 25
    springs.add(sp_5_10); // index 26
    springs.add(sp_5_12); // index 27
    
    m5.associate_with_spring(sp_1_5);
    m5.associate_with_spring(sp_2_5);
    m5.associate_with_spring(sp_4_5);
    m5.associate_with_spring(sp_5_6);
    m5.associate_with_spring(sp_5_7);
    m5.associate_with_spring(sp_5_8);
    m5.associate_with_spring(sp_5_9);
    m5.associate_with_spring(sp_5_10);
    m5.associate_with_spring(sp_5_12);
    
    springs.add(sp_6_7); // index 28
    springs.add(sp_6_8); // index 29
    springs.add(sp_6_9); // index 30
    springs.add(sp_6_10); // index 31
    springs.add(sp_6_11); // index 32
    
    m6.associate_with_spring(sp_1_6);
    m6.associate_with_spring(sp_2_6);
    m6.associate_with_spring(sp_3_6);
    m6.associate_with_spring(sp_5_6);
    m6.associate_with_spring(sp_6_7);
    m6.associate_with_spring(sp_6_8);
    m6.associate_with_spring(sp_6_9);
    m6.associate_with_spring(sp_6_10);
    m6.associate_with_spring(sp_6_11);
    
    springs.add(sp_7_8); // index 33
    springs.add(sp_7_10); // index 34
    springs.add(sp_7_11); // index 35
    springs.add(sp_7_12); // index 36
    
    m7.associate_with_spring(sp_2_7);
    m7.associate_with_spring(sp_3_7);
    m7.associate_with_spring(sp_4_7);
    m7.associate_with_spring(sp_5_7);
    m7.associate_with_spring(sp_6_7);
    m7.associate_with_spring(sp_7_8);
    m7.associate_with_spring(sp_7_10);
    m7.associate_with_spring(sp_7_11);
    m7.associate_with_spring(sp_7_12);
    
    springs.add(sp_8_9); // index 37
    springs.add(sp_8_11); // index 38
    springs.add(sp_8_12); // index 39
    
    m8.associate_with_spring(sp_1_8);
    m8.associate_with_spring(sp_3_8);
    m8.associate_with_spring(sp_4_8);
    m8.associate_with_spring(sp_5_8);
    m8.associate_with_spring(sp_6_8);
    m8.associate_with_spring(sp_7_8);
    m8.associate_with_spring(sp_8_9);
    m8.associate_with_spring(sp_8_11);
    m8.associate_with_spring(sp_8_12);
    
    springs.add(sp_9_10); // index 40
    springs.add(sp_9_11); // index 41
    springs.add(sp_9_12); // index 42
    springs.add(sp_9_13); // index 43
    springs.add(sp_9_14); // index 44
    springs.add(sp_9_16); // index 45
    
    m9.associate_with_spring(sp_5_9);
    m9.associate_with_spring(sp_6_9);
    m9.associate_with_spring(sp_8_9);
    m9.associate_with_spring(sp_9_10);
    m9.associate_with_spring(sp_9_11);
    m9.associate_with_spring(sp_9_12);
    m9.associate_with_spring(sp_9_13);
    m9.associate_with_spring(sp_9_14);
    m9.associate_with_spring(sp_9_16);
    
    springs.add(sp_10_11); // index 46
    springs.add(sp_10_12); // index 47
    springs.add(sp_10_13); // index 48
    springs.add(sp_10_14); // index 49
    springs.add(sp_10_15); // index 50
    
    m10.associate_with_spring(sp_5_10);
    m10.associate_with_spring(sp_6_10);
    m10.associate_with_spring(sp_7_10);
    m10.associate_with_spring(sp_9_10);
    m10.associate_with_spring(sp_10_11);
    m10.associate_with_spring(sp_10_12);
    m10.associate_with_spring(sp_10_13);
    m10.associate_with_spring(sp_10_14);
    m10.associate_with_spring(sp_10_15);
    
    springs.add(sp_11_12); // index 51
    springs.add(sp_11_14); // index 52
    springs.add(sp_11_15); // index 53
    springs.add(sp_11_16); // index 54
    
    m11.associate_with_spring(sp_6_11);
    m11.associate_with_spring(sp_7_11);
    m11.associate_with_spring(sp_8_11);
    m11.associate_with_spring(sp_9_11);
    m11.associate_with_spring(sp_10_11);
    m11.associate_with_spring(sp_11_12);
    m11.associate_with_spring(sp_11_14);
    m11.associate_with_spring(sp_11_15);
    m11.associate_with_spring(sp_11_16);
    
    springs.add(sp_12_13); // index 55
    springs.add(sp_12_15); // index 56
    springs.add(sp_12_16); // index 57
    
    m12.associate_with_spring(sp_5_12);
    m12.associate_with_spring(sp_7_12);
    m12.associate_with_spring(sp_8_12);
    m12.associate_with_spring(sp_9_12);
    m12.associate_with_spring(sp_10_12);
    m12.associate_with_spring(sp_11_12);
    m12.associate_with_spring(sp_12_13);
    m12.associate_with_spring(sp_12_15);
    m12.associate_with_spring(sp_12_16);
    
    springs.add(sp_13_14); // index 58
    springs.add(sp_13_15); // index 59
    springs.add(sp_13_16); // index 60
    springs.add(sp_13_17); // index 61
    springs.add(sp_13_18); // index 62
    springs.add(sp_13_20); // index 63
    
    m13.associate_with_spring(sp_9_13);
    m13.associate_with_spring(sp_10_13);
    m13.associate_with_spring(sp_12_13);
    m13.associate_with_spring(sp_13_14);
    m13.associate_with_spring(sp_13_15);
    m13.associate_with_spring(sp_13_16);
    m13.associate_with_spring(sp_13_17);
    m13.associate_with_spring(sp_13_18);
    m13.associate_with_spring(sp_13_20);
    
    springs.add(sp_14_15); // index 64
    springs.add(sp_14_16); // index 65
    springs.add(sp_14_17); // index 66
    springs.add(sp_14_18); // index 67
    springs.add(sp_14_19); // index 68
    
    m14.associate_with_spring(sp_9_14);
    m14.associate_with_spring(sp_10_14);
    m14.associate_with_spring(sp_11_14);
    m14.associate_with_spring(sp_13_14);
    m14.associate_with_spring(sp_14_15);
    m14.associate_with_spring(sp_14_16);
    m14.associate_with_spring(sp_14_17);
    m14.associate_with_spring(sp_14_18);
    m14.associate_with_spring(sp_14_19);
    
    springs.add(sp_15_16); // index 69
    springs.add(sp_15_18); // index 70
    springs.add(sp_15_19); // index 71
    springs.add(sp_15_20); // index 72
    
    m15.associate_with_spring(sp_10_15);
    m15.associate_with_spring(sp_11_15);
    m15.associate_with_spring(sp_12_15);
    m15.associate_with_spring(sp_13_15);
    m15.associate_with_spring(sp_14_15);
    m15.associate_with_spring(sp_15_16);
    m15.associate_with_spring(sp_15_18);
    m15.associate_with_spring(sp_15_19);
    m15.associate_with_spring(sp_15_20);
    
    springs.add(sp_16_17); // index 73
    springs.add(sp_16_19); // index 74
    springs.add(sp_16_20); // index 75
    
    m16.associate_with_spring(sp_9_16);
    m16.associate_with_spring(sp_11_16);
    m16.associate_with_spring(sp_12_16);
    m16.associate_with_spring(sp_13_16);
    m16.associate_with_spring(sp_14_16);
    m16.associate_with_spring(sp_15_16);
    m16.associate_with_spring(sp_16_17);
    m16.associate_with_spring(sp_16_19);
    m16.associate_with_spring(sp_16_20);
    
    springs.add(sp_17_18); // index 76
    springs.add(sp_17_19); // index 77
    springs.add(sp_17_20); // index 78
    springs.add(sp_17_21); // index 79
    springs.add(sp_17_22); // index 80
    
    m17.associate_with_spring(sp_13_17);
    m17.associate_with_spring(sp_14_17);
    m17.associate_with_spring(sp_16_17);
    m17.associate_with_spring(sp_17_18);
    m17.associate_with_spring(sp_17_19);
    m17.associate_with_spring(sp_17_20);
    m17.associate_with_spring(sp_17_21);
    m17.associate_with_spring(sp_17_22);
    
    springs.add(sp_18_19); // index 81
    springs.add(sp_18_20); // index 82
    springs.add(sp_18_21); // index 83
    springs.add(sp_18_22); // index 84
    
    m18.associate_with_spring(sp_13_18);
    m18.associate_with_spring(sp_14_18);
    m18.associate_with_spring(sp_15_18);
    m18.associate_with_spring(sp_17_18);
    m18.associate_with_spring(sp_18_19);
    m18.associate_with_spring(sp_18_20);
    m18.associate_with_spring(sp_18_21);
    m18.associate_with_spring(sp_18_22);
    
    springs.add(sp_19_20); // index 85
    springs.add(sp_19_21); // index 86
    springs.add(sp_19_22); // index 87
    
    m19.associate_with_spring(sp_14_19);
    m19.associate_with_spring(sp_15_19);
    m19.associate_with_spring(sp_16_19);
    m19.associate_with_spring(sp_17_19);
    m19.associate_with_spring(sp_18_19);
    m19.associate_with_spring(sp_19_20);
    m19.associate_with_spring(sp_19_21);
    m19.associate_with_spring(sp_19_22);
    
    springs.add(sp_20_21); // index 88
    springs.add(sp_20_22); // index 89
    
    m20.associate_with_spring(sp_13_20);
    m20.associate_with_spring(sp_15_20);
    m20.associate_with_spring(sp_16_20);
    m20.associate_with_spring(sp_17_20);
    m20.associate_with_spring(sp_18_20);
    m20.associate_with_spring(sp_19_20);
    m20.associate_with_spring(sp_20_21);
    m20.associate_with_spring(sp_20_22);
    
    springs.add(sp_21_22); // index 90
    
    m21.associate_with_spring(sp_17_21);
    m21.associate_with_spring(sp_18_21);
    m21.associate_with_spring(sp_19_21);
    m21.associate_with_spring(sp_20_21);
    m21.associate_with_spring(sp_21_22);
    m22.associate_with_spring(sp_17_22);
    m22.associate_with_spring(sp_18_22);
    m22.associate_with_spring(sp_19_22);
    m22.associate_with_spring(sp_20_22);
    m22.associate_with_spring(sp_21_22);
    
    
    // List of surfaces
    Mass [] neighbors_1 = {m0, m1, m2, m3, m4};
    Surface sf_0_1_2 = new Surface(m0, m1, m2, neighbors_1);
    Surface sf_0_1_4 = new Surface(m0, m1, m4, neighbors_1);
    Surface sf_0_3_4 = new Surface(m0, m3, m4, neighbors_1);
    Surface sf_0_2_3 = new Surface(m0, m2, m3, neighbors_1);
    
    Mass [] neighbors_2 = {m1, m2, m3, m4, m5, m6, m7, m8};
    Surface sf_1_2_5 = new Surface(m1, m2, m5, neighbors_2);
    Surface sf_1_2_6 = new Surface(m1, m2, m6, neighbors_2);
    Surface sf_1_5_6 = new Surface(m1, m5, m6, neighbors_2);
    Surface sf_2_5_6 = new Surface(m2, m5, m6, neighbors_2);
    Surface sf_1_4_5 = new Surface(m1, m4, m5, neighbors_2);
    Surface sf_1_4_8 = new Surface(m1, m4, m8, neighbors_2);
    Surface sf_1_5_8 = new Surface(m1, m5, m8, neighbors_2);
    Surface sf_4_5_8 = new Surface(m4, m5, m8, neighbors_2);
    Surface sf_3_4_7 = new Surface(m3, m4, m7, neighbors_2);
    Surface sf_3_4_8 = new Surface(m3, m4, m8, neighbors_2);
    Surface sf_3_7_8 = new Surface(m3, m7, m8, neighbors_2);
    Surface sf_4_7_8 = new Surface(m4, m7, m8, neighbors_2);
    Surface sf_2_3_6 = new Surface(m2, m3, m6, neighbors_2);
    Surface sf_2_3_7 = new Surface(m2, m3, m7, neighbors_2);
    Surface sf_2_6_7 = new Surface(m2, m6, m7, neighbors_2);
    Surface sf_3_6_7 = new Surface(m3, m6, m7, neighbors_2);
    
    Mass [] neighbors_3 = {m5, m6, m7, m8, m9, m10, m11, m12};
    Surface sf_5_6_9 = new Surface(m5, m6, m9, neighbors_3);
    Surface sf_5_6_10 = new Surface(m5, m6, m10, neighbors_3);
    Surface sf_5_9_10 = new Surface(m5, m9, m10, neighbors_3);
    Surface sf_6_9_10 = new Surface(m6, m9, m10, neighbors_3);
    Surface sf_5_8_9 = new Surface(m5, m8, m9, neighbors_3);
    Surface sf_5_8_12 = new Surface(m5, m8, m12, neighbors_3);
    Surface sf_5_9_12 = new Surface(m5, m9, m12, neighbors_3);
    Surface sf_8_9_12 = new Surface(m8, m9, m12, neighbors_3);
    Surface sf_7_8_11 = new Surface(m7, m8, m11, neighbors_3);
    Surface sf_7_8_12 = new Surface(m7, m8, m12, neighbors_3);
    Surface sf_7_11_12 = new Surface(m7, m11, m12, neighbors_3);
    Surface sf_8_11_12 = new Surface(m8, m11, m12, neighbors_3);
    Surface sf_6_7_10 = new Surface(m6, m7, m10, neighbors_3);
    Surface sf_6_7_11 = new Surface(m6, m7, m11, neighbors_3);
    Surface sf_6_10_11 = new Surface(m6, m10, m11, neighbors_3);
    Surface sf_7_10_11 = new Surface(m7, m10, m11, neighbors_3);
    
    Mass [] neighbors_4 = {m9, m10, m11, m12, m13, m14, m15, m16};
    Surface sf_9_10_13 = new Surface(m9, m10, m13, neighbors_4);
    Surface sf_9_10_14 = new Surface(m9, m10, m14, neighbors_4);
    Surface sf_9_13_14 = new Surface(m9, m13, m14, neighbors_4);
    Surface sf_10_13_14 = new Surface(m10, m13, m14, neighbors_4);
    Surface sf_9_12_13 = new Surface(m9, m12, m13, neighbors_4);
    Surface sf_9_12_16 = new Surface(m9, m12, m16, neighbors_4);
    Surface sf_9_13_16 = new Surface(m9, m13, m16, neighbors_4);
    Surface sf_12_13_16 = new Surface(m12, m13, m16, neighbors_4);
    Surface sf_11_12_15 = new Surface(m11, m12, m15, neighbors_4);
    Surface sf_11_12_16 = new Surface(m11, m12, m16, neighbors_4);
    Surface sf_11_15_16 = new Surface(m11, m15, m16, neighbors_4);
    Surface sf_12_15_16 = new Surface(m12, m15, m16, neighbors_4);
    Surface sf_10_11_14 = new Surface(m10, m11, m14, neighbors_4);
    Surface sf_10_11_15 = new Surface(m10, m11, m15, neighbors_4);
    Surface sf_10_14_15 = new Surface(m10, m14, m15, neighbors_4);
    Surface sf_11_14_15 = new Surface(m11, m14, m15, neighbors_4);
    
    Mass [] neighbors_5 = {m13, m14, m15, m16, m17, m18, m19, m20};
    Surface sf_13_14_17 = new Surface(m13, m14, m17, neighbors_5);
    Surface sf_13_14_18 = new Surface(m13, m14, m18, neighbors_5);
    Surface sf_13_17_18 = new Surface(m13, m17, m18, neighbors_5);
    Surface sf_14_17_18 = new Surface(m14, m17, m18, neighbors_5);
    Surface sf_13_16_17 = new Surface(m13, m16, m17, neighbors_5);
    Surface sf_13_16_20 = new Surface(m13, m16, m20, neighbors_5);
    Surface sf_13_17_20 = new Surface(m13, m17, m20, neighbors_5);
    Surface sf_16_17_20 = new Surface(m16, m17, m20, neighbors_5);
    Surface sf_15_16_19 = new Surface(m15, m16, m19, neighbors_5);
    Surface sf_15_16_20 = new Surface(m15, m16, m20, neighbors_5);
    Surface sf_15_19_20 = new Surface(m15, m19, m20, neighbors_5);
    Surface sf_16_19_20 = new Surface(m16, m19, m20, neighbors_5);
    Surface sf_14_15_18 = new Surface(m14, m15, m18, neighbors_5);
    Surface sf_14_15_19 = new Surface(m14, m15, m19, neighbors_5);
    Surface sf_14_18_19 = new Surface(m14, m18, m19, neighbors_5);
    Surface sf_15_18_19 = new Surface(m15, m18, m19, neighbors_5);
    
    Mass [] neighbors_6 = {m17, m18, m19, m20, m21};
    Surface sf_17_18_21 = new Surface(m17, m18, m21, neighbors_6);
    Surface sf_17_20_21 = new Surface(m17, m20, m21, neighbors_6);
    Surface sf_17_20_22 = new Surface(m17, m20, m22, neighbors_6);
    Surface sf_17_21_22 = new Surface(m17, m21, m22, neighbors_6);
    Surface sf_20_21_22 = new Surface(m20, m21, m22, neighbors_6);
    Surface sf_19_20_22 = new Surface(m19, m20, m22, neighbors_6);
    Surface sf_18_19_21 = new Surface(m18, m19, m21, neighbors_6);
    Surface sf_18_19_22 = new Surface(m18, m19, m22, neighbors_6);
    Surface sf_18_21_22 = new Surface(m18, m21, m22, neighbors_6);
    Surface sf_19_21_22 = new Surface(m19, m21, m22, neighbors_6);
    
    m0.associate_with_surface(sf_0_1_2);
    m0.associate_with_surface(sf_0_1_4);
    m0.associate_with_surface(sf_0_3_4);
    m0.associate_with_surface(sf_0_2_3);
    
    surfaces.add(sf_0_1_2); // index 0
    surfaces.add(sf_0_1_4); // index 1
    surfaces.add(sf_0_2_3); // index 2
    surfaces.add(sf_0_3_4); // index 3
    
    m1.associate_with_surface(sf_0_1_2);
    m1.associate_with_surface(sf_0_1_4);
    m1.associate_with_surface(sf_1_2_5);
    m1.associate_with_surface(sf_1_2_6);
    m1.associate_with_surface(sf_1_4_5);
    m1.associate_with_surface(sf_1_4_8);
    m1.associate_with_surface(sf_1_5_6);
    m1.associate_with_surface(sf_1_5_8);
    
    surfaces.add(sf_1_2_5); // index 4
    surfaces.add(sf_1_2_6); // index 5
    surfaces.add(sf_1_4_5); // index 6
    surfaces.add(sf_1_4_8); // index 7
    surfaces.add(sf_1_5_6); // index 8
    surfaces.add(sf_1_5_8); // index 9
    
    m2.associate_with_surface(sf_0_1_2);
    m2.associate_with_surface(sf_0_2_3);
    m2.associate_with_surface(sf_1_2_5);
    m2.associate_with_surface(sf_1_2_6);
    m2.associate_with_surface(sf_2_3_6);
    m2.associate_with_surface(sf_2_3_7);
    m2.associate_with_surface(sf_2_5_6);
    m2.associate_with_surface(sf_2_6_7);
    
    surfaces.add(sf_2_3_6); // index 10
    surfaces.add(sf_2_3_7); // index 11
    surfaces.add(sf_2_5_6); // index 12
    surfaces.add(sf_2_6_7);  // index 13
    
    m3.associate_with_surface(sf_0_2_3);
    m3.associate_with_surface(sf_0_3_4);
    m3.associate_with_surface(sf_2_3_6);
    m3.associate_with_surface(sf_2_3_7);
    m3.associate_with_surface(sf_3_4_7);
    m3.associate_with_surface(sf_3_4_8);
    m3.associate_with_surface(sf_3_6_7);
    m3.associate_with_surface(sf_3_7_8);
    
    surfaces.add(sf_3_4_7); // index 14
    surfaces.add(sf_3_4_8); // index 15
    surfaces.add(sf_3_6_7); // index 16
    surfaces.add(sf_3_7_8); // index 17
    
    m4.associate_with_surface(sf_0_1_4);
    m4.associate_with_surface(sf_0_3_4);
    m4.associate_with_surface(sf_1_4_5);
    m4.associate_with_surface(sf_1_4_8);
    m4.associate_with_surface(sf_3_4_7);
    m4.associate_with_surface(sf_3_4_8);
    m4.associate_with_surface(sf_4_5_8);
    m4.associate_with_surface(sf_4_7_8);
    
    surfaces.add(sf_4_5_8); // index 18
    surfaces.add(sf_4_7_8); // index 19
    
    m5.associate_with_surface(sf_1_2_5);
    m5.associate_with_surface(sf_1_4_5);
    m5.associate_with_surface(sf_1_5_6);
    m5.associate_with_surface(sf_1_5_8);
    m5.associate_with_surface(sf_2_5_6);
    m5.associate_with_surface(sf_4_5_8);
    m5.associate_with_surface(sf_5_6_9);
    m5.associate_with_surface(sf_5_6_10);
    m5.associate_with_surface(sf_5_8_9);
    m5.associate_with_surface(sf_5_8_12);
    m5.associate_with_surface(sf_5_9_10);
    m5.associate_with_surface(sf_5_9_12);
    
    surfaces.add(sf_5_6_9); // index 20
    surfaces.add(sf_5_6_10); // index 21
    surfaces.add(sf_5_8_9); // index 22
    surfaces.add(sf_5_8_12); // index 23
    surfaces.add(sf_5_9_10); // index 24
    surfaces.add(sf_5_9_12); // index 25
    
    m6.associate_with_surface(sf_1_2_6);
    m6.associate_with_surface(sf_1_5_6);
    m6.associate_with_surface(sf_2_3_6);
    m6.associate_with_surface(sf_2_5_6);
    m6.associate_with_surface(sf_2_6_7);
    m6.associate_with_surface(sf_3_6_7);
    m6.associate_with_surface(sf_5_6_9);
    m6.associate_with_surface(sf_5_6_10);
    m6.associate_with_surface(sf_6_7_10);
    m6.associate_with_surface(sf_6_7_11);
    m6.associate_with_surface(sf_6_9_10);
    m6.associate_with_surface(sf_6_10_11);
    
    surfaces.add(sf_6_7_10); // index 26
    surfaces.add(sf_6_7_11); // index 27
    surfaces.add(sf_6_9_10); // index 28
    surfaces.add(sf_6_10_11); // index 29
    
    m7.associate_with_surface(sf_2_3_7);
    m7.associate_with_surface(sf_2_6_7);
    m7.associate_with_surface(sf_3_4_7);
    m7.associate_with_surface(sf_3_6_7);
    m7.associate_with_surface(sf_3_7_8);
    m7.associate_with_surface(sf_4_7_8);
    m7.associate_with_surface(sf_6_7_10);
    m7.associate_with_surface(sf_6_7_11);
    m7.associate_with_surface(sf_7_8_11);
    m7.associate_with_surface(sf_7_8_12);
    m7.associate_with_surface(sf_7_10_11);
    m7.associate_with_surface(sf_7_11_12);
    
    surfaces.add(sf_7_8_11); // index 30
    surfaces.add(sf_7_8_12); // index 31
    surfaces.add(sf_7_10_11); // index 32
    surfaces.add(sf_7_11_12); // index 33
    
    m8.associate_with_surface(sf_1_4_8);
    m8.associate_with_surface(sf_1_5_8);
    m8.associate_with_surface(sf_3_4_8);
    m8.associate_with_surface(sf_3_7_8);
    m8.associate_with_surface(sf_4_5_8);
    m8.associate_with_surface(sf_4_7_8);
    m8.associate_with_surface(sf_5_8_9);
    m8.associate_with_surface(sf_5_8_12);
    m8.associate_with_surface(sf_7_8_11);
    m8.associate_with_surface(sf_7_8_12);
    m8.associate_with_surface(sf_8_9_12);
    m8.associate_with_surface(sf_8_11_12);
    
    surfaces.add(sf_8_9_12); // index 34
    surfaces.add(sf_8_11_12); // index 35
    
    m9.associate_with_surface(sf_5_6_9);
    m9.associate_with_surface(sf_5_8_9);
    m9.associate_with_surface(sf_5_9_10);
    m9.associate_with_surface(sf_5_9_12);
    m9.associate_with_surface(sf_6_9_10);
    m9.associate_with_surface(sf_8_9_12);
    m9.associate_with_surface(sf_9_10_13);
    m9.associate_with_surface(sf_9_10_14);
    m9.associate_with_surface(sf_9_12_13);
    m9.associate_with_surface(sf_9_12_16);
    m9.associate_with_surface(sf_9_13_14);
    m9.associate_with_surface(sf_9_13_16);
    
    surfaces.add(sf_9_10_13); // index 36
    surfaces.add(sf_9_10_14); // index 37
    surfaces.add(sf_9_12_13); // index 38
    surfaces.add(sf_9_12_16); // index 39
    surfaces.add(sf_9_13_14); // index 40
    surfaces.add(sf_9_13_16);  // index 41
    
    m10.associate_with_surface(sf_5_6_10);
    m10.associate_with_surface(sf_5_9_10);
    m10.associate_with_surface(sf_6_7_10);
    m10.associate_with_surface(sf_6_9_10);
    m10.associate_with_surface(sf_6_10_11);
    m10.associate_with_surface(sf_7_10_11);
    m10.associate_with_surface(sf_9_10_13);
    m10.associate_with_surface(sf_9_10_14);
    m10.associate_with_surface(sf_10_11_14);
    m10.associate_with_surface(sf_10_11_15);
    m10.associate_with_surface(sf_10_13_14);
    m10.associate_with_surface(sf_10_14_15);
    
    surfaces.add(sf_10_11_14); // index 42
    surfaces.add(sf_10_11_15); // index 43
    surfaces.add(sf_10_13_14); // index 44
    surfaces.add(sf_10_14_15); // index 45
    
    m11.associate_with_surface(sf_6_7_11);
    m11.associate_with_surface(sf_6_10_11);
    m11.associate_with_surface(sf_7_8_11);
    m11.associate_with_surface(sf_7_10_11);
    m11.associate_with_surface(sf_7_11_12);
    m11.associate_with_surface(sf_8_11_12);
    m11.associate_with_surface(sf_10_11_14);
    m11.associate_with_surface(sf_10_11_15);
    m11.associate_with_surface(sf_11_12_15);
    m11.associate_with_surface(sf_11_12_16);
    m11.associate_with_surface(sf_11_14_15);
    m11.associate_with_surface(sf_11_15_16);
    
    surfaces.add(sf_11_12_15); // index 46
    surfaces.add(sf_11_12_16); // index 47
    surfaces.add(sf_11_14_15); // index 48
    surfaces.add(sf_11_15_16); // index 49
    
    m12.associate_with_surface(sf_5_8_12);
    m12.associate_with_surface(sf_5_9_12);
    m12.associate_with_surface(sf_7_8_12);
    m12.associate_with_surface(sf_7_11_12);
    m12.associate_with_surface(sf_8_11_12);
    m12.associate_with_surface(sf_8_9_12);
    m12.associate_with_surface(sf_8_11_12);
    m12.associate_with_surface(sf_9_12_13);
    m12.associate_with_surface(sf_11_12_15);
    m12.associate_with_surface(sf_11_12_16);
    m12.associate_with_surface(sf_12_13_16);
    m12.associate_with_surface(sf_12_15_16);
    
    surfaces.add(sf_12_13_16); // index 50
    surfaces.add(sf_12_15_16); // index 51
    
    m13.associate_with_surface(sf_9_13_14);
    m13.associate_with_surface(sf_10_13_14);
    m13.associate_with_surface(sf_9_10_13);
    m13.associate_with_surface(sf_9_12_13);
    m13.associate_with_surface(sf_10_13_14);
    m13.associate_with_surface(sf_12_13_16);
    m13.associate_with_surface(sf_13_14_17);
    m13.associate_with_surface(sf_13_14_18);
    m13.associate_with_surface(sf_13_16_17);
    m13.associate_with_surface(sf_13_16_20);
    m13.associate_with_surface(sf_13_17_18);
    m13.associate_with_surface(sf_13_17_20);
    
    surfaces.add(sf_13_14_17); // index 52
    surfaces.add(sf_13_14_18); // index 53
    surfaces.add(sf_13_16_17); // index 54
    surfaces.add(sf_13_16_20); // index 55
    surfaces.add(sf_13_17_18); // index 56
    surfaces.add(sf_13_17_20); // index 57
    
    m14.associate_with_surface(sf_9_10_14);
    m14.associate_with_surface(sf_9_13_14);
    m14.associate_with_surface(sf_10_11_14);
    m14.associate_with_surface(sf_10_13_14);
    m14.associate_with_surface(sf_10_14_15);
    m14.associate_with_surface(sf_11_14_15);
    m14.associate_with_surface(sf_13_14_17);
    m14.associate_with_surface(sf_13_14_18);
    m14.associate_with_surface(sf_14_15_18);
    m14.associate_with_surface(sf_14_15_19);
    m14.associate_with_surface(sf_14_17_18);
    m14.associate_with_surface(sf_14_18_19);
    
    surfaces.add(sf_14_15_18); // index 58
    surfaces.add(sf_14_15_19); // index 59
    surfaces.add(sf_14_17_18); // index 60
    surfaces.add(sf_14_18_19);  // index 61
    
    m15.associate_with_surface(sf_10_11_15);
    m15.associate_with_surface(sf_10_14_15);
    m15.associate_with_surface(sf_11_12_15);
    m15.associate_with_surface(sf_11_14_15);
    m15.associate_with_surface(sf_11_15_16);
    m15.associate_with_surface(sf_12_15_16);
    m15.associate_with_surface(sf_14_15_18);
    m15.associate_with_surface(sf_14_15_19);
    m15.associate_with_surface(sf_15_16_19);
    m15.associate_with_surface(sf_15_16_20);
    m15.associate_with_surface(sf_15_18_19);
    m15.associate_with_surface(sf_15_19_20);
    
    surfaces.add(sf_15_16_19); // index 62
    surfaces.add(sf_15_16_20); // index 63
    surfaces.add(sf_15_18_19); // index 64
    surfaces.add(sf_15_19_20); // index 65
    
    m16.associate_with_surface(sf_9_12_16);
    m16.associate_with_surface(sf_9_13_16);
    m16.associate_with_surface(sf_11_12_16);
    m16.associate_with_surface(sf_11_15_16);
    m16.associate_with_surface(sf_12_13_16);
    m16.associate_with_surface(sf_12_15_16);
    m16.associate_with_surface(sf_13_16_17);
    m16.associate_with_surface(sf_13_16_20);
    m16.associate_with_surface(sf_15_16_19);
    m16.associate_with_surface(sf_15_16_20);
    m16.associate_with_surface(sf_16_17_20);
    m16.associate_with_surface(sf_16_19_20);
    
    surfaces.add(sf_16_17_20); // index 66
    surfaces.add(sf_16_19_20); // index 67
    
    m17.associate_with_surface(sf_13_14_17);
    m17.associate_with_surface(sf_13_16_17);
    m17.associate_with_surface(sf_13_17_18);
    m17.associate_with_surface(sf_13_17_20);
    m17.associate_with_surface(sf_14_17_18);
    m17.associate_with_surface(sf_16_17_20);
    m17.associate_with_surface(sf_17_18_21);
    m17.associate_with_surface(sf_17_20_21);
    m17.associate_with_surface(sf_17_20_22);
    m17.associate_with_surface(sf_17_21_22);
    
    surfaces.add(sf_17_18_21); // index 68
    surfaces.add(sf_17_20_21); // index 69
    surfaces.add(sf_17_20_22); // index 70
    surfaces.add(sf_17_21_22); // index 71
    
    m18.associate_with_surface(sf_13_14_18);
    m18.associate_with_surface(sf_13_17_18);
    m18.associate_with_surface(sf_14_15_18);
    m18.associate_with_surface(sf_14_17_18);
    m18.associate_with_surface(sf_14_18_19);
    m18.associate_with_surface(sf_15_18_19);
    m18.associate_with_surface(sf_17_18_21);
    m18.associate_with_surface(sf_18_19_21);
    m18.associate_with_surface(sf_18_19_22);
    m18.associate_with_surface(sf_18_21_22);
    
    surfaces.add(sf_18_19_21); // index 72
    surfaces.add(sf_18_19_22); // index 73
    surfaces.add(sf_18_21_22); // index 74
    
    m19.associate_with_surface(sf_14_15_19);
    m19.associate_with_surface(sf_14_18_19);
    m19.associate_with_surface(sf_15_16_19);
    m19.associate_with_surface(sf_15_18_19);
    m19.associate_with_surface(sf_15_19_20);
    m19.associate_with_surface(sf_16_19_20);
    m19.associate_with_surface(sf_18_19_21);
    m19.associate_with_surface(sf_18_19_22);
    m19.associate_with_surface(sf_19_20_22);
    m19.associate_with_surface(sf_19_21_22);
    
    surfaces.add(sf_19_20_22); // index 75
    surfaces.add(sf_19_21_22); // index 76
    
    m20.associate_with_surface(sf_13_16_20);
    m20.associate_with_surface(sf_13_17_20);
    m20.associate_with_surface(sf_15_16_20);
    m20.associate_with_surface(sf_15_19_20);
    m20.associate_with_surface(sf_16_17_20);
    m20.associate_with_surface(sf_16_19_20);
    m20.associate_with_surface(sf_17_20_21);
    m20.associate_with_surface(sf_17_20_22);
    m20.associate_with_surface(sf_19_20_22);
    m20.associate_with_surface(sf_20_21_22);
    
    surfaces.add(sf_20_21_22); // index 77
    
    m21.associate_with_surface(sf_17_18_21);
    m21.associate_with_surface(sf_17_20_21);
    m21.associate_with_surface(sf_17_21_22);
    m21.associate_with_surface(sf_18_19_21);
    m21.associate_with_surface(sf_18_21_22);
    m21.associate_with_surface(sf_19_21_22);
    m21.associate_with_surface(sf_20_21_22);
    
    m22.associate_with_surface(sf_17_20_22);
    m22.associate_with_surface(sf_17_21_22);
    m22.associate_with_surface(sf_18_19_22);
    m22.associate_with_surface(sf_18_21_22);
    m22.associate_with_surface(sf_19_20_22);
    m22.associate_with_surface(sf_19_21_22); 
    m22.associate_with_surface(sf_20_21_22);
    
    // 'finArea' is simply the average size of all surfaces 
    for (Surface surf : surfaces) {
      finArea += surf.Area;
    }
    finArea /= surfaces.size();
    
    // Find the center of mass
    float total_mass = 0.0;
    for (Mass m : masses) {
      total_mass += m.mass;
      center_mass.add(PVector.mult(m.position, m.mass));
    }
    center_mass.div(total_mass);
  }
  
  /**
  * Determine the trout's current orientation in space including:
  * 1) Its angle in relation to the x-y axis - i.e. up-and-down (ang_Y)
  * 2) Its angle in relation to the x-z axis - i.e. side-to-side (ang_Z)
  * 3) The left and right angles of unbalance - i.e. the degree 
  *    to which the trout is rolled over on one side or the other (right_tilt & left_tilt)
  * 4) Its angle in relation to x-y axis away from its target (elevation)
  * 5) Its angle in relation to the x-z axis away from its target (turn)
  * 6) Its velocity (avg_veloc)
  *
  * @return orientation - orientation.x is #4, orientation.y is #5, orientation.z is #6
  */
  PVector findOrientation() {
    
    // Determine the trout's current orientation 
    PVector center = PVector.add(masses.get(5).position, masses.get(6).position).add(masses.get(7).position).add(masses.get(8).position);
    center.div(4.0);
    PVector for_dir = PVector.sub(masses.get(0).position, center);
    float upward_angle = asin(for_dir.y / for_dir.mag());
    if (upward_angle < 0.0 && for_dir.x < 0.0) {
      upward_angle = -PI - upward_angle;
    } else if (upward_angle > 0.0 && for_dir.x < 0.0) {
      upward_angle = PI - upward_angle;
    }
    float temp = (upward_angle < 0.0) ? upward_angle + TWO_PI : upward_angle;
    float side_angle = asin(for_dir.z / (for_dir.mag() * cos(temp)));
    if (side_angle < 0.0 && for_dir.x < 0.0) {
      side_angle = -PI - side_angle;
    } else if (side_angle > 0.0 && for_dir.x < 0.0) {
      side_angle = PI - side_angle;
    }
    this.ang_Y = (upward_angle < 0.0) ? upward_angle + TWO_PI : upward_angle;
    this.ang_Z = (side_angle < 0.0) ? side_angle + TWO_PI : side_angle;
    
    // Determine imbalances on right and left sides 
    PVector right_dir = PVector.sub(masses.get(6).position, masses.get(5).position);
    right_dir.add(PVector.sub(masses.get(7).position, masses.get(8).position)).div(2.0);
    this.right_tilt = asin(right_dir.y / right_dir.mag());
    if (this.right_tilt < 0.0) this.right_tilt += TWO_PI;
    PVector left_dir = PVector.sub(masses.get(5).position, masses.get(6).position);
    left_dir.add(PVector.sub(masses.get(8).position, masses.get(7).position)).div(2.0);
    this.left_tilt = asin(left_dir.y / left_dir.mag());
    if (this.left_tilt < 0.0) this.left_tilt += TWO_PI;
    
    // Determine angles from trout's nose to target
    PVector route = PVector.sub(destination, masses.get(0).position);
    //debug4.set(route);
    float route_elev = asin(route.y / route.mag());
    if (route_elev < 0.0 && route.x < 0.0) {
      route_elev = -PI - route_elev;
    } else if (route_elev > 0.0 && route.x < 0.0) {
      route_elev = PI - route_elev;
    }
    temp = (route_elev < 0.0) ? route_elev + TWO_PI : route_elev;
    float route_side = asin(route.z / (route.mag() * cos(temp)));
    if (route_side < 0.0 && route.x < 0.0) {
      route_side = -PI - route_side;
    } else if (route_side > 0.0 && route.x < 0.0) {
      route_side = PI - route_side;
    }
    
    // Determine necessary adjustments to trout's trajectory in order to reach target
    float elevation = 0.0;
    float difference1 = abs(temp - this.ang_Y);
    float difference2 = TWO_PI - difference1;
    if (difference1 < difference2) elevation = ang_Y - temp;
    else if (difference2 < difference1) elevation = upward_angle - route_elev;
    if (elevation < 0.0) elevation += TWO_PI;
    temp = (route_side < 0.0) ? route_side + TWO_PI : route_side;
    float turn = 0.0;
    difference1 = abs(temp - this.ang_Z);
    difference2 = TWO_PI - difference1;
    if (difference1 < difference2) turn = ang_Z - temp;
    else if (difference2 < difference1) turn = side_angle - route_side;
    if (turn < 0.0) turn += TWO_PI;
    
    // Determine the forward velocity of the trout
    float avg_veloc = 0.0;
    for (int i = 1; i < 13; i++) {
      avg_veloc += masses.get(i).velocity.x;
    }
    avg_veloc /= 12;
    
    PVector orientation = new PVector(elevation, turn, avg_veloc);
    return orientation;
  }
  
  /**
  * Applys force of imagined pectoral fins. Results in 'Lift' -
  * the ascent or descent of the trout in water
  *
  * @param angle - angle of elevation of the force vector 
  * @param veloc - the current velocity of the trout 
  * @param unit_normal - the unit normal vector of the force 
  * @return force - the vector of the force being applied to the body
  */
  PVector applyFinForce(float angle, float veloc, PVector unit_normal) {
    if (veloc < 0.0) veloc *= -1;
    
    float scalar = this.finArea * (veloc * cos(angle));
    PVector force = PVector.mult(unit_normal, scalar);
   
    return force;
  }
  
  /**
  * Separation steering force that guides trout away from collisions
  *
  * @param fish - array list of other trout in simulation
  * @return repelling_force - PVector of the force separating different trout
  */
  PVector separate(ArrayList<Trout> fish) {
    PVector repelling_force = new PVector(0, 0);
    int count = 0;
    for (Trout t : fish) {
      float distance = PVector.dist(this.center_mass, t.center_mass);
      if ((distance > 1.0) && (distance < 250.0)) {
        count++;
        PVector difference = PVector.sub(this.center_mass, t.center_mass);
        difference.normalize();
        difference.div(distance);
        repelling_force.add(difference);
      }
    }
    
    // Now calculate change in acceleration
    if (count > 0) {
      repelling_force.div(float(count));
    }
    PVector veloc = new PVector(0.0, 0.0, 0.0);
    for (int i = 1; i < 13; i++) {
      veloc.add(masses.get(i).velocity);
    }
    veloc.div(12.0);
    if (repelling_force.mag() > 0) {
      repelling_force.setMag(2.0);
      repelling_force.sub(veloc);
      repelling_force.limit(0.05);
    }
    
    return repelling_force;
  }
  
  /**
  * Updates all forces acting on trout and subsequently determines trout's 
  * velocity
  *
  * @param orientation - PVector that contains information found in 'findOrientation' method
  * @param action - int that determines how force from pectoral fins will be applied
  */
  void update(PVector orientation, int action, PVector separation) {
    
    for (Spring sprg : springs) { // Update spring forces 
      sprg.update();
    }
    for (Surface surf : surfaces) { // Update surface forces
      surf.update();
    }
    
    ArrayList<PVector> forces = new ArrayList<PVector>(); 
    for (Mass m : masses) {
      
      // Determine the net spring forces acting on mass
      PVector sprgForces = new PVector(0.0, 0.0, 0.0);
      for (Spring sprg : m.associated_springs) {
        int idx = sprg.associated_masses.indexOf(m);
        if (idx == 1) {
          sprgForces.add(sprg.force);
        } else {
          sprgForces.sub(sprg.force);
        }
      }
      
      // Determine the net external force on mass from all the surfaces it is associated with
      PVector external_force = new PVector(0.0, 0.0, 0.0);
      for (Surface surf : m.associated_surfaces) {
        float theta = asin(surf.force.y / surf.force.mag());
        if (theta < 0.0 && surf.force.x < 0.0) {
          theta = -PI - theta;
        } else if (theta > 0.0 && surf.force.x < 0.0) {
          theta = PI - theta;
        }
        float temp = (theta < 0.0) ? theta + TWO_PI : theta;
        float phi = asin(surf.force.z / (surf.force.mag() * cos(temp)));
        if (phi < 0.0 && surf.force.x < 0.0) {
          phi = -PI - theta;
        } else if (phi > 0.0 && surf.force.x < 0.0) {
          phi = PI - theta;
        }
        float veloc_theta = asin(m.velocity.y / m.velocity.mag());
        if (veloc_theta < 0.0 && m.velocity.x < 0.0) {
          veloc_theta = -PI - veloc_theta;
        } else if (veloc_theta > 0.0 && m.velocity.x < 0.0) {
          veloc_theta = PI - veloc_theta;
        }
        temp = (veloc_theta < 0.0) ? veloc_theta + TWO_PI : veloc_theta;
        float veloc_phi = asin(m.velocity.z / (m.velocity.mag() * cos(temp)));
        if (veloc_phi < 0.0 && m.velocity.x < 0.0) {
          veloc_phi = -PI - veloc_phi;
        } else if (veloc_phi > 0.0 && m.velocity.x < 0.0) {
          veloc_phi = PI - veloc_phi;
        }
        if (!oppositeDirections(theta, veloc_theta) && !oppositeDirections(phi, veloc_phi)) { // Ensures force is only applied as reaction to trout's movement rather than as constant pressure
          continue;
        }
        external_force.add(PVector.div(surf.force, 3.0));
      }
      
      // Account for current potentially acting on mass
      PVector total_force = new PVector(0.0, 0.0, 0.0);
      if (inCurrent(m, masses)) {
        total_force.sub(new PVector(current, 0.0, 0.0));
      }
      
      total_force.add(sprgForces);
      total_force.add(external_force);
      total_force.add(m.calculateDampForce()); // Account for damping on mass
      forces.add(total_force);
    }
    
    // Determine forces needed to offset imbalances
    PVector Balance_Left = new PVector(0.0, 0.0, 0.0);
    PVector Balance_Right = new PVector(0.0, 0.0, 0.0);
    float left_align = 0.0;
    float right_align = 0.0;
    left_align = this.left_tilt + PI/2.0;
    if (left_align > TWO_PI) left_align -= TWO_PI;
    right_align = this.right_tilt + PI/2.0;
    if (right_align > TWO_PI) right_align -= TWO_PI;
    
    PVector unit_normal = new PVector(cos(left_align), sin(left_align), sin(ang_Z));
    unit_normal.normalize();
    Balance_Left.set(applyFinForce(left_align, orientation.z, unit_normal)).mult(0.05);
    //debug2.set(PVector.div(Balance_Left, Balance_Left.mag()).mult(100.0));
    
    unit_normal.set(cos(right_align), sin(right_align), sin(ang_Z));
    unit_normal.normalize();
    Balance_Right.set(applyFinForce(right_align, orientation.z, unit_normal)).mult(0.05);
    //debug3.set(PVector.div(Balance_Right, Balance_Right.mag()).mult(100.0));
    
    // Determine force needed to bring trout to desired depth/y-coordinate
    PVector Lift = new PVector(0.0, 0.0, 0.0);
    float alignment = 0.0;
    float multiplier = 0.025;
    if (action == 0) { // reposition trout / BALANCE
      alignment = this.ang_Y + PI/2.0;
    } else if (action == 1) { // pursue food / CHASE
      alignment = orientation.x + PI/2.0;
    } else if (action == 2) { // brake to stop forward movement / REVERSE
      alignment = PI;
      if (orientation.z < 10.0) multiplier = -7.5; 
      else multiplier = -0.75;
    } else if (action == 3) { // prevent excessive backward movement / BACKING UP TOO FAST
      alignment = PI;
      multiplier = 0.25;
    } else if (action == 4) { // ensure trout does not go to fast / SLOW DOWN
      alignment = PI;
      multiplier = -1.0/this.finArea;
    }
    
    if (alignment > TWO_PI) alignment -= TWO_PI;
    unit_normal.set(cos(alignment), sin(alignment), 0.0);
    unit_normal.normalize();
    Lift.set(applyFinForce(alignment, orientation.z, unit_normal)).mult(multiplier);
    //debug1.set(PVector.div(Lift, Lift.mag()).mult(500.0));
    
    for (int i = 0; i < masses.size(); i++) { // Determine acceleration generated by all forces and add to velocity 
      
      if (i == 1 || i == 4 || i == 5 || i == 8 || i == 9 || i == 12) {
        forces.get(i).add(Balance_Left);
      } else if (i == 2 || i == 3 || i == 6 || i == 7 || i == 10 || i == 11) {
        forces.get(i).add(Balance_Right);
      }
      
      if (i > 0 && i < 13) {
        forces.get(i).add(Lift);
        forces.get(i).add(separation); // Separation steering force
      }
      
      masses.get(i).acceleration.set(PVector.div(forces.get(i), masses.get(i).mass));
      masses.get(i).velocity.add(PVector.mult(masses.get(i).acceleration, timestep));
      masses.get(i).velocity.limit(max_velocity_magnitude);
      masses.get(i).position.add(PVector.mult(masses.get(i).velocity, timestep));
      
      //System.out.println(i);
      //System.out.println("Force");
      //System.out.println(forces.get(i));
      //System.out.println("Accel");
      //System.out.println(masses.get(i).acceleration);
      //System.out.println("Veloc");
      //System.out.println(masses.get(i).velocity);
    }
    //System.out.println("\nNext\n");
  }
  
  /**
  * Trout will find something to eat if it doesn't already see something. 
  * If it has already seen food, it will decide whether or not it is still
  * worth pursuing
  */
  void check_for_Food() {
    
    if (seeSomething && target != null) {
      
      destination.set(target.location);
      float distance = PVector.dist(masses.get(0).position, destination);
      PVector line = PVector.sub(destination, masses.get(0).position);
      float ang_y = asin(line.y / line.mag());
      if (ang_y < 0.0 && line.x < 0.0) {
        ang_y = -PI - ang_y;
      } else if (ang_y > 0.0 && line.x < 0.0) {
        ang_y = PI - ang_y;
      }
      if (ang_y < 0.0) ang_y += TWO_PI;
      float ang_z = asin(line.z / (line.mag() * cos(ang_y)));
      if (ang_z < 0.0 && line.x < 0.0) {
        ang_z = -PI - ang_z;
      } else if (ang_z > 0.0 && line.x < 0.0) {
        ang_z = PI - ang_z;
      }
      if (ang_z < 0.0) ang_z += TWO_PI; 
      if (((ang_y > PI/5 && ang_y < 9*PI/5) || (ang_z > PI/4 && ang_z < 7*PI/4)) && distance > 50.0) {
        target = null;
        abort = true;
        seeSomething = false;
      } else {
        if (distance < 25.0) {
          unfollow();
        }
      }
    } else {
    
      for (Food fly : flies) {
        PVector dest = new PVector(fly.location.x - 320, fly.location.y, fly.location.z);
        PVector line = PVector.sub(dest, masses.get(0).position);
        float ang_y = asin(line.y / line.mag());
        if (ang_y < 0.0 && line.x < 0.0) {
          ang_y = -PI - ang_y;
        } else if (ang_y > 0.0 && line.x < 0.0) {
          ang_y = PI - ang_y;
        }
        if (ang_y < 0.0) ang_y += TWO_PI;
        float ang_z = asin(line.z / (line.mag() * cos(ang_y)));
        if (ang_z < 0.0 && line.x < 0.0) {
          ang_z = -PI - ang_z;
        } else if (ang_z > 0.0 && line.x < 0.0) {
          ang_z = PI - ang_z;
        }
        if (ang_z < 0.0) ang_z += TWO_PI; 
        if ((ang_y <= PI/5 || ang_y >= 9*PI/5) && (ang_z <= PI/4 || ang_z >= 7*PI/4) && fly.location.x > masses.get(0).position.x + 320) {
          target = fly;
          destination.set(fly.location);
          seeSomething = true;
          return;
        }
      }
   }
   
  }
  
  /**
  * Method that tells trout to stop pursuit of food
  */
  void unfollow() {
    try {
      int i = flies.indexOf(target);
      flies.remove(i);
      target = null;
      abort = true;
      seeSomething = false;
      intercepting = false;
    } catch(Exception e) {
      abort = true;
      seeSomething = false;
      intercepting = false;
    }
  }
  
  /**
  * Turns on designated side. Uses third stretch method to add stretch
  * over multiple frames
  *
  * @ param right - if true, the trout will contract its muscle springs on the right side 
  * while relaxing those on the left. The result will be a right turn. If false, it will 
  * be a left turn.
  * @ param stretch - the size of the additional contraction per frame
  */
  void turn(boolean right, float stretch) {
    //stretch = 0.075;
    if (right) {
      springs.get(7).setStretch_3(stretch); // 1_5
      springs.get(13).setStretch_3(-stretch); // 2_6
      springs.get(17).setStretch_3(-stretch); // 3_7
      springs.get(21).setStretch_3(stretch); // 4_8
      
      springs.get(25).setStretch_3(stretch); // 5_9
      springs.get(31).setStretch_3(-stretch); // 6_10
      springs.get(35).setStretch_3(-stretch); // 7_11
      springs.get(39).setStretch_3(stretch); // 8_12
      
      springs.get(43).setStretch_3(stretch); // 9_13
      springs.get(49).setStretch_3(-stretch); // 10_14
      springs.get(53).setStretch_3(-stretch); // 11_15
      springs.get(57).setStretch_3(stretch); // 12_16
    } else {
      springs.get(7).setStretch_3(-stretch); // 1_5
      springs.get(13).setStretch_3(stretch); // 2_6
      springs.get(17).setStretch_3(stretch); // 3_7
      springs.get(21).setStretch_3(-stretch); // 4_8
      
      springs.get(25).setStretch_3(-stretch); // 5_9
      springs.get(31).setStretch_3(stretch); // 6_10
      springs.get(35).setStretch_3(stretch); // 7_11
      springs.get(39).setStretch_3(-stretch); // 8_12
      
      springs.get(43).setStretch_3(-stretch); // 9_13
      springs.get(49).setStretch_3(stretch); // 10_14
      springs.get(53).setStretch_3(stretch); // 11_15
      springs.get(57).setStretch_3(-stretch); // 12_16
    }
  }
  
  /**
  * Resets all muscle springs to their original rest lengths
  */
  void relax() {
    springs.get(7).resetStretch(); // 1_5
    springs.get(13).resetStretch(); // 2_6
    springs.get(17).resetStretch(); // 3_7
    springs.get(21).resetStretch(); // 4_8
    
    springs.get(25).resetStretch(); // 5_9
    springs.get(31).resetStretch(); // 6_10
    springs.get(35).resetStretch(); // 7_11
    springs.get(39).resetStretch(); // 8_12
    
    springs.get(43).resetStretch(); // 9_13
    springs.get(49).resetStretch(); // 10_14
    springs.get(53).resetStretch(); // 11_15
    springs.get(57).resetStretch(); // 12_16
  }
  
  /**
  * As long as trout is not in the process of turning
  * this method continuously contracts and relaxes 
  * the trout's muscle springs in order to produce
  * forward movement
  *
  * @ param amplitude - the size of the contraction
  * @ param frequency - the frequency of contractions
  */
  void glide(float amplitude, int frequency) {
    
    if (turning_time == 0) {
      float stretch =  amplitude * cos(TWO_PI * frameCount/frequency);
          
      springs.get(7).setStretch_2(stretch); // 1_5
      springs.get(13).setStretch_2(-stretch); // 2_6
      springs.get(17).setStretch_2(-stretch); // 3_7
      springs.get(21).setStretch_2(stretch); // 4_8
      
      springs.get(25).setStretch_2(stretch); // 5_9
      springs.get(31).setStretch_2(-stretch); // 6_10
      springs.get(35).setStretch_2(-stretch); // 7_11
      springs.get(39).setStretch_2(stretch); // 8_12
      
      springs.get(43).setStretch_2(stretch); // 9_13
      springs.get(49).setStretch_2(-stretch); // 10_14
      springs.get(53).setStretch_2(-stretch); // 11_15
      springs.get(57).setStretch_2(stretch); // 12_16
    }
  }
  
  /*
  * Performs turns. Muscles contractions will take place over a maximum of 
  * 134 frames and will relax over a period of twice as many frames in order
  * to ensure that the turn takes place without snapping back to original
  * position
  */
  void execute_turns() {
    if (turning_time >= 268) {
      turning = false;
    }
    
    if (turning) {
      turning_time += 2;
      turn(right, 0.075);
    } else if (!turning && turning_time > 1) {
      turn(!right, 0.0375);
      turning_time -= 1;
    } else if (!turning && turning_time == 1) {
      turning_time = 0;
      relax();
    }
  }
  
  /*
  * Displays trout to screen
  */
  void display() {

    fill(130, 100, 125);
    stroke(130, 100, 125);
    pushMatrix();
    beginShape();
    
    // Head
    line(masses.get(0).position.x, masses.get(0).position.y, masses.get(0).position.z, masses.get(1).position.x, masses.get(1).position.y, masses.get(1).position.z);
    line(masses.get(0).position.x, masses.get(0).position.y, masses.get(0).position.z, masses.get(2).position.x, masses.get(2).position.y, masses.get(2).position.z);
    line(masses.get(0).position.x, masses.get(0).position.y, masses.get(0).position.z, masses.get(3).position.x, masses.get(3).position.y, masses.get(3).position.z);
    line(masses.get(0).position.x, masses.get(0).position.y, masses.get(0).position.z, masses.get(4).position.x, masses.get(4).position.y, masses.get(4).position.z);
    line(masses.get(1).position.x, masses.get(1).position.y, masses.get(1).position.z, masses.get(2).position.x, masses.get(2).position.y, masses.get(2).position.z);
    line(masses.get(1).position.x, masses.get(1).position.y, masses.get(1).position.z, masses.get(3).position.x, masses.get(3).position.y, masses.get(3).position.z);
    line(masses.get(1).position.x, masses.get(1).position.y, masses.get(1).position.z, masses.get(4).position.x, masses.get(4).position.y, masses.get(4).position.z);
    line(masses.get(2).position.x, masses.get(2).position.y, masses.get(2).position.z, masses.get(3).position.x, masses.get(3).position.y, masses.get(3).position.z);
    line(masses.get(2).position.x, masses.get(2).position.y, masses.get(2).position.z, masses.get(4).position.x, masses.get(4).position.y, masses.get(4).position.z);
    
    // Body
      // Segment 1
    line(masses.get(1).position.x, masses.get(1).position.y, masses.get(1).position.z, masses.get(5).position.x, masses.get(5).position.y, masses.get(5).position.z);
    line(masses.get(1).position.x, masses.get(1).position.y, masses.get(1).position.z, masses.get(6).position.x, masses.get(6).position.y, masses.get(6).position.z);
    line(masses.get(1).position.x, masses.get(1).position.y, masses.get(1).position.z, masses.get(8).position.x, masses.get(8).position.y, masses.get(8).position.z);
    line(masses.get(2).position.x, masses.get(2).position.y, masses.get(2).position.z, masses.get(5).position.x, masses.get(5).position.y, masses.get(5).position.z);
    line(masses.get(2).position.x, masses.get(2).position.y, masses.get(2).position.z, masses.get(6).position.x, masses.get(6).position.y, masses.get(6).position.z);
    line(masses.get(2).position.x, masses.get(2).position.y, masses.get(2).position.z, masses.get(7).position.x, masses.get(7).position.y, masses.get(7).position.z);
    line(masses.get(3).position.x, masses.get(3).position.y, masses.get(3).position.z, masses.get(6).position.x, masses.get(6).position.y, masses.get(6).position.z);
    line(masses.get(3).position.x, masses.get(3).position.y, masses.get(3).position.z, masses.get(7).position.x, masses.get(7).position.y, masses.get(7).position.z);
    line(masses.get(3).position.x, masses.get(3).position.y, masses.get(3).position.z, masses.get(8).position.x, masses.get(8).position.y, masses.get(8).position.z);
    line(masses.get(4).position.x, masses.get(4).position.y, masses.get(4).position.z, masses.get(5).position.x, masses.get(5).position.y, masses.get(5).position.z);
    line(masses.get(4).position.x, masses.get(4).position.y, masses.get(4).position.z, masses.get(7).position.x, masses.get(7).position.y, masses.get(7).position.z);
    line(masses.get(4).position.x, masses.get(4).position.y, masses.get(4).position.z, masses.get(8).position.x, masses.get(8).position.y, masses.get(8).position.z);
    line(masses.get(5).position.x, masses.get(5).position.y, masses.get(5).position.z, masses.get(6).position.x, masses.get(6).position.y, masses.get(6).position.z);
    line(masses.get(5).position.x, masses.get(5).position.y, masses.get(5).position.z, masses.get(7).position.x, masses.get(7).position.y, masses.get(7).position.z);
    line(masses.get(5).position.x, masses.get(5).position.y, masses.get(5).position.z, masses.get(8).position.x, masses.get(8).position.y, masses.get(8).position.z);
    line(masses.get(6).position.x, masses.get(6).position.y, masses.get(6).position.z, masses.get(7).position.x, masses.get(7).position.y, masses.get(7).position.z);
    line(masses.get(6).position.x, masses.get(6).position.y, masses.get(6).position.z, masses.get(8).position.x, masses.get(8).position.y, masses.get(8).position.z);
    line(masses.get(7).position.x, masses.get(7).position.y, masses.get(7).position.z, masses.get(8).position.x, masses.get(8).position.y, masses.get(8).position.z);
   
      // Segment 2
    line(masses.get(5).position.x, masses.get(5).position.y, masses.get(5).position.z, masses.get(9).position.x, masses.get(9).position.y, masses.get(9).position.z);
    line(masses.get(5).position.x, masses.get(5).position.y, masses.get(5).position.z, masses.get(10).position.x, masses.get(10).position.y, masses.get(10).position.z);
    line(masses.get(5).position.x, masses.get(5).position.y, masses.get(5).position.z, masses.get(12).position.x, masses.get(12).position.y, masses.get(12).position.z);
    line(masses.get(6).position.x, masses.get(6).position.y, masses.get(6).position.z, masses.get(9).position.x, masses.get(9).position.y, masses.get(9).position.z);
    line(masses.get(6).position.x, masses.get(6).position.y, masses.get(6).position.z, masses.get(10).position.x, masses.get(10).position.y, masses.get(10).position.z);
    line(masses.get(6).position.x, masses.get(6).position.y, masses.get(6).position.z, masses.get(11).position.x, masses.get(11).position.y, masses.get(11).position.z);
    line(masses.get(7).position.x, masses.get(7).position.y, masses.get(7).position.z, masses.get(10).position.x, masses.get(10).position.y, masses.get(10).position.z);
    line(masses.get(7).position.x, masses.get(7).position.y, masses.get(7).position.z, masses.get(11).position.x, masses.get(11).position.y, masses.get(11).position.z);
    line(masses.get(7).position.x, masses.get(7).position.y, masses.get(7).position.z, masses.get(12).position.x, masses.get(12).position.y, masses.get(12).position.z);
    line(masses.get(8).position.x, masses.get(8).position.y, masses.get(8).position.z, masses.get(9).position.x, masses.get(9).position.y, masses.get(9).position.z);
    line(masses.get(8).position.x, masses.get(8).position.y, masses.get(8).position.z, masses.get(11).position.x, masses.get(11).position.y, masses.get(11).position.z);
    line(masses.get(8).position.x, masses.get(8).position.y, masses.get(8).position.z, masses.get(12).position.x, masses.get(12).position.y, masses.get(12).position.z);
    line(masses.get(9).position.x, masses.get(9).position.y, masses.get(9).position.z, masses.get(10).position.x, masses.get(10).position.y, masses.get(10).position.z);
    line(masses.get(9).position.x, masses.get(9).position.y, masses.get(9).position.z, masses.get(11).position.x, masses.get(11).position.y, masses.get(11).position.z);
    line(masses.get(9).position.x, masses.get(9).position.y, masses.get(9).position.z, masses.get(12).position.x, masses.get(12).position.y, masses.get(12).position.z);
    line(masses.get(10).position.x, masses.get(10).position.y, masses.get(10).position.z, masses.get(11).position.x, masses.get(11).position.y, masses.get(11).position.z);
    line(masses.get(10).position.x, masses.get(10).position.y, masses.get(10).position.z, masses.get(12).position.x, masses.get(12).position.y, masses.get(12).position.z);
    line(masses.get(11).position.x, masses.get(11).position.y, masses.get(11).position.z, masses.get(12).position.x, masses.get(12).position.y, masses.get(12).position.z);
   
      // Segment 3
    line(masses.get(9).position.x, masses.get(9).position.y, masses.get(9).position.z, masses.get(13).position.x, masses.get(13).position.y, masses.get(13).position.z);
    line(masses.get(9).position.x, masses.get(9).position.y, masses.get(9).position.z, masses.get(14).position.x, masses.get(14).position.y, masses.get(14).position.z);
    line(masses.get(9).position.x, masses.get(9).position.y, masses.get(9).position.z, masses.get(16).position.x, masses.get(16).position.y, masses.get(16).position.z);
    line(masses.get(10).position.x, masses.get(10).position.y, masses.get(10).position.z, masses.get(13).position.x, masses.get(13).position.y, masses.get(13).position.z);
    line(masses.get(10).position.x, masses.get(10).position.y, masses.get(10).position.z, masses.get(14).position.x, masses.get(14).position.y, masses.get(14).position.z);
    line(masses.get(10).position.x, masses.get(10).position.y, masses.get(10).position.z, masses.get(15).position.x, masses.get(15).position.y, masses.get(15).position.z);
    line(masses.get(11).position.x, masses.get(11).position.y, masses.get(11).position.z, masses.get(14).position.x, masses.get(14).position.y, masses.get(14).position.z);
    line(masses.get(11).position.x, masses.get(11).position.y, masses.get(11).position.z, masses.get(15).position.x, masses.get(15).position.y, masses.get(15).position.z);
    line(masses.get(11).position.x, masses.get(11).position.y, masses.get(11).position.z, masses.get(16).position.x, masses.get(16).position.y, masses.get(16).position.z);
    line(masses.get(12).position.x, masses.get(12).position.y, masses.get(12).position.z, masses.get(13).position.x, masses.get(13).position.y, masses.get(13).position.z);
    line(masses.get(12).position.x, masses.get(12).position.y, masses.get(12).position.z, masses.get(15).position.x, masses.get(15).position.y, masses.get(15).position.z);
    line(masses.get(12).position.x, masses.get(12).position.y, masses.get(12).position.z, masses.get(16).position.x, masses.get(16).position.y, masses.get(16).position.z);
    line(masses.get(13).position.x, masses.get(13).position.y, masses.get(13).position.z, masses.get(14).position.x, masses.get(14).position.y, masses.get(14).position.z);
    line(masses.get(13).position.x, masses.get(13).position.y, masses.get(13).position.z, masses.get(15).position.x, masses.get(15).position.y, masses.get(15).position.z);
    line(masses.get(13).position.x, masses.get(13).position.y, masses.get(13).position.z, masses.get(16).position.x, masses.get(16).position.y, masses.get(16).position.z);
    line(masses.get(14).position.x, masses.get(14).position.y, masses.get(14).position.z, masses.get(15).position.x, masses.get(15).position.y, masses.get(15).position.z);
    line(masses.get(14).position.x, masses.get(14).position.y, masses.get(14).position.z, masses.get(16).position.x, masses.get(16).position.y, masses.get(16).position.z);
    line(masses.get(15).position.x, masses.get(15).position.y, masses.get(15).position.z, masses.get(16).position.x, masses.get(16).position.y, masses.get(16).position.z);

      // Segment 4
    line(masses.get(13).position.x, masses.get(13).position.y, masses.get(13).position.z, masses.get(17).position.x, masses.get(17).position.y, masses.get(17).position.z);
    line(masses.get(13).position.x, masses.get(13).position.y, masses.get(13).position.z, masses.get(18).position.x, masses.get(18).position.y, masses.get(18).position.z);
    line(masses.get(13).position.x, masses.get(13).position.y, masses.get(13).position.z, masses.get(20).position.x, masses.get(20).position.y, masses.get(20).position.z);
    line(masses.get(14).position.x, masses.get(14).position.y, masses.get(14).position.z, masses.get(17).position.x, masses.get(17).position.y, masses.get(17).position.z);
    line(masses.get(14).position.x, masses.get(14).position.y, masses.get(14).position.z, masses.get(18).position.x, masses.get(18).position.y, masses.get(18).position.z);
    line(masses.get(14).position.x, masses.get(14).position.y, masses.get(14).position.z, masses.get(19).position.x, masses.get(19).position.y, masses.get(19).position.z);
    line(masses.get(15).position.x, masses.get(15).position.y, masses.get(15).position.z, masses.get(18).position.x, masses.get(18).position.y, masses.get(18).position.z);
    line(masses.get(15).position.x, masses.get(15).position.y, masses.get(15).position.z, masses.get(19).position.x, masses.get(19).position.y, masses.get(19).position.z);
    line(masses.get(15).position.x, masses.get(15).position.y, masses.get(15).position.z, masses.get(20).position.x, masses.get(20).position.y, masses.get(20).position.z);
    line(masses.get(16).position.x, masses.get(16).position.y, masses.get(16).position.z, masses.get(17).position.x, masses.get(17).position.y, masses.get(17).position.z);
    line(masses.get(16).position.x, masses.get(16).position.y, masses.get(16).position.z, masses.get(19).position.x, masses.get(19).position.y, masses.get(19).position.z);
    line(masses.get(16).position.x, masses.get(16).position.y, masses.get(16).position.z, masses.get(20).position.x, masses.get(20).position.y, masses.get(20).position.z);
    line(masses.get(17).position.x, masses.get(17).position.y, masses.get(17).position.z, masses.get(18).position.x, masses.get(18).position.y, masses.get(18).position.z);
    line(masses.get(17).position.x, masses.get(17).position.y, masses.get(17).position.z, masses.get(19).position.x, masses.get(19).position.y, masses.get(19).position.z);
    line(masses.get(17).position.x, masses.get(17).position.y, masses.get(17).position.z, masses.get(20).position.x, masses.get(20).position.y, masses.get(20).position.z);
    line(masses.get(18).position.x, masses.get(18).position.y, masses.get(18).position.z, masses.get(19).position.x, masses.get(19).position.y, masses.get(19).position.z);
    line(masses.get(18).position.x, masses.get(18).position.y, masses.get(18).position.z, masses.get(20).position.x, masses.get(20).position.y, masses.get(20).position.z);
    line(masses.get(19).position.x, masses.get(19).position.y, masses.get(19).position.z, masses.get(20).position.x, masses.get(20).position.y, masses.get(20).position.z);
    
    // Tail
    line(masses.get(17).position.x, masses.get(17).position.y, masses.get(17).position.z, masses.get(21).position.x, masses.get(21).position.y, masses.get(21).position.z);
    line(masses.get(18).position.x, masses.get(18).position.y, masses.get(18).position.z, masses.get(21).position.x, masses.get(21).position.y, masses.get(21).position.z);
    line(masses.get(19).position.x, masses.get(19).position.y, masses.get(19).position.z, masses.get(21).position.x, masses.get(21).position.y, masses.get(21).position.z);
    line(masses.get(20).position.x, masses.get(20).position.y, masses.get(20).position.z, masses.get(21).position.x, masses.get(21).position.y, masses.get(21).position.z);
    line(masses.get(17).position.x, masses.get(17).position.y, masses.get(17).position.z, masses.get(22).position.x, masses.get(22).position.y, masses.get(22).position.z);
    line(masses.get(18).position.x, masses.get(18).position.y, masses.get(18).position.z, masses.get(22).position.x, masses.get(22).position.y, masses.get(22).position.z);
    line(masses.get(19).position.x, masses.get(19).position.y, masses.get(19).position.z, masses.get(22).position.x, masses.get(22).position.y, masses.get(22).position.z);
    line(masses.get(20).position.x, masses.get(20).position.y, masses.get(20).position.z, masses.get(22).position.x, masses.get(22).position.y, masses.get(22).position.z);
    line(masses.get(21).position.x, masses.get(21).position.y, masses.get(21).position.z, masses.get(22).position.x, masses.get(22).position.y, masses.get(22).position.z);
    
    // Debugging - seeing what direction forces are being applied among other things
    
    //for (Surface s : surfaces) {
    //  s.display();
    //}
    
    //line(masses.get(0).position.x, masses.get(0).position.y, masses.get(0).position.z, masses.get(0).position.x + debug1.x, masses.get(0).position.y + debug1.y, masses.get(0).position.z + debug1.z);
    //line(masses.get(8).position.x, masses.get(8).position.y, masses.get(8).position.z, masses.get(8).position.x + debug2.x, masses.get(8).position.y + debug2.y, masses.get(8).position.z + debug2.z);
    //line(masses.get(7).position.x, masses.get(7).position.y, masses.get(7).position.z, masses.get(7).position.x + debug3.x, masses.get(7).position.y + debug3.y, masses.get(7).position.z + debug3.z);
    //line(masses.get(0).position.x, masses.get(0).position.y, masses.get(0).position.z, masses.get(0).position.x + debug4.x, masses.get(0).position.y + debug4.y, masses.get(0).position.z + debug4.z);
    //line(masses.get(0).position.x, masses.get(0).position.y, masses.get(0).position.z, masses.get(0).position.x + debug5.x, masses.get(0).position.y + debug5.y, masses.get(0).position.z + debug5.z);
    //line(masses.get(0).position.x, masses.get(0).position.y, masses.get(0).position.z, masses.get(0).position.x, masses.get(0).position.y+50, masses.get(0).position.z+2000);
    
    endShape();
    popMatrix();
  }
  
  /**
  * Debugging method for resetting trout to a new desired position
  * with 0 velocity and acceleration
  *
  * @param x - x coordinate of desired position
  * @param y - y coordinate of desired position
  * @param z - z coordinate of desired position
  */
  void reset(float x, float y, float z) {
    masses.get(0).position.set(x, y, z);
    masses.get(0).velocity.set(0.0, 0.0, 0.0);
    masses.get(0).acceleration.set(0.0, 0.0, 0.0);
    masses.get(1).position.set(x-20, y+10, z-10);
    masses.get(1).velocity.set(0.0, 0.0, 0.0);
    masses.get(1).acceleration.set(0.0, 0.0, 0.0);
    masses.get(2).position.set(x-20, y+10, z+10);
    masses.get(2).velocity.set(0.0, 0.0, 0.0);
    masses.get(2).acceleration.set(0.0, 0.0, 0.0);
    masses.get(3).position.set(x-20, y-10, z+10);
    masses.get(3).velocity.set(0.0, 0.0, 0.0);
    masses.get(3).acceleration.set(0.0, 0.0, 0.0);
    masses.get(4).position.set(x-20, y-10, z-10);
    masses.get(4).velocity.set(0.0, 0.0, 0.0);
    masses.get(4).acceleration.set(0.0, 0.0, 0.0);
    
    masses.get(5).position.set(x-50, y+12.5, z-12.5);
    masses.get(5).velocity.set(0.0, 0.0, 0.0);
    masses.get(5).acceleration.set(0.0, 0.0, 0.0);
    masses.get(6).position.set(x-50, y+12.5, z+12.5);
    masses.get(6).velocity.set(0.0, 0.0, 0.0);
    masses.get(6).acceleration.set(0.0, 0.0, 0.0);
    masses.get(7).position.set(x-50, y-12.5, z+12.5);
    masses.get(7).velocity.set(0.0, 0.0, 0.0);
    masses.get(7).acceleration.set(0.0, 0.0, 0.0);
    masses.get(8).position.set(x-50, y-12.5, z-12.5);
    masses.get(8).velocity.set(0.0, 0.0, 0.0);
    masses.get(8).acceleration.set(0.0, 0.0, 0.0);
    
    masses.get(9).position.set(x-80, y+10, z-10);
    masses.get(9).velocity.set(0.0, 0.0, 0.0);
    masses.get(9).acceleration.set(0.0, 0.0, 0.0);
    masses.get(10).position.set(x-80, y+10, z+10);
    masses.get(10).velocity.set(0.0, 0.0, 0.0);
    masses.get(10).acceleration.set(0.0, 0.0, 0.0);
    masses.get(11).position.set(x-80, y-10, z+10);
    masses.get(11).velocity.set(0.0, 0.0, 0.0);
    masses.get(11).acceleration.set(0.0, 0.0, 0.0);
    masses.get(12).position.set(x-80, y-10, z-10);
    masses.get(12).velocity.set(0.0, 0.0, 0.0);
    masses.get(12).acceleration.set(0.0, 0.0, 0.0);
    
    masses.get(13).position.set(x-110, y+7.5, z-7.5);
    masses.get(13).velocity.set(0.0, 0.0, 0.0);
    masses.get(13).acceleration.set(0.0, 0.0, 0.0);
    masses.get(14).position.set(x-110, y+7.5, z+7.5);
    masses.get(14).velocity.set(0.0, 0.0, 0.0);
    masses.get(14).acceleration.set(0.0, 0.0, 0.0);
    masses.get(15).position.set(x-110, y-7.5, z+7.5);
    masses.get(15).velocity.set(0.0, 0.0, 0.0);
    masses.get(15).acceleration.set(0.0, 0.0, 0.0);
    masses.get(16).position.set(x-110, y-7.5, z-7.5);
    masses.get(16).velocity.set(0.0, 0.0, 0.0);
    masses.get(16).acceleration.set(0.0, 0.0, 0.0);
    
    masses.get(17).position.set(x-130, y+5, z-5);
    masses.get(17).velocity.set(0.0, 0.0, 0.0);
    masses.get(17).acceleration.set(0.0, 0.0, 0.0);
    masses.get(18).position.set(x-130, y+5, z+5);
    masses.get(18).velocity.set(0.0, 0.0, 0.0);
    masses.get(18).acceleration.set(0.0, 0.0, 0.0);
    masses.get(19).position.set(x-130, y-5, z+5);
    masses.get(19).velocity.set(0.0, 0.0, 0.0);
    masses.get(19).acceleration.set(0.0, 0.0, 0.0);
    masses.get(20).position.set(x-130, y-5, z-5);
    masses.get(20).velocity.set(0.0, 0.0, 0.0);
    masses.get(20).acceleration.set(0.0, 0.0, 0.0);
    
    masses.get(21).position.set(x-160, y+15, z);
    masses.get(21).velocity.set(0.0, 0.0, 0.0);
    masses.get(21).acceleration.set(0.0, 0.0, 0.0);
    masses.get(22).position.set(x-160, y-15, z);
    masses.get(22).velocity.set(0.0, 0.0, 0.0);
    masses.get(22).acceleration.set(0.0, 0.0, 0.0);
  }
  
  /**
  * Wrapping method for when trout leaves screen
  */
  void wrap() {
    masses.get(0).position.set(-500.0 + masses.get(0).position.x - (width+700), masses.get(0).position.y, masses.get(0).position.z);
    masses.get(1).position.set(-500.0 + masses.get(1).position.x - (width+700), masses.get(1).position.y, masses.get(1).position.z);
    masses.get(2).position.set(-500.0 + masses.get(2).position.x - (width+700), masses.get(2).position.y, masses.get(2).position.z);
    masses.get(3).position.set(-500.0 + masses.get(3).position.x - (width+700), masses.get(3).position.y, masses.get(3).position.z);
    masses.get(4).position.set(-500.0 + masses.get(4).position.x - (width+700), masses.get(4).position.y, masses.get(4).position.z);
    
    masses.get(5).position.set(-500.0 + masses.get(5).position.x - (width+700), masses.get(5).position.y, masses.get(5).position.z);
    masses.get(6).position.set(-500.0 + masses.get(6).position.x - (width+700), masses.get(6).position.y, masses.get(6).position.z);
    masses.get(7).position.set(-500.0 + masses.get(7).position.x - (width+700), masses.get(7).position.y, masses.get(7).position.z);
    masses.get(8).position.set(-500.0 + masses.get(8).position.x - (width+700), masses.get(8).position.y, masses.get(8).position.z);
    
    masses.get(9).position.set(-500.0 + masses.get(9).position.x - (width+700), masses.get(9).position.y, masses.get(9).position.z);
    masses.get(10).position.set(-500.0 + masses.get(10).position.x - (width+700), masses.get(10).position.y, masses.get(10).position.z);
    masses.get(11).position.set(-500.0 + masses.get(11).position.x - (width+700), masses.get(11).position.y, masses.get(11).position.z);
    masses.get(12).position.set(-500.0 + masses.get(12).position.x - (width+700), masses.get(12).position.y, masses.get(12).position.z);
    
    masses.get(13).position.set(-500.0 + masses.get(13).position.x - (width+700), masses.get(13).position.y, masses.get(13).position.z);
    masses.get(14).position.set(-500.0 + masses.get(14).position.x - (width+700), masses.get(14).position.y, masses.get(14).position.z);
    masses.get(15).position.set(-500.0 + masses.get(15).position.x - (width+700), masses.get(15).position.y, masses.get(15).position.z);
    masses.get(16).position.set(-500.0 + masses.get(16).position.x - (width+700), masses.get(16).position.y, masses.get(16).position.z);
    
    masses.get(17).position.set(-500.0 + masses.get(17).position.x - (width+700), masses.get(17).position.y, masses.get(17).position.z);
    masses.get(18).position.set(-500.0 + masses.get(18).position.x - (width+700), masses.get(18).position.y, masses.get(18).position.z);
    masses.get(19).position.set(-500.0 + masses.get(19).position.x - (width+700), masses.get(19).position.y, masses.get(19).position.z);
    masses.get(20).position.set(-500.0 + masses.get(20).position.x - (width+700), masses.get(20).position.y, masses.get(20).position.z);
    
    masses.get(21).position.set(-500.0 + masses.get(21).position.x - (width+700), masses.get(21).position.y, masses.get(21).position.z);
    masses.get(22).position.set(-500.0 + masses.get(22).position.x - (width+700), masses.get(22).position.y, masses.get(22).position.z);
  }
}
