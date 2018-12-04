function f_pert = get_sun_pert_force(R,D,s_cfg)
    % get_sun_pert_force.m
    % Using the current positions of the spacecraft and the Sun in the ECI
    % frame, determine the perturbing force exerted by the Sun's gravity.
    %
    % Inputs:
    %     R       s/c ECI frame position [km]
    %     D       Sun ECI frame position [km]
    %     s_cfg   struct containing parameters describing the Sun,
    %                 derivative of the system config struct
    %
    % Outputs:
    %     f_pert  force exerted by Sun 3rd Body perturbations [kN/kg]
    %
    % Author(s): Joseph Yates
    % AEROSP 548 F18 Final Project: Ha, Mohseni, Yates
    %
    % Sources: ThirdBodyPerturbationForceModeling.pdf lecture slides
    d = norm(D);
    RD = R - D;
    rd = norm(RD);
    f_pert = -s_cfg.mu*(RD/abs(rd)^3+D/abs(d)^3);
end