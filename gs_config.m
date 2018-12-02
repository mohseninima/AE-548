function gs_cfg = gs_config(ground_station)
    % gs_config.m
    % Returns a struct of parameters (e.g. lat, long, ECEF position)
    % for a desired ground station (GS).
    % Author(s): Brian Ha
    % AEROSP 548 F18 Final Project: Ha, Mohseni, Yates
    %
    % Sources:
    % * Latitude & Longitude: Google Maps
    % * WGS 84 Earth Radius by Latitude: https://planetcalc.com/7721/
    % * Altitude of Ann Arbor: Google 
    % * ECEF Cartesian Position Vector: 548 Module II Notes, Slide 172
    
    
    VALID_GROUND_STATIONS = ["fxb"]; % <-- Need to use double quotes.
    
    
    % Ground Station at the UMich FXB Building
    if strcmp(lower(ground_station), VALID_GROUND_STATIONS(1))
        
        gs_cfg.lat = 42.293396;     % Latitude [decimal deg]
        gs_cfg.long = -83.712060;   % Longitude [decimal deg]
        gs_cfg.min_comm_angle = 5;  % Min. Angle Above Local Horizon [deg]
        gs_cfg.Re = 6368.498;       % WGS 84 Earth Radius at FXB [km]
        gs_cfg.alt = 0.256;         % Altitude of Ann Arbor [km]
        gs_cfg.R = 6368.754;        % Earth Radius + Altitude [km]

        
        % ECEF Cartesian Position Vector [km]
        gs_cfg.r_ecef = [gs_cfg.R*cosd(gs_cfg.lat)*cosd(gs_cfg.long);
                         gs_cfg.R*cosd(gs_cfg.lat)*sind(gs_cfg.long);
                         gs_cfg.R*sind(gs_cfg.lat)];
        return
        
    else
        
        % Protect against invalid argument
        error(['Sorry, %s is not a valid ground station. ' ... 
              'Please choose from this list: %s '],...
              ground_station, VALID_GROUND_STATIONS);
    end
end

