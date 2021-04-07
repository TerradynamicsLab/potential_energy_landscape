function plot_righting
    
    clear
    close all
    
    load data/dat_righting.mat
    
    n  = numel(r_steps);
    n0 = ceil(n/2);
    
    
    % setup figures     

    ff.fh = figure(1)
    clf
    set(gcf,'position',[1 50 900 900],'color',[1 1 1])
    
%% 3d plots
    ff.sp(1) = subplot(2,2,1)
    hold on; set(gca,'fontsize',15) 
    colormap(fire)
    ff.sh.w = surf( squeeze(roll( :, 1, :)),  squeeze(pitch( :, 1, :)), squeeze(wing( :, 1, :)), squeeze(pe( :, 1, :)), 'edgealpha',0);
    ff.sh.r = surf( squeeze(roll(n0, :, :)),  squeeze(pitch(n0, :, :)), squeeze(wing(n0, :, :)), squeeze(pe(n0, :, :)), 'edgealpha',0);
    ff.sh.p = surf( squeeze(roll( :, :,n0)),  squeeze(pitch( :, :,n0)), squeeze(wing( :, :,n0)), squeeze(pe( :, :,n0)), 'edgealpha',0);
    
    xlim([-1,1]*180);       xticks([-2,-1,0,1,2]*90); xticklabels({'−180','−90','0','90','180'})
    ylim([-1,1]*180);       yticks([-2,-1,0,1,2]*90); yticklabels({'−180','−90','0','90','180'})
    zlim([min(w_steps) max(w_steps)])
    xlabel('body roll (°)');
    ylabel('body pitch (°)');
    zlabel('wing opening (°)')
    view(44,33)
    
%% 2d sections
    ff.sp(2) = subplot(2,2,2)
    hold on; set(gca,'fontsize',15,'tag','sp_w_sec') 
    colormap(fire)
    ff.sh.w_sec = surf( squeeze(roll( :, 1, :)),  squeeze(pitch( :, 1, :)),  squeeze(pe( :, 1, :)), 'edgealpha',0,'tag','w_sec');
    axis equal
    xlim([-1,1]*180);       xticks([-2,-1,0,1,2]*90); xticklabels({'−180','−90','0','90','180'})
    ylim([-1,1]*180);       yticks([-2,-1,0,1,2]*90); yticklabels({'−180','−90','0','90','180'})
    xlabel('roll (°)');         ylabel('pitch (°)');
    title(['wing opening = ' num2str(w_steps(1)) '°'],'fontweight','normal');


    ff.sp(3) = subplot(2,2,3)
    hold on; set(gca,'fontsize',15,'tag','sp_r_sec') 
    colormap(fire)
    ff.sh.r_sec = surf(squeeze(pitch(n0, :, :)), squeeze(wing(n0, :, :)), squeeze(pe(n0, :, :)), 'edgealpha',0,'tag','r_sec');
%     axis equal
    xlim([-1,1]*180);       xticks([-2,-1,0,1,2]*90); xticklabels({'−180','−90','0','90','180'})
    ylim(w_steps([1 end])); yticks([0:4]*20);
    xlabel('body pitch (°)');         ylabel('wing opening (°)');
    title(['body roll = ' num2str(r_steps(n0)) '°'],'fontweight','normal');
%     axis equal

    ff.sp(4) = subplot(2,2,4)
    hold on; set(gca,'fontsize',15,'tag','sp_p_sec') 
    colormap(fire)
    ff.sh.p_sec =surf( squeeze(roll( :, :,n0)), squeeze(wing( :, :,n0)), squeeze(pe( :, :,n0)),'edgealpha',0,'tag','p_sec');
%     axis equal
    xlim([-1,1]*180);       xticks([-2,-1,0,1,2]*90); xticklabels({'−180','−90','0','90','180'})
    ylim(w_steps([1 end])); yticks([0:4]*20);
    xlabel('body roll (°)');         ylabel('wing opening (°)');
%     axis equal
    title(['body pitch = ' num2str(p_steps(n0)) '°'],'fontweight','normal');
    

%% gui controls
    ff.sl.w = uicontrol('style','slider','units','pixel','string','wing opening','position',[54,862,120,20]); 
    ff.sl.w.Max = max(w_steps);
    ff.sl.w.Min = min(w_steps);
    addlistener(ff.sl.w,'ContinuousValueChange',@(hObject, event) update_fig(hObject,event,w_steps,ff.sh.w,wing,pe)); 
    
    ff.sl.p = uicontrol('style','slider','units','pixel','string','body pitch','position',[54+130,862,120,20]); 
    ff.sl.p.Max = max(p_steps);
    ff.sl.p.Min = min(p_steps);
    addlistener(ff.sl.p,'ContinuousValueChange',@(hObject, event) update_fig(hObject,event,p_steps,ff.sh.p,pitch,pe)); 
    
    ff.sl.r = uicontrol('style','slider','units','pixel','string','body roll','position',[54+260,862,120,20]); 
    ff.sl.r.Max = max(r_steps);
    ff.sl.r.Min = min(r_steps);
    addlistener(ff.sl.r,'ContinuousValueChange',@(hObject, event) update_fig(hObject,event,r_steps,ff.sh.r,roll,pe)); 
    
    
    
function update_fig(hObject, event, steps,sh,depvar,pe)

    val_temp = get(hObject,'Value');
    [~, min_idx] = min(abs(steps-val_temp));
    
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
            
        case 'body pitch'
            sh.YData = squeeze(depvar(:, :, min_idx));
            sh.CData = squeeze(    pe(:, :, min_idx));
            hh = findobj('tag','p_sec');
            gg = findobj('tag','sp_p_sec'); 
            gg.Title.String=['body pitch = ' str_app num2str(abs(steps(min_idx))) '°'];
      
        case 'body roll'
            sh.XData = squeeze(depvar(min_idx, :, :));
            sh.CData = squeeze(    pe(min_idx, :, :));
            hh = findobj('tag','r_sec');
            gg = findobj('tag','sp_r_sec'); 
            gg.Title.String=['body roll = ' str_app num2str(abs(steps(min_idx))) '°'];
            

    end

    hh.ZData = sh.CData;
