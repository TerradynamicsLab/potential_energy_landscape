% load gap system

hold on

robot.abc = [25 12 5];
[robot.xx robot.yy robot.zz] = ellipsoid(0,0,0, robot.abc(1), robot.abc(2), robot.abc(3), 200);
robot.sh = surf(robot.xx,robot.yy,robot. zz,'facecolor',[0 176 240]/255,'edgealpha',0,'facelighting', 'gouraud');

gap.ylim=30;
robot.gap_d=15;
robot.gap_w=37.5000;

gap.ground = patch([-200 0 0 -200],[-1 -1 1 1]*gap.ylim,[0 0 0 0 ],'k')
set(gap.ground,'facecolor',[1 1 1]*0.6,'facelighting','none');
robot.gap_wall1   = patch([0 0 0 0],[-1 1 1 -1]*gap.ylim,[0 0 -robot.gap_d -robot.gap_d ],'k')
set(robot.gap_wall1,'facecolor',[1 1 1]*0.6,'facelighting','none');
robot.gap_wall2   = patch(robot.gap_w+[0 0 0 0],[-1 1 1 -1]*gap.ylim,[0 0 -robot.gap_d -robot.gap_d ],'k')
set(robot.gap_wall2,'facecolor',[1 1 1]*0.6,'facelighting','none');
gap.top    = patch(robot.gap_w+[200 0 0 200],[-1 -1 1 1]*gap.ylim,[0 0 0 0 ],'k')
set(gap.top,'facecolor',[1 1 1]*0.6,'facelighting','none');
gap.bottom = patch(robot.gap_w*[1 0 0 1],[-1 -1 1 1]*gap.ylim,-robot.gap_d*[1 1 1 1 ],'k')
set(gap.bottom,'facecolor',[1 1 1]*0.6,'facelighting','none');
axis equal
xlim([-55 60+robot.gap_w])
ylim([-1 1]*gap.ylim)
zlim([-robot.gap_d 2*robot.abc(1)])

light('position',[-400 0 200 ])
light('position',[-200 -200 200 ])
light('position',[-200  200 200 ])
view(-45,22)
view(-30,20)
view(-25,25)


set(get(gca,'xaxis'),'visible','off')
set(get(gca,'yaxis'),'visible','off')
set(get(gca,'zaxis'),'visible','off')
           


 