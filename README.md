# README - Trout Simulation 

## BACKGROUND
* This is a simulation of trout or other river-dwelling fish swimming against current and periodically looking for food. The 
  simulation utilizes equations of classical mechanics to produce motion in a 3D environment. Forward swimming is generated by a 
  spring-mass system where contractions of springs replicate the biological contraction of muscle. Reactive forces, produced when 
  the outer surface of the artificial fish pushes against the surrounding water, propel the fish forward. Much of this, 
  particularly the structure of the fish model, was drawn from the work of Demetri Terzopoulos, Xiaoyuan Tu, and Radek Grzeszczuk 
  at the University of Toronto. You can find that work [here](http://web.cs.ucla.edu/~dt/papers/alifej94/alifej94.pdf)
## PREREQUISITES/INSTALLATION
* The only thing you need to run the simulation is [Processing](https://processing.org/), which can be acquired here: 
  *  https://processing.org/download/
* The code is written in Java, and Processing will compile and run the code whenever the play button is clicked
* Though the "main method" (which in Processing is the draw() function) is in the Trout_Simulator.pde file, the simulation 
  can be started from any of the six files by clicking the play button in the top left corner of the window  
