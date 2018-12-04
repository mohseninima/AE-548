function cs_cfg = spacecraft_3U_cubesat_config()
    % spacecraft_3U_cubesat.m
    % Generates a struct containing spacecraft parameters for a basic 3U
    % CubeSat. The cubesat will be based off of the UM MXL GRIFEX CubeSat.
    %
    % Author(s): Joseph Yates
    % AEROSP 548 F18 Final Project: Ha, Mohseni, Yates
    %
    % Sources:
    % "GRIFEX Mass Properties V3"
    % https://mxl-redmine.engin.umich.edu/projects/grifex/repository/
    %     changes/Documentation/Launch%20Documentation/Mass%20Properties/
    %     GRIFEX_Mass_Properties_v3.pdf
    % "An Evaluation of CubeSat Orbital Decay"
    % https://digitalcommons.usu.edu/cgi/
    %     viewcontent.cgi?article=1144&context=smallsat
    % "Emissivity" https://en.wikipedia.org/wiki/Emissivity

    cs_cfg.m = 3.065; % [kg] mass of the spacecraft
    % Note that higher-fidelity modeling for drag and SRP has not been
    % implemented because s/c attitude is not being tracked in this
    % simulation.
    
    % For air drag, a ram pointing configuration is assumed
    cs_cfg.Ad = 0.012; % [m^2] average air drag cross-sectional area of s/c
    cs_cfg.Cd = 2.2; % [] coefficient of drag
    cs_cfg.B = cs_cfg.m/(cs_cfg.Ad*cs_cfg.Cd); % [kg/m^2] ballistic coeff
    cs_cfg.n_hp = 5.6; % [] Harris-Priester Drag Model calibratable
                       % component, takes values 2-6 for low-incl. to
                       % high-incl. orbits
    
    % For SRP, a ram pointing configuration in a roughly circular and
    % equatorial Earth orbit is assumed. Because the side of the spacecraft
    % will sometimes face the Sun instead of the front/back, this area
    % number is larger.
    cs_cfg.As = 0.024; % [m^2] average SRP corss-sectional area of s/c
    cs_cfg.ep = 0.5; % [] reflectivity constant, estimated from slides,
                   %     roughly equal to .1*.9+.3*.95+.6*.21.
    cs_cfg.CR = 1 + cs_cfg.ep; % [] radiation pressure coefficient
end