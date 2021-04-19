% load pillar system 

hold on

% Create robot vertices and faces
robot.l = 84*2;
robot.b = 64*2;
robot.h = 30;
robot.vx = 0.5*robot.l*[-1 1 1 -1 -1 1 1 -1]';
robot.vy = 0.5*robot.b*[1 1 1 1 -1 -1 -1 -1]';
robot.vz = 0.5*robot.h*[-1 -1 1 1 1 1 -1 -1]';
robot.verts= [robot.vx, robot.vy ,robot.vz ];
robot.facs = [  1 2 3 4
                5 6 7 8
                4 3 6 5
                3 2 7 6
                2 1 8 7
                1 4 5 8];
            
robot.patch = patch('Faces',robot.facs,'Vertices',robot.verts,'facecolor',[1 0 0.25]);

% create pillars
pillar_radius = 12.7;
pillar.center = [212.7000 0];
robot.x_offset = pillar.center(1);

[x0,y0,z0] = cylinder(pillar_radius,100);
z0 = z0*180;
ppill(1) = surf(x0,y0,z0, 'edgealpha',0,'facecolor',[1 1 1 ]*0.2,'facelighting', 'gouraud');
ptop(1) = patch('xdata',x0(1,:),'ydata',y0(1,:),'zdata',z0(2,:));
set(ptop(1),'facecolor',[1 1 1 ]*0.2,'facelighting', 'gouraud', 'edgealpha',1);

% ground
gnd = patch([-1 -1 1 1]*220,[-1 1 1 -1]*150,'k');
set(gnd,'facecolor',[1 1 1]*0.6);

view(-12,20);

axis equal

light('position',[-400 0 200 ]);
light('position',[-200 -200 200 ]*2);
light('position',[-200  200 200 ]*2);
 
set(get(gca,'xaxis'),'visible','off');
set(get(gca,'yaxis'),'visible','off');
set(get(gca,'zaxis'),'visible','off');

xlim([-210 60])
ylim([-1 1]*120)
zlim([0 200])