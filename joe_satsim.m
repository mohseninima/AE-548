% Housekeeping
clear all;
close all;

% Hard-coded TLE: replace with TLE parser
tle.sat_num = '40379';
tle.epoch_year = 18;
tle.epoch_day = 333.50532158;
tle.ndo2 = .00001566;
tle.nddo6 = 00000e0;
tle.Bstar = 71119e-4;
tle.i_deg = 99.0880;
tle.Om_deg = 263.3887;
tle.e = .0138035;
tle.om_deg = 55.7924;
tle.M_deg = 305.6296;
tle.n_rev_per_day = 15.14814963;

% Create spacecraft, system, and simulation config structs from generation
% scripts
sc_cfg = spacecraft_3U_cubesat_config();
sys_cfg = system_config();
sim_cfg = sim_config();

% Generate initial conditions from TLE
init_cond = tle_to_init_cond(tle,sim_cfg,sys_cfg);

% Run simulation (Output: [days] [km] [km/s])
[T, R_ECI, V_ECI] = simulation(init_cond,sc_cfg,sys_cfg,sim_cfg);

% Generate plots
Tplot = T - init_cond.JD0;
epoch = num2str(init_cond.MJD0);
% Position and Velocity ECI Frame Plots
if sim_cfg.plot.rv_eci
    figure(11)
    ax(1) = subplot(3,1,1);
    plot(Tplot,R_ECI(:,1));
    ylabel('X [km]');
    title(['Inertial Position of ' tle.sat_num ' since MJD' epoch]);
    ax(2) = subplot(3,1,2);
    plot(Tplot,R_ECI(:,2));
    ylabel('Y [km]');
    ax(3) = subplot(3,1,3);
    plot(Tplot,R_ECI(:,3));
    ylabel('Z [km]');
    xlabel('Time [day]');
    linkaxes(ax,'x');

    figure(12)
    ax(1) = subplot(3,1,1);
    plot(Tplot,V_ECI(:,1));
    ylabel('V_X [km/s]');
    title(['Inertial Velocity of ' tle.sat_num ' since MJD' epoch]);
    ax(2) = subplot(3,1,2);
    plot(Tplot,V_ECI(:,2));
    ylabel('V_Y [km/s]');
    ax(3) = subplot(3,1,3);
    plot(Tplot,V_ECI(:,3));
    ylabel('V_Z [km/s]');
    xlabel('Time [day]');
    linkaxes(ax,'x');
    
    R = vecnorm(R_ECI,2,2); % position magnitude [km]
    Alt = R - sys_cfg.earth.R;
    figure(13)
    plot(Tplot,Alt);
    title(['Altitude of ' tle.sat_num ' since MJD' epoch]);
    xlabel('Time [day]');
    ylabel('r - R_E [km]');
end
% 3D Orbital Track Plot
if sim_cfg.plot.track_3d
    [XE, YE, ZE] = sphere(30); % Build reference sphere for Earth's surface
    figure(21)
    plot3(R_ECI(:,1),R_ECI(:,2),R_ECI(:,3),'-r');
    hold on;
    surf(XE*sys_cfg.earth.R, YE*sys_cfg.earth.R, ZE*sys_cfg.earth.R);
    hold off;
    axis(1.5*[-1e4 1e4 -1e4 1e4 -1e4 1e4]);
    title(['Orbital Trajectory of ' tle.sat_num ' since MJD' epoch]);
    xlabel('x_{ECI} [km]');
    ylabel('y_{ECI} [km]');
    zlabel('z_{ECI} [km]');
end