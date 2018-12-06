function plot_rv(T,R,V,name,epoch,sys_cfg,sim_cfg)
    % plot_pert_forces.m
    % Generate plots of central and perturbation forces acting on the
    % spacecraft in question
    %
    % Inputs:
    %     T           Array of timestep values [day]
    %     R           Spacecraft ECI-frame position vector array [km]
    %     V           Spacecraft ECI-frame velocity vector array [km/s]
    %     name        Satellite identifying name or catalog ID (string)
    %     epoch       MJD time at start of simulation (string)
    %     sys_cfg     celestial body system configuration struct
    %     sim_cfg     simulation configuration struct
    %
    % Outputs:
    %     None
    %
    % Byproducts:
    %     Figure 11   Spacecraft ECI position X,Y,Z
    %     Figure 12   Spacecraft ECI velocity Vx,Vy,Vz
    %     Figure 13   Spacecraft altitude ||R|| - R_E
    %
    % Author(s): Joseph Yates
    % AEROSP 548 F18 Final Project: Ha, Mohseni, Yates
    %
    % Sources:
    
    % Spacecraft ECI Position Plot
    figure(11)
    ax(1) = subplot(3,1,1);
    plot(T,R(:,1));
    ylabel('X [km]','fontSize',sim_cfg.plot.axisFontSize);
    title(['Inertial Position of ' name ' since ' epoch], ...
        'fontsize',sim_cfg.plot.titleFontSize);
    ax(2) = subplot(3,1,2);
    plot(T,R(:,2));
    ylabel('Y [km]','fontSize',sim_cfg.plot.axisFontSize);
    ax(3) = subplot(3,1,3);
    plot(T,R(:,3));
    ylabel('Z [km]','fontSize',sim_cfg.plot.axisFontSize);
    xlabel('Time (UTC)','fontSize',sim_cfg.plot.axisFontSize);
    linkaxes(ax,'x');
    set(findall(gcf,'type','line'),'linewidth',2)

    % Spacecraft ECI Velocity Plot
    figure(12)
    ax(1) = subplot(3,1,1);
    plot(T,V(:,1));
    ylabel('V_X [km/s]','fontSize',sim_cfg.plot.axisFontSize);
    title(['Inertial Velocity of ' name ' since ' epoch], ...
        'fontsize',sim_cfg.plot.titleFontSize);
    ax(2) = subplot(3,1,2);
    plot(T,V(:,2));
    ylabel('V_Y [km/s]','fontSize',sim_cfg.plot.axisFontSize);
    ax(3) = subplot(3,1,3);
    plot(T,V(:,3));
    ylabel('V_Z [km/s]','fontSize',sim_cfg.plot.axisFontSize);
    xlabel('Time (UTC)','fontSize',sim_cfg.plot.axisFontSize);
    linkaxes(ax,'x');
    set(findall(gcf,'type','line'),'linewidth',2)
    
    % Spacecraft Altitude
    % Calculate altitude values for each timestep
    data_length = length(T);    % Get length of data
    Alt = zeros(data_length,1); % Allocate and populate altitude values
    for i = 1:data_length
        Alt(i) = norm(R(i,:),2) - sys_cfg.earth.R;
    end
    
    % Plot
    figure(13)
    plot(T,Alt);
    title(['Altitude of ' name ' since ' epoch], ...
        'fontsize',sim_cfg.plot.titleFontSize);
    xlabel('Time (UTC)','fontSize',sim_cfg.plot.axisFontSize);
    ylabel('r - R_E [km]','fontSize',sim_cfg.plot.axisFontSize);
    set(findall(gcf,'type','line'),'linewidth',2)
end