function plot_righting
    
    clear
    close all
    
    load data/dat_righting.mat
    addpath(genpath('geometry/righting'))
    
    n  = numel(r_steps);
    n0 = ceil(n/2);
    
    
    % setup figures     

    ff.fh = figure(1)
    clf
    set(gcf,'position',[1 50 900 900],'color',[1 1 1], 'units','normalized','outerposition',[0 0 1 1])
    
%% robot plot
    subplot(2,3,1)
    hold on
    load_robot_model
    generate_robot_entities
    % initial robot state
    wing_ip = 0; roll_ip = 0; pitch_ip = 0;
 
    mk_size=8;
    
%% 3d plots
    subplot(2,3,2)
    hold on; set(gca,'fontsize',15) 
    colormap(fire)
    ff.sh.w = surf( squeeze(roll( :, 1, :)),  squeeze(pitch( :, 1, :)), squeeze(wing( :, 1, :)), squeeze(pe( :, 1, :)), 'edgealpha',0,'tag','w3d');
    ff.sh.r = surf( squeeze(roll(n0, :, :)),  squeeze(pitch(n0, :, :)), squeeze(wing(n0, :, :)), squeeze(pe(n0, :, :)), 'edgealpha',0,'tag','r3d');
    ff.sh.p = surf( squeeze(roll( :, :,n0)),  squeeze(pitch( :, :,n0)), squeeze(wing( :, :,n0)), squeeze(pe( :, :,n0)), 'edgealpha',0,'tag','p3d');
    ff.mh.state = plot3(0,0,0,'marker','o','markerfacecolor','g','markeredgecolor','k','markersize',mk_size,'tag','state_3d');
    xlim([-1,1]*180);       xticks([-2,-1,0,1,2]*90); xticklabels({'−180','−90','0','90','180'})
    ylim([-1,1]*180);       yticks([-2,-1,0,1,2]*90); yticklabels({'−180','−90','0','90','180'})
    zlim([min(w_steps) max(w_steps)])
    xlabel('body roll (°)');
    ylabel('body pitch (°)');
    zlabel('wing opening (°)')
    view(44,33)
    
%% 2d sections
    subplot(2,3,4)
    hold on; set(gca,'fontsize',15,'tag','sp_w_sec') 
    colormap(fire)
    ff.sh.w_sec = surf( squeeze(roll( :, 1, :)),  squeeze(pitch( :, 1, :)),  squeeze(pe( :, 1, :)), 'edgealpha',0,'tag','w_sec');
    ff.mh.state_cw = plot(0,0,'marker','o','markerfacecolor','g','markeredgecolor','k','markersize',mk_size,'tag','state_cw');
    axis equal
    xlim([-1,1]*180);       xticks([-2,-1,0,1,2]*90); xticklabels({'−180','−90','0','90','180'})
    ylim([-1,1]*180);       yticks([-2,-1,0,1,2]*90); yticklabels({'−180','−90','0','90','180'})
    xlabel('roll (°)');         ylabel('pitch (°)');
    title(['wing opening = ' num2str(w_steps(1)) '°'],'fontweight','normal');
    set(get(gca,'yaxis'),'direction','reverse');

    subplot(2,3,5)
    hold on; set(gca,'fontsize',15,'tag','sp_r_sec') 
    colormap(fire)
    ff.sh.r_sec = surf(squeeze(pitch(n0, :, :)), squeeze(wing(n0, :, :)), squeeze(pe(n0, :, :)), 'edgealpha',0,'tag','r_sec');
    ff.mh.state_cr = plot(0,0,'marker','o','markerfacecolor','g','markeredgecolor','k','markersize',mk_size,'tag','state_cr');
    xlim([-1,1]*180);       xticks([-2,-1,0,1,2]*90); xticklabels({'−180','−90','0','90','180'})
    ylim(w_steps([1 end])); yticks([0:4]*20);
    xlabel('body pitch (°)');         ylabel('wing opening (°)');
    title(['body roll = ' num2str(r_steps(n0)) '°'],'fontweight','normal');

    subplot(2,3,6)
    hold on; set(gca,'fontsize',15,'tag','sp_p_sec') 
    colormap(fire)
    ff.sh.p_sec =surf( squeeze(roll( :, :,n0)), squeeze(wing( :, :,n0)), squeeze(pe( :, :,n0)),'edgealpha',0,'tag','p_sec');
    ff.mh.state_cp = plot(0,0,'marker','o','markerfacecolor','g','markeredgecolor','k','markersize',mk_size,'tag','state_cp');
    xlim([-1,1]*180);       xticks([-2,-1,0,1,2]*90); xticklabels({'−180','−90','0','90','180'})
    ylim(w_steps([1 end])); yticks([0:4]*20);
    xlabel('body roll (°)');         ylabel('wing opening (°)');
    title(['body pitch = ' num2str(p_steps(n0)) '°'],'fontweight','normal');
    

