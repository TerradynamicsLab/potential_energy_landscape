

for ii=1:3
    subplot(2,3,ii)
    hold on
    set(gca,'outerposition',[0.01+(ii-1)*0.31 0.55 0.3 .4])

    subplot(2,3,3+ii)
    hold on
    set(gca,'outerposition',[0.01+(ii-1)*0.31 0.05 0.3 .4])
end

% set top right subplot emptly
subplot(2,3,3)
hold on 
set(gca,'visible','off')

% set slider and its text positions
fn=fieldnames(ff.sl)
for ii = 1:numel(fn)
   ff.sl.(fn{ii}).Units='normalized';
   ff.sl.(fn{ii}).Position = [0.65 0.80-(ii-1)*0.1 .2 .02] 
   ff.st(ii).Position      = [0.65 0.83-(ii-1)*0.1 .2 .03] 
   ff.st(ii).FontSize      = 15;
   ff.st(ii).BackgroundColor = 'w';
   
   switch fn{ii}
       case 'w'
           ff.st(ii).String = 'wing opening angle'
       case 'x'
           ff.st(ii).String = 'body forward position'
       case 'p'
           ff.st(ii).String = 'body pitch'
       case 'r'
           ff.st(ii).String = 'body roll'
       case 'y'
           ff.st(ii).String = 'body yaw'
       case 'b'
           ff.st(ii).String = 'bearing'
   end
   
end

ff.st(ii).FontSize = 15;

% reset button
ff.bt.Units = 'normalized';
ff.bt.Position = [0.65 0.9 0.2 0.03]; 
ff.bt.String = 'Right click here to reset'
ff.bt.FontSize = 15;

