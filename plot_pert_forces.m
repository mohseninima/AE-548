function plot_pert_forces(T,fd,name,epoch,sim_cfg)
    % plot_pert_forces.m
    % Generate plots of central and perturbation forces acting on the
    % spacecraft in question
    %
    % Inputs:
    %     T           Array of timestep values [day]
    %     fd          Struct of force data values for central and
    %                 perturbing forces exerted on s/c. [kN/kg]
    %     name        Satellite identifying name or catalog ID (string)
    %     epoch       MJD time at start of simulation (string)
    %     sim_cfg     simulation configuration struct
    %
    % Outputs:
    %     None
    %
    % Byproducts:
    %     Figure 41   Plots of all six force types
    %     Figure 42   Comparison plot of all six force magnitudes
    %
    % Author(s): Joseph Yates
    % AEROSP 548 F18 Final Project: Ha, Mohseni, Yates
    %
    % Sources:

    % Plot of all six force types
    figure(41)
    ax(1) = subplot(3,2,1);
    plot(T,fd.a_2bp(:,1),T,fd.a_2bp(:,2),T,fd.a_2bp(:,3));
    title(['Force Vectors Acting On ' name ' since MJD' epoch], ...
        'fontsize', sim_cfg.plot.titleFontSize);
    ylabel('F_{central} [kN/kg]', 'fontSize', sim_cfg.plot.axisFontSize);
    ax(2) = subplot(3,2,2);
    plot(T,fd.a_drag(:,1),T,fd.a_drag(:,2),T,fd.a_drag(:,3));
    % title(['Force Vectors Acting On ' name ' since MJD' epoch], ...
    %     'fontsize', sim_cfg.plot.titleFontSize);
    ylabel('F_{drag} [kN/kg]', 'fontSize', sim_cfg.plot.axisFontSize);
    ax(3) = subplot(3,2,3);
    plot(T,fd.a_m3ba(:,1),T,fd.a_m3ba(:,2),T,fd.a_m3ba(:,3));
    ylabel('F_{m3ba} [kN/kg]', 'fontSize', sim_cfg.plot.axisFontSize);
    ax(4) = subplot(3,2,4);
    plot(T,fd.a_s3ba(:,1),T,fd.a_s3ba(:,2),T,fd.a_s3ba(:,3));
    ylabel('F_{s3ba} [kN/kg]', 'fontSize', sim_cfg.plot.axisFontSize);
    ax(5) = subplot(3,2,5);
    plot(T,fd.a_srp(:,1),T,fd.a_srp(:,2),T,fd.a_srp(:,3));
    ylabel('F_{srp} [kN/kg]', 'fontSize', sim_cfg.plot.axisFontSize);
    xlabel('Time [day]', 'fontSize', sim_cfg.plot.axisFontSize);
    ax(6) = subplot(3,2,6);
    plot(T,fd.a_zh(:,1),T,fd.a_zh(:,2),T,fd.a_zh(:,3));
    ylabel('F_{zh} [kN/kg]', 'fontSize', sim_cfg.plot.axisFontSize);
    xlabel('Time [day]', 'fontSize', sim_cfg.plot.axisFontSize);
    legend({'F_x','F_y','F_z'},'fontSize',sim_cfg.plot.legendFontSize, ...
        'location','Southeast')
    linkaxes(ax,'x');
    set(findall(gcf,'type','line'),'linewidth',2)
    
    % Comparison plot of all six forces
    figure(42)
    semilogy(T,fd.mag_2bp,'-k',T,fd.mag_drag,'-b',T,fd.mag_m3ba,'-c', ...
             T,fd.mag_s3ba,'-r',T,fd.mag_srp,'-g',T,fd.mag_zh,'-m');
    title(['Forces Acting On ' name ' since MJD' epoch], ...
        'fontsize', sim_cfg.plot.titleFontSize);
    xlabel('Time [day]', 'fontSize', sim_cfg.plot.axisFontSize);
    ylabel('Force log([kN/kg])', 'fontSize', sim_cfg.plot.axisFontSize);
    legend({'Central','Drag','Moon Third Body','Sun Third Body', ...
        'Solar Radiation Pressure','Earth Zonal Harmonics'}, ...
        'location','Northeast','fontSize', sim_cfg.plot.legendFontSize)
    set(findall(gcf,'type','line'),'linewidth',2)
end