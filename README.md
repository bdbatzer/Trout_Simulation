# README - Trout Simulation 

## BACKGROUND
* This is a simulation of trout or other river-dwelling fish swimming against current and periodically looking for food. The 
  simulation utilizes equations of classical mechanics to produce motion in a 3D environment. Forward swimming is generated by a 
  spring-mass system where contractions of springs replicate the biological contraction of muscle. Reactive forces, produced 
  when the outer surface of the artificial fish pushes against the surrounding water, propel the fish forward. Much of this, 
  particularly the structure of the fish model, was drawn from the work of Demetri Terzopoulos, Xiaoyuan Tu, and Radek 
  Grzeszczuk at the University of Toronto. You can find that work by clicking **[here](http://web.cs.ucla.edu/~dt/papers/alifej94/alifej94.pdf)**
## DEMONSTRATION
* You can view a video demonstration of the simulation by clicking **[here](https://youtu.be/o1kP8HgYBm0)**. It's eight and a 
  half minutes long and shows the simulation running from various camera angles while I talk a little bit about mechanics
## PREREQUISITES/INSTALLATION
* The only thing you will need to run the simulation is [Processing](https://processing.org/), which can be acquired here: 
  *  https://processing.org/download/
* The code is written in Java, and Processing will compile and run the code whenever you click the play button
* Though the "main method" (which in Processing is the **draw()** function) is located in the Trout_Simulator.pde file, the 
  simulation can be started from any of the six files by clicking the play button in the top left corner of the window  
* Ensure that all the files are located in the same folder which must be called **Trout_Simulator**
## CONTROLS
* There are four options regarding the position of the camera:
  1) Press **F** to position the camera at the front of the pool
  2) Press **B** to position the camera at the back of the pool
  3) Press **E** to position the camera overhead, i.e. to get a bird's-eye view
  4) Press **S** to position the camera at the side of the pool (this is the default view)
* It is also possible to pause the simulation by pressing **P**
* Clicking the **Play** button will start the simulation
* To end the simulation, simply click the **Stop** button in the upper left hand corner or just exit out of the simulation 
  window 
## DESIGN
* The design of the fish attempted to replicate the design of Terzopoulos, Tu, and Grzeszczuk. Each fish was comprised of 23 
  masses, 90 springs, and 78 surfaces. All are updated each frame of the simulation and contribute to the motion of the fish
* Fish are neutrally buoyant in the water column that they are initalized in (more on that later). Ascent and descent are 
  achieved through the application of an extra force that superficially takes on the role of the pectoral fins and swim bladder. 
  This force not only produces lift, but applied to the fish's sides maintains balance
* In addition to pitching (up-and-down motion), this force can be used to create backward movement if desired. The fish relaxes 
  its muscles and produces a braking force which, along with the current, results in a controlled reversing motion. It is also 
  possible to prevent excessive backward acceleration by aiming this braking force at the front of the fish  
* Turning is achieved through a prolonged contraction of the muscle/springs on one side of the fish with a simultaneous 
  relaxation of springs on the other 
* Forward movement relies on trigonometric wave functions, also known as sinusoidal oscillations, which operate on the springs 
  of both sides of the fish. Two parameters control the strength of the force generated: amplitude and frequency. Amplitude 
  determines the size of each oscillation while frequency determines the time period over which the oscillations take place.
  Increasing amplitude while decreasing frequency has the effect of making the fish swing its tail more rapidly and over wider 
  arcs. For the purposes of this project I found an amplitude of 2.0 worked well and adjusted the frequency to values between 
  80 and 145 - 80 being the shortest time period and thus fastest.  
* Spring forces alone though are insufficient for allowing the fish to move around its 3D environment. External hyrdodynamic 
  force is also necessary. Surfaces, defined as the area between different masses along the fish's skin, each produce a reactive 
  force in response to outward velocity (i.e. the surface's movement in the direction away from the inside of the fish). These 
  reactive forces provide resistance that prevent the fish from moving too rapidly in any direction, and also generate a 
  propulsion force when the tail moves side-to-side
* Each fish has a starting y-position (elevation) and z-position (depth) that they will attempt to return to should they venture 
  too far away. This is an attempt to simulate real trout which tend to establish a territorial position in the pool they 
  inhabit. There is also a small collision-avoidance steering force that further encourages the fish to keep to their own 
  positions.
## ENVIRONMENT
* With no force of gravity, the fish are neutrally buoyant
* *Current* is a constant force in the environment that the fish must overcome to achieve forward propulsion. Though it can also 
  be used to accelerate in the backward direction should the fish choose to reverse
* Current moves right to left - the same direction each item of food is moving