%% gui controls
    
    ff.sl.w = uicontrol('style','slider','string','wing opening'); 
    ff.sl.w.Max = max(w_steps);
    ff.sl.w.Min = min(w_steps);
    addlistener(ff.sl.w,'ContinuousValueChange',@(hObject, event) update_fig(hObject,event,w_steps,ff.sh.w,wing,pe,robot)); 
    
    ff.sl.p = uicontrol('style','slider','string','body pitch'); 
    ff.sl.p.Max = max(p_steps);
    ff.sl.p.Min = min(p_steps);
    addlistener(ff.sl.p,'ContinuousValueChange',@(hObject, event) update_fig(hObject,event,p_steps,ff.sh.p,pitch,pe,robot)); 
    
    ff.sl.r = uicontrol('style','slider','string','body roll'); 
    ff.sl.r.Max = max(r_steps);
    ff.sl.r.Min = min(r_steps);
    addlistener(ff.sl.r,'ContinuousValueChange',@(hObject, event) update_fig(hObject,event,r_steps,ff.sh.r,roll,pe,robot)); 
    
    ff.bt = uicontrol('style','pushbutton')
    addlistener(ff.bt,'ButtonDown',@(hObject, event) reset_fig(n0, wing(1,1,1), pitch(1,1,n0), roll(n0,1,1), pe, robot))
    
    for ii=1:3
        ff.st(ii) = uicontrol('style','text','units','normalized','string','dof')
    end
    
    % configure ui components     
    format_gui
    % reset the figure once before showing
    reset_fig(n0, wing(1,1,1), pitch(1,1,n0), roll(n0,1,1), pe, robot)
    
function update_fig(hObject, event, steps,sh,depvar,pe,robot)

    % find closest available value to the chosen value on the slider
    val_temp = get(hObject,'Value');
    [~, min_idx] = min(abs(steps-val_temp));
   
    % fix minus sign
    if(steps(min_idx)<0)
        str_app='−';
    else 
        str_app='';
    end
    
    switch hObject.String
        case 'wing opening'
            sh.ZData = squeeze(depvar(:, min_idx, :));
            sh.CData = squeeze(    pe(:, min_idx, :));
            hh = findobj('tag','w_sec');
            gg = findobj('tag','sp_w_sec');  
            gg.Title.String=['wing opening = ' str_app num2str(abs(steps(min_idx))) '°'];
            ss = findobj('tag','state_3d');
            ss.ZData = steps(min_idx);
            
        case 'body pitch'
            sh.YData = squeeze(depvar(:, :, min_idx));
            sh.CData = squeeze(    pe(:, :, min_idx));
            hh = findobj('tag','p_sec');
            gg = findobj('tag','sp_p_sec'); 
            gg.Title.String=['body pitch = ' str_app num2str(abs(steps(min_idx))) '°'];
            ss = findobj('tag','state_3d');
            ss.YData = steps(min_idx);
             
        case 'body roll'
            sh.XData = squeeze(depvar(min_idx, :, :));
            sh.CData = squeeze(    pe(min_idx, :, :));
            hh = findobj('tag','r_sec');
            gg = findobj('tag','sp_r_sec'); 
            gg.Title.String=['body roll = ' str_app num2str(abs(steps(min_idx))) '°'];
            ss = findobj('tag','state_3d');
            ss.XData = steps(min_idx);

    end

    % Update 2d plot showing section
    hh.ZData = sh.CData;
    
    % update robot_geometry
    wing_ip  = ss.ZData;
    pitch_ip = ss.YData*pi/180;
    roll_ip  = ss.XData*pi/180;
    
    % markers on subplots     
    sw = findobj('tag','state_cw'); sw.XData=ss.XData; sw.YData=ss.YData; sw.ZData=2000;
    sr = findobj('tag','state_cr'); sr.XData=ss.YData; sr.YData=ss.ZData; sr.ZData=2000;
    sp = findobj('tag','state_cp'); sp.XData=ss.XData; sp.YData=ss.ZData; sp.ZData=2000;
    

    update_robot_geometry;

% reset figure to initial state    
function reset_fig(n0,w0,p0,r0,pe,robot)
    
    % orthogonal sections in 3d plot
    gg = findobj('tag','w3d');      gg.CData = squeeze(pe( :, 1, :));   gg.ZData = w0*ones(size(gg.ZData)); 
    gg = findobj('tag','p3d');      gg.CData = squeeze(pe( :, :,n0));   gg.YData = p0*ones(size(gg.YData));
    gg = findobj('tag','r3d');      gg.CData = squeeze(pe( n0, :, :));  gg.XData = r0*ones(size(gg.XData));;
    % 2d plots
    gg = findobj('tag','w_sec');    gg.ZData = squeeze(pe( :, 1, :));
    gg = findobj('tag','p_sec');    gg.ZData = squeeze(pe( :, :,n0));
    gg = findobj('tag','r_sec');    gg.ZData = squeeze(pe( n0, :, :));
    
    % reset title
    gg = findobj('tag','sp_w_sec');  
    if(w0<0) str_app='−' , else str_app=''; end
    gg.Title.String=['wing opening = '  str_app num2str(abs(w0)) '°'];
    
    gg = findobj('tag','sp_p_sec');    
    if(p0<0) str_app='−' , else str_app=''; end
    gg.Title.String=['wing opening = '  str_app num2str(abs(p0)) '°'];
    
    gg = findobj('tag','sp_r_sec');  
    if(r0<0) str_app='−' , else str_app=''; end
    gg.Title.String=['wing opening = '  str_app num2str(abs(r0)) '°'];
    
    % state markers
    ss = findobj('tag','state_3d');    ss.ZData = w0;    ss.YData = p0;    ss.XData = r0;
    ss = findobj('tag','state_cw');    ss.XData = r0;    ss.YData = p0;    
    ss = findobj('tag','state_cr');    ss.XData = p0;    ss.YData = w0;   
    ss = findobj('tag','state_cp');    ss.XData = r0;    ss.YData = w0;   
     
    % robot
    wing_ip  = w0;
    pitch_ip = p0;
    roll_ip  = r0;
    update_robot_geometry
    
    

