function viz_window_table = viz_window_generator(r_sc_vectors, times, gs)
    % viz_window_generator.m
    % Returns a MATLAB table containing the start time, end time, and
    % duration of "visibility windows" for a spacecraft at a specified
    % ground station. All timestamps in the final table are in UTC.
    %
    % Inputs:
    %   r_sc_vectors  : Array of SC's ECI Cartesian position vectors [km]
    %   times         : Array of UTC datetime objects for each position.
    %   gs            : String indicating ground station, e.g. 'fxb'
    %
    % Outputs:
    %   viz_window_table : MATLAB table of spacecraft visibility windows.
    %
    % Author(s): Brian Ha
    % AEROSP 548 F18 Final Project: Ha, Mohseni, Yates
    %
    % Sources:
    
    
    % Get the simulation configuration
    sim_cfg = sim_config();
    
    
    % Initialize data arrays
    Start_Time = [];
    End_Time = [];
    Duration = [];
    in_cone_bool_list = [];
    sc_angles = [];
    
    
    % Get the ground station ECEF cartesian position vector
    gs_cfg = gs_config(gs);
    r_gs_ecef = gs_cfg.r_ecef;
    
    
    % Check whether the SC is within the comm cone at each timestamp
    for i = 1:length(times)
        
        % Find the direction cosine matrix to convert from ECEF to ECI
        O_ecef_2_eci = get_ecef_2_eci_dcm(times(i));
        
        
        % Convert the ground station's position vector from ECEF to ECI
        r_gs_eci = O_ecef_2_eci*r_gs_ecef;
        
        
        % Check if the spacecraft is within the comm cone
        cone_half_angle = 90 - gs_cfg.min_comm_angle; % [deg]
        [in_cone_bool, angle] = check_if_sc_in_comm_cone(r_sc_vectors(i,:)', ...
                                                         r_gs_eci, ...
                                                         cone_half_angle);
        
        % Save the results
        in_cone_bool_list = [in_cone_bool_list; in_cone_bool];
        sc_angles = [sc_angles; angle];
        
    end
    
    
    % Plot the spacecraft angle relative to the ground station zenith
    if sim_cfg.plot.sc_angle == true
        figure(31)
        plot(times, sc_angles)
        hold on
        plot(times, cone_half_angle*ones(1,length(times)), 'r--')
        xlabel('UTC Timestamp', 'fontSize', sim_cfg.plot.axisFontSize)
        ylabel('[deg]', 'fontSize', sim_cfg.plot.axisFontSize)
        title('Spacecraft Angle Relative to Ground Station Zenith', ...
              'fontsize', sim_cfg.plot.titleFontSize)  
        legend({'SC Angle', 'GS Half Cone Angle'}, ... 
                'fontSize', sim_cfg.plot.legendFontSize, ...
                'location', 'southeast')
        grid on
        set(findall(gcf,'type','line'),'linewidth',2)
    end
    
    
    % Check if the spacecraft sim starts out in the comm cone. If so, the
    % beginning of the viz window is assumed to be unknown.
    if in_cone_bool_list(1) == true
        Start_Time = [Start_Time; "unknown"];
    end
    
    
    % Identify indices at which the spacecraft transitions into or out of
    % the comm cone. 
    transitions = diff(in_cone_bool_list); 
    
    
    % Determine Viz Window Start Times and End Times
    for j = 1:length(transitions)
        
        if transitions(j) == 1
            Start_Time = [Start_Time; string(times(j+1))];
            
        elseif transitions(j) == -1
            End_Time = [End_Time; string(times(j))];
            
        else
            continue
        end
        
    end
    
    
    % Check if the spacecraft sim ends in the comm cone. If so, the
    % end of the viz window is assumed to be unknown.
    if in_cone_bool_list(end) == true
        End_Time = [End_Time; "unknown"];
    end
    
    
    % Calculate the duration of each fully defined viz window
    for k = 1:length(Start_Time)
        
        if ~strcmp(string(Start_Time(k)), "unknown") && ...
                ~strcmp(string(End_Time(k)), "unknown")
            duration = datetime(End_Time(k)) - datetime(Start_Time(k));
        else
            duration = "unknown";
        end
        
        Duration = [Duration; string(duration)];

    end
    
    
    % Generate the final Viz Window Table
    viz_window_table = table(Start_Time, ...
                             End_Time, ...
                             Duration);

 
    % Print warning message if the viz window table is empty
    if isempty(viz_window_table)
        warning(['The Viz Window Table is empty. The spacecraft did '...
         'not enter the ground station comm. code during the simulation.'])
    end
    
end