function [a,e,i,Om,om,th] = rveci2coe(R,V,mu)
    % rveci2coe.m
    % Calculate the keplerian orbital elements of a orbiting body from that
    % body's position and velocity vectors, and the gravitational parameter
    % of the body being orbited. Two-body problem assumptions are held for
    % this conversion.
    %
    % Inputs:
    %     R    inertial position vector of spacecraft [km]
    %     V    inertial velocity vector of spacecraft [km/s]
    %     mu   gravitational parameter of parent body [km^3/s^2]
    %
    % Outputs:
    %     a    semi-major axis [km]
    %     e    eccentricity []
    %     i    inclination [rad]
    %     Om   right angle of the ascending node [rad]
    %     om   argument of periapsis [rad]
    %     th   true anomaly [rad]
    %
    % Author: Joseph Yates
    % Originally written by the author as rv_to_koe_2bp.m for Homework 5.
    % AEROSP 548 F18 Final Project: Ha, Mohseni, Yates
    %
    % Source: Adapted from computeOrbitalElements.m, written by Professor
    % Ilya Kolmanovsky.
    
    % Inertial frame unit vectors
    I = [1 0 0]';
    J = [0 1 0]';
    K = [0 0 1]';
    
    % Norms
    r = norm(R);
    v = norm(V);
    
    % Angular momentum and eccentricity vectors
    hv = cross(R,V);
    ev = 1/mu*cross(V,hv)-R/r;
    h = norm(hv);
    e = norm(ev);
    
    % Perifocal frame unit vectors
    ih = hv/h;
    ie = ev/e;
    ip = cross(ih,ie);
    
    % Vector along the line of nodes
    n0 = cross(K,ih)/norm(cross(K,ih));
    
    % Right angle of the ascending node (RAAN)
    cosOm = dot(n0, I);
    sinOm = dot(n0, J);
    Om = atan2(sinOm,cosOm);
    
    % Inclination
    i = acos(dot(K,ih));
    
    % Argument of periapsis (AOP)
    cosom = dot(n0,ie);
    sinom = dot(ih,cross(n0,ie));
    om = atan2(sinom,cosom);
    
    % Semi-latus rectum, semi-major axis
    p = h^2/mu;
    a = p/(1-e^2);
    
    % True anomaly
    th = acos(1/norm(e)*(p/norm(R)-1));
    if dot(cross(ev,R),ih) < 0
       th = 2*pi - th;
    end
end