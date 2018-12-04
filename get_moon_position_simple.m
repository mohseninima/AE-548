function Rm_ECI = get_moon_position_simple(t,sys_cfg,sim_cfg)
    % get_moon_position_simple.m
    % Using JPL ephemeris from 00:00:00.0 01/01/18, calculate the ECI frame
    % position of the moon at the current epoch.
    %
    % Inputs:
    %     t       JD epoch [day]
    %     sys_cfg celestial body system configuration struct
    %     sim_cfg simulation configuration struct
    %
    % Outputs:
    %     Rm_ECI  position of moon w.r.t. Earth center (ECI) [km]
    %
    % Author(s): Joseph Yates
    % AEROSP 548 F18 Final Project: Ha, Mohseni, Yates
    %
    % Sources:
    % "JPL Horizons" https://ssd.jpl.nasa.gov/horizons.cgi
    
    % Setup Initial conditions from JPL Horizons ephemerides
    t0 = 2458119.500000000; % [day], JD
    e0 = 7.618173744911751e-02; % []
    i0 = 5.196960685321760e+00 * sys_cfg.rad_per_deg; % [rad]
    Om0 = 1.351208912106474e+02 * sys_cfg.rad_per_deg; % [rad]
    om0 = 3.249459462415981e+02 * sys_cfg.rad_per_deg; % [rad]
    Tp0 = 2.458120522369065e+06; % [day], JD
    n0 = 1.311948039001663e+01 * sys_cfg.rad_per_deg; % [rad/day]
    M0 = 3.465870491046982e+02 * sys_cfg.rad_per_deg; % [rad]
    th0 = 3.443568163820373e+02 * sys_cfg.rad_per_deg; % [rad]
    a0 = 2.579309287237687e-03 * sys_cfg.km_per_AU; % [km]
    
    % Propogate these elements forward, assuming only mean anomaly/true
    % anomaly are time-variant
    Tperiod = 2*pi/n0; % [day] period
    Tsincefirst = t - Tp0; % [day] time since init cond periapsis pass
    Nwholeorbits = floor(Tsincefirst/Tperiod); % # of orbits since then
    Twholeorbits = Tperiod*Nwholeorbits; % how long those orbits took
    Tp = Tp0 + Twholeorbits; % time of last periapsis passage
    deltaT = t - Tp; % [day] change in time since last periapsis passage
    
    M = n0*deltaT; % [rad]
    % Potentially cut true anomaly calculation and go to a circular orbit
    % to save on speed - moon perturbations are very small anyways
    % (displacement of <1m over 2+ days)
    phi = mean_to_ecc_nr(M,e0,sim_cfg.tol.nr_rel); % [rad]git a
    th = 2*atan2(sqrt(1+e0)*tan(phi/2),sqrt(1-e0)); % [rad]
    
    [Rm_ECI,~] = coe2rveci(a0,e0,i0,Om0,om0,th,sys_cfg.earth.mu); % [km]
end