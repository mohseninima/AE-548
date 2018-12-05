function f_pert = get_drag_pert_force_msis(R,V,sc_cfg,sys_cfg,tJD)
    % get_drag_pert_force_msis.m
    % Calculate the density using the 2001 United States Naval Research Laboratory 
    % Mass Spectrometer and Incoherent Scatter Radar Exosphere (NRLMSISE-00)
    %
    % Inputs:
    %     R       spacecraft ECI position vector [km]
    %     V       spacecraft ECI velocity vector [km/s]
    %     sc_cfg  spacecraft configuration struct
    %     sys_cfg celestial body system configuration struct
    %     tJD     time in Julian days  
    %
    % Outputs:
    %     f_pert  force exerted by air drag [kN/kg]
    %
    % Author(s): Nima Mohseni
    % AEROSP 548 F18 Final Project: Ha, Mohseni, Yates
    %
    % Sources: AirDragAndSolarRadiationPressure.pdf lecture slides
    
    % Compute the geodetic latitude, longitude, and altitude
    dt = datetime(tJD,'convertfrom','juliandate');
    O_ecef_2_eci = get_ecef_2_eci_dcm(dt);
    O_eci_2_ecef = O_ecef_2_eci';
    R_ecef = O_eci_2_ecef*R;
    
    lla = ecef2lla(R_ecef'*1000);  % wants meters
    latitude = lla(1);
    longitude = lla(2);
    altitude = lla(3);
    
    
    
    
    % Angle between satellite position vector and apex of diurnal bugle
    r = norm(R); % [km] s/c range

    % Convert Julian Date to Year, day, seconds
    % Create datetime object
    JD_datetime = datetime(tJD,'convertfrom','juliandate');
    % Convert datetime to yyyymmdd
    JD_yyyymmdd = yyyymmdd(JD_datetime);
    % Get year
    year = JD_yyyymmdd;
    % Find first day of the year in julian time
    JD_startofyear = juliandate(datetime(str2double(strcat(num2str(2018),'0101')),'convertfrom','yyyymmdd'));
    % Find days since new year
    dayOfYear = floor(tJD - JD_startofyear);
    % Find the time since the day started in seconds
    UTseconds = (tJD - JD_startofyear - dayOfYear)*24*60*60;
    
    
    %Temporary values for F107 %taken from http://lasp.colorado.edu/lisird/data/noaa_radio_flux/
    f107Daily = 68;
    f107Average = 70.47901235;
    magneticIndex = 10; %need to get this right
    
    % Calculate density with NRLMSISE-00 model
    [Tall, rhoall] = atmosnrlmsise00(altitude, latitude, longitude, year, dayOfYear, UTseconds, f107Average, f107Daily, magneticIndex);
    
    rho = rhoall(6);
    
    % Calculate relative velocity (to air) and drag force
    Omega_e = sys_cfg.earth.omega_e * sys_cfg.earth.rot_axis; % [rad/s]
    Vr = V - cross(Omega_e,R); % [km/s]
    vr = norm(Vr); % [km/s]
    Ad = sc_cfg.Ad /1e6; % [km^2], change units of cross-sectional area
    F_pert = -0.5*sc_cfg.Cd*Ad*rho*vr^2*(Vr/vr); % [kN]
    % Normalize force by spacecraft mass
    f_pert = F_pert / sc_cfg.m; % [kN/kg]
end