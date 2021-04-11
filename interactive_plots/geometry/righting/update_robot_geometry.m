%% notes
% the origin of CAD model works when reconstructing motion, but is not at
% COM
% the COM data has to be considered separately for some parts



HEAD = 1;
M1 = 2; M2 = 3; M3  = 4; M4 = 5; M5 = 6;
PEN = 7; TAIL = 8;
W1 = 9; W2 = 10;
entities = {'head','motor1','motor2','motor3','motor4','motor5','pen','tail','wing1','wing2'};

rel_config = [ -90 -12  0,    50.52    0    8.12 ; ....   M5 to Head          
                90  74  0,    70     -24    6.64 ; ....   M3 to M1
                90  74  0,    70      24    6.64 ; ....   M4 to M2
                 0  90  0,    27     -26   -3    ; ....   M5 to M3
                 0  90  0,    27     +26   -3    ; ....   M5 to M4
                 0  90  0,     0       0    0    ; ....   M5 to M5
                 0   0  0,   -64       0   32.5  ; ....   M5 to PEN      
                 0   0 90,   -26       0   17.75 ; ....   M5 to TAIL
               100   5  5,   -21.77  -29   19.7  ; ....   M1 to W1
                80   5 -5,   -21.77   29   19.7  ; ....   M2 to W2
            ];
             
%% geometry input


pitch_ang_L = wing_ip;
pitch_ang_R = wing_ip;
roll_ang_L = wing_ip;
roll_ang_R = wing_ip;

vib_ang = 0;    

% Body rotation measured by the IMU
R_body = EulerZYX_Fast([roll_ip pitch_ip 0]);



%% M345/HEAD
HeadOrigin_HeadCom = [77.46; -1.205 ; 7.186];

% M5
robot(M5).position = [0 0 0]';
robot(M5).orientation = eye(3); 

% HEAD
robot(HEAD).orientation= eye(3);
robot(HEAD).position = robot(M5).position  + rel_config(HEAD,4:6)';

% M3-M4
robot(M3).orientation = eye(3); 
robot(M4).orientation = eye(3);
robot(M3).position = robot(M5).position  + rel_config(M3,4:6)';
robot(M4).position = robot(M5).position  + rel_config(M4,4:6)';   

%% M1-M2 
robot(M1).orientation = robot(M3).orientation*EulerZYX_Fast([ 0 -(pitch_ang_R) 0]*pi/180); 
robot(M2).orientation = robot(M4).orientation*EulerZYX_Fast([ 0 -(pitch_ang_L) 0]*pi/180);

M3Origin_M1RotCenter = [ 5.91;  0; 1.63];    M4Origin_M2RotCenter = [ 5.91;  0; 1.63];   
M1RotCenter_M1Origin = [37.1 ; -2; 6.51];    M2RotCenter_M2Origin = [37.1 ;  2; 6.51];

robot(M1).position =   robot(M3).position + ...
                       robot(M3).orientation*M3Origin_M1RotCenter + ...
                       robot(M1).orientation*M1RotCenter_M1Origin;                       
robot(M2).position =   robot(M4).position + ...
                       robot(M4).orientation*M4Origin_M2RotCenter + ...
                       robot(M2).orientation*M2RotCenter_M2Origin;

%% WINGS
robot(W1).orientation = robot(M1).orientation*EulerZYX_Fast([roll_ang_R 0 0]*pi/180);
robot(W2).orientation = robot(M2).orientation*EulerZYX_Fast([-roll_ang_L 0 0]*pi/180);

M1Origin_W1RotCenter = [0;9.21;0];                M2Origin_W2RotCenter = [0;-9.21;0];
W1RotCenter_W1Origin = [-84.63; -14.31; 17.79];     W2RotCenter_W2Origin = [-84.63;  14.31; 17.79];
W1RotCenter_W1Com    = [-79.42; -39.8 ; -7.06];     W2RotCenter_W2Com    = [-79.42;  39.8 ; -7.06];  

robot(W1).position =   robot(M1).position + ...
                       robot(M1).orientation*M1Origin_W1RotCenter+ ...
                       robot(W1).orientation*W1RotCenter_W1Origin;                       
robot(W2).position =   robot(M2).position + ...
                       robot(M2).orientation*M2Origin_W2RotCenter+ ...
                       robot(W2).orientation*W2RotCenter_W2Origin;

%% TAIL-PENDULUM
robot(TAIL).orientation = robot(M5).orientation*EulerZYX_Fast([0 0 vib_ang]*pi/180);
robot(PEN).orientation = robot(M5).orientation*EulerZYX_Fast([0 0 vib_ang]*pi/180);

M5Origin_TailRotCenter = [0; 0; 15];
TailRotCenter_TailOrigin = [-35;0;0];
robot(TAIL).position =   robot(M5).position + ...
                         robot(M5).orientation*M5Origin_TailRotCenter +...   
                         robot(TAIL).orientation*TailRotCenter_TailOrigin;

M5Origin_PenRotCenter = [0; 0; 30];
TailRotCenter_TailOrigin = [-64.5;0;0];
robot(PEN).position =    robot(M5).position + ...
                         robot(M5).orientation*M5Origin_TailRotCenter +...   
                         robot(TAIL).orientation*TailRotCenter_TailOrigin;
%% apply body rotation and ground contact constraint / update pose for part frames                     
z_points = [];
all_points = [];

minZ = [];
% stack all points
for ob =  1:length(entities)       

   % Concatenate all the points in the body      
   all_points = [all_points, [robot(ob).orientation*EulerZYX_Fast(rel_config(ob,1:3)*pi/180)* robot(ob).obj_v +  robot(ob).position ]];

   % Rotate all the entities to make the current configuration
   robot(ob).Patch.Vertices = (R_body*[robot(ob).orientation*EulerZYX_Fast(rel_config(ob,1:3)*pi/180)* robot(ob).obj_v +  robot(ob).position ])';           

   % Check for the lowest Z coordinate
   minZ = min([minZ ; robot(ob).Patch.Vertices(:,3)]);       
end   


% Find the lowest lying points to shift up all the bodies by


for ob = 1:length(entities)               
   % Shift parts to enfronce ground contact constraint
   robot(ob).Patch.Vertices(:,3) = robot(ob).Patch.Vertices(:,3) - minZ;   
  
end
