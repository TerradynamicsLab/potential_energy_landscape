
hold on 

% system properties
robot = struct();
robot.abc = [26.4 12.37 4];
robot.mass = 2.64/1000; 
robot.beam_width = 10; %mm
robot.beam_height = 80; %mm
robot.beam_gap = 10; %mm
robot.A = diag(1./robot.abc);
robot.A = robot.A.*robot.A;

[robot.xx robot.yy robot.zz] = ellipsoid(0,0,0, robot.abc(1), robot.abc(2), robot.abc(3), 200);
robot.sh = surf(robot.xx,robot.yy,robot. zz,'facecolor',[0 0.8 0.3]);

robot.b1 = patch([0 0 0 0 ] , ([-1 -1 -1 -1]*(robot.beam_gap+robot.beam_width) + [1 -1 -1 1]*robot.beam_width)/2 , [0  0 1 1] ,  'g' , 'edgealpha',1, 'facelighting' , 'none');
robot.b2 = patch([0 0 0 0 ] , ([ 1  1  1  1]*(robot.beam_gap+robot.beam_width) + [1 -1 -1 1]*robot.beam_width)/2 , [0  0 1 1] ,  'g' , 'edgealpha',1,'facelighting' , 'none');


set(robot.b1,'facecolor',   [0 0.9 0.5] , ....
             'XData'    ,   [0 0 1 1]*robot.beam_height*sin(beam_angles(1)) ,...
             'ZData'    ,   [0 0 1 1]*robot.beam_height *cos(beam_angles(1)) );
set(robot.b2,'facecolor',   [0 0.9 0.5] ,... 
             'XData'    ,   [0 0 1 1]*robot.beam_height*sin(beam_angles(2)) , ...
             'ZData'    ,   [0 0 1 1]*robot.beam_height *cos(beam_angles(2)) );
         
robot.b10.xx = robot.b1.XData; robot.b10.yy = robot.b1.YData; robot.b10.zz = robot.b1.ZData;
robot.b20.xx = robot.b2.XData; robot.b20.yy = robot.b2.YData; robot.b20.zz = robot.b2.ZData;        

gnd = patch([-220 -220 180 180],[100 -100 -100 100],[0 0 0 0],'k');
gnd.FaceColor = [1 1 1]*0.8;

robot.b1.FaceColor = [1 1 1]*0.5;
robot.b2.FaceColor = robot.b1.FaceColor ;

set(robot.sh, 'edgealpha',0,'FaceLighting','gouraud' , 'facealpha', 0.6 );
light('Position',[500 -60 100]);
light('Position',[-500 0 100]);
light('Position',[0 0 -200]);
light('Position',[0 -50 200]);

axis equal;box off;grid off
set(gca,'visible','off')


xx = robot.sh.XData;
c_data = nan.*xx;

% apply color data
c_data(1:ceil(size(xx)/2) , 1:ceil(size(xx)/4)) = 1;
c_data(ceil(size(xx)/2)+1:end , 1:ceil(size(xx)/4)) = 0;

c_data(1:ceil(size(xx)/2) , ceil(size(xx)/4)+1:ceil(size(xx)/2)) = 0;
c_data(ceil(size(xx)/2)+1:end , ceil(size(xx)/4)+1:ceil(size(xx)/2)) = 1;

c_data(1:ceil(size(xx)/2) , ceil(size(xx)/2)+1:ceil(3*size(xx)/4)) = 1;
c_data(ceil(size(xx)/2)+1:end , ceil(size(xx)/2)+1:ceil(3*size(xx)/4)) = 0;

c_data(1:ceil(size(xx)/2) , ceil(3*size(xx)/4)+1:end) = 0;
c_data(ceil(size(xx)/2)+1:end , ceil(3*size(xx)/4)+1:end) = 1;


set(robot.sh, 'cdata',c_data);

% rotate the elements
rotated_pts = EulerZYX_Fast([roll_ip pitch_ip 0]*pi/180)*([robot.sh.XData(:) , robot.sh.YData(:),  robot.sh.ZData(:)]');
robot.sh.XData = reshape(rotated_pts(1,:),size(robot.sh.XData));
robot.sh.YData = reshape(rotated_pts(2,:),size(robot.sh.XData));
min_Z  = min(rotated_pts(3,:));
robot.sh.ZData = reshape(rotated_pts(3,:),size(robot.sh.XData)) - min_Z ;


xlim([-80 80]);ylim([-20 20]*1.5); zlim([0 80]);
view(-40 , 27);
