function [phi, iter] = mean_to_ecc_nr(M,e,rel_tol)
    % mean_to_ecc_nr.m
    % Solves for the eccentric anomaly given the mean anomaly and
    % eccentricity of the orbit, for an elliptical orbit, using a
    % Newton-Raphson root-finding method.
    %
    % Inputs:
    %     M       mean anomaly [rad]
    %     e       eccentricity []
    %     rel_tol relative tolerance between results for termination of
    %                 algorithm []
    %
    % Outputs:
    %     phi     approximate eccentric anomaly [rad]
    %     iter    number of iterations of the algorithm loop []
    %
    % Author: Joseph Yates
    % Adapted from code originally written by the author for Princeton
    % University MAE 341 Space Flight, Fall 2015.
    % AEROSP 548 F18 Final Project: Ha, Mohseni, Yates
    
    % Housekeeping with default tolerance
    if nargin < 3
        rel_tol = 1e-12;
    end

    % Set initial guess
    if ((M > pi) || ((-pi < M) && (M < 0)))
        phi = M - e;
    else
        phi = M + e;
    end
    
    % Set up iteration loop
    not_converged = true;
    iter = 0;
    
    % Iteration loop
    while not_converged
        % Increment iterations
        iter = iter + 1;
        
        % Numerical root-finding
        fphi = M - phi + e*sin(phi);
        fpphi = 1 - e*cos(phi);
        dfphi = fphi / fpphi;
        phip1 = phi + dfphi; % "phi plus 1" - new estimate of phi
        
        % Check to see if converged
        not_converged = (abs(phip1 - phi) > rel_tol);
        phi = phip1;
    end
end