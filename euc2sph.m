function [r,nu,lm] = euc2sph(R)
    % euc2sph.m
    % Convert a euclidean-geometry position vector to spherical
    % coordinates.
    %
    % Inputs:
    %     R      position vector [km]
    %
    % Outputs:
    %     r       range [km]
    %     nu      right ascension [rad]
    %     lm      declination [rad]
    %
    % Author(s): Joseph Yates
    % AEROSP 548 F18 Final Project: Ha, Mohseni, Yates
    %
    % Sources: AEROSP 548 Lectures
    r = norm(R); % [km] (range)
    lm = asin(R(3)/r); % [rad] (declination)
    cosnu = R(1)/(r*cos(lm)); % [ul]
    sinnu = R(2)/(r*cos(lm)); % [ul]
    nu = atan2(sinnu,cosnu); % [rad] (right ascension)
    if nu < 0
        nu = nu + 2*pi;
    end
end