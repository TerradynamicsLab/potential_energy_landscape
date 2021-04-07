function plot_pillar_elliptical
    
    clear
    close all
    
    load data/dat_pillar_ellip.mat
    
    n  = numel(p_steps);
    n0 = ceil(n/2);
    
    
    % setup figures     

    ff.fh = figure(1)
    clf
    set(gcf,'position',[1 50 900 900],'color',[1 1 1])
    
%% 3d plots
    ff.sp(1) = subplot(2,2,1)
    hold on; set(gca,'fontsize',15) 
    colormap(fire)
    ff.sh.x = surf( squeeze(heading( :, 1, :)),  squeeze(pitch( :, 1, :)), squeeze(x( :, 1, :)), squeeze(pe( :, 1, :)), 'edgealpha',0);
    ff.sh.p = surf( squeeze(heading(n0, :, :)),  squeeze(pitch(n0, :, :)), squeeze(x(n0, :, :)), squeeze(pe(n0, :, :)), 'edgealpha',0);
    ff.sh.h = surf( squeeze(heading( :, :,n0)),  squeeze(pitch( :, :,n0)), squeeze(x( :, :,n0)), squeeze(pe( :, :,n0)), 'edgealpha',0);
    
    xlim([-1,1]*90);       xticks([-2,-1,0,1,2]*45); xticklabels({'−90','−45','0','45','90'})
    ylim([-1,1]*90);       yticks([-2,-1,0,1,2]*45); yticklabels({'−90','−45','0','45','90'})
    zlim([min(x_steps) max(x_steps)])
    xlabel('body heading (°)');
    ylabel('body pitch (°)');
    zlabel('x (mm)')
    view(39,44)
    
%% 2d sections
    ff.sp(2) = subplot(2,2,2)
    hold on; set(gca,'fontsize',15,'tag','sp_x_sec') 
    colormap(fire)
    ff.sh.x_sec = surf( squeeze(heading( :, 1, :)),  squeeze(pitch( :, 1, :)),  squeeze(pe( :, 1, :)), 'edgealpha',0,'tag','x_sec');
    axis equal
    xlim([-1,1]*90);       xticks([-2,-1,0,1,2]*45); xticklabels({'−90','−45','0','45','90'})
    ylim([-1,1]*90);       yticks([-2,-1,0,1,2]*45); yticklabels({'−90','−45','0','45','90'})
    xlabel('heading (°)');         ylabel('pitch (°)');
    title(['x  = ' num2str(x_steps(1)) 'mm'],'fontweight','normal');


    ff.sp(3) = subplot(2,2,3)
    hold on; set(gca,'fontsize',15,'tag','sp_h_sec') 
    colormap(fire)
    ff.sh.h_sec = surf( squeeze(pitch( :, :,n0)), squeeze(x( :, :,n0)), squeeze(pe( :, :,n0)),'edgealpha',0,'tag','h_sec');
    xlim([-1,1]*90);       xticks([-2,-1,0,1,2]*45); xticklabels({'−90','−45','0','45','90'})
    ylim(x_steps([1 end])); yticks([4.5:0.5:6.5]*20);
    xlabel('body pitch (°)');         ylabel('x (mm)');
    title(['body heading = ' num2str(h_steps(n0)) '°'],'fontweight','normal');


    ff.sp(4) = subplot(2,2,4)
    hold on; set(gca,'fontsize',15,'tag','sp_p_sec') 
    colormap(fire)
    ff.sh.p_sec =surf( squeeze(heading( n0,:, :)), squeeze(x(n0, :, :)), squeeze(pe( n0,:, :)),'edgealpha',0,'tag','p_sec');
    xlim([-1,1]*90);       xticks([-2,-1,0,1,2]*45); xticklabels({'−90','−45','0','45','90'})
    ylim(x_steps([1 end])); yticks([4.5:0.5:6.5]*20);
    xlabel('body heading (°)');         ylabel('x (mm)');
    title(['body pitch = ' num2str(p_steps(n0)) '°'],'fontweight','normal');
    

%% gui controls
    ff.sl.x = uicontrol('style','slider','units','pixel','string','x','position',[54,862,120,20]); 
    ff.sl.x.Max = max(x_steps);
    ff.sl.x.Min = min(x_steps);
    ff.sl.x.Value = x_steps(1);
    addlistener(ff.sl.x,'ContinuousValueChange',@(hObject, event) update_fig(hObject,event,x_steps,ff.sh.x,x,pe)); 
    
    ff.sl.h = uicontrol('style','slider','units','pixel','string','body heading','position',[54+130,862,120,20]); 
    ff.sl.h.Max = max(h_steps);
    ff.sl.h.Min = min(h_steps);
    addlistener(ff.sl.h,'ContinuousValueChange',@(hObject, event) update_fig(hObject,event,h_steps,ff.sh.h,heading,pe)); 
    
    ff.sl.p = uicontrol('style','slider','units','pixel','string','body pitch','position',[54+260,862,120,20]); 
    ff.sl.p.Max = max(p_steps);
    ff.sl.p.Min = min(p_steps);
    addlistener(ff.sl.p,'ContinuousValueChange',@(hObject, event) update_fig(hObject,event,p_steps,ff.sh.p,pitch,pe)); 
    
    
    
function update_fig(hObject, event, steps,sh,depvar,pe)

    val_temp = get(hObject,'Value');
    [~, min_idx] = min(abs(steps-val_temp));
    
    if(steps(min_idx)<0)
        str_app='−';
    else 
        str_app='';
    end
    
    switch hObject.String
        case 'x'
            sh.ZData = squeeze(depvar(:, min_idx, :));
            sh.CData = squeeze(    pe(:, min_idx, :));
            hh = findobj('tag','x_sec');
            gg = findobj('tag','sp_x_sec');  
            gg.Title.String=['x = ' str_app num2str(abs(steps(min_idx))) '°'];
            
        case 'body pitch'
            sh.YData = squeeze(depvar(min_idx, :, :));%
            sh.CData =  squeeze(    pe(min_idx, :, :));
            hh = findobj('tag','p_sec');
            gg = findobj('tag','sp_p_sec'); 
            gg.Title.String=['body pitch = ' str_app num2str(abs(steps(min_idx))) '°'];
      
        case 'body heading'
            sh.XData = squeeze(depvar(:, :, min_idx));
            sh.CData = squeeze(    pe(:, :, min_idx));
            hh = findobj('tag','h_sec');
            gg = findobj('tag','sp_h_sec'); 
            gg.Title.String=['body heading = ' str_app num2str(abs(steps(min_idx))) '°'];
            

    end

    hh.ZData = sh.CData;
