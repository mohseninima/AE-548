function f_pert = get_zonal_harmonic_pert_force(R,e_cfg)
    % get_zonal_harmonic_pert_force.m
    % Get the mass-normalized perturbation force for Earth zonal harmonics
    % given the spacecraft ECI frame position and a set of parameters
    % describing Earth.
    %
    % Inputs:
    %     R       s/c ECI frame position [km]
    %     e_cfg   struct containing parameters describing the Earth,
    %                 derivative of the system config struct
    %
    % Outputs:
    %     f_pert  force exerted by zonal harmonic perturbations [kN/kg]
    %
    % Author(s): Joseph Yates
    % AEROSP 548 F18 Final Project: Ha, Mohseni, Yates
    %
    % Sources: zonal_harmonics_symbolic.m
    
    % Setup
    x = R(1);
    y = R(2);
    z = R(3);
    r = norm(R);
    
    % Rename things for speed
    r2 = r^2;
    r4 = r^4;
    r6 = r^6;
    r8 = r^8;
    r10 = r^10;
    r12 = r^12;
    r14 = r^14;
    r19 = r^19;
    z2 = z^2;
    z3 = z^3;
    z4 = z^4;
    z5 = z^5;
    z6 = z^6;
    z7 = z^7;
    z8 = z^8;
    z9 = z^9;
    J2R2 = e_cfg.J2*e_cfg.R^2;
    J3R3 = e_cfg.J3*e_cfg.R^3;
    J4R4 = e_cfg.J4*e_cfg.R^4;
    J5R5 = e_cfg.J5*e_cfg.R^5;
    J6R6 = e_cfg.J6*e_cfg.R^6;
    J7R7 = e_cfg.J7*e_cfg.R^7;
    J8R8 = e_cfg.J8*e_cfg.R^8;
    
    % X-component
    fx = e_cfg.mu*x/(128*r19) * ... % Lead coefficient
         (J2R2*(-192*r14+960*z2*r12) + ... % J2
         J3R3*(-960*z*r12+2240*z3*r10) + ... % J3 and so on
         J4R4*(240*r12-3360*z2*r10+5040*z4*r8) + ... % J4
         J5R5*(1680*z*r10-10080*z3*r8+11088*z5*r6) + ... % J5
         J6R6*(-280*r10+7560*z2*r8-27720*z4*r6+24024*z6*r4) + ... % J6
         J7R7*(-2520*z*r8+27720*z3*r6-72072*z5*r4+51480*z7*r2) + ... % J7
         J8R8*(315*r8-13860*z2*r6+90090*z4*r4-180180*z6*r2+109395*z8)); %J8
     
    % Y-component
    fy = e_cfg.mu*y/(128*r19) * ... % Lead coefficient
         (J2R2*(-192*r14+960*z2*r12) + ... % J2
         J3R3*(-960*z*r12+2240*z3*r10) + ... % J3
         J4R4*(240*r12-3360*z2*r10+5040*z4*r8) + ... % J4
         J5R5*(1680*z*r10-10080*z3*r8+11088*z5*r6) + ... % J5
         J6R6*(-280*r10+7560*z2*r8-27720*z4*r6+24024*z6*r4) + ... % J6
         J7R7*(-2520*z*r8+27720*z3*r6-72072*z5*r4+51480*z7*r2) + ... % J7
         J8R8*(315*r8-13860*z2*r6+90090*z4*r4-180180*z6*r2+109395*z8)); %J8
     
     % Z-component
     fz = e_cfg.mu/(128*r19) * ... % Lead coefficient
          (J2R2*(-576*z*r14+960*z3*r12) + ... % J2
          J3R3*(192*r14-1920*z2*r12+2240*z4*r10) + ... % J3
          J4R4*(1200*z*r12-5600*z3*r10+5040*z5*r8) + ... % J4
          J5R5*(-240*r12+5040*z2*r10-15120*z4*r8+11088*z6*r6) + ... % J5
          J6R6*(-1960*z*r10+17640*z3*r8-38808*z5*r6+24024*z7*r4) + ... % J6
          J7R7*(280*r10-10080*z2*r8+55440*z4*r6-96096*z6*r4+...
                51480*z8*r2) + ... % J7
          J8R8*(2835*z*r8-41580*z3*r6+162162*z5*r4-231660*z7*r2+...
                109395*z9)); % J8
     
     % Collation
     f_pert = [fx fy fz]';
end