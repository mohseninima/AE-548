function O_ecef_2_eci = get_ecef_2_eci_dcm(dt)
    % get_ecef_2_eci_dcm.m
    % Returns the direction cosine matrix (DCM) (a.k.a. orientation matrix)
    % for converting from the ECEF frame to the ECI frame.
    %
    % Inputs:
    %   dt :  A MATLAB datetime object representing a UTC timestamp
    %
    % Outputs:
    %   O_ecef_2_eci : 3x3 direction cosine matrix
    %
    % Author(s): Brian Ha
    % AEROSP 548 F18 Final Project: Ha, Mohseni, Yates
    %
    % Sources:
    % * Sidereal Time: AEROSP 548 Module II Notes, Slide 170
    
    
    % Convert from UTC Datetime to Modified Julian Date
    mjd = mjuliandate(dt.Year, dt.Month, dt.Day, ...
                      dt.Hour, dt.Minute, dt.Second);
    
    
    % Determine the Sidereal Time (a.k.a. the Greenwich Hour Angle)
    theta = 280.4606 + 360.9856473*(mjd - 51544.5); % [deg]
    
    
    % Orientation Matrix from ECEF to ECI
    O_ecef_2_eci = [cosd(theta) -sind(theta) 0; 
                    sind(theta) cosd(theta) 0; 
                    0 0 1];
end

