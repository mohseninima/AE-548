function f_pert = get_srp_pert_force(Rpe,Rse,eclipse,sc_cfg,sys_cfg)
    % get_srp_pert_force.m
    % Using the current position of the spacecraft and Sun in the ECI
    % frame, properties of the solar system, spacecraft eclipse status, and
    % properties of the spacecraft, determine the average approximate
    % perturbing force exerted by solar radiation pressure.
    %
    % Inputs:
    %     Rpe     Spacecraft ECI frame position [km]
    %     Rse     Sun ECI frame position [km]
    %     eclipse boolean describing eclipse status of spacecraft
    %     sc_cfg  spacecraft configuration struct
    %     sys_cfg celestial body system configuration struct
    %
    % Outputs:
    %     f_pert  force exerted by solar radiation pressure [kN/kg]
    %
    % Author(s): Joseph Yates
    % AEROSP 548 F18 Final Project: Ha, Mohseni, Yates
    %
    % Sources: AirDragAndSolarRadiationPressure.pdf lecture slides
    
    % If we're in eclipse, immediately return 0:
    if eclipse
       f_pert = [0 0 0]';
       return
    end
    
    % Calculate useful vector quantities
    Rsp = Rse - Rpe;
    rsp = norm(Rsp);
    rsp_hat = Rsp/rsp;
    
    % Force calculation
    % MAJOR ASSUMPTION: Because we're calculating the average SRP force,
    % we make approximations about the directions of the faces of the
    % spacecraft. Furthermore, because our spacecraft is a CubeSat, which
    % is approximately a regular rectangular prism, it can be shown that
    % the net force by drag-like forces normal to faces applies no torque
    % on the body (this holds for the rectangular prism assumption, despite
    % that this is counter-intuitive). Therefore we approximate the normal
    % unit vector as the unit vector from the spacecraft to the Sun. This
    % means that the SRP equation, as described in the slides, reduces:
    % nhat = eshat; cos(theta) = dot(eshat,nhat) = 1
    % F = -Ps*1AU^2/rs^2*A*cos(theta)*((1-eps)*eshat+2*eps*cos(theta)*nhat)
    % =>   F = -Ps*1AU^2/rs^2*A*((1+eps)*eshat)
    F_pert = -sys_cfg.earth.SRP * (sys_cfg.km_per_AU)^2/rsp^2 * ...
             sc_cfg.As * ((1+sc_cfg.ep)*rsp_hat);
    
    % Normalize force by spacecraft mass
    f_pert = F_pert/sc_cfg.m;
end