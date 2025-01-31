function SZA = calcSZA(inputs,step)

% Defunct code. Keeping it in folder as it may be useful later

%Calculates the heliocentric position of the Earth. Begins at noon 

% Need to add in an altitude correction

ecliptic = 23.44;

N = step.stephour/24;
%N has to equal number of days since start of year
%N = 
declination = asin(sind(-ecliptic)*cosd((360/365.24)*(N+10)...
        +(360/pi)*.0167*sind((360/365.24)*(N-2))));

angularstep = 360./(24./step.hour);
%gridsize(1)/(24/control.hour);
hour_angle = 180-angularstep;    
    
SZA = acos(sind(inputs.latitude)*sin(declination)+...
           cosd(inputs.latitude)*cos(declination)*cosd(hour_angle)).*180./pi;

end
