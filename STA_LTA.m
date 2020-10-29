%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%  Code to test the STA/LTA algorithm for the simple cases %%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all
close all


%%%%%% defining sampling frequency, time step and time vector %%%%%%%%%%%%

fs = 100;
dt = 1/fs;
t = 0:1/fs:5-1/fs;
nt = length(t);

%%%%%% Defining a simple function to analyse %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fun1 = zeros(1,nt);

for n = 1:nt
    if rem(n,2) == 0
        fun1(n) = 1;
    end
end

%%%%%% Introducing a transient to the defined function %%%%%%%%%%%%%%%%%%%

trans1 = zeros(1,nt);
trans1(nt/2) = 3;

fun2 = fun1 + trans1;

%%%%%% Introducing a more complex transient to the defined function %%%%%%

% random indeces with transient
% xt = [15,36,40,45,46,88,90];
xt = [421;128;408;122;465;175;99;126;309;237;176;416;293;275;459;143;379;377;191;284];
% random transient values
%tr = [2,2,4,5,2,1,3];
tr =[2;4;4;1;1;3;5;2;3;2;4;2;3;4;5;5;3;1;1;2];

trans2 = zeros(1,nt);

for nn = 1:length(xt)
    kk = xt(nn);
    trans2(kk) = tr(nn);
end

fun3 = fun2 + trans2;



%%%%%% Plotting the signal %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure 

subplot 311
stem(t,fun1)
ylim([-.5, 7])
xlabel 'time'
ylabel 'amplitude'
title 'the original function'

subplot 312
stem(t,fun2)
ylim([-.5, 7])
xlabel 'time'
ylabel 'amplitude'
title 'Function with the transient'

subplot 313
stem(t,fun3)
ylim([-.5, 7])
xlabel 'time'
ylabel 'amplitude'
title 'Function with more transient'


%% STA/LTA
%%%%%% Defining STA/LTA parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% length/numebr of data point of the long time average
LTA = 20 ;     
% length numebr of data point of the long time average
STA = 4;
% treshold for the transient to be captured
trig = 1.5;
% the pre and post event time
PEM = 4;



%%%%%% Simple case of detecting the threshold %%%%%%%%%%%%%%%%%%%%%%%%%%%%

% vectors for STA and LTA results 
STA1 = zeros(1,nt);
STA2 = zeros(1,nt);
STA3 = zeros(1,nt);

LTA1 = zeros(1,nt);
LTA2 = zeros(1,nt);
LTA3 = zeros(1,nt);

ratio1 = zeros(1,nt); 
ratio2 = zeros(1,nt); 
ratio3 = zeros(1,nt); 



%for ll = 1:1:nt
    
    % short term average
    for k = 1:length(fun1)-STA
        STA1(k+STA./2)=mean(fun1(k:floor(STA+k-1)));
        STA2(k+STA./2)=mean(fun2(k:floor(STA+k-1)));
        STA3(k+STA./2)=mean(fun3(k:floor(STA+k-1)));
    end
    % the long average loop
    for k = 1:length(fun1)-LTA
        LTA1(k+LTA./2)=mean(fun1(k:floor(LTA+k)-1));
        LTA2(k+LTA./2)=mean(fun2(k:floor(LTA+k)-1));
        LTA3(k+LTA./2)=mean(fun3(k:floor(LTA+k)-1));
    end
    % the STA/LTA ratio loop
    for k = 1:length(fun1)-LTA
        ratio1(k+LTA./2)=STA1(k+LTA./2)./LTA1(k+LTA./2);
        ratio2(k+LTA./2)=STA2(k+LTA./2)./LTA2(k+LTA./2);
        ratio3(k+LTA./2)=STA3(k+LTA./2)./LTA3(k+LTA./2);
    end
%end
%

%%%%%% Figures for STA, LTA and ratios %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure 
subplot 311
plot(t,LTA1);hold on
plot(t,STA1)
ylim([0,2.5])
xlabel('time','Fontsize',14)
ylabel('Aver. ampl.','Fontsize',14)
legend('LTA','STA','Fontsize',14,'Position',[0.8 0.9 0.08 0.08])
title 'function 1 - no transient'

