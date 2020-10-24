function ceil_auto(date)
% enter date as 'YYYY-MM-DD'

%% SET START POINT (TIME) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
s_dt = datetime(date,'InputFormat','yyyy-MM-dd');
s_yr = num2str(year(s_dt));
s_mth = num2str(month(s_dt));
if strlength(s_mth)~= 2
    s_mth = strcat('0',s_mth);
end
s_dy = num2str(day(s_dt));
if strlength(s_dy)~= 2
    s_dy = strcat('0',s_dy);
end
%% OPEN FILE DIRECTROY & COMPILE DATA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
drive = 'Z:\Cronyn\';
directory = strcat(drive,s_yr,'\',s_mth,'\',s_dy,'\');
ncfile = dir(directory);
density = zeros(1024, 4500);
for j = 3:length(ncfile)
      file = ncfile(j).name;
      densitynew = ncread(strcat(directory,file),'beta_raw');
      density(:,((j-2)*19):((j-1)*19))=densitynew(:,:);
end
%% FULL SCREEN DEFAULT SIZE
set(groot, 'defaultFigureUnits','normalized')
set(groot, 'defaultFigurePosition',[0 0 1 1])
figure(1);
%% SUBPLOT NIGHT  AVG %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
sn = subplot(2,2,3);
a=size(density);
d_night = density(:,1:(a(2)/2));
d_sum = mean(d_night,2);
range = ncread(strcat(directory,file),'range');
[x,y] = coadd(d_sum,range,10);
semilogx(x,y);
set(gca,'FontSize',15);
xlim([10^4 10^7]);
ylim([0 15000]);
title('Night Average Signal');
xlabel('normalized range corrected signal')
ylabel('Height (m)')
%% SUBPLOT DAY  AVG %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
sd = subplot(2,2,4);
a=size(density);
d_night = density(:,(a(2)/2):a(2));
d_sum = mean(d_night,2);
range = ncread(strcat(directory,file),'range');
[x,y] = coadd(d_sum,range,10);
semilogx(x,y);
set(gca,'FontSize',15);
xlim([10^4 10^7]);
ylim([0 15000]);
title('Day Average Signal');
xlabel('normalized range corrected signal')
ylabel('Height (m)')
%% SUBPLOT 24H CONTOUR %%%%%%%%%%%%%%%%%%%%%%%%%%%%
cp=subplot(2,2,[1,2]);
density(density<0) = 0;
pc=pcolor(log10(density));
set(pc,'EdgeColor','none');
newmap = jet;                    
ncol = size(newmap,1);           
zpos = ncol;   
newmap(1,:) = [1 1 1];                    % set lowest position to white
newmap(ncol,:) = [0.75 0.75 0.75];           % set highest position to grey
colormap(newmap);              
shading interp;
c = colorbar;
caxis([4 7]);
c.Label.String='log10(normalized range corrected signal)';
c.Label.FontSize = 15;
xlabel('Time (UT)');
ylabel('Height (m)');
a=size(density);
xticks(1:(a(2)/12.01):a(2));
xticklabels({'00:00','02:00','04:00','06:00','08:00','010:00','12:00','14:00','16:00','18:00','20:00','22:00','24:00'});
yticks(10:(a(1)/5.1):a(1));
yticklabels({'0','3000','6000','9000','12000','15000'})
aH = ancestor(pc,'axes');
set(gca,'FontSize',15);
title(string(s_dt));
%% SETTING EXACT POSITION AND SIZE OF PLOTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%
cp.Position = [.1 .56 .8 .375]; % contour positon [left bottom width height]
sd.Position = [.575 .09 .35 .375]; % sum day position [left bottom width height]
sn.Position = [.1 .09 .35 .375]; % sum night position [left bottom width height]

end

