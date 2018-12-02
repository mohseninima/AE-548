function [in_cone_bool, angle] = check_if_sc_in_comm_cone(r_sc_eci, ...
                                                          r_gs_eci, ...
                                                          cone_half_angle)
    % check_if_sc_in_comm_cone.m
    % Checks if a spacecraft (SC) is within the communications cone of a
    % ground station (GS). This is done by checking the angle between the
    % ground station's zenith direction and the position vector of the
    % spacecraft relative to the ground station.
    %
    % Inputs:
    %   r_sc_eci        : SC's [3x1] ECI Cartesian position vector [km]
    %   r_gs_eci        : GS's [3x1] ECI Cartesian position vector [km]
    %   cone_half_angle : Defines the max angle relative to the ground
    %                     station's zenith direction where communication is
    %                     considered possible. [deg]
    %
    % Outputs:
    %   in_cone_bool    : Boolean. True if spacecraft is within comm. cone.
    %   angle           : Angle between the ground station's zenith 
    %                     direction and the spacecraft. [deg]
    %
    % Author(s): Brian Ha
    % AEROSP 548 F18 Final Project: Ha, Mohseni, Yates
    %
    % Sources:
    
    
    % Determine ECI position vector of the SC relative to the GS
    r_rgs_2_sc_eci = r_sc_eci - r_gs_eci;
    
    
    % Normalize to obtain the unit vector pointing from the GS to the SC
    unit_rgs_2_sc = r_rgs_2_sc_eci/norm(r_rgs_2_sc_eci);
    
    
    % Normalize to obtain the unit vector pointing toward the GS's zenith
    unit_origin_2_rgs = r_gs_eci/norm(r_gs_eci);
    
    
    % Find the angle between these unit vectors.
    sin_angle = norm(cross(unit_origin_2_rgs, unit_rgs_2_sc));
    cos_angle = dot(unit_origin_2_rgs, unit_rgs_2_sc);
    
    angle = atan2(sin_angle,cos_angle);
    angle = rad2deg(angle);
    
    
    % Check if the spacecraft is within the communications cone.
    if abs(angle) <= cone_half_angle
        in_cone_bool = true;
    else
        in_cone_bool = false;
    end
end
