function plot_beam
    
    clear
    close all
    
    load data/dat_beam.mat
    
    n  = numel(r_steps);
    n0 = ceil(n/2);
    
    
    % setup figures   
    ff.fh = figure(1)
    clf
    set(gcf,'position',[1 50 900 900],'color',[1 1 1])
    
%% 3d plots
    ff.sp(1) = subplot(2,2,1)
    hold on; box on; set(gca,'fontsize',15) 
    colormap(fire)
    ff.sh.x = surf( squeeze(roll( :, 1, :)),  squeeze(pitch( :, 1, :)), squeeze(x( :, 1, :)), squeeze(pe( :, 1, :)), 'edgealpha',0);
    ff.sh.r = surf( squeeze(roll(n0, :, :)),  squeeze(pitch(n0, :, :)), squeeze(x(n0, :, :)), squeeze(pe(n0, :, :)), 'edgealpha',0);
    ff.sh.p = surf( squeeze(roll( :, :,n0)),  squeeze(pitch( :, :,n0)), squeeze(x( :, :,n0)), squeeze(pe( :, :,n0)), 'edgealpha',0);
    
    xlim([-1,1]*90);       xticks([-2,-1,0,1,2]*45); xticklabels({[char(8211) '90'],[char(8211) '45'],'0','45','90'})
    ylim([-1,1]*90);       yticks([-2,-1,0,1,2]*45); yticklabels({[char(8211) '90'],[char(8211) '45'],'0','45','90'})
    zlim([min(x_steps) max(x_steps)])
    xlabel('body roll (°)');
    ylabel('body pitch (°)');
    zlabel('{\it x} (mm)')
    view(44,33)
    
    % boundaries for the panels
    ff.bh.x = patch([-1 -1 1 1]*90, [-1 1 1 -1]*90, [1 1 1 1]*ff.sh.x.ZData(1), 'k' ); ff.bh.x.FaceAlpha = 0;
    ff.bh.r = patch([1 1 1 1]*ff.sh.r.XData(1), [-1 1 1 -1]*90, [[1 1]*min(x_steps), [1 1]*max(x_steps)] , 'k' ); ff.bh.r.FaceAlpha = 0;
    ff.bh.p = patch([-1 1 1 -1]*90, [1 1 1 1]*ff.sh.p.YData(1), [[1 1]*min(x_steps), [1 1]*max(x_steps)], 'k' ); ff.bh.p.FaceAlpha = 0;
    
%% 2d sections
    ff.sp(2) = subplot(2,2,2)
    hold on; box on; set(gca,'fontsize',15,'tag','sp_x_sec','boxstyle','full') 
    colormap(fire)
    ff.sh.x_sec = surf( squeeze(roll( :, 1, :)),  squeeze(pitch( :, 1, :)),  squeeze(pe( :, 1, :)), 'edgealpha',0,'tag','x_sec');
    axis equal
    xlim([-1,1]*90);       xticks([-2,-1,0,1,2]*45); xticklabels({[char(8211) '90'],[char(8211) '45'],'0','45','90'})
    ylim([-1,1]*90);       yticks([-2,-1,0,1,2]*45); yticklabels({[char(8211) '90'],[char(8211) '45'],'0','45','90'})
    xlabel('roll (°)');         ylabel('pitch (°)');
    title(['{\it x }= ' num2str(x_steps(1)) '°'],'fontweight','normal');
    


    ff.sp(3) = subplot(2,2,3)
    hold on; box on; set(gca,'fontsize',15,'tag','sp_r_sec') 
    colormap(fire)
    ff.sh.r_sec = surf(squeeze(pitch(n0, :, :)), squeeze(x(n0, :, :)), squeeze(pe(n0, :, :)), 'edgealpha',0,'tag','r_sec');
    xlim([-1,1]*90);       xticks([-2,-1,0,1,2]*45); xticklabels({[char(8211) '90'],[char(8211) '45'],'0','45','90'})
    ylim(x_steps([1 end])); yticks([0:4]*20);
    xlabel('body pitch (°)');         ylabel('{\it x} (mm)');
    title(['body roll = ' num2str(r_steps(n0)) '°'],'fontweight','normal');

    ff.sp(4) = subplot(2,2,4)
    hold on; box on; set(gca,'fontsize',15,'tag','sp_p_sec') 
    colormap(fire)
    ff.sh.p_sec =surf( squeeze(roll( :, :,n0)), squeeze(x( :, :,n0)), squeeze(pe( :, :,n0)),'edgealpha',0,'tag','p_sec');
    xlim([-1,1]*90);       xticks([-2,-1,0,1,2]*45); xticklabels({[char(8211) '90'],[char(8211) '45'],'0','45','90'})
    ylim(x_steps([1 end])); yticks([0:4]*20);
    xlabel('body roll (°)');         ylabel('{\it x}(mm)');
    title(['body pitch = ' num2str(p_steps(n0)) '°'],'fontweight','normal');
    

%% gui controls
    ff.sl.x = uicontrol('style','slider','units','pixel','string','x','position',[54,862,120,20]); 
    ff.sl.x.Max = max(x_steps);
    ff.sl.x.Min = min(x_steps);
    addlistener(ff.sl.x,'ContinuousValueChange',@(hObject, event) update_fig(hObject,event,x_steps,ff.sh.x,x,pe)); 
    
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
            gg.Title.String=['{\it x}= ' str_app num2str(abs(steps(min_idx))) 'mm'];
            
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
