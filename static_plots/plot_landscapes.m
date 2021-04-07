%% Data accompanying publication: 10.1098/rspb.2020.2734
% Proceedings of Royal Society B: Biological Sciences

% Locomotor transitions in potential energy landscape dominated regime
% Ratan Othayoth, Qihan Xuan, Yaqing Wang, and Chen Li*
% Corresponding author (chen.li@jhu.edu)



% Code to visualize potential energy landscape
clear
close all
addpath(genpath('data'))
%% Load data 

bump            = load('dat_bump.mat');
gap             = load('dat_gap.mat');
pillar_cuboid   = load('dat_pillar_cuboid.mat');
pillar_ellip    = load('dat_pillar_elliptical.mat');
beam            = load('dat_beam.mat');
self_right      = load('dat_righting.mat');



%% plot bump landscape
figure(1);
clf;
colormap('fire');
sh(1) = surf(bump.yaw,bump.pitch,bump.pe,'EdgeAlpha',0);
xlabel('body yaw (°)');
ylabel('body pitch (°)');
zlabel('normalized potential energy');
xticks([-90:45:90]); yticks([-90:45:90]); zticks([0:0.25:1])
title('bump landscape')
view(-135,50)
%% plot gap landscape
figure(2);
clf;
colormap('fire');
sh(2) = surf(gap.yaw,gap.pitch,gap.pe,'EdgeAlpha',0);
xlabel('body yaw (°)');
ylabel('body pitch (°)');
zlabel('normalized potential energy');
xticks([-90:45:90]); yticks([-90:45:90]); zticks([0:0.25:1])
title('gap landscape')
view(-135,50)

%% plot pillar landscape -- elliptical body shape
figure(3);
clf;
colormap('fire');
sh(3) = surf(pillar_ellip.bearing,pillar_ellip.pitch,pillar_ellip.pe,'EdgeAlpha',0);

% add walls of prohibited regions
hold on
sh_proh = surf(pillar_ellip.bearing,pillar_ellip.pitch,pillar_ellip.pe*0.99,'facecolor','k','facealpha',0.2,'edgealpha',0)
sh_proh.ZData(isnan(sh_proh.ZData)) = 10; %set energy to high

xlabel('bearing (°)');
ylabel('body pitch (°)');
zlabel('normalized potential energy');
xticks([-90:45:90]); yticks([-90:45:90]); zticks([-0:0.25:1])
zlim([0 1])
title('pillar landscape (elliptical body)')
view(-135,50)

%% plot pillar landscape -- cuboidal body shape
figure(4);
clf;
colormap('fire');
sh(4) = surf(pillar_cuboid.bearing,pillar_cuboid.pitch,pillar_cuboid.pe,'EdgeAlpha',0);

% add walls of prohibited regions
hold on
sh_proh = surf(pillar_cuboid.bearing,pillar_cuboid.pitch,pillar_cuboid.pe*0.99,'facecolor','k','facealpha',0.2,'edgealpha',0)
sh_proh.ZData(isnan(sh_proh.ZData)) = 10; %set energy to high

xlabel('bearing (°)');
ylabel('body pitch (°)');
zlabel('normalized potential energy');
xticks([-90:45:90]); yticks([-90:45:90]); zticks([0:0.25:1])
zlim([0 1])
title('pillar landscape (cuboidal body)')
view(-135,50)

%% plot beam landscape 
figure(5);
clf;
colormap('fire');
sh(5) = surf(beam.roll,beam.pitch,beam.pe,'EdgeAlpha',0);

xlabel('body roll (°)');
ylabel('body pitch (°)');
zlabel('normalized potential energy');
xticks([-90:45:90]); yticks([-90:45:90]); zticks([0:0.25:1])
zlim([0 1])
title('beam landscape')
view(-135,50)

%% plot self-righting landscape 
figure(6);
clf;
colormap('fire');
sh(6) = surf(self_right.roll,self_right.pitch,self_right.pe,'EdgeAlpha',0);
xlabel('body roll (°)');
ylabel('body pitch (°)');
zlabel('normalized potential energy');
xticks([-180:90:180]); yticks([-180:90:180]); zticks([0:0.25:1])
zlim([0 1])
title('self-righting landscape')
view(-135,50)
%% format figures

% figure position
px = [10 430 850 10 430 850];
py = [610 610 610 150 150 150];
for i=1:6
   figure(i)
   
   set(gcf,'position',[px(i) py(i) 400 360])
   hold on  
   axis equal   
   gca
   pbaspect([1 1 0.1])
   set(gca,'position',[0.14 0 0.72 1 ]);
   axis normal
   set(gca,'plotboxaspectratio', [1.2 1.2 0.5])   
   zlim([0 1])
   caxis([min(sh(i).ZData(:)) max(sh(i).ZData(:))])
   grid off
   box on   
   zticks([0 0.5 1])
   set(get(gca,'xaxis'),'direction','reverse')
end