function f_pert = get_drag_pert_force_hp(R,V,Rs,sc_cfg,sys_cfg)
    % get_drag_pert_force_hp.m
    % Calculate the max and min atmospheric density values given the
    % altitude using the tabulated Harris-Priester model. This is a
    % modified version of harris_priester written by Professor Kolmanovsky
    % for AEROSP 548.
    %
    % Inputs:
    %     R       spacecraft ECI position vector [km]
    %     V       spacecraft ECI velocity vector [km/s]
    %     Rs      Sun ECI frame position vector [km]
    %     sc_cfg  spacecraft configuration struct
    %     sys_cfg celestial body system configuration struct
    %
    % Outputs:
    %     f_pert  force exerted by air drag [kN/kg]
    %
    % Author(s): Joseph Yates
    % AEROSP 548 F18 Final Project: Ha, Mohseni, Yates
    %
    % Sources: AirDragAndSolarRadiationPressure.pdf lecture slides
    
    % Calculate Harris-Priester quantities
    % Get Sun right ascension and declination in Earth-centered coordinates
    [~,nus,lms] = euc2sph(Rs); % [rad],[rad]
    % Apex of diurnal bulge direction
    eb = sph2euc(1,nus+30*sys_cfg.rad_per_deg,lms); % []
    % Angle between satellite position vector and apex of diurnal bugle
    r = norm(R); % [km] s/c range
    Phi = acos(dot(eb,R/r)); % [rad]
    % Get max and min densities from HP tabulation
    alt = r - sys_cfg.earth.R; % [km] s/c altitude
    [rhomax,rhomin] = harris_priester(alt); % [g/km^3],[g/km^3]
    
    % Calculate density with Harris-Priester model
    rho = rhomin + (rhomax-rhomin) * (cos(Phi/2))^sc_cfg.n_hp; % [g/km^3]
    rho = rho / 1000; % [kg/km^3]
    
    % Calculate relative velocity (to air) and drag force
    Omega_e = sys_cfg.earth.omega_e * sys_cfg.earth.rot_axis; % [rad/s]
    Vr = V - cross(Omega_e,R); % [km/s]
    vr = norm(Vr); % [km/s]
    Ad = sc_cfg.Ad /1e6; % [km^2], change units of cross-sectional area
    F_pert = -0.5*sc_cfg.Cd*Ad*rho*vr^2*(Vr/vr); % [kN]
    % Normalize force by spacecraft mass
    f_pert = F_pert / sc_cfg.m; % [kN/kg]
end