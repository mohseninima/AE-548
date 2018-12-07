function tle = parse_tle_from_txt(file_name)
    % parse_tle_from_txt.m
    % Converts a text (.txt) file-stored TLE into a TLE struct compatible
    % with the main propagator architecture.
    %
    % Author(s): Joseph Yates
    % AEROSP 548 F18 Final Project: Ha, Mohseni, Yates
    %
    % Sources:
    % "Two-line element set"
    %     https://en.wikipedia.org/wiki/Two-line_element_set
    % https://www.mathworks.com/matlabcentral/fileexchange/
    %     39364-two-line-element
    %
    % To do: Add better parsing for values in scientific notation (line 1)
    %        Make this look cleaner?
    
    % Open File -----------------------------------------------------------
    file = fopen(file_name,'r');
    
    % Line 1 --------------------------------------------------------------
    
    % Field Summary
    % 1  Line # (int)
    % 2  -space-
    % 3  Satellite Catalog Number (string)
    % 4  Classification (string)
    % 5  -space-
    % 6  Last Two Digits of Launch Year (int)
    % 7  Launch Number of the Year (int)
    % 8  Piece of the Launch (string)
    % 9  -space-
    % 10 Last Two Digits of Epoch Year [year] (int)
    % 11 Epoch Day and Fractional Day [day] (float)
    % 12 -space-
    % 13 First Time Derivative of Mean Motion Divided By 2 (string)
    % 14 -space-
    % 15 Second Time Derivative of Mean Motion Divided By 6 (string)
    % 16 -space-
    % 17 B*/BSTAR Drag Term (string)
    % 18 -space-
    % 19 0 (int)
    % 20 -space-
    % 21 Element Set Number (int)
    % 22 Line 1 Checksum (modulo 10) (int)
    
    % Read Line and Build Struct
    L1 = fscanf(file,'%1d%1c',[1 2]); % Line Number, space
    tle.line_1_num = L1(1);
    
    tle.sat_num = fscanf(file,'%5c',[1 1]);
    
    tle.sat_class = fscanf(file,'%1c',[1 1]);
    
    L1 = fscanf(file,'%1c%2d%3d',[1 3]); % space, Launch Year, Launch Num
    tle.launch_year = L1(2);
    tle.launch_num = L1(3);
    
    tle.launch_piece = fscanf(file,'%3c',[1 1]);

    L1 = fscanf(file,'%2d%12f%1c',[1 3]); % Epoch Year, Epoch Day, space
    tle.epoch_year = L1(1);
    tle.epoch_day = L1(2);
    
    tle.ndo2 = fscanf(file,'%10c',[1 1]);
    fscanf(file,'%1c',[1 1]) % space
    
    tle.nddo6 = fscanf(file,'%8c',[1 1]);
    fscanf(file,'%1c',[1 1]) % space
    
    tle.Bstar = fscanf(file,'%8c',[1 1]);
    
    L1 = fscanf(file,'%1c%1d%2c%3d%1d',[1 5]); % space, zero, space,
    tle.zero = L1(2);                          % Element Set Num, Checksum
    tle.element_set_num = L1(5); % %2c stores as two matrix entries,
    tle.line_1_checksum = L1(6); % despite being only one field.
    
    % Line 2 --------------------------------------------------------------
    % 1  Line # (int)
    % 2  -space-
    % 3  Satellite Catalog Number (string)
    % 4  -space-
    % 5  Inclination [deg] (float)
    % 6  -space-
    % 7  RAAN [deg] (float)
    % 8  -space-
    % 9  Eccentricity times 1e7 [] (int)
    % 10 -space-
    % 11 Argument of Perigee [deg] (float)
    % 12 -space-
    % 13 Mean Anomaly [deg] (float)
    % 14 -space-
    % 15 Mean Motion [rev/day] (float)
    % 16 Revolution Number at Epoch [] (int)
    % 17 Line 2 Checksum (modulo 10) (int)
    
    % Read - since there are no strings in the second line, do as batch
    format_L2 = '%1d%5d%8f%8f%7d%8f%8f%11f%5d%1d';
    L2 = fscanf(file,format_L2,[1 10]);
    
    % Build Struct
    tle.line_2_num = L2(1);
    tle.sat_num_val = L2(2);
    tle.i_deg = L2(3);
    tle.Om_deg = L2(4);
    tle.e = L2(5) * 1e-7;
    tle.om_deg = L2(6);
    tle.M_deg = L2(7);
    tle.n_rev_per_day = L2(8);
    tle.rev_num = L2(9);
    tle.line_2_checksum = L2(10);
    
    % Close File ----------------------------------------------------------
    fclose(file_name);
end