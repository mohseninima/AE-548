function Rs_ECI = get_sun_position_simple(t,sys_cfg,sim_cfg)
    % get_sun_position_simple.m
    % Using JPL ephemeris from 00:00:00.0 01/01/18, calculate the ECI frame
    % position of the sun at the current epoch.
    %
    % Inputs:
    %     t       JD epoch [day]
    %     sys_cfg celestial body system configuration struct
    %     sim_cfg simulation configuration struct
    %
    % Outputs:
    %     Rs_ECI  position of sun w.r.t. Earth center (ECI) [km]
    %
    % Author(s): Joseph Yates
    % AEROSP 548 F18 Final Project: Ha, Mohseni, Yates
    %
    % Sources:
    % "JPL Horizons" https://ssd.jpl.nasa.gov/horizons.cgi
    % "An Overview of Reference Frames and Coordinate Systems in the SPICE
    %     Context" https://naif.jpl.nasa.gov/pub/naif/toolkit_docs/
    %     Tutorials/pdf/individual_docs/
    %     17_frames_and_coordinate_systems.pdf
    % "Earth" https://en.wikipedia.org/wiki/Earth
    
    % Setup initial conditions for Earth orbit about the Sun from JPL
    % Horizons ephemerides
    t0 = 2458119.500000000; % [day], JD
    e0 = 1.578453256417450e-02; % []
    i0 = 2.365870868513173e-03 * sys_cfg.rad_per_deg; % [rad]
    Om0 = 2.109010444915891e+02 * sys_cfg.rad_per_deg; % [rad]
    om0 = 2.525270024725202e+02 * sys_cfg.rad_per_deg; % [rad]
    Tp0 = 2.458122605020900e+06; % [day], JD
    n0 = 9.870194326671633e-01 * sys_cfg.rad_per_deg; % [rad/day]
    M0 = 3.569352840329298e+02 * sys_cfg.rad_per_deg; % [rad]
    th0 = 3.568366379975838e+02 * sys_cfg.rad_per_deg; % [rad]
    a0 = 9.990472190345268E-01 * sys_cfg.km_per_AU; % [km]
    
    % Propogate these elements forward, assuming only mean anomaly/true
    % anomaly are time-variant (methodology borrowed from
    % get_moon_position_simple.m)
    Tperiod = 2*pi/n0; % [day] period
    Tsincefirst = t - Tp0; % [day] time since init cond periapsis pass
    Nwholeorbits = floor(Tsincefirst/Tperiod); % # of orbits since then
    Twholeorbits = Tperiod*Nwholeorbits; % how long those orbits took
    Tp = Tp0 + Twholeorbits; % time of last periapsis passage
    deltaT = t - Tp; % [day] change in time since last periapsis passage
    
    % Calculate time-variant angles
    M = n0*deltaT; % [rad]
    phi = mean_to_ecc_nr(M,e0,sim_cfg.tol.nr_rel); % [rad]git a
    th = 2*atan2(sqrt(1+e0)*tan(phi/2),sqrt(1-e0)); % [rad]
    
    % Since our orbital elements are w.r.t. the parent frame, we can hijack
    % coe2rveci to calculate the position vector of the Earth using orbital
    % elements for its orbit about the Sun in the HCI frame
    [Re_HCI,~] = coe2rveci(a0,e0,i0,Om0,om0,th,sys_cfg.earth.mu); % [km]
    Rs_HCI = -Re_HCI; % Sun-Earth vector is opposite Earth-Sun vector
    
    % Transform to ECI: axial tilt along the 1-axis, rotate back to ECI
    axial_tilt = 23.439281 * sys_cfg.rad_per_deg; % [rad]
    O_ECI_HCI = [1 0 0;
                 0 cos(axial_tilt) -sin(axial_tilt);
                 0 sin(axial_tilt) cos(axial_tilt)]; % note backwards rot.
    Rs_ECI = O_ECI_HCI * Rs_HCI;    
end