function init_cond = tle_to_init_cond(tle,sim_cfg,sys_cfg)
    % tle_to_init_cond.m
    % Converts information from a TLE struct into a set of initial
    % conditions for a simulation, in both Keplerian orbital elements and
    % ECI-frame position and velocity vector formats. Also generate initial
    % time/epoch.
    %
    % Author(s): Joseph Yates
    % AEROSP 548 F18 Final Project: Ha, Mohseni, Yates
    %
    % Sources:
    
    % Epoch
    % First calculate Gregorian leap days elapsed since 00h 01 Jan 2000
    leap_days = floor(tle.epoch_year/4) + 1; % +1 for leap year 2000
    % Then calculate days elapsed in previous years (will probably bring us
    % to 00h 01 Jan 2018)
    days_to_year_start = 365 * tle.epoch_year + leap_days;
    % Then calculate decimal JD and MJD of current epoch
    init_cond.JD0 = sys_cfg.JDY2K + days_to_year_start + tle.epoch_day - 1;
    init_cond.MJD0 = init_cond.JD0 - sys_cfg.diff_JD_MJD;
    % Finally, convert to seconds for each time
    init_cond.JD0s = init_cond.JD0 * sys_cfg.s_per_solar_day;
    init_cond.MJD0s = init_cond.MJD0 * sys_cfg.s_per_solar_day;
    
    % Keplerian Elements
    init_cond.n = tle.n_rev_per_day * 2*pi /sys_cfg.s_per_solar_day;
    init_cond.a = (sys_cfg.earth.mu / init_cond.n^2)^(1/3);
    init_cond.e = tle.e;
    init_cond.i = tle.i_deg * sys_cfg.rad_per_deg;
    init_cond.Om = tle.Om_deg * sys_cfg.rad_per_deg;
    init_cond.om = tle.om_deg * sys_cfg.rad_per_deg;
    init_cond.M = tle.M_deg * sys_cfg.rad_per_deg;
    % Newton-Raphson method to find the eccentric anomaly
    [init_cond.phi,~] = mean_to_ecc_nr(init_cond.M,init_cond.e, ...
                                       sim_cfg.tol.nr_rel);
    % Inverse tangent to find true anomaly
    init_cond.th = 2*atan2(sqrt(1+init_cond.e)*tan(init_cond.phi/2), ...
                           sqrt(1-init_cond.e));
    if init_cond.th < 0
        init_cond.th = init_cond.th + 2*pi;
    end
    
    % Convert to position and velocity vectors in ECI frame
    [init_cond.R_ECI, init_cond.V_ECI] = coe2rveci(init_cond.a, ...
        init_cond.e,init_cond.i,init_cond.Om,init_cond.om,init_cond.th, ...
        sys_cfg.earth.mu);
end