subplot 312
plot(t,LTA2);hold on
plot(t,STA2)
ylim([0,2.5])
xlabel('time','Fontsize',14)
ylabel('Aver. ampl.','Fontsize',14)
%legend('LTA','STA','Fontsize',14)
title 'function 2 - one transient peak'

subplot 313
plot(t,LTA3);hold on
plot(t,STA3)
ylim([0,2.5])
xlabel('time','Fontsize',14)
ylabel('Aver. ampl.','Fontsize',14)
%legend('LTA','STA','Fontsize',14)
title 'function 3 - added transient'


text = "STA = %d and LTA = %d data points";
sgtitle(sprintf(text,STA,LTA),'Fontsize',16)



figure

subplot 311
plot(t,ratio1); hold on
line([t(1),t(end)],[trig,trig],'Linestyle',':','Color','r')
ylim([0,3])
legend('STA/LTA ratio','threshold','Fontsize',14,'Position',[0.8 0.9 0.08 0.08])
xlabel('time','Fontsize',14)
ylabel('STA/LTA ratio','Fontsize',14)
title 'function 1 - no transient'

subplot 312
plot(t,ratio2); hold on
line([t(1),t(end)],[trig,trig],'Linestyle',':','Color','r')
ylim([0,3])
%legend('STA/LTA ratio','threshold','Fontsize',14)
xlabel('time','Fontsize',14)
ylabel('STA/LTA ratio','Fontsize',14)
title 'function 2 - one transient peak'

subplot 313
plot(t,ratio3); hold on
line([t(1),t(end)],[trig,trig],'Linestyle',':','Color','r')
ylim([0,3])
%legend('STA/LTA ratio','threshold','Fontsize',14)
xlabel('time','Fontsize',14)
ylabel('STA/LTA ratio','Fontsize',14)
title 'function 3 - added transient'

text2 = "STA/LTA ratio with treshold = %d";
sgtitle(sprintf(text2,trig),'Fontsize',16)


%% Stationary and transient separation

%%%%%% loop for extracting indecies of the signal above the threshold %%%%
  
% in this look, the index and transient part is extracted

bb=0;
for kk = 1: length(ratio1)
    if ratio1(kk) >=trig && ratio1(kk-1) <=trig
        bb=bb+1;
        %             all_data(ll).trasient(bb).threshold=all_data(ll).mod_data(kk-PEM:kk+PET,:);
        numbers1(bb)=kk;
    end
end
bb=0;
for kk = 1: length(ratio2)
    if ratio2(kk) >=trig && ratio2(kk-1) <=trig
        bb=bb+1;
        %             all_data(ll).trasient(bb).threshold=all_data(ll).mod_data(kk-PEM:kk+PET,:);
        numbers2(bb)=kk;
    end
end
bb=0;
for kk = 1: length(ratio3)
    if ratio3(kk) >=trig && ratio3(kk-1) <=trig
        bb=bb+1;
        %             all_data(ll).trasient(bb).threshold=all_data(ll).mod_data(kk-PEM:kk+PET,:);
        numbers3(bb)=kk;
    end
end

    
%%

% a loop for extracting the whole vecotr data for stationary and transient
% parts of the signal


i = 1;
kk = 1;

