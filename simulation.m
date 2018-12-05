function [T, R_ECI, V_ECI] = simulation(init_cond,sc_cfg,sys_cfg,sim_cfg)
    % simulation.m
    % Equations of motion differential equation for perturbed Earth orbit
    % spacecraft motion.
    %
    % Inputs:
    %     init_cond   initial conditions struct (time, elements, RV vec's)
    %     sc_cfg      spacecraft configuration struct
    %     sys_cfg     celestial body system configuration struct
    %     sim_cfg     simulation configuration struct
    %
    % Outputs:
    %     T           JD timestep array [day]
    %     R_ECI       ECI-frame position vector array [km]
    %     V_ECI       ECI-frame velocity vector array [km/s]
    %
    % Author(s): Joseph Yates
    % AEROSP 548 F18 Final Project: Ha, Mohseni, Yates
    %
    % Sources:
    
    % Setup simulation timing
    ti = init_cond.JD0s;
    tf = init_cond.JD0s + sim_cfg.time.length * sys_cfg.s_per_solar_day;
    ts = sim_cfg.time.step;
    tspan = ti:ts:tf;
    
    % Setup simulation initial conditions and options
    X0_ECI = [init_cond.R_ECI;init_cond.V_ECI];
    options = odeset('AbsTol',sim_cfg.tol.ode45_abs, ...
                     'RelTol',sim_cfg.tol.ode45_rel);
                 
    % Run simulation
    [Ts, X_ECI] = ode113(@perturbed_orbit_eom,tspan,X0_ECI,options, ...
                       sc_cfg,sys_cfg,sim_cfg);
    
    % Convert time back to days since calcs are complete
    T = Ts ./ sys_cfg.s_per_solar_day;
    
    % Split position and velocity data
    R_ECI = X_ECI(:,1:3);
    V_ECI = X_ECI(:,4:6);
end