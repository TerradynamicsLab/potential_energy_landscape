function plot_pillar_elliptical
    
    clear
    close all
    
    load data/dat_pillar_ellip.mat 
    load data/dat_pillar_ellip.mat pe x pitch heading
    addpath(genpath('geometry'))
    addpath(genpath('geometry/pillar'))
    addpath(genpath('graphics'))
    
    n  = numel(p_steps);
    n0 = ceil(n/2);
    
    
    % setup figures   
    ff.fh = figure(1)
    clf
    set(gcf,'position',[1 50 900 900],'color',[1 1 1],'units','normalized','outerposition',[0 0 1 1])

%% robot plot
    subplot(2,3,1)
    hold on
             
    load_pillar_model_elliptical
    x=x-robot.x_offset;
    x_steps = x_steps-robot.x_offset;
    % initial robot state
    x_ip = x(1,1,1); pitch_ip = pitch(n0,1,1); heading_ip = heading(1,1,n0);
    
    mk_size=8;
    
%% 3d plots
    ff.sp(1) = subplot(2,3,2)
    hold on; box on; set(gca,'fontsize',15) 
    colormap(fire)
    ff.sh.x = surf( squeeze(heading( :, 1, :)),  squeeze(pitch( :, 1, :)), squeeze(x( :, 1, :)), squeeze(pe( :, 1, :)), 'edgealpha',0,'tag','x3d');
    ff.sh.p = surf( squeeze(heading(n0, :, :)),  squeeze(pitch(n0, :, :)), squeeze(x(n0, :, :)), squeeze(pe(n0, :, :)), 'edgealpha',0,'tag','p3d');
    ff.sh.h = surf( squeeze(heading( :, :,n0)),  squeeze(pitch( :, :,n0)), squeeze(x( :, :,n0)), squeeze(pe( :, :,n0)), 'edgealpha',0,'tag','h3d');
    ff.mh.state_3d = plot(0,0,'marker','o','markerfacecolor','g','markeredgecolor','k','markersize',mk_size,'tag','state_3d');
    xlim([-1,1]*90);       xticks([-2,-1,0,1,2]*45); xticklabels({[char(8211) '90'],[char(8211) '45'],'0','45','90'})
    ylim([-1,1]*90);       yticks([-2,-1,0,1,2]*45); yticklabels({[char(8211) '90'],[char(8211) '45'],'0','45','90'})
    zlim([min(x_steps) max(x_steps)])
    xlabel('body heading (°)');
    ylabel('body pitch (°)');
    zlabel('{\it x} (mm)')
    view(44,33)
    
    % boundaries for the panels
    ff.bh.x = patch([-1 -1 1 1]*90, [-1 1 1 -1]*90, [1 1 1 1]*ff.sh.x.ZData(1), 'k' ,'tag','xbound');                           ff.bh.x.FaceAlpha = 0;
    ff.bh.h= patch([1 1 1 1]*ff.sh.h.XData(1), [-1 1 1 -1]*90, [[1 1]*min(x_steps), [1 1]*max(x_steps)] , 'k','tag','hbound' ); ff.bh.h.FaceAlpha = 0;
    ff.bh.p = patch([-1 1 1 -1]*90, [1 1 1 1]*ff.sh.p.YData(1), [[1 1]*min(x_steps), [1 1]*max(x_steps)], 'k','tag','pbound' ); ff.bh.p.FaceAlpha = 0;
    
