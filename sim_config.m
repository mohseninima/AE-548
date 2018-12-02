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
    sim_cfg.plot.kepler_oe = false;   % Plot orbital elements
    sim_cfg.plot.pert_forces = false; % Plot perturbation forces
    sim_cfg.plot.rv_eci = true;       % Plot pos and vel vectors
    sim_cfg.plot.track_2d = false;    % Plot Earth surface track in 2D
    sim_cfg.plot.track_3d = true;     % Plot orbit around Earth in 3D
    sim_cfg.plot.sc_angle = true;     % Plot sc angle relative to gs zenith
    
    % Plot Settings
    sim_cfg.plot.titleFontSize = 16;
    sim_cfg.plot.axisFontSize = 12;
    sim_cfg.plot.legendFontSize = 12;
    
    % Propagation Perturbation Flags
    sim_cfg.pert.drag = false;            % Include air drag in dynamics
    sim_cfg.pert.moon_3ba = false;        % Include moon grav. in dynamics
    sim_cfg.pert.srp = false;             % Include SRP in dynamics
    sim_cfg.pert.sun_3ba = false;         % Include sun grav. in dynamics
    sim_cfg.pert.zonal_harmonics = false; % Include zonal harmonics in dyn.
    
    % Timing Constants
    sim_cfg.time.length = 2;  % [days] Length of simulation
    sim_cfg.time.step = 100;  % [s] Length of nominal timestep
    
    % Tolerances
    sim_cfg.tol.nr_rel = 1e-14;    % [] Tolerance on Newton-Raphson method
    sim_cfg.tol.ode45_abs = 1e-10; % [] Absolute tolerance on ODE45
    sim_cfg.tol.ode45_rel = 1e-10; % [] Relative tolerance on ODE45
end