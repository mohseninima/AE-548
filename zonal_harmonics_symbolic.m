function zonal_harmonics_symbolic()
    % Set up constants
    mu = sym('mu');
    Re = sym('Re');
    J2 = sym('J2');
    J3 = sym('J3');
    J4 = sym('J4');
    J5 = sym('J5');
    J6 = sym('J6');
    J7 = sym('J7');
    J8 = sym('J8');

    % Set up coords
    x = sym('x');
    y = sym('y');
    z = sym('z');
    r = sqrt(x^2+y^2+z^2);
    sphi = z/r;
    
    % Potential function
    Ps = -1 + ... 
         J2*Re^2/r^2*1/2*(3*sphi^2-1) + ...
         J3*Re^3/r^3*1/2*(5*sphi^3 - 3*sphi) + ...
         J4*Re^4/r^4*1/8*(35*sphi^4-30*sphi^2+3) + ...
         J5*Re^5/r^5*1/8*(63*sphi^5-70*sphi^3+15*sphi) + ...
         J6*Re^6/r^6*1/16*(231*sphi^6-315*sphi^4+105*sphi^2-5) + ... 
         J7*Re^7/r^7*1/16*(429*sphi^7-693*sphi^5+315*sphi^3-35*sphi) + ...
         J8*Re^8/r^8*1/128*(6435*sphi^8-12012*sphi^6+6930*sphi^4-1260* ...
                            sphi^2+35);
    U = mu/r*Ps;
    
    % Equations of motion
    xdd = simplify(-diff(U,x))
    ydd = simplify(-diff(U,y))
    zdd = simplify(-diff(U,z))
    
    pretty(xdd)
    pretty(ydd)
    pretty(zdd)
end