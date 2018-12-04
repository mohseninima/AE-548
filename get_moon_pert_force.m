function f_pert = get_moon_pert_force(R,D,m_cfg)
    % get_moon_pert_force.m
    % Using JPL ephemeris from 00:00:00.0 01/01/18, calculate the ECI frame
    % position of the moon at the current epoch.
    %
    % Inputs:
    %     R       s/c ECI frame position [km]
    %     D       moon ECI frame position [km]
    %     m_cfg   struct containing parameters describing the Moon,
    %                 derivative of the system config struct
    %
    % Outputs:
    %     f_pert  force exerted by Moon 3rd Body perturbations [kN/kg]
    %
    % Author(s): Joseph Yates
    % AEROSP 548 F18 Final Project: Ha, Mohseni, Yates
    %
    % Sources: ThirdBodyPerturbationForceModeling.pdf lecture slides
    d = norm(D);
    RD = R - D;
    rd = norm(RD);
    f_pert = -m_cfg.mu*(RD/abs(rd)^3+D/abs(d)^3);
end