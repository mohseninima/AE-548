function R = sph2euc(r,nu,lm)
    % sph2euc.m
    % Convert spherical coordinates to a euclidean-coordinate vector.
    %
    % Inputs:
    %     r       range [km]
    %     nu      right ascension [rad]
    %     lm      declination [rad]
    %
    % Outputs:
    %     R      position vector [km]
    %
    % Author(s): Joseph Yates
    % AEROSP 548 F18 Final Project: Ha, Mohseni, Yates
    %
    % Sources: AEROSP 548 Lectures
    x = r*cos(lm)*cos(nu); % [km]
    y = r*cos(lm)*sin(nu); % [km]
    z = r*sin(lm); % [km]
    R = [x y z]';
end