while kk <= n
    if kk+PEM <= n
        % case when there is only one peak
        if length(numbers2) == 1
            if ratio2(kk+PEM) >=trig && ratio2(kk+PEM-1) <=trig
                while kk <  numbers2(i)+PEM
                    trans2(kk) = fun2(kk);
                    stat2(kk) = 0;
                    kk = kk + 1;
                end
            else
                stat2(kk) = fun2(kk);
                trans2(kk) = 0;
                kk = kk + 1;
            end
            
        elseif i+1 > length(numbers2)
            while kk <= n
                stat2(kk) = fun2(kk);
                trans2(kk) = 0;
                kk = kk + 1;
            end
        else
            if ratio2(kk+PEM) >=trig && ratio2(kk+PEM-1) <=trig
                while kk <  numbers2(i)+PEM
                    trans2(kk) = fun2(kk);
                    stat2(kk) = 0;
                    kk = kk + 1;
                end
                % dopoki numbers(i+1)+pem < kk 
                if i+1 <= length(numbers2)
                    if numbers2(i+1)-PEM <= kk
                        
                        while numbers2(i+1)-PEM <= kk
                            % dopoki
                            while kk < numbers2(i+1)+PEM
                                trans2(kk) = fun2(kk);
                                stat2(kk) = 0;
                                kk = kk + 1;
                            end
                            i = i + 1
                            %jesli tak, to do konca numbers(i+1)+Pem - transient
                            
                            if i+1 > length(numbers2)
                                break
                            end
                        end              
                    else
                        i = i + 1        
                        %jesli nie, idziemy dalej normlanie
                    end
                else
                    stat2(kk) = fun2(kk);
                    trans2(kk) = 0;
                    kk = kk + 1;
                end

                %{
                %                 [row, col] = find(all_data(ll).numbers > kk)
                %                 col (1)<= kk
                %                 if all_data(ll).numbers(i+1) <= kk
                %
                %                     if isempty(col)
                %                         while kk <= n
                %                         all_data(ll).stationary(kk,:) = all_data(ll).mod_data(kk,:);
                %                         all_data(ll).transient(kk,:) = 0;
                %                         kk = kk + 1;
                %                         end
                %                     else
                %                        while kk <= all_data(ll).numbers(i)+PEM
                %                         all_data(ll).transient(kk,1:20) = all_data(ll).mod_data(kk,:);
                %                         all_data(ll).stationary(kk,:) = 0;
                %                         kk = kk + 1;
                %                     end
                %                         i = col(1)
                %                     end
                %                 else
                %                         i = i + 1
                %                 end
                %}
            else
                stat2(kk) = fun2(kk);
                trans2(kk) = 0;
                kk = kk + 1;
            end
        end
    else
        stat2(kk) = fun2(kk);
        trans2(kk) = 0;
        kk = kk + 1;
    end
end


i = 1;
kk = 1;

while kk <= n
    if kk+PEM <= n
        % case when there is only one peak
        if length(numbers3) == 1
            if ratio3(kk+PEM) >=trig && ratio3(kk+PEM-1) <=trig
                while kk <  numbers3(i)+PEM
                    trans3(kk) = fun3(kk);
                    stat3(kk) = 0;
                    kk = kk + 1;
                end
            else
                stat3(kk) = fun3(kk);
                trans3(kk) = 0;
                kk = kk + 1;
            end
            
        elseif i+1 > length(numbers3)
            while kk <= n
                stat3(kk) = fun3(kk);
                trans3(kk) = 0;
                kk = kk + 1;
            end
        else
            if ratio3(kk+PEM) >=trig && ratio3(kk+PEM-1) <=trig
                while kk <  numbers3(i)+PEM
                    trans3(kk) = fun3(kk);
                    stat3(kk) = 0;
                    kk = kk + 1;
                end
                % dopoki numbers(i+1)+pem < kk 
                if i+1 <= length(numbers3)
                    if numbers3(i+1)-PEM <= kk
                        
                        while numbers3(i+1)-PEM <= kk
                            % dopoki
                            while kk < numbers3(i+1)+PEM
                                trans3(kk) = fun3(kk);
                                stat3(kk) = 0;
                                kk = kk + 1;
                            end
                            i = i + 1
                            %jesli tak, to do konca numbers(i+1)+Pem - transient
                            
                            if i+1 > length(numbers3)
                                break
                            end
                        end              
                    else
                        i = i + 1        
                        %jesli nie, idziemy dalej normlanie
                    end
                else
                    stat3(kk) = fun3(kk);
                    trans3(kk) = 0;
                    kk = kk + 1;
                end
            else
                stat3(kk) = fun3(kk);
                trans3(kk) = 0;
                kk = kk + 1;
            end
        end
    else
        stat3(kk) = fun3(kk);
        trans3(kk) = 0;
        kk = kk + 1;
    end
end



%% figures 

figure
subplot 211
stem(t,trans2,'r'); hold on
stem(t,stat2,'b')
legend('transient','stationary')

subplot 212
stem(t,trans3,'r'); hold on
stem(t,stat3,'b'); hold on
plot(t,ratio3); hold on
line([t(1),t(end)],[trig,trig],'Linestyle',':','Color','r')
legend('transient','stationary')



