% script to load and build the robot from parts

HEAD = 1;
M1 = 2; M2 = 3; M3  = 4; M4 = 5; M5 = 6;
PEN = 7; TAIL = 8;
W1 = 9; W2 = 10;
entities = {'head','motor1','motor2','motor3','motor4','motor5','pen','tail','wing1','wing2'};
          
% from colorbrewer : https://colorbrewer2.org/#type=qualitative&scheme=Dark2&n=3          
entity_color = {[117 112 179]/255 ,[27 158 119]/255 ,[27 158 119]/255 ,[27 158 119]/255, [27 158 119]/255, [27 158 119]/255, ...
              [217 95 2]/255 ,[217 95 2]/255 ,...
              [117 112 179]/255  ,[117 112 179]/255  };

% mass (g)          
mass = [13.4 24.4 24.4 28 28 28.6 51.5 4.3 28.7 28.7];

% inertia (cm*cm) for unit mass distribution
Imotor_bb_normalized_12  =  (1/12)*diag([2.3*2.3 + 3*3 , 2*2 + 2.3*2.3 , 2*2 + 3*3 ]);
Imotor_bb_normalized_345 =  (1/12)*diag([2.3*2.3 + 2*2 , 3*3 + 2.3*2.3 , 2*2 + 3*3 ]);
Ipend_bb_normalized      =   (2/5)*diag([1.4*1.4 , 1.4*1.4 , 1.4*1.4]);
Itail_bb_normalized      =  (1/12)*diag([0.15*0.15 + 0.8*0.8 , 0.15*0.15 + 7*7, 7*7 + 0.8*0.8]);
% the following will be treated as point masses

Ihead_bb_normalized = zeros(3,3);
Iwing_bb_normalized = zeros(3,3);



% inertia (kg-m*m2)
robot(M1).Ibb   = Imotor_bb_normalized_12  *mass(2)  /(100*100*1000); %kg-m*m
robot(M2).Ibb   = Imotor_bb_normalized_12  *mass(3)  /(100*100*1000); %kg-m*m
robot(M3).Ibb   = Imotor_bb_normalized_345 *mass(4)  /(100*100*1000); %kg-m*m
robot(M4).Ibb   = Imotor_bb_normalized_345 *mass(5)  /(100*100*1000); %kg-m*m
robot(M5).Ibb   = Imotor_bb_normalized_345 *mass(6)  /(100*100*1000); %kg-m*m
robot(PEN).Ibb  = Ipend_bb_normalized      *mass(7)  /(100*100*1000); %kg-m*m
robot(TAIL).Ibb = Itail_bb_normalized      *mass(8)  /(100*100*1000); %kg-m*m
% the following will be treated as point masses
robot(W1).Ibb   = Iwing_bb_normalized      *mass(9)  /(100*100*1000); %kg-m*m
robot(W2).Ibb   = Iwing_bb_normalized      *mass(10) /(100*100*1000); %kg-m*m
robot(HEAD).Ibb = Ihead_bb_normalized      *mass(1)  /(100*100*1000); %kg-m*m
robot(11).Ibb   = nan(3,3);


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
        
       

for i = [ 1 2 3 4 5 6 7 8 9 10] % 1:length(entities)
    surfObj{i} = loadawobj([entities{i} '.obj']);
    surfObj{i}.v = surfObj{i}.v*10;
    robot(i).obj_v =   surfObj{i}.v;
end   
        


