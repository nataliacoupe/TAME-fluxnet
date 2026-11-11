%Reads Harvard data. However, it will read any Fluxnet mat file
%Natalia Restrepo Coupe, at UTS
%Feb 5, 2014
%My beautiful Sydney
%% Giovanni -72.172,42.537,-72.171,42.538
%..........................................................................
addpath /home/ncoupe/Documents/OZ/;
addpath /home/ncoupe/Documents/Amazon/;

monthstr = ['Jan';'Feb';'Mar';'Apr';'May';'Jun';'Jul';'Aug';'Sep';'Oct';'Nov';'Dec'];
% parpool;

INa.nee_all = INa.Fc+INa.Sco2;

% ..............................................................
%u* correction
% ..............................................................
figure ('color','white');
subplot(2,1,1);
plot(INa.dateloc,INa.nee_all);          hold on;
INa.nee_all((INa.nee_all<-40)|(INa.nee_all>20)) = NaN;    INa.nee_all = AM_fill(INa.nee_all);
plot(INa.dateloc,INa.nee_all);     legend('INa.nee','INa.nee_{rm 3std}');

[~,nee_spike7] = AM_spike_detection(INa.nee_all,7);
[~,nee_spike11]= AM_spike_detection(INa.nee_all,11);
[~,nee_spike9] = AM_spike_detection(INa.nee_all,9);

plot(INa.dateloc,nee_spike11,'c');    plot(INa.dateloc,nee_spike9,':m');      plot(INa.dateloc,nee_spike7,':g');
legend('NEE','NEE_clean','NEE_{spk9}','NEE_{spk7}','NEE_{spk5}');

subplot(2,1,2);
plot(INa.dateloc,INa.nee_all);          hold on;
plot(INa.dateloc,nee_spike9);          hold on;

INa.nee_all = AM_fill(nee_spike7);

%%
INa.nee_night_all = INa.nee_all;  INa.tair_night_all = INa.tair;  INa.ustar_night_all = INa.ustar;
ind = find((INa.So>0)&(INa.nee_all<-3));
INa.nee_night_all(ind) = NaN;     INa.tair_night_all(ind) = NaN;  INa.ustar_night_all(ind) = NaN;
% INa.nee_night = AM_rm_outlier(INa.nee_night,3);

INa.nee_night_ustar = INa.nee_night_all;      INa.nee_night_ustar((isnan(INa.ustar))) = NaN;
INa.nee_night_ustar = AM_rm_outlier(INa.nee_night_ustar,3);

