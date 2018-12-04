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
data_length = length(T);
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

% Keplerian Orbital Elements Plots
if sim_cfg.plot.kepler_oe
    A = zeros(data_length,6);
    for i = 1:data_length
        [A(i,1),A(i,2),A3,A4,A5,A6] = rveci2coe(R_ECI(i,:),V_ECI(i,:), ...
                                                sys_cfg.earth.mu);
        A(i,3) = A3 * sys_cfg.deg_per_rad;
        A(i,4) = A4 * sys_cfg.deg_per_rad;
        A(i,5) = A5 * sys_cfg.deg_per_rad;
        A(i,6) = A6 * sys_cfg.deg_per_rad;
    end
    
    figure(15)
    ax(1) = subplot(3,2,1);
    plot(Tplot,A(:,1));
    title(['Orbital Elements of ' tle.sat_num ' since MJD' epoch]);
    ylabel('a [km]');
    ax(2) = subplot(3,2,2);
    plot(Tplot,A(:,2));
    % title(['Orbital Elements of ' tle.sat_num ' since MJD' epoch]);
    ylabel('e');
    ax(3) = subplot(3,2,3);
    plot(Tplot,A(:,3));
    ylabel('i [deg]');
    ax(4) = subplot(3,2,4);
    plot(Tplot,A(:,4));
    ylabel('\Omega [deg]');
    ax(5) = subplot(3,2,5);
    plot(Tplot,A(:,5));
    ylabel('\omega [deg]');
    xlabel('Time [day]');
    ax(6) = subplot(3,2,6);
    plot(Tplot,A(:,6));
    ylabel('\theta [deg]');
    xlabel('Time [day]');
    linkaxes(ax,'x');
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


% Convert simulation time from Julian date to UTC datetime objects
utc_tstamps = datetime(T, 'ConvertFrom', 'juliandate', 'TimeZone', 'UTC');


% Generate Viz Windows
viz_window_table = viz_window_generator(R_ECI, utc_tstamps, 'fxb');
disp('Viz Windows')
disp(viz_window_table)

