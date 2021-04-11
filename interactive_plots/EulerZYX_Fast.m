function R = EulerZYX_Fast(rpy) % Note BY Qihan: Same with eul2rotm([1 2 3], 'XYZ')
%RYZ_Fast Calculates the Z->Y->X rotation matrix. Input is R-P-Y in radians

r = rpy(1); % Along X
p = rpy(2); % Along Y
y = rpy(3); % Along Z

R = zeros(3,3);
% First Column
R(1,1) = cos(y)*cos(p);
R(2,1) = sin(y)*cos(p);
R(3,1) =       -sin(p);

% Second Column
R(1,2) = -sin(y)*cos(r)  +  cos(y)*sin(p)*sin(r);
R(2,2) =  cos(y)*cos(r)  +  sin(y)*sin(p)*sin(r);
R(3,2) =                           cos(p)*sin(r);

% Third Column
R(1,3) =  sin(y)*sin(r)  +  cos(y)*sin(p)*cos(r);
R(2,3) = -cos(y)*sin(r)  +  sin(y)*sin(p)*cos(r);
R(3,3) =                           cos(p)*cos(r);

end