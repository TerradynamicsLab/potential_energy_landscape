% load pillar system  

hold on

% robot
robot = struct();
robot.abc = [84 64 15];
[robot.xx robot.yy robot.zz] = ellipsoid(0,0,0, robot.abc(1), robot.abc(2), robot.abc(3), 200);
robot.zz(robot.zz>0) = robot.abc(3);
robot.zz(robot.zz<0) =-robot.abc(3);
robot.sh = surf(robot.xx,robot.yy,robot. zz,'facecolor',[1 0 0.25],'edgealpha',0);

% elliptical shape boundaries
t = 0:0.01:2*pi;   
robot.xb = robot.abc(1)*cos(t);  
robot.yb = robot.abc(2)*sin(t);
robot.zb = robot.abc(3)*ones(size(robot.xb));
robot.top_sh = plot3(robot.xb,robot.yb, robot.zb,'k');
robot.bot_sh = plot3(robot.xb,robot.yb,-robot.zb,'k');

% create pillars
pillar_radius = 12.7;
pillar.center = [212.7000 0];
robot.x_offset = pillar.center(1);

[x0,y0,z0] = cylinder(pillar_radius,100);
z0 = z0*180;
ppill(1) = surf(x0,y0,z0, 'edgealpha',0,'facecolor',[1 1 1 ]*0.2,'facelighting', 'gouraud');
ptop(1) = patch('xdata',x0(1,:),'ydata',y0(1,:),'zdata',z0(2,:));
set(ptop(1),'facecolor',[1 1 1 ]*0.2,'facelighting', 'gouraud', 'edgealpha',1);

%ground
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