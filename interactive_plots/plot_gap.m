function plot_gap
    
    clear
    close all
    
    load data/dat_gap.mat
    
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
    ff.sh.x = surf( squeeze(yaw( :, 1, :)),  squeeze(pitch( :, 1, :)), squeeze(x( :, 1, :)), squeeze(pe( :, 1, :)), 'edgealpha',0);
    ff.sh.y = surf( squeeze(yaw(n0, :, :)),  squeeze(pitch(n0, :, :)), squeeze(x(n0, :, :)), squeeze(pe(n0, :, :)), 'edgealpha',0);
    ff.sh.p = surf( squeeze(yaw( :, :,n0)),  squeeze(pitch( :, :,n0)), squeeze(x( :, :,n0)), squeeze(pe( :, :,n0)), 'edgealpha',0);
    
    xlim([-1,1]*90);       xticks([-2,-1,0,1,2]*45); xticklabels({'−90','−45','0','45','90'})
    ylim([-1,1]*90);       yticks([-2,-1,0,1,2]*45); yticklabels({'−90','−45','0','45','90'})
    zlim([min(x_steps) max(x_steps)])
    xlabel('body yaw (°)');
    ylabel('body pitch (°)');
    zlabel('x (mm)')
    view(39,44)
    
%% 2d sections
    ff.sp(2) = subplot(2,2,2)
    hold on; set(gca,'fontsize',15,'tag','sp_x_sec') 
    colormap(fire)
    ff.sh.x_sec = surf( squeeze(yaw( :, 1, :)),  squeeze(pitch( :, 1, :)),  squeeze(pe( :, 1, :)), 'edgealpha',0,'tag','x_sec');
    axis equal
    xlim([-1,1]*90);       xticks([-2,-1,0,1,2]*45); xticklabels({'−90','−45','0','45','90'})
    ylim([-1,1]*90);       yticks([-2,-1,0,1,2]*45); yticklabels({'−90','−45','0','45','90'})
    xlabel('yaw (°)');         ylabel('pitch (°)');
    title(['x  = ' num2str(x_steps(1)) 'mm'],'fontweight','normal');
    set(get(gca,'yaxis'),'direction','reverse')

    ff.sp(3) = subplot(2,2,3)
    hold on; set(gca,'fontsize',15,'tag','sp_y_sec') 
    colormap(fire)
    ff.sh.y_sec = surf( squeeze(pitch(n0, :, :)), squeeze(x(n0, :, :)), squeeze(pe(n0, :, :)),'edgealpha',0,'tag','y_sec');
    xlim([-1,1]*90);       xticks([-2,-1,0,1,2]*45); xticklabels({'−90','−45','0','45','90'})
    ylim(x_steps([1 end])); yticks([-1.5:0.5:3.5]*20);
    xlabel('body pitch (°)');         ylabel('x (mm)');
    title(['body yaw = ' num2str(y_steps(n0)) '°'],'fontweight','normal');


    ff.sp(4) = subplot(2,2,4)
    hold on; set(gca,'fontsize',15,'tag','sp_p_sec') 
    colormap(fire)
    ff.sh.p_sec =surf( squeeze(yaw( :, :,n0)),  squeeze(x( :, :,n0)), squeeze(pe( :, :,n0)),'edgealpha',0,'tag','p_sec');
    xlim([-1,1]*90);       xticks([-2,-1,0,1,2]*45); xticklabels({'−90','−45','0','45','90'})
    ylim(x_steps([1 end])); yticks([-1.5:0.5:3.5]*20);
    xlabel('body yaw (°)');         ylabel('x (mm)');
    title(['body pitch = ' num2str(p_steps(n0)) '°'],'fontweight','normal');
    

%% gui controls
    ff.sl.x = uicontrol('style','slider','units','pixel','string','x','position',[54,862,120,20]); 
    ff.sl.x.Max = max(x_steps);
    ff.sl.x.Min = min(x_steps);
    ff.sl.x.Value = x_steps(1);
    addlistener(ff.sl.x,'ContinuousValueChange',@(hObject, event) update_fig(hObject,event,x_steps,ff.sh.x,x,pe)); 
    
    ff.sl.y = uicontrol('style','slider','units','pixel','string','body yaw','position',[54+130,862,120,20]); 
    ff.sl.y.Max = max(y_steps);
    ff.sl.y.Min = min(y_steps);
    addlistener(ff.sl.y,'ContinuousValueChange',@(hObject, event) update_fig(hObject,event,y_steps,ff.sh.y,yaw,pe)); 
    
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
            gg.Title.String=['x = ' str_app num2str(abs(steps(min_idx))) 'mm'];
            
        case 'body yaw'
            sh.XData = squeeze(depvar(min_idx, :, :));%
            sh.CData =  squeeze(    pe(min_idx, :, :));
            hh = findobj('tag','y_sec');
            gg = findobj('tag','sp_y_sec'); 
            gg.Title.String=['body yaw = ' str_app num2str(abs(steps(min_idx))) '°'];
      
        case 'body pitch'
            sh.YData = squeeze(depvar(:, :, min_idx));
            sh.CData = squeeze(    pe(:, :, min_idx));
            hh = findobj('tag','p_sec');
            gg = findobj('tag','sp_p_sec'); 
            gg.Title.String=['body pitch = ' str_app num2str(abs(steps(min_idx))) '°'];
            

    end

    hh.ZData = sh.CData;