%% 2d sections
    ff.sp(2) = subplot(2,3,4)
    hold on; box on; set(gca,'fontsize',15,'tag','sp_x_sec','boxstyle','full') 
    colormap(fire)
    ff.sh.x_sec = surf( squeeze(heading( :, 1, :)),  squeeze(pitch( :, 1, :)),  squeeze(pe( :, 1, :)), 'edgealpha',0,'tag','x_sec');
    ff.mh.state_cx = plot(0,0,'marker','o','markerfacecolor','g','markeredgecolor','k','markersize',mk_size,'tag','state_cx');
    axis equal
    xlim([-1,1]*90);       xticks([-2,-1,0,1,2]*45); xticklabels({[char(8211) '90'],[char(8211) '45'],'0','45','90'})
    ylim([-1,1]*90);       yticks([-2,-1,0,1,2]*45); yticklabels({[char(8211) '90'],[char(8211) '45'],'0','45','90'})
    xlabel('heading (°)');         ylabel('pitch (°)');
    title(['{\it x }= ' num2str(x_steps(1)) '°'],'fontweight','normal');
    set(get(gca,'yaxis'),'direction','reverse');


    ff.sp(3) = subplot(2,3,5)
    hold on; box on; set(gca,'fontsize',15,'tag','sp_p_sec') 
    colormap(fire)
    ff.sh.p_sec = surf(squeeze(heading(n0, :, :)), squeeze(x(n0, :, :)), squeeze(pe(n0, :, :)), 'edgealpha',0,'tag','p_sec');
    ff.mh.state_cp = plot(0,0,'marker','o','markerfacecolor','g','markeredgecolor','k','markersize',mk_size,'tag','state_cp');
    xlim([-1,1]*90);       xticks([-2,-1,0,1,2]*45); xticklabels({[char(8211) '90'],[char(8211) '45'],'0','45','90'})
    ylim(x_steps([1 end])); yticks([0:4]*20);
    xlabel('body heading (°)');         ylabel('{\it x}(mm)');
    title(['body pitch = ' num2str(p_steps(n0)) '°'],'fontweight','normal');
    
    
    ff.sp(4) = subplot(2,3,6)
    hold on; box on; set(gca,'fontsize',15,'tag','sp_h_sec') 
    colormap(fire)
    ff.sh.h_sec = surf( squeeze(pitch( :, :,n0)), squeeze(x( :, :,n0)), squeeze(pe( :, :,n0)),'edgealpha',0,'tag','h_sec');
    ff.mh.state_ch = plot(0,0,'marker','o','markerfacecolor','g','markeredgecolor','k','markersize',mk_size,'tag','state_ch');
    xlim([-1,1]*90);       xticks([-2,-1,0,1,2]*45); xticklabels({[char(8211) '90'],[char(8211) '45'],'0','45','90'})
    ylim(x_steps([1 end])); yticks([0:4]*20);
    xlabel('body pitch (°)');         ylabel('{\it x} (mm)');
    title(['body heading = ' num2str(h_steps(n0)) '°'],'fontweight','normal');

%% gui controls
    ff.sl.x = uicontrol('style','slider','units','pixel','string','x','tag','tag_sl_x'); 
    ff.sl.x.Max = max(x_steps);
    ff.sl.x.Min = min(x_steps);
    addlistener(ff.sl.x,'ContinuousValueChange',@(hObject, event) update_fig(hObject,event,x_steps,ff.sh.x,x,pe,robot)); 
    
    ff.sl.p = uicontrol('style','slider','units','pixel','string','body pitch','tag','tag_sl_p'); 
    ff.sl.p.Max = max(p_steps);
    ff.sl.p.Min = min(p_steps);
    addlistener(ff.sl.p,'ContinuousValueChange',@(hObject, event) update_fig(hObject,event,p_steps,ff.sh.p,pitch,pe,robot)); 
    
    ff.sl.h= uicontrol('style','slider','units','pixel','string','body heading','tag','tag_sl_r'); 
    ff.sl.h.Max = max(h_steps);
    ff.sl.h.Min = min(h_steps);
    addlistener(ff.sl.h,'ContinuousValueChange',@(hObject, event) update_fig(hObject,event,h_steps,ff.sh.h,heading,pe,robot)); 
    
    ff.bt = uicontrol('style','pushbutton')
    addlistener(ff.bt,'ButtonDown',@(hObject, event) reset_fig(n0,  x(1,1,1), pitch(n0,1,1), heading(1,1,n0), pe, robot))
    
    for ii=1:3
        ff.st(ii) = uicontrol('style','text','units','normalized','tag',['var_' num2str(ii)]);
    end
    