% ..............................................................
%u* correction
% ..............................................................
for im = 1:4
    indNight = find(INa.So>0);
    INa.nee_night = INa.nee;                     INa.nee_night(indNight) = NaN;
    INa.tair_night = AM_fill_plus(INa.tair);     INa.tair_night(indNight) = NaN;
    INa.ustar_night = INa.ustar;                 INa.ustar_night(indNight) = NaN;
    id_month = (im*3)-2:(im*3);
    INa.tair_night((INa.M<id_month(1))|(INa.M>id_month(3))) = [];
    INa.nee_night((INa.M<id_month(1))|(INa.M>id_month(3))) = [];
    INa.ustar_night((INa.M<id_month(1))|(INa.M>id_month(3))) = [];
    % split 7 Tair classes of ~equal sample size
    [INa.tair_class,INa.nee_class_avg,INa.nee_class_std,INa.nee_class_count] = AM_class_eq_size(INa.tair_night,INa.nee_night,4);
    if isnan(INa.tair_class)
        INa.nee_night = INa.nee;                          INa.nee_night(indNight) = NaN;
        INa.tair_night = AM_fill_plus(INa.tair);          INa.tair_night(indNight) = NaN;
        INa.ustar_night = INa.ustar;                      INa.ustar_night(indNight) = NaN;
        if im>1; id_month = ((im-1)*3)-2:((im-1)*3);      end
        if im==1; id_month = ((im+1)*3)-2:((im+1)*3);     end
        INa.tair_night((M<id_month(1))|(M>id_month(end))) = [];
        INa.nee_night((M<id_month(1))|(M>id_month(end))) = [];
        INa.ustar_night((M<id_month(1))|(M>id_month(end))) = [];
        [INa.tair_class,INa.nee_class_avg,INa.nee_class_std,INa.nee_class_count] = AM_class_eq_size(INa.tair_night,INa.nee_night,7);
    end
    INa.tair_class = [INa.tair_class(1,1);INa.tair_class(:,2)];
    INa.ustar_min = (floor((min(INa.ustar_night*100,[],'omitnan'))))/100;
    INa.ustar_max = (ceil(max(INa.ustar_night*100,[],'omitnan')))/100;
    INa.ustar_class = (INa.ustar_min:((INa.ustar_max-INa.ustar_min)/20):INa.ustar_max)';
    %             [INa.ustar_class] = AM_class_eq_size(INa.ustar_night,INa.nee_night,10);
    %             INa.ustar_class = [INa.ustar_class(1,1);INa.ustar_class(:,2)];

    [INa.LUT_tair_ustar,INa.LUT_tair_ustar_std,INa.LUT_tair_ustar_count]  =  AM_LUTgeneral(INa.tair_night,INa.ustar_night,INa.nee_night,...
        INa.tair_class,INa.ustar_class,1,'Ta(C)','u*(ms^-^1)',...
        ['INa.nee (\mumol im^-2 s^-^1)' monthstr(im*3-2)  '-' monthstr(im*3)],5);

    ind = find((INa.LUT_tair_ustar_count<40)&(INa.LUT_tair_ustar_std>mean(mean(INa.LUT_tair_ustar_std,'omitnan'),'omitnan')*2));
    INa.LUT_tair_ustar(ind) = NaN;	INa.LUT_tair_ustar_std(ind) = NaN;	INa.LUT_tair_ustar_count(ind) = NaN;
    % ..............................................................
    %        figure ('color','white');
    for k = 1:(length(INa.ustar_class))-1
        %             plot(INa.LUT_tair_ustar(:,k),'o','color',[0 1./k 0.01*k]); hold on;
        x = AM_rm_outlier(INa.LUT_tair_ustar(:,k),2);   INa.LUT_tair_ustar(:,k) = x;
        %             plot(INa.LUT_tair_ustar(:,k),'.','color',[0 1./k 0.01*k]);
    end
    %         close all;

    figure('color','white');
    subplot(2,2,1);
    for k = 1:length(INa.tair_class)-1
        plot(INa.ustar_class(2:end),((INa.LUT_tair_ustar(k,:))'),'color',[(.8^k) 0 (1/k)]); hold on;
        plot(INa.ustar_class(2:end),((INa.LUT_tair_ustar(k,:))'),'.','MarkerSize',12,'color',[(.8^k) 0 (1/k)]);
        INa.LUT_tair_ustar(k,:) = AM_rm_outlier(INa.LUT_tair_ustar(k,:),3);
        x = (INa.LUT_tair_ustar(k,:));    Y = (1:length(INa.ustar_class)-1);
        ind = find((isnan(x))|(isnan(Y)));    x(ind) = [];  y = Y;    y(ind) = [];
        if length(x)>2
            X = interp1(y,x,Y);       INa.LUT_tair_ustar(k,:) = X;
        end
        plot(INa.ustar_class(2:end),((INa.LUT_tair_ustar(k,:))'),'o','MarkerSize',6,'color',[(.8^k) 0 (1/k)]);
    end
    title(strcat(site_name, ' : tair, u_{*} nee  ', monthstr(im*3-2,:), '–', monthstr(im*3,:)));
    ylabel('INa.nee_{night}(\mumol m^-^2 s^-^1)'); xlabel('u*_{night}(im s^-^1)');
    set(gca,'XColor','k','YColor','k','XTick',INa.ustar_class(1:end),...
        'XAxisLocation','bottom','XTick',INa.ustar_class(1:end),'Xlim',([INa.ustar_class(1) INa.ustar_class(end)]),...
        'FontSize',8);          axis tight;
    subplot(2,2,2);
    for k = 1:length(INa.tair_class)-1
        plot(INa.ustar_class(2:end),((INa.LUT_tair_ustar_std(k,:))'),'color',[(.8^k) 0 (1/k)]); hold on;
    end
    title(strcat(site_name, ': tair, u_{*} nee'));
    ylabel('INa.nee_{night}std(\mumol m^-^2 s^-^1)'); xlabel('u*_{night}(im s^-^1)');
    set(gca,'XColor','k','YColor','k','XTick',INa.ustar_class(1:2:end),...
        'XAxisLocation','bottom','XTick',INa.ustar_class(1:end),'Xlim',([INa.ustar_class(1) INa.ustar_class(end)]),...
        'FontSize',8);          axis tight;
    subplot(2,2,3);
    for k = 1:length(INa.tair_class)-1
        plot(INa.ustar_class(2:end),((INa.LUT_tair_ustar_count(k,:))'),'color',[(.8^k) 0 (1/k)]); hold on;
    end
    title(strcat(site_name, ': tair, u_{*} nee'));
    ylabel('INa.nee_{night}count(\mumol m^-^2 s^-^1)'); xlabel('u*_{night}(im s^-^1)');
    set(gca,'XColor','k','YColor','k','XTick',INa.ustar_class(1:2:end),...
        'XAxisLocation','bottom','XTick',INa.ustar_class(1:end),'Xlim',([INa.ustar_class(1) INa.ustar_class(end)]),...
        'FontSize',8);          axis tight;

    % ..............................................................
    INa.max_ustar_tair_tresh_flag = [];
    for k = 1:(length(INa.tair_class))-1
        INa.max_ustar_tair_tresh_flag = [INa.max_ustar_tair_tresh_flag;(INa.ustar_class(1:end-1))'];
    end
    INa.max_ustar_tair_tresh_flag = INa.max_ustar_tair_tresh_flag.*(INa.LUT_tair_ustar./INa.LUT_tair_ustar);

    for k = 1:(length(INa.tair_class))-1
        x = INa.LUT_tair_ustar(k,:);
        x(isnan(x)) = [];
        if length(x)>1
            y = max(x);
            mp = find(x==max(x,[],'omitnan'));  mp = mp(1); if mp>1; mp = mp-1; end
            jp = mean(x(mp:end),'omitnan');
            y = 1:length(x);
            max_INa.ustar_INa.tair_tresh_max = jp*0.95;%0.95 at Papale's paper
            ind = find((x<max_INa.ustar_INa.tair_tresh_max)&(y<=mp));
            INa.max_ustar_tair_tresh_flag(k,ind) = NaN;
        end
    end

    subplot(2,2,4);
    for k = 1:length(INa.tair_class)-1
        plot(INa.ustar_class(2:end),((INa.max_ustar_tair_tresh_flag(k,:))'),'color',[(.8^k) 0 (1/k)]); hold on;
        plot(INa.ustar_class(2:end),((INa.max_ustar_tair_tresh_flag(k,:))'),'.','MarkerSize',12,'color',[(.8^k) 0 (1/k)]);
    end
    title(['flag treshold Ta - u* - INa.nee', site_name]);
    ylabel('INa.nee_{night}(\mumol m^-^2 s^-^1)'); xlabel('u*_{night}(m s^-^1)');
    set(gca,'XColor','k','YColor','k','XTick',INa.ustar_class(1:end),...
        'XAxisLocation','bottom','XTick',INa.ustar_class(1:end),'Xlim',([INa.ustar_class(1) INa.ustar_class(end)]),...
        'FontSize',8);          axis tight;

    INa.max_ustar_tair = NaN(1,((length(INa.tair_class))-1));
    for k = 1:(length(INa.tair_class))-1
        x = INa.max_ustar_tair_tresh_flag(k,:);
        x(isnan(x)) = [];     %if you have only one u* value missing, usually at low temp
        if ((~isempty(x))&(length(x)>1))
            INa.max_ustar_tair(k) = min(x,[],'omitnan');
        else
            INa.max_ustar_tair(k) = NaN;
        end
    end
    mean(INa.max_ustar_tair(INa.max_ustar_tair>0),'omitnan')
    INa.ustar_thr(ip,im).INa.tair = mean(INa.max_ustar_tair(INa.max_ustar_tair>0),'omitnan');

    INa.tair_night = INa.tair_night_all;      INa.nee_night = INa.nee_night_all;	INa.ustar_night = INa.ustar_night_all;
end

% ..............................................................
%% Night time respiration vs temperature
% ..............................................................
%%
color_mtx = jet(12);
figure('color','white')
for ik=1:12
    ind = find(INa.M==ik);   hold on;
    plot(INa.tair_night_all(ind),INa.nee_night_all(ind),'.','color',color_mtx(ik,:))
end

%%
[INa.tair_class,INa.nee_class_avg,INa.nee_class_std,INa.nee_class_count] = ...
    AM_class_eq_size(INa.tair_night,INa.nee_night_ustar,5);
INa.tair_class = [INa.tair_class(1,1);INa.tair_class(:,2)];
% M3_class = (1:1:4)';   INa.M3 = ceil(INa.M./3);
M_class = (1:1:12)';
[INa.LUT_tair_month,INa.LUT_tair_month_std,INa.LUT_tair_month_count]  = ...
    AM_LUTgeneral(INa.tair,INa.M,INa.nee_night,...
    INa.tair_class,M_class,1,'tair(C)','month','INa.nee (\mumol m^-2 s^-^1)',5);
% ..............................................................
figure('color','white');
subplot(2,2,2);
for k = 1:length(INa.tair_class)-1
    plot(INa.tair_class(2:end),((INa.LUT_tair_month(:,k))'),'color',[(.8^k) 0 (1/k)]); hold on;
end
title(['tair	month	INa.nee', site_name]);
ylabel('INa.nee_{night}(\mumol m^-^2 s^-^1)');  xlabel('INa.tair_{night}(\circC)');
set(gca,'XColor','k','YColor','k','XTick',INa.tair_class(1:2:end),...
    'XAxisLocation','bottom','XTick',INa.tair_class(1:2:end),'Xlim',([INa.tair_class(1) INa.tair_class(end)]),...
    'FontSize',8);                          axis tight;

% ..............................................................
%% Nigth time INa.ustar vs. month
% ..............................................................
%LUT month(as proxy for soil moisture) Ta night-time INa.nee

[INa.ustar_class] = ...
    AM_class_eq_size(INa.ustar_night,INa.nee_night,12);
INa.ustar_class = [INa.ustar_class(1,1);INa.ustar_class(:,2)];
month_class = (1:1:12+1)';
[INa.LUT_month_ustar,INa.LUT_month_ustar_std,INa.LUT_month_ustar_count]  = ...
    AM_LUTgeneral(INa.M,INa.ustar_night,INa.nee_night,...
    month_class,INa.ustar_class,1,'month','INa.ustar(m s^-^1)','INa.nee (\mumol m^-2 s^-^1)',5);

% ..............................................................
figure('color','white');
subplot(2,2,1);
for k = 1:length(month_class)-1
    plot(INa.ustar_class(2:end),((INa.LUT_month_ustar(k,:))'),'color',[(.8^k) 0 (1/k)]); hold on;
    plot(INa.ustar_class(2:end),((INa.LUT_month_ustar(k,:))'),'.','MarkerSize',12,'color',[(.8^k) 0 (1/k)]);
    x = (INa.LUT_month_ustar(k,:));
    Y = (1:length(INa.ustar_class)-1);
    ind = find((isnan(x))|(isnan(Y)));    x(ind) = [];  y = Y;    y(ind) = [];
    if length(y)>2
        X = interp1(y,x,Y);       INa.LUT_month_ustar(k,:) = X;
    end
    plot(INa.ustar_class(2:end),((INa.LUT_month_ustar(k,:))'),'o','MarkerSize',6,'color',[(.8^k) 0 (1/k)]);
end
title(['month - u* - INa.nee', site_name]);
ylabel('INa.nee_{night}(\mumol m^-^2 s^-^1)'); xlabel('u*_{night}(m s^-^1)');
set(gca,'XColor','k','YColor','k','XTick',INa.ustar_class(1:end),...
    'XAxisLocation','bottom','XTick',INa.ustar_class(1:end),'Xlim',([INa.ustar_class(1) INa.ustar_class(end)]),...
    'FontSize',8);          axis tight;
subplot(2,2,2);
for k = 1:length(month_class)-1
    plot(INa.ustar_class(2:end),((INa.LUT_month_ustar_std(k,:))'),'color',[(.8^k) 0 (1/k)]); hold on;
end
title(['month - u* - INa.nee', site_name]);
ylabel('INa.nee_{night}std(\mumol m^-^2 s^-^1)'); xlabel('u*_{night}(m s^-^1)');
set(gca,'XColor','k','YColor','k','XTick',INa.ustar_class(1:2:end),...
    'XAxisLocation','bottom','XTick',INa.ustar_class(1:end),'Xlim',([INa.ustar_class(1) INa.ustar_class(end)]),...
    'FontSize',8);          axis tight;
subplot(2,2,3);
for k = 1:length(month_class)-1
    plot(INa.ustar_class(2:end),((INa.LUT_month_ustar_count(k,:))'),'color',[(.8^k) 0 (1/k)]); hold on;
end
title(['month - u* - INa.nee', site_name]);
ylabel('INa.nee_{night}count(\mumol m^-^2 s^-^1)'); xlabel('u*_{night}(m s^-^1)');
set(gca,'XColor','k','YColor','k','XTick',INa.ustar_class(1:2:end),...
    'XAxisLocation','bottom','XTick',INa.ustar_class(1:end),'Xlim',([INa.ustar_class(1) INa.ustar_class(end)]),...
    'FontSize',8);          axis tight;

% % % % ..............................................................
% % % INa.max_ustar_month_tresh_flag = [];
% % % for k = 1:(length(month_class))-1
% % %     INa.max_ustar_month_tresh_flag  =  [INa.max_ustar_month_tresh_flag;(INa.ustar_class(2:end))'];
% % % end
% % % INa.max_ustar_month_tresh_flag = INa.max_ustar_month_tresh_flag.*(INa.LUT_month_ustar./INa.LUT_month_ustar);
% % %
% % % for k = 1:(length(month_class)-1)
% % %     x = INa.LUT_month_ustar(k,:);   x(isnan(x)) = [];
% % %     if length(x)>1
% % %         INa.max_ustar_month_tresh_max = (mean(x(end-1:end),'omitnan'))*0.95;%0.95 at Papale's paper
% % %         INa.max_ustar_month_tresh_flag(k,(INa.LUT_month_ustar(k,:)<INa.max_ustar_month_tresh_max)) = NaN;
% % %     end
% % % end
% % %
% % % subplot(2,2,4);
% % % for k = 1:(length(month_class)-1)
% % %     plot(INa.ustar_class(2:end),((INa.max_ustar_month_tresh_flag(k,:))'),'color',[(.8^k) 0 (1/k)]); hold on;
% % %     plot(INa.ustar_class(2:end),((INa.max_ustar_month_tresh_flag(k,:))'),'.','MarkerSize',12,'color',[(.8^k) 0 (1/k)]);
% % % end
% % % title(['flag treshold month - u* - INa.nee', site_name]);
% % % ylabel('INa.nee_{night}(\mumol m^-^2 s^-^1)'); xlabel('u*_{night}(m s^-^1)');
% % % set(gca,'XColor','k','YColor','k','XTick',INa.ustar_class(1:end),...
% % %     'XAxisLocation','bottom','XTick',INa.ustar_class(1:end),'Xlim',([INa.ustar_class(1) INa.ustar_class(end)]),...
% % %     'FontSize',8);          axis tight;
% % %
% % % INa.max_ustar_month = NaN(1,((length(month_class))-1));
% % % for ik = 1:(length(month_class))-1
% % %     x = INa.max_ustar_month_tresh_flag(k,:); x(isnan(x)) = [];     %if you have only one u* value missing, usually at low temp
% % %     if length(x)>1
% % %         INa.max_ustar_month(k) = min(x);
% % %     else
% % %         INa.max_ustar_month(k) = NaN;
% % %     end
% % % end
% % % mean(INa.max_ustar_month(INa.max_ustar_month>0),'omitnan')
% % % INa.ustar_thr.month = mean(INa.max_ustar_month(INa.max_ustar_month>0),'omitnan');
% % %
% % % % %             if flag_figure_ps==1
% % % % %                 for ik = 1:13
% % % % %                     print('-dpsc', ['BFflux.INa.ustarr.ps' ], '-append');     close;
% % % % %                 end
% % % % %             else
% % % % %                 close all;
% % % % %             end
% % %
%             close all;
% ..............................................................
%% Bootstrap this thing. 1) join both time series 2) calculate u*
% ..............................................................
INa.ustar_thr_btp10_per95 = [];     INa.ustar_thr_btp100_per95 = [];
INa.ustar_thr_btp1000_per95 = [];   INa.ustar_thr_btp100_per99 = [];
INa.ustar_thr_btp1000_per99 = [];   %INa.ustar_thr_btp100_per91 = [];
%INa.ustar_thr_btp1000_per91 = [];

INa.tair_night = INa.tair_night_all;      INa.nee_night = INa.nee_night_all;	INa.ustar_night = INa.ustar_night_all;    INa.ustar_night(INa.ustar_night==0) = NaN;
for im = 1:4
    id_month = (im*3)-2:(im*3);
    INa.tair_night((INa.M<id_month(1))|(INa.M>id_month(3))) = [];	INa.nee_night((INa.M<id_month(1))|(INa.M>id_month(3))) = [];
    INa.ustar_night((INa.M<id_month(1))|(INa.M>id_month(3))) = [];
    x = INa.tair_night;     y = INa.ustar_night;        z = INa.nee_night;
    ind = find((isnan(INa.tair_night))|(isnan(INa.ustar_night))|(isnan(INa.nee_night)));
    x(ind) = [];      y(ind) = [];          z(ind) = [];

    if (~isempty(x))
        %                     dummy10 =  bootstrp(10,['AM_ustar_papale',x,y,z,7,10,0,0.95,ip],10);
        %                     dummy1 =  bootstrp(10,'AM_ustar_papale',x,y,z,7,10,0,0.95,ip,1);
        ix = bootstrp(10,'AM_ustar_papale',x,y,z,3,7,0,0.95,ip,5);      INa.ustar_thr_btp10(im).per95 = ix;
        ix = bootstrp(100,'AM_ustar_papale',x,y,z,3,7,0,0.95,ip,5);     INa.ustar_thr_btp100(im).per95 = ix;
        ix = bootstrp(10000,'AM_ustar_papale',x,y,z,3,7,0,0.95,ip,5);   INa.ustar_thr_btp1000(im).per95 = ix;
        ix = bootstrp(100,'AM_ustar_papale',x,y,z,3,7,0,0.99,ip,5);     INa.ustar_thr_btp100(im).per99 = ix;
        ix = bootstrp(10000,'AM_ustar_papale',x,y,z,3,7,0,0.99,ip,5);   INa.ustar_thr_btp1000(im).per99 = ix;
        %                                         INa.ustar_thr_btp100(im).per91 =  bootstrp(100,'AM_ustar_papale',x,y,z,7,10,0,0.91,ip);
        %                                         INa.ustar_thr_btp1000(im).per91 =  bootstrp(1000,'AM_ustar_papale',x,y,z,7,10,0,0.91,ip);
        %                     INa.ustar_thr_btp100.per85 =  bootstrp(100,'AM_ustar_papale',INa.tair_night,INa.ustar_night,INa.nee_night,sunrise,sunset,1,0.85,ip);
        %                     INa.ustar_thr_btp1000.per85 =  bootstrp(1000,'AM_ustar_papale',INa.tair_night,INa.ustar_night,INa.nee_night,sunrise,sunset,1,0.85,ip);
        close all;

        INa.ustar_thr_btp10_per95 = [INa.ustar_thr_btp10_per95;INa.ustar_thr_btp10(im).per95];
        INa.ustar_thr_btp100_per95 = [INa.ustar_thr_btp100_per95;INa.ustar_thr_btp100(im).per95];
        INa.ustar_thr_btp1000_per95 = [INa.ustar_thr_btp1000_per95;INa.ustar_thr_btp1000(im).per95];
        %                                         INa.ustar_thr_btp100_per91 = [INa.ustar_thr_btp100_per91;INa.ustar_thr_btp100(im).per91];
        %                                         INa.ustar_thr_btp1000_per91 = [INa.ustar_thr_btp1000_per91;INa.ustar_thr_btp1000(im).per91];
        INa.ustar_thr_btp100_per99 = [INa.ustar_thr_btp100_per99;INa.ustar_thr_btp100(im).per99];
        INa.ustar_thr_btp1000_per99 = [INa.ustar_thr_btp1000_per99;INa.ustar_thr_btp1000(im).per99];

    end
    INa.tair_night = INa.tair_night_all;      INa.nee_night = INa.nee_night_all;	INa.ustar_night = INa.ustar_night_all;
end
%%
figure('color','white');
subplot(2,2,1);
histfit(INa.ustar_thr_btp10_per95);    h  =  get(gca,'Children');
set(h(2),'FaceColor',[.8 .8 1]);        axis ([0 0.4 0 10]);
xlabel('u* treshhold');                 ylabel({'incidence';'n = 100, 95% max flux'});
[muhat.btp10.per95,sigmahat.btp10.per95,muci.btp10.per95,...
    sigmaci.btp10.per95] =  normfit(INa.ustar_thr_btp10_per95);
%returns 95% confidence intervals for the rgsameter estimates on the mean
title(site_name);

subplot(2,2,2);
histfit(INa.ustar_thr_btp100_per95,15);   h  =  get(gca,'Children');
set(h(2),'FaceColor',[.8 .8 1]);    axis ([0.0 0.4 0 40]);
xlabel('u* treshhold');                 ylabel({'incidence';'n = 1000, 95% max flux'});
[muhat.btp100.per95,sigmahat.btp100.per95,muci.btp100.per95,...
    sigmaci.btp100.per95] =  normfit(INa.ustar_thr_btp100_per95);
title(site_name);

subplot(2,2,3);
histfit(INa.ustar_thr_btp100_per99,15);	h  =  get(gca,'Children');
set(h(2),'FaceColor',[.8 .8 1]);    axis ([0.0 0.4 0 40]);
xlabel('u* treshhold');             ylabel({'incidence';'n = 100, 99% max flux'});
[muhat.btp100.per99,sigmahat.btp100.per99,muci.btp100.per99,...
    sigmaci.btp100.per99] =  normfit(INa.ustar_thr_btp100_per99);
title(site_name);

muhat.btp100.per99
sigmahat.btp100.per99
%             subplot(2,2,4);
%             histfit(INa.ustar_thr_btp100_per91,15);	h  =  get(gca,'Children');
%             set(h(2),'FaceColor',[.8 .8 1]);    axis ([0.0 04 0 40]);
%             xlabel('u* treshhold'); ylabel({'incidence';'n = 100, 91% max flux'});
%             [muhat.btp100.per91,sigmahat.btp100.per91,muci.btp100.per91,...
%                 sigmaci.btp100.per91] =  normfit(INa.ustar_thr_btp100_per91);
%             %%
figure('color','white');
subplot(2,2,1);
histfit(INa.ustar_thr_btp1000_per95,15);	h  =  get(gca,'Children');
set(h(2),'FaceColor',[.8 .8 1]);        axis ([0 0.4 0 10000]);
xlabel('u* treshhold');                 ylabel({'incidence';'n = 1000, 95% max flux'});
[muhat.btp1000.per95,sigmahat.btp1000.per95,muci.btp1000.per95,...
    sigmaci.btp1000.per95] =  normfit(INa.ustar_thr_btp1000_per95(~isnan(INa.ustar_thr_btp1000_per95)));
title(site_name);

subplot(2,2,2);
histfit(INa.ustar_thr_btp1000_per99,15);	h  =  get(gca,'Children');
set(h(2),'FaceColor',[.8 .8 1]);        axis ([0 0.4 0 10000]);
xlabel('u* treshhold');                 ylabel({'incidence';'n = 1000, 99% max flux'});
[muhat.btp1000.per99,sigmahat.btp1000.per99,muci.btp1000.per99,...
    sigmaci.btp1000.per99] =  normfit(INa.ustar_thr_btp1000_per99(~isnan(INa.ustar_thr_btp1000_per99)));
title(site_name);

muhat.btp1000.per99
sigmahat.btp1000.per99