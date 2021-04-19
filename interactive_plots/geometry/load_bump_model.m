% load bump system

hold on

robot.abc = [25 12 5];
[robot.xx robot.yy robot.zz] = ellipsoid(0,0,0, robot.abc(1), robot.abc(2), robot.abc(3), 200);
robot.sh = surf(robot.xx,robot.yy,robot. zz,'facecolor','y','edgealpha',0,'facelighting', 'gouraud');

robot.bump_h = 15;%mm
bump.ylim = 52;

bump.ground = patch([-1 0 0 -1]*bump.ylim,[-1 -1 1 1]*bump.ylim,[0 0 0 0 ],'k')
set(bump.ground,'facecolor',[1 1 1]*0.6,'facelighting','none');

bump.wall   = patch([0 0 0 0],[-1 1 1 -1]*bump.ylim,[0 0 robot.bump_h robot.bump_h ],'k')
set(bump.wall,'facecolor',[1 1 1]*0.6,'facelighting','none');

bump.top    = patch([1 0 0 1]*bump.ylim,[-1 -1 1 1]*bump.ylim,[1 1 1 1 ]*robot.bump_h,'k')
set(bump.top,'facecolor',[1 1 1]*0.6,'facelighting','none');

axis equal
xlim([-60 60])
ylim([-1 1]*bump.ylim)
zlim([0 robot.bump_h+2*robot.abc(1)])

light('position',[-400 0 200 ])
light('position',[-200 -200 200 ])

view(-45,22)
view(-25,25)

set(get(gca,'xaxis'),'visible','off')
set(get(gca,'yaxis'),'visible','off')
set(get(gca,'zaxis'),'visible','off')



 