%     configure ui components     
    format_gui
    
%   reset the figure once before showing
    reset_fig(n0, x(1,1,1), pitch(n0,1,1), heading(1,1,n0), pe,robot)
    
function update_fig(hObject, event, steps,sh,depvar,pe,robot)

    val_temp = get(hObject,'Value');
    [~, min_idx] = min(abs(steps-val_temp));
    
    if(steps(min_idx)<0)
        str_app=char(8211);
    else 
        str_app='';
    end
    
    switch hObject.String
        case 'x'
            sh.ZData = squeeze(depvar(:, min_idx, :));
            sh.CData = squeeze(    pe(:, min_idx, :));
            hh = findobj('tag','x_sec');
            gg = findobj('tag','sp_x_sec');  
            gg.Title.String=['{\it x} = ' str_app num2str(abs(steps(min_idx))) ' mm'];
            gg = findobj('tag','xbound');            gg.ZData = [1 1 1 1]*sh.ZData(1);
            ss = findobj('tag','state_3d');
            ss.ZData = steps(min_idx);
            gg = findobj('tag','var_1');  
            gg.String=['body forward position (x) = ', str_app num2str(abs(steps(min_idx))) ' mm'];
            
        case 'body pitch'
            sh.YData = squeeze(depvar(min_idx, :, :));
            sh.CData = squeeze(    pe(min_idx, :, :));
            hh = findobj('tag','p_sec');
            gg = findobj('tag','sp_p_sec'); 
            gg.Title.String=['body pitch = ' str_app num2str(abs(steps(min_idx))) '°'];
            gg = findobj('tag','pbound');            gg.YData = [1 1 1 1]*sh.YData(1);
            ss = findobj('tag','state_3d');
            ss.YData = steps(min_idx);
            gg = findobj('tag','var_2');  
            gg.String=['body pitch = ' str_app num2str(abs(steps(min_idx))) '°'];
      
        case 'body heading'
            sh.XData = squeeze(depvar(:, :, min_idx));
            sh.CData = squeeze(    pe(:, :, min_idx));
            hh = findobj('tag','h_sec');
            gg = findobj('tag','sp_h_sec'); 
            gg.Title.String=['body heading = ' str_app num2str(abs(steps(min_idx))) '°'];
            gg = findobj('tag','hbound');            gg.XData = [1 1 1 1]*sh.XData(1);
            ss = findobj('tag','state_3d');
            ss.XData = steps(min_idx);
            gg = findobj('tag','var_3');  
            gg.String=['body heading = ' str_app num2str(abs(steps(min_idx))) '°'];

    end

    % Update 2d plot showing section
    hh.ZData = sh.CData;
    
    % update robot_geometry
    x_ip        = ss.ZData;
    pitch_ip    = ss.YData*pi/180;
    heading_ip  = ss.XData*pi/180;
    
    % markers on subplots     
    sx = findobj('tag','state_cx'); sx.XData=ss.XData; sx.YData=ss.YData; sx.ZData=2000;
    sh = findobj('tag','state_ch'); sh.XData=ss.YData; sh.YData=ss.ZData; sh.ZData=2000;
    sp = findobj('tag','state_cp'); sp.XData=ss.XData; sp.YData=ss.ZData; sp.ZData=2000;
    
    % robot
    update_robot_geometry(x_ip,pitch_ip,heading_ip,robot)
    
    
