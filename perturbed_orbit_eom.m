function Xdot = perturbed_orbit_eom(t,X,sc_cfg,sys_cfg,sim_cfg)
    % perturbed_orbit_eom.m
    % Equations of motion differential equation for perturbed Earth orbit
    % spacecraft motion.
    %
    % Inputs:
    %     t       time since simulation start [s]
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

    % Calculate vector quantities
    R = X(1:3);
    r = norm(R);
    V = X(4:6);
    v = norm(V);
    
    % Basic R2BP Implementation ===========================================
    % Baseline R2BP equation: r" = -mu/r^3*R + F/m, all vectors in ECI
    % Baseline R2BP EOM
    a_2bp = -sys_cfg.earth.mu/r^3 * R;
    
    % Perturbing Forces ===================================================
    % Air Drag
    a_drag = [0 0 0]';
    if sim_cfg.pert.drag == true
       a_drag = [0 0 0]';
    end
    
    % Moon 3rd-Body Acceleration
    a_m3ba = [0 0 0]';
    if sim_cfg.pert.moon_3ba == true
       a_m3ba = [0 0 0]';
    end
    
    % Sun 3rd-Body Acceleration
    a_s3ba = [0 0 0]';
    if sim_cfg.pert.sun_3ba == true
       a_s3ba = [0 0 0]';
    end
    
    % Solar Radiation Pressure
    a_srp = [0 0 0]';
    if sim_cfg.pert.srp == true
       a_srp = [0 0 0]';
    end
    
    % Zonal Harmonics (J2, J3, ...)
    a_zh = [0 0 0]';
    if sim_cfg.pert.zonal_harmonics == true
       a_zh = [0 0 0]';
    end
    
    % EOM Setup ===========================================================
    Xdot(1:3) = V;
    Xdot(4:6) = a_2bp + a_drag + a_m3ba + a_s3ba + a_srp + a_zh;
    Xdot = Xdot(:);
end