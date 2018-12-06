function status = force_save(t,X,flag,sc_cfg,sys_cfg,sim_cfg)
    % force_save.m
    % "Output Function" corresponding to the call to ode45.m, that
    % recalculates all forces acting on the spacecraft and saves them to a
    % persistent struct, which goes to the top-level script to be used for
    % plotting. This makes that persistent struct, `force_data`, a de facto
    % by product of simulation.m.
    %
    % Inputs:
    %     t           Julian Day time converted to seconds [s]
    %     X           spacecraft kinematic state [km][km/s]
    %     sc_cfg      spacecraft configuration struct
    %     sys_cfg     celestial body system configuration struct
    %     sim_cfg     simulation configuration struct
    %
    % Outputs:
    %     status      integer indicating function status on exit, used by
    %                 ode45.m.
    %
    % Byproducts:
    %     force_data  output struct containing central and perturbing force
    %                 values at each timestep. [kN/kg]
    %
    % Author(s): Joseph Yates
    % AEROSP 548 F18 Final Project: Ha, Mohseni, Yates
    %
    % Sources:
    % https://www.mathworks.com/help/matlab/ref/odeset.html
    % https://www.mathworks.com/matlabcentral/answers/305698-how-do-i-
    %     extract-extra-parameters-from-the-ode45-ordinary-differential-
    %     equation-solver-function
    % https://www.mathworks.com/matlabcentral/answers/312549-get-variable-
    %     out-of-ode-45

    persistent force_data
    
    switch flag
        % First-iteration case
        case 'init'            
            % Re-calculate accelerations (because MATLAB ODE solvers are
            % clunky)
            [a_2bp,a_drag,a_m3ba,a_s3ba,a_srp,a_zh...
                ] = get_perturbed_accel(t(1),X,sc_cfg,sys_cfg,sim_cfg);
            
            % Save acceleration vectors
            force_data.a_2bp = a_2bp';
            force_data.a_drag = a_drag';
            force_data.a_m3ba = a_m3ba';
            force_data.a_s3ba = a_s3ba';
            force_data.a_srp = a_srp';
            force_data.a_zh = a_zh';
            
            % Save acceleration magnitudes
            force_data.mag_2bp = norm(a_2bp);
            force_data.mag_drag = norm(a_drag);
            force_data.mag_m3ba = norm(a_m3ba);
            force_data.mag_s3ba = norm(a_s3ba);
            force_data.mag_srp = norm(a_srp);
            force_data.mag_zh = norm(a_zh);
            
        % Iteration case
        case ''
            cols = size(X,2);
            for i = 1:cols
                % Recalculate accelerations
                [a_2bp,a_drag,a_m3ba,a_s3ba,a_srp,a_zh...
                    ] = get_perturbed_accel(t(1),X(:,i), ...
                                            sc_cfg,sys_cfg,sim_cfg);

                % Save acceleration vectors
                force_data.a_2bp = [force_data.a_2bp; a_2bp'];
                force_data.a_drag = [force_data.a_drag; a_drag'];
                force_data.a_m3ba = [force_data.a_m3ba; a_m3ba'];
                force_data.a_s3ba = [force_data.a_s3ba; a_s3ba'];
                force_data.a_srp = [force_data.a_srp; a_srp'];
                force_data.a_zh = [force_data.a_zh; a_zh'];

                % Save acceleration magnitudes
                force_data.mag_2bp = [force_data.mag_2bp; norm(a_2bp)];
                force_data.mag_drag = [force_data.mag_drag; norm(a_drag)];
                force_data.mag_m3ba = [force_data.mag_m3ba; norm(a_m3ba)];
                force_data.mag_s3ba = [force_data.mag_s3ba; norm(a_s3ba)];
                force_data.mag_srp = [force_data.mag_srp; norm(a_srp)];
                force_data.mag_zh = [force_data.mag_zh; norm(a_zh)];
            end
            
        case 'done'
            assignin('base','force_data',force_data);
    end
    
    status = 0;
end