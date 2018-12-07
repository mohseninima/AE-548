function plot_kepler_oe(T,R,V,name,epoch,sys_cfg,sim_cfg)
    % plot_kepler_oe.m
    % Generate a plot Keplerian orbital elements for the spacecraft over
    % the simulation time period.
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
    %     Figure 21   Plots of all six orbital elements
    %
    % Author(s): Joseph Yates
    % AEROSP 548 F18 Final Project: Ha, Mohseni, Yates
    %
    % Sources:
    
    % Get length of data and convert position and velocity to elements
    data_length = length(T);
    A = zeros(data_length,6);
    for j = 1:data_length
        [A(j,1),A(j,2),A3,A4,A5,A6] = rveci2coe(R(j,:),V(j,:), ...
                                                sys_cfg.earth.mu);
        % Plot angles in degrees
        A(j,3) = A3 * sys_cfg.deg_per_rad;
        A(j,4) = A4 * sys_cfg.deg_per_rad;
        A(j,5) = A5 * sys_cfg.deg_per_rad;
        A(j,6) = A6 * sys_cfg.deg_per_rad;
    end
    
    % Plot semi-major axis, eccentricity, inclination, RAAN, argper, and
    % true anomaly together via subplots
    figure(21)
    ax(1) = subplot(3,2,1);
    plot(T,A(:,1));
    title(['Orbital Elements of ' name ' since ' epoch], ...
        'fontsize',sim_cfg.plot.titleFontSize);
    ylabel('a [km]','fontSize',sim_cfg.plot.axisFontSize);
    ax(2) = subplot(3,2,2);
    plot(T,A(:,2));
    % title(['Orbital Elements of ' name ' since MJD' epoch], ...
    %     'fontsize', sim_cfg.plot.titleFontSize);
    ylabel('e', 'fontSize',sim_cfg.plot.axisFontSize);
    ax(3) = subplot(3,2,3);
    plot(T,A(:,3));
    ylabel('i [deg]','fontSize',sim_cfg.plot.axisFontSize);
    ax(4) = subplot(3,2,4);
    plot(T,A(:,4));
    ylabel('\Omega [deg]','fontSize',sim_cfg.plot.axisFontSize);
    ax(5) = subplot(3,2,5);
    plot(T,A(:,5));
    ylabel('\omega [deg]','fontSize',sim_cfg.plot.axisFontSize);
    xlabel('Time (UTC)','fontSize',sim_cfg.plot.axisFontSize);
    ax(6) = subplot(3,2,6);
    plot(T,A(:,6));
    ylabel('\theta [deg]','fontSize',sim_cfg.plot.axisFontSize);
    xlabel('Time (UTC)','fontSize',sim_cfg.plot.axisFontSize);
    linkaxes(ax,'x');
    set(findall(gcf,'type','line'),'linewidth',2)
end
    