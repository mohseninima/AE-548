function plot_track_2d(r_sc_eci_list, utc_tstamp_list, sc_num)
    % plot_track_2d.m
    % Calculates and plots a spacecraft's (SC) ground track.
    %
    % Inputs:
    %  r_sc_eci_list   : Array of SC's ECI Cartesian position vectors [km]
    %  utc_tstamp_list : Array of UTC datetime objects for each position.
    %  sc_num          : String indicating spacecraft catalog number
    %
    % Outputs:
    %   None
    %
    % Byproducts:
    %   Figure 61 : Plot of the spacecraft's ground track
    %
    % Author(s): Brian Ha
    % AEROSP 548 F18 Final Project: Ha, Mohseni, Yates
    %
    % Sources:
    
    
    % Pre-allocate arrays for spacecraft latitude and longitude
    LAT_DATA = zeros(length(utc_tstamp_list), 1);
    LONG_DATA = zeros(length(utc_tstamp_list), 1);
    
    
    % For each UTC datetime object...
    for i = 1:length(utc_tstamp_list)
        
        % Get the ECEF to ECI Direction Cosine Matrix (DCM)
        O_ecef_2_eci = get_ecef_2_eci_dcm(utc_tstamp_list(i));
        
        
        % Transpose it to get the ECI to ECEF DCM.
        O_eci_2_ecef = O_ecef_2_eci';
        
        
        % Express the spacecraft's position vector in the ECEF frame.
        r_sc_ecef = O_eci_2_ecef*r_sc_eci_list(i,:)';
        
        
        % Find the distance of the spacecraft from the ECEF origin
        r = norm(r_sc_ecef);
       
        
        % Find ground track latitude. Equals the spacecraft declination.
        lat = asind(r_sc_ecef(3)/r); % [deg]
       
        
        % Find ground track longitude.
        sind_long = r_sc_ecef(2)/(r*cosd(lat));
        cosd_long = r_sc_ecef(1)/(r*cosd(lat));
        
        long = atan2d(sind_long, cosd_long); % [deg]
        
        
        % Store the latitude and longitude data
        LAT_DATA(i) = lat;
        LONG_DATA(i) = long;
    end
    
    
    % Get the plot standards from the simulation configuration
    sim_cfg = sim_config();
    
    
    % Plot the satellite ground track on a Mercator projection.
    figure(61)
    landareas = shaperead('landareas.shp','UseGeoCoords',true);
    axesm ('mercator', 'Frame', 'on', 'Grid', 'on');
    geoshow(landareas,'FaceColor',[1 1 .5],'EdgeColor',[.6 .6 .6]);
    geoshow(LAT_DATA, LONG_DATA);
    
    
    % Place a marker on the spacecraft's starting position.
    geoshow(LAT_DATA(1), LONG_DATA(1), 'DisplayType', 'point',...
        'MarkerSize', 20, 'LineWidth', 2, 'MarkerEdgeColor', 'b')
    
    
    % Place a marker on the FXB ground station.
    fxb = gs_config('fxb');
    geoshow(fxb.lat, fxb.long, 'DisplayType', 'point',...
        'MarkerSize', 20, 'LineWidth', 2, 'MarkerEdgeColor', 'r')
    
    
    % Create and display title
    title_str = sprintf('Ground Track of %s Starting on %s',...
        sc_num, string(utc_tstamp_list(1)));
    title(title_str, 'FontSize', sim_cfg.plot.titleFontSize)
    
end

