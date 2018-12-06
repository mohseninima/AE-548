function Xdot = perturbed_orbit_eom(t,X,sc_cfg,sys_cfg,sim_cfg)
    % perturbed_orbit_eom.m
    % Equations of motion differential equation for perturbed Earth orbit
    % spacecraft motion.
    %
    % Inputs:
    %     t       Julian Day time converted to seconds [s]
    %     X       spacecraft kinematic state [km][km/s]
    %     sc_cfg  spacecraft configuration struct
    %     sys_cfg celestial body system configuration struct
    %     sim_cfg simulation configuration struct
    %
    % Outputs:
    %     Xdot    time derivative of the s/c kinematic state [km/s][km/s^2]
    %
    % Author(s): Joseph Yates
    % AEROSP 548 F18 Final Project: Ha, Mohseni, Yates
    %
    % Sources:
    
    % Get all accelerations of spacecraft =================================
    [a_2bp,a_drag,a_m3ba,a_s3ba,a_srp,a_zh] = get_perturbed_accel(...
                                               t,X,sc_cfg,sys_cfg,sim_cfg);
    
    % EOM =================================================================
    Xdot(1:3) = X(4:6);
    Xdot(4:6) = a_2bp + a_drag + a_m3ba + a_s3ba + a_srp + a_zh;
    Xdot = Xdot(:);
end