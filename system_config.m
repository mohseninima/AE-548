function sys_cfg = system_config()
    % system_constants.m
    % Generates all physical constants and constants for the Earth, Sun,
    % and Moon system needed to run the orbital propagator.
    %
    % Author(s): Joseph Yates
    % AEROSP 548 F18 Final Project: Ha, Mohseni, Yates
    %
    % Sources:
    % AEROSP 548 Lecture Slides
    % "Earth" https://en.wikipedia.org/wiki/Earth
    % "Gravitational Constant" 
    %     https://en.wikipedia.org/wiki/Gravitational_constant
    % "Julian Date Converter"
    %     https://aa.usno.navy.mil/data/docs/JulianDate.php
    % "Julian day" https://en.wikipedia.org/wiki/Julian_day
    % "Moon" https://en.wikipedia.org/wiki/Moon
    % "Speed of Light" https://en.wikipedia.org/wiki/Speed_of_light
    % "Statistical Orbit Determination", Tapley and Born, 2004
    % "Sun" https://en.wikipedia.org/wiki/Sun

    % Global Physical Constants
    sys_cfg.c = 299792.458; % [km/s] Speed of light
    sys_cfg.G = 6.67408e-20; % [km^3/(kg*s^2)] Gravitational constant
    
    % Global Timing Constants
    sys_cfg.diff_JD_MJD = 2400000.5; % [day] difference betw. JD and MJD
    sys_cfg.JDY2K = 2451544.5; % [day] JD for 00h 01 Jan 2000
    
    % Global Unit Conversions
    sys_cfg.deg_per_rad = 180/pi; % [deg/rad] degrees per radian
    sys_cfg.km_per_AU = 149597870.691; % [km] kilometers per AU
    sys_cfg.rad_per_deg = pi/180; % [rad/deg] radians per degree
    sys_cfg.s_per_solar_day = 86400; % [s] seconds per solar day
    sys_cfg.s_per_sidereal_day = 86164; % [s] seconds per sidereal day
    sys_cfg.s_per_hr = 3600; % [s] seconds per hour

    % Earth Constants
    earth.m = 5.97237e24; % [kg] Earth mass
    % earth.mu = 398600.4405; % [km^3/s^2] Earth gravitational parameter
    earth.mu = sys_cfg.G * earth.m; % [km^3/s^2] Earth grav. parameter
    earth.R = 6371; % [km] Earth average radius
    earth.R_equat = 6378.1; % [km] Earth equatorial radius
    earth.R_polar = 6356.8; % [km] Earth polar radius
    earth.omega_e = 0.7292e-4; % [rad/s] Earth rotational speed
    earth.SRP = 4.56e-6; % [N/m^2] Approx. SRP near Earth/at 1 AU from Sun
    
    earth.J0 = 1; % Earth Zonal Harmonics Coefficients
    earth.J1 = 0;
    earth.J2 = 0.10826360229840e-2;
    earth.J3 = -0.25324353457544e-5;
    earth.J4 = -0.16193312050719e-5;
    earth.J5 = -0.22771610163688e-6;
    earth.J6 = 0.53964849049834e-6;
    earth.J7 = -0.35136844210318e-6;
    earth.J8 = -0.20251871520885e-6;
    % Vector of coefficients - J0 is skipped so indices match coeff's.
    earth.J = [earth.J1 earth.J2 earth.J3 earth.J4 ...
               earth.J5 earth.J6 earth.J7 earth.J8];

    % Moon Constants
    moon.m = 7.342e22; % [kg] Moon mass
    moon.mu = sys_cfg.G * moon.m; % [km^3/s^2] Moon grav. parameter
    moon.R = 1737.1; % [km] Moon mean radius

    % Sun Constants
    sun.m = 1.9885e30; % [kg] Solar mass
    sun.mu = sys_cfg.G * sun.m; % [km^3/s^2] Sun gravitational parameter
    sun.R = 695700; % [km] Sun radius
    
    % Collation
    sys_cfg.earth = earth;
    sys_cfg.moon = moon;
    sys_cfg.sun = sun;
end