# AE-548

Code for the Aerospace 548 Astrodynamics Final Project at the University of Michigan. 

## Basic Start Guide:
1. Download everything into a common folder/repo.
2. Open MATLAB and run joe_satsim.m as an example.
3. Look at pretty plots. Wow! GRIFEX!

Breakdown of Functions so far:
 
###### Top-Level Scripts
`joe_satsim.m` is an example top-level script for verification. This will probably be the "layer" that Brian also places the cone-intersection verification code at, so this is also subject to replacement by a common script that he and I work on. Right now it's a simple debugger that runs the guts of the simulator and generates all parameters and initial conditions.

###### Parameter Generation Functions
Right now there are four functions to generate parameters used by the simulation. They should cover pretty much all the numbers we'll ever need/all the numbers we've used in 548 so far.
`spacecraft_3U_cubesat_config.m` generates a struct with parameters about our example CubeSat, GRIFEX, such as cross-sectional area and mass.
`system_config.m` generates a struct of all global/environmental constants used. These include calendar constants, unit conversions, and constants associated with the Earth, Sun, and Moon. I'll likely be expanding on the sections associated with the 3 bodies as I build up the perturbation forces.
`sim_config.m` generates a struct of all flags and constants associated with running the sim. They describe which plots and perturbation forces are "on", how long the sim will run for, and what our numerical tolerances are.
`tle_to_init_cond.m` generates an initial conditions struct from a TLE struct (currently hardcoded - we'll ideally have a TLE parser that feeds in a TLE but that's not a super high priority right now). It's somewhat redundant but thorough as the struct  contains orbital element and R_ECI/V_ECI vectors.

###### Propagator Functions
Right now we have two main functions for this, a top-level simulation function which manages the simulation and outputs the resulting kinematic data (simulation.m), which is probably my "highest-level" actual deliverable right now, and the ODE/EOM that the simulation runs over (`perturbed_orbit_eom.m`). My next step is to start adding functions to calculate perturbation forces to `perturbed_orbit_eom.m`, and seeing how they affect the simulation.

###### Supporting Functions
`coe2rveci.m` - converter from canonical/Keplerian orbital elements to R_ECI, V_ECI. Based on a function I wrote for Homework 5.
`mean_to_ecc_nr.m` - Newton-Raphson solver to find eccentric anomaly from mean anomaly and eccentricty. Based on a function I wrote in undergrad.










# Disclaimer
By participating in this project Joe agrees to hand over all rights to the project, all future earnings resulting from this code, and 10% of his first child's annual earnings to Nima and Brian.
Effective Nov. 30, 2018