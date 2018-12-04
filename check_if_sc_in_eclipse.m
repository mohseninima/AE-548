function eclipse = check_if_sc_in_eclipse(Rpe,Rse,sys_cfg)
    % get_sun_position_simple.m
    % Using JPL ephemeris from 00:00:00.0 01/01/18, calculate the ECI frame
    % position of the sun at the current epoch.
    %
    % Inputs:
    %     Rpe     spacecraft position vector, ECI frame [km]
    %     Rse     Sun position vector w.r.t. Earth, ECI frame [km]
    %     sys_cfg celestial body system configuration struct
    %
    % Outputs:
    %     eclipse boolean indicating whether s/c is in eclipse
    %
    % Author(s): Joseph Yates
    % AEROSP 548 F18 Final Project: Ha, Mohseni, Yates
    %
    % Sources:
    %
    % Todo: Add occlusion by Moon as well?
    
    % Use vector geometry to determine whether we're in the cone behind the
    % Earth formed by the Earth's shadow: whether we're in eclipse
    % First, get magnitudes and unit vectors.
    rse = norm(Rse);
    rse_hat = Rse/rse;
    
    % Next, get angle for tangent line (cone when rotated) between Earth
    % and Sun spheres: inverse sine of difference in body radii over
    % distance between them.
    apex_half_angle = asin((sys_cfg.sun.R - sys_cfg.earth.R)/rse);
    
    % Solving for similar triangles, we can get the vector describing the
    % apex of the cone w.r.t. the center of the Earth. Magnitude of the
    % vector is determined by similar triangles, direction is opposite of
    % Sun vector.
    Roe = -sys_cfg.earth.R/(sin(apex_half_angle)) * rse_hat;
    
    % With vector arithmetic, we can get the spacecraft position vector
    % w.r.t. the apex of the eclipse cone. Comparing this vector to the
    % position vector of the Earth w.r.t the apex, we can determine whether
    % the spacecraft is in the cone by a dot product.
    Rpo = Rpe - Roe;
    Reo = -Roe;
    rpo = norm(Rpo);
    rpo_hat = Rpo/rpo;
    reo_hat = Reo/norm(Reo);
    % Since we normalized both vectors, we can go straight to inv. cosine
    vector_half_angle = acos(dot(reo_hat,rpo_hat));
    
    % This determines whether we're in the cone. But if we're on the cone
    % on the light side of the Earth, then we're still not in eclipse.
    % However, if our s/c position vector w.r.t. the apex is shorter than
    % the distance from the apex to the tangent point on the Earth, we can
    % definitively say that we are behind the Earth.
    tangent_apex_distance = sys_cfg.earth.R/tan(apex_half_angle);
    
    % If both criteria are true, then we are in eclipse. Else, we are not.
    eclipse = false;
    if (rpo <= tangent_apex_distance && ...
            vector_half_angle <= apex_half_angle)
        eclipse = true;
    end
end