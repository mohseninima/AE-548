%% Housekeeping ===========================================================
clear all;
close all;

%% Hard-coded TLE: replace with TLE parser ================================
tle.sat_num = '40379';
tle.epoch_year = 18;
tle.epoch_day = 334.09980871; %333.50532158;
tle.ndo2 = .00001627; %.00001566;
tle.nddo6 = 00000e0;
tle.Bstar = 73693-4; %71119e-4;
tle.i_deg = 99.0881; %99.0880;
tle.Om_deg = 264.0985; %263.3887;
tle.e = .0138014; %.0138035;
tle.om_deg = 53.8357; %55.7924;
tle.M_deg = 307.5546; %305.6296;
tle.n_rev_per_day = 15.14817118; %15.14814963;

%% Check for Needed Toolboxes =============================================
% Determine whether the user has licenses for the Aerospace Toolbox and
% Mapping Toolbox in use.
has_aero_tbx = false;
has_map_tbx = false;

licenses = license('inuse');
num_lics = length(licenses);

for j = 1:num_lics
    if strcmp(licenses(j).feature,'aerospace_toolbox')
        has_aero_tbx = true;
    end
    if strcmp(licenses(j).feature,'map_toolbox')
        has_map_tbx = true;
    end
end

%% Build and Run Simulation ===============================================
% Create spacecraft, system, and simulation config structs from generation
% scripts
sc_cfg = spacecraft_3U_cubesat_config();
sys_cfg = system_config();
sim_cfg = sim_config();

% Generate initial conditions from TLE
init_cond = tle_to_init_cond(tle,sim_cfg,sys_cfg);

% Check if aerospace toolbox is installed and swap drag models if needed
if (~has_aero_tbx && sim_cfg.pert.drag_adv)
    warning(['You don''t have the aerospace toolbox so the' ...
          ' NRLMSISE-00model is unavailable. Please download the'...
          ' toolbox. Defaulting to the Harris-Priester model.']);
    sim_cfg.pert.drag = true;             % Include air drag in dynamics
    sim_cfg.pert.drag_adv = false;        % Remove NRLMSISE-00 air drag
end

% Run simulation (Output: [days] [km] [km/s])
[T, R_ECI, V_ECI] = simulation(init_cond,sc_cfg,sys_cfg,sim_cfg);
% This also creates `force_data` [kN/kg] as a byproduct, which we can use
% beyond this point.

%% Generate Propagator Plots ==============================================
% Convert simulation time from Julian date to UTC datetime objects
utc_tstamps = datetime(T, 'ConvertFrom', 'juliandate', 'TimeZone', 'UTC');
epoch = datestr(utc_tstamps(1)); % Get first value for plot titles

% Position and Velocity ECI Frame Plots
if sim_cfg.plot.rv_eci
    plot_rv(utc_tstamps,R_ECI,V_ECI,tle.sat_num,epoch,sys_cfg,sim_cfg);
end

% Keplerian Orbital Elements Plot
if sim_cfg.plot.kepler_oe
    plot_kepler_oe(utc_tstamps,R_ECI,V_ECI,tle.sat_num,epoch, ...
                   sys_cfg,sim_cfg);
end

% 3D Orbital Track Plot
if sim_cfg.plot.track_3d
    plot_track_3d(R_ECI,tle.sat_num,epoch,sys_cfg,sim_cfg);
end

% Force plotting
if sim_cfg.plot.pert_forces
    plot_pert_forces(utc_tstamps,force_data,tle.sat_num,epoch,sim_cfg);
end

%% Viz Windows ============================================================
% Generate Viz Windows
viz_window_table = viz_window_generator(R_ECI, utc_tstamps, 'fxb');
disp('Viz Windows')
disp(viz_window_table)


%% Plot Ground Track ======================================================
if sim_cfg.plot.track_2d
    if has_map_tbx
        plot_track_2d(R_ECI, utc_tstamps, tle.sat_num)
    else
        warning(['You don''t have the mapping toolbox so the ground '... 
          'track cannot be plotted. Please download the mapping toolbox.'])
    end
end
