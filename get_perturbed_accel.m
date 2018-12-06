function [a_2bp,a_drag,a_m3ba,a_s3ba,a_srp,a_zh] = get_perturbed_accel(...
                                                t,X,sc_cfg,sys_cfg,sim_cfg)
    % get_perturbed_accel.m
    % Calculate main central gravity acceleration of the spacecraft in
    % question, as well as all perturbing accelerations as they are enabled
    % in the simulation. Moved into a separate function so it can be called
    % by both the EOM function (perturbed_orbit_eom.m) and the force data
    % recorder (force_save.m).
    %
    % Inputs:
    %     t       Julian Day time converted to seconds [s]
    %     X       spacecraft kinematic state [km][km/s]
    %     sc_cfg  spacecraft configuration struct
    %     sys_cfg celestial body system configuration struct
    %     sim_cfg simulation configuration struct
    %
    % Outputs:
    %     a_2bp   central body "2-Body Problem" grav. acceleration [km/s^2]
    %     a_drag  drag force acceleration [km/s^2]
    %     a_m3ba  third body grav. acceleration due to moon [km/s^2]
    %     a_s3ba  third body grav. acceleration due to sun [km/s^2]
    %     a_srp   solar radiation pressure acceleration [km/s^2]
    %     a_zh    Earth zonal harmonics grav. acceleration [km/s^2]
    %
    % Author(s): Joseph Yates
    % AEROSP 548 F18 Final Project: Ha, Mohseni, Yates
    %
    % Sources:
    
    % Calculate vector quantities and JD epoch ============================
    tJD = t / sys_cfg.s_per_solar_day;
    R = X(1:3);
    r = norm(R);
    V = X(4:6);
    
    % Central Force =======================================================
    % Baseline R2BP equation: r" = -mu/r^3*R + F/m, all vectors in ECI
    % Baseline R2BP EOM
    a_2bp = -sys_cfg.earth.mu/r^3 * R;
    
    % Perturbing Forces ===================================================
    % Sun ECI Position Calculation - Used in Air Drag, Sun 3BA, and SRP.
    if (sim_cfg.pert.drag || sim_cfg.pert.sun_3ba || sim_cfg.pert.srp)
        Rs = get_sun_position_simple(tJD,sys_cfg,sim_cfg);
    end
    
    % Air Drag
    a_drag = [0 0 0]';
    if sim_cfg.pert.drag && ~sim_cfg.pert.drag_adv
        a_drag = get_drag_pert_force_hp(R,V,Rs,sc_cfg,sys_cfg);
    elseif ~sim_cfg.pert.drag && sim_cfg.pert.drag_adv
        a_drag = get_drag_pert_force_msis(R,V,sc_cfg,sys_cfg,tJD);
    elseif sim_cfg.pert.drag && sim_cfg.pert.drag_adv
        disp('You have both drag models enabled')
    end
    
    % Moon 3rd-Body Acceleration
    a_m3ba = [0 0 0]';
    if sim_cfg.pert.moon_3ba
        % Moon ECI Position Calculation
        Rm = get_moon_position_simple(tJD,sys_cfg,sim_cfg);
        a_m3ba = get_moon_pert_force(R,Rm,sys_cfg.moon);
    end
    
    % Sun 3rd-Body Acceleration
    a_s3ba = [0 0 0]';
    if sim_cfg.pert.sun_3ba
        a_s3ba = get_sun_pert_force(R,Rs,sys_cfg.sun);
    end
    
    % Solar Radiation Pressure
    a_srp = [0 0 0]';
    if sim_cfg.pert.srp
        eclipse = check_if_sc_in_eclipse(R,Rs,sys_cfg);
        a_srp = get_srp_pert_force(R,Rs,eclipse,sc_cfg,sys_cfg);
    end
    
    % Zonal Harmonics (J2, J3, ... , J8)
    a_zh = [0 0 0]';
    if sim_cfg.pert.zonal_harmonics
        a_zh = get_zonal_harmonic_pert_force(R,sys_cfg.earth);
    end
end