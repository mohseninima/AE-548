function sim_cfg = sim_config()
    % sim_config.m
    % Generates a simulation configuration used to specify propagation and
    % display flags and modes, and simulation parameters and tolerancing.
    %
    % Author(s): Joseph Yates, Brian Ha
    % AEROSP 548 F18 Final Project: Ha, Mohseni, Yates
    %
    % Sources:
    
    % Plotting Flags
    sim_cfg.plot.kepler_oe = true;    % Plot orbital elements (2X)
    sim_cfg.plot.pert_forces = true;  % Plot perturbation forces (4X)
    sim_cfg.plot.rv_eci = true;       % Plot pos and vel vectors (1X)
    sim_cfg.plot.sc_angle = true;     % Plot sc angle rel to gs zenith (5X)
    sim_cfg.plot.track_2d = false;    % Plot Earth surface track in 2D (6X)
    sim_cfg.plot.track_3d = true;     % Plot orbit around Earth in 3D (3X)
    
    % Plot Settings
    sim_cfg.plot.titleFontSize = 16;  % Uniform font size for plot titles
    sim_cfg.plot.axisFontSize = 12;   % Uniform font size for plot axes
    sim_cfg.plot.legendFontSize = 12; % Uniform font size for plot legends
    
    % Propagation Perturbation Flags
    sim_cfg.pert.drag = false;           % Include Harris-Priester air drag
    sim_cfg.pert.drag_adv = true;        % Include NRLMSISE-00 air drag
    sim_cfg.pert.moon_3ba = true;        % Include moon grav. in dynamics
    sim_cfg.pert.srp = true;             % Include SRP in dynamics
    sim_cfg.pert.sun_3ba = true;         % Include sun grav. in dynamics
    sim_cfg.pert.zonal_harmonics = true; % Include zonal harmonics
    
    % Timing Constants
    sim_cfg.time.length = 2.5;  % [days] Length of simulation
    sim_cfg.time.step = 100;  % [s] Length of nominal timestep
    
    % Tolerances
    sim_cfg.tol.nr_rel = 1e-14;    % [] Tolerance on Newton-Raphson method
    sim_cfg.tol.ode45_abs = 1e-10; % [] Absolute tolerance on ODE45
    sim_cfg.tol.ode45_rel = 1e-10; % [] Relative tolerance on ODE45
end