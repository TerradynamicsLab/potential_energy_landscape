% generate all the entities based on the geometry


z_points = [];
all_points = [];


 
% add the plot elements of robot entities 
for i = 1:length(surfObj) 
    
 % align parts to proper initial conditions 
 normalizing_rot = EulerZYX_Fast(rel_config(i,1:3)*pi/180);
 S{i}.v = normalizing_rot*surfObj{i}.v + rel_config(i,4:6)';
 S{i}.f3 = surfObj{i}.f3;  
 shellpoints=S{i}.v;
 faces=S{i}.f3;
 
 axis equal
 
 % patch for entities
 robot(i).Patch = patch('Vertices',shellpoints' ,'Faces',faces' , 'FaceVertexCData', ones(size(faces,2),1));
 robot(i).Patch.FaceLighting = 'phong';
 robot(i).Patch.FaceColor = entity_color{i};
 robot(i).Patch.EdgeAlpha= 0;
 robot(i).Patch.FaceAlpha= 0.4;
 
 % com markers
%  robot(i).mh = plot3( 0, 0, 0, 'color',[0 0 1 0], 'marker', 'o','markerfacecolor','k','markeredgecolor','w','markersize',5,'linewidth',1.5); 
 
 
 z_points = [z_points ; robot(i).Patch.Vertices(:,3)];
 
 
 xlabel('x');ylabel('y');zlabel('z')
 xticks([0]);  xticklabels({''});
 yticks([0]);  yticklabels({''});
 zticks([0]);  zticklabels({''});
end

box on

% enforce ground contact
minZ = min(z_points);
for i = [ 1 2 3 4 5 6 7 8 9 10] 
    robot(i).Patch.Vertices(:,3) = robot(i).Patch.Vertices(:,3) - minZ;
end

% ground
robot(11).Patch = patch([-1 -1 1 1]*400,[1 -1 -1 1]*400, [0 0 0 0],'facecolor',[1 1 1]*0.9,'facelighting','phong');
% robot(11).mh = plot3( 0, 0, 0, 'color',[0 0 1 0], 'marker', 'o','markerfacecolor',[0 0.8 0 ],'markeredgecolor','k','markersize',4,'linewidth',1.5); 


light('position',[-3 0 5]*50);
light('position',[0 -2 -5]*50);
light('position',[0 2 -5]*50);
view(158,33)
 
xlim([-200 200]);       ylim([-200 200]);       zlim([0 280]);
 