% reset figure to initial state    
function reset_fig(n0,x0,p0,h0,pe,robot)
    
    % orthogonal sections in 3d plot
    gg = findobj('tag','x3d');      gg.CData = squeeze(pe( :, 1, :));   gg.ZData = x0*ones(size(gg.ZData)); 
    gg = findobj('tag','p3d');      gg.CData = squeeze(pe(n0, :, :));   gg.YData = p0*ones(size(gg.YData));
    gg = findobj('tag','h3d');      gg.CData = squeeze(pe( :, :,n0));   gg.XData = h0*ones(size(gg.XData));
    % section boundaries
    gg = findobj('tag','xbound');   gg.ZData = [1 1 1 1]*x0;
    gg = findobj('tag','pbound');   gg.YData = [1 1 1 1]*p0;
    gg = findobj('tag','hbound');   gg.XData = [1 1 1 1]*h0;
    % 2d plots
    gg = findobj('tag','x_sec');    gg.ZData = squeeze(pe( :, 1, :));
    gg = findobj('tag','p_sec');    gg.ZData = squeeze(pe(n0, :, :));
    gg = findobj('tag','h_sec');    gg.ZData = squeeze(pe( :, :,n0));    
    % slider position
    gg = findobj('tag','tag_sl_x');  gg.Value = x0;
    gg = findobj('tag','tag_sl_r');  gg.Value = h0;
    gg = findobj('tag','tag_sl_p');  gg.Value = p0;
    
    % reset title     
    if(x0<0) str_app='−' ; else str_app=''; end
    gg = findobj('tag','sp_x_sec');  gg.Title.String=['body forward position = '  str_app num2str(abs(x0)) ' mm'];
    gg = findobj('tag','var_1');     gg.String=['body forward position = '  str_app num2str(abs(x0)) ' mm']; 
    
    if(p0<0) str_app='−' ; else str_app=''; end
    gg = findobj('tag','sp_p_sec'); gg.Title.String=['body pitch = '  str_app num2str(abs(p0)) '°'];
    gg = findobj('tag','var_2');     gg.String=['body pitch = '  str_app num2str(abs(p0)) '°'];
          
    if(h0<0) str_app='−' ; else str_app=''; end
    gg = findobj('tag','sp_h_sec'); gg.Title.String=['body heading = '  str_app num2str(abs(h0)) '°'];
    gg = findobj('tag','var_3');     gg.String=['body heading = '  str_app num2str(abs(h0)) '°'];
    
    % state markers
    ss = findobj('tag','state_3d');    ss.ZData = x0;    ss.YData = p0;    ss.XData = h0;
    ss = findobj('tag','state_cx');    ss.XData = h0;    ss.YData = p0;    ss.ZData = 2000;
    ss = findobj('tag','state_ch');    ss.XData = p0;    ss.YData = x0;    ss.ZData = 2000;
    ss = findobj('tag','state_cp');    ss.XData = h0;    ss.YData = x0;    ss.ZData = 2000;
     
    % robot
    update_robot_geometry(x0,p0,h0,robot)

% update_robot_geometry
function update_robot_geometry(x,p,h,robot)
    
    % rotate robot body       
    rotated_points = EulerZYX_Fast([0 p h])*([robot.xx(:), robot.yy(:), robot.zz(:)]');     
    % update robot body         
    robot.sh.XData = reshape(rotated_points(1,:),size(robot.sh.XData)) + x;
    robot.sh.YData = reshape(rotated_points(2,:),size(robot.sh.XData));
    z_min= min(rotated_points(3,:));
    robot.sh.ZData = reshape(rotated_points(3,:),size(robot.sh.XData)) - z_min; 
        
    % rotate robot edges
    rotated_points = EulerZYX_Fast([0 p h])*([robot.xb(:), robot.yb(:), robot.zb(:)]');   
    robot.top_sh.XData = reshape(rotated_points(1,:),size(robot.top_sh.XData)) + x;
    robot.top_sh.YData = reshape(rotated_points(2,:),size(robot.top_sh.XData));
    robot.top_sh.ZData = reshape(rotated_points(3,:),size(robot.top_sh.XData)) -z_min;
    
    rotated_points = EulerZYX_Fast([0 p h])*([robot.xb(:), robot.yb(:), -robot.zb(:)]');   
    robot.bot_sh.XData = reshape(rotated_points(1,:),size(robot.bot_sh.XData)) + x;
    robot.bot_sh.YData = reshape(rotated_points(2,:),size(robot.bot_sh.XData));
    robot.bot_sh.ZData = reshape(rotated_points(3,:),size(robot.bot_sh.XData)) - z_min;

    
