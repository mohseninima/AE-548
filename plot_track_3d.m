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
    % Author(s): Joseph Yates, Nima Mohseni
    % AEROSP 548 F18 Final Project: Ha, Mohseni, Yates
    %
    % Sources:
    %https://www.mathworks.com/matlabcentral/fileexchange/13823-3d-earth-example
    % Build reference sphere for Earth's surface
    [XE, YE, ZE] = sphere(30);
    
    % Plot Earth and spacecraft 3D orbital track around the Earth
    figure(31)
    plot3(R(:,1),R(:,2),R(:,3),'-r');
    hold on;
    image_file = 'https://upload.wikimedia.org/wikipedia/commons/thumb/c/cd/Land_ocean_ice_2048.jpg/1024px-Land_ocean_ice_2048.jpg';
    globe = surf(XE*sys_cfg.earth.R, YE*sys_cfg.earth.R, -ZE*sys_cfg.earth.R);
    cdata = imread(image_file);
    set(globe, 'FaceColor', 'texturemap', 'CData', cdata, 'FaceAlpha', 1,'EdgeColor', 'none');
    scatter3(-1e4 + 2e4*rand(500,1),1e4*ones(500,1),-1e4 + 2e4*rand(500,1),abs(1*randn(500,1)),'w','.')
    scatter3(-1e4 + 2e4*rand(500,1),-1e4 + 2e4*rand(500,1),-1e4*ones(500,1),1*rand(500,1),'w','.')
    scatter3(1e4*ones(500,1),-1e4 + 2e4*rand(500,1),-1e4 + 2e4*rand(500,1),1*rand(500,1),'w','.')
    hold off;
    axis([-1e4,1e4,-1e4,1e4,-1e4,1e4])
    axis square
    title(['Orbital Trajectory of ' name ' since ' epoch], ...
        'fontsize',sim_cfg.plot.titleFontSize);
    xlabel('x_{ECI} [km]','fontSize',sim_cfg.plot.axisFontSize);
    ylabel('y_{ECI} [km]','fontSize',sim_cfg.plot.axisFontSize);
    zlabel('z_{ECI} [km]','fontSize',sim_cfg.plot.axisFontSize);
    set(findall(gcf,'type','line'),'linewidth',1)
    set(gca,'Color','k')
end