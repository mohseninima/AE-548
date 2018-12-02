% unit_test_for_viz_window_generator.m
% Runs a unit test on the viz window generator.
%
% Author(s): Brian Ha
% AEROSP 548 F18 Final Project: Ha, Mohseni, Yates


% Housekeeping
clear variables
close all
clc


% Setup 10 time stamps
t1 = datetime(2018, 12, 1, 0, 0, 1);
t2 = datetime(2018, 12, 1, 0, 0, 2);
t3 = datetime(2018, 12, 1, 0, 0, 3);
t4 = datetime(2018, 12, 1, 0, 0, 4);
t5 = datetime(2018, 12, 1, 0, 0, 5);
t6 = datetime(2018, 12, 1, 0, 0, 6);
t7 = datetime(2018, 12, 1, 0, 0, 7);
t8 = datetime(2018, 12, 1, 0, 0, 8);
t9 = datetime(2018, 12, 1, 0, 0, 9);
t10 = datetime(2018, 12, 1, 0, 0, 10);


times = [t1; t2; t3; t4; t5; t6; t7; t8; t9; t10];


% Get the ECI position vector of the FXB ground station
gs_cfg = gs_config('fxb');
O_ecef_2_eci = get_ecef_2_eci_dcm(t5);
r_gs_eci = O_ecef_2_eci*gs_cfg.r_ecef;


% Setup 10 spacecraft position vectors in the same direction as the GS. 
% Make these negative to make the spacecraft "leave" the comm cone.
r_sc_vectors = [
    -2*r_gs_eci';
    2*r_gs_eci';
    2*r_gs_eci';
    2*r_gs_eci';
    2*r_gs_eci';
    -2*r_gs_eci';
    -2*r_gs_eci';
    2*r_gs_eci';
    2*r_gs_eci';
    -2*r_gs_eci';];

%r_sc_vectors = -1*r_sc_vectors;


% Generate a Viz Window Table
viz_window_table = viz_window_generator(r_sc_vectors, times, 'fxb');
disp(viz_window_table)

%{
% SCENARIOS TO TEST
PASS 1. Sim Starts Outside Cone, Never Enters  --> Empty Table
PASS 2. Sim Starts Inside Cone, Never Leaves   --> Unknown Table
PASS 3. Sim Starts Inside Cone, and Leaves Once --> Report End Time, no duration
PASS 4. Sim Starts Outside Cone, and Enters Once --> Report Start Time, no duration
PASS 5. Sim Starts Inside, Multiple Transitions, Finishes In --> One missing start, One missing End
PASS 6. Sim Starts Inside, Multiple Transitions, Finishes Out --> One missing start
PASS 7. Sim Starts Outside, Multiple Transitions, Finishes In --> One Missing End
PASS 8. Sim Starts Outside, Multiple Transitions, Finishes Out --> Complete Table
%}