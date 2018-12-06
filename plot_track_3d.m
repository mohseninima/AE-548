function plot_track_3d(R,name,epoch,sys_cfg,sim_cfg)
    % plot_kepler_oe.m
    % Generate a plot Keplerian orbital elements for the spacecraft over
    % the simulation time period.
    %
    % Inputs:
    %     R           Spacecraft ECI-frame position vector array [km]
    %     name        Satellite identifying name or catalog ID (string)
    %     epoch       MJD time at start of simulation (string)
    %     sys_cfg     celestial body system configuration struct
    %     sim_cfg     simulation configuration struct
    %
    % Outputs:
    %     None
    %
    % Byproducts:
    %     Figure 31   Plot spacecraft 3D orbital track around the Earth
    %
    % Author(s): Joseph Yates
    % AEROSP 548 F18 Final Project: Ha, Mohseni, Yates
    %
    % Sources:
    
    % Build reference sphere for Earth's surface
    [XE, YE, ZE] = sphere(30);
    
    % Plot Earth and spacecraft 3D orbital track around the Earth
    figure(31)
    plot3(R(:,1),R(:,2),R(:,3),'-r');
    hold on;
    surf(XE*sys_cfg.earth.R, YE*sys_cfg.earth.R, ZE*sys_cfg.earth.R);
    hold off;
    axis square
    title(['Orbital Trajectory of ' name ' since MJD' epoch], ...
        'fontsize',sim_cfg.plot.titleFontSize);
    xlabel('x_{ECI} [km]','fontSize',sim_cfg.plot.axisFontSize);
    ylabel('y_{ECI} [km]','fontSize',sim_cfg.plot.axisFontSize);
    zlabel('z_{ECI} [km]','fontSize',sim_cfg.plot.axisFontSize);
    set(findall(gcf,'type','line'),'linewidth',2)
end