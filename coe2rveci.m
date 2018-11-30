function [R_ECI, V_ECI] = coe2rveci(a,e,i,W,w,TA,mu)
    % coe2rveci.m
    % Converts canonical (Keplerian) orbital elements to r_ECI and v_ECI
    % for an elliptical orbit.
    %
    % Author: Joseph Yates
    % Originally written for the solution to Homework 5, Problem 2.
    % AEROSP 548 F18 Final Project: Ha, Mohseni, Yates
    
    p = a*(1-e^2);
    r = p/(1+e*cos(TA));
    Rp = [r*cos(TA) r*sin(TA) 0]';
    
    % Velocity equation adapted from Bate, Mueller, and White (1971)
    Vp = [-sqrt(mu/p)*sin(TA) sqrt(mu/p)*(e+cos(TA)) 0]';
    
    O_G_G1 = [cos(W) -sin(W) 0; sin(W) cos(W) 0; 0 0 1];
    O_G1_G2 = [1 0 0; 0 cos(i) -sin(i); 0 sin(i) cos(i)];
    O_G2_P = [cos(w) -sin(w) 0; sin(w) cos(w) 0; 0 0 1];
    O_G_P = O_G_G1 * O_G1_G2 * O_G2_P;
    
    R_ECI = O_G_P * Rp;
    V_ECI = O_G_P * Vp;
end