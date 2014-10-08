
clear; clc; close all;
%      clc; clear;close all;
%   load('/home/eric/nerf_verilog_eric/projects/balance_limb_pymunk/20130808_174406.mat');  %
% load('/home/eric/nerf_verilog_eric/projects/balance_limb_pymunk/20130808_174627.mat');%
%  load('/home/eric/nerf_verilog_eric/projects/balance_limb_pymunk/20130808_174801.mat');%
% load('/home/eric/nerf_verilog_eric/projects/balance_limb_pymunk/20130808_174912.mat');
%load('/home/eric/nerf_verilog_eric/projects/balance_limb_pymunk/20130808_175015.mat');
cd /home/eric/nerf_verilog_eric/projects/balance_limb_pymunk

fpgadata = '20140918_144334';

% data_list = {'20140526_143633','20140526_144419','20140526_145205','20140526_145951','20140526_150737','20140526_151523','20140526_152309'};
%     data_list = {'20140526_143806','20140526_144552','20140526_145338','20140526_150124','20140526_150910','20140526_151656','20140526_152442'};
%     data_list = {'20140526_143940','20140526_144726','20140526_145511','20140526_150257','20140526_151043','20140526_151829','20140526_152615'};
%     data_list = {'20140526_144113','20140526_144859','20140526_145645','20140526_150431','20140526_151217','20140526_152003','20140526_152749'};
%     data_list = {'20140526_144246','20140526_145032','20140526_145818','20140526_150604','20140526_151350','20140526_152136','20140526_152922'};


cursor_info = sprintf('cursor_info_20130920_150701');  % scaler 20130829_114414
load([cursor_info, '.mat']); 

for k = 1:2
  %% process EMG

  if k==1
      fname1 = sprintf('20130920_150701');  % Baseline
      load([fname1, '.mat']); 
  elseif (k==2)
      fname2 = sprintf(fpgadata);   % pathologic
      load([fname2, '.mat']);
  end
 % figure 4a: 20130824_174839,    20130824_174958  (DC-UP),  
  % figure 4b:  20130824_182344        20130824_182555 (HI_GAIN)
  
  % figure 4a: 20130824_174839,    20130824_174958  (DC-UP),  
  % figure 4b:  20130824_182344        20130824_182555 (HI_GAIN)
  
  % scaler 20130829_114414  (bigger gain? , cut)  |    % scaler 20130829_105922   (smaller gain?, offset)
  %  20130920_150701 : trial5 (DC-UP) - no input, phase: 44  (BASE)   
  %  20130920_173643 : trial5 (DC-UP) i_extra_CN1: 2000,  scaler:1  phase : 42, offset: 30
  %  20130920_151800 : trial5 (DC-UP) i_extra_CN1: 2000,  scaler:2  phase : 58, offset:-150
  %  20130920_174306 : trial5 (DC-UP) i_extra_CN1: 2000,  scaler:3  phase : 45, offset: -160
  %  20130920_172651 : trial5 (DC-UP) i_extra_CN1: 2000,  scaler:4  phase : 46, offset:-10

  %  20130920_175321 : trial4 (HI-GAIN) scaler:1  phase: 51   offset: -160
  %  20130920_175642 : trial4 (HI-GAIN) scaler:2  phase: 48   offset: -160
  %  20130920_175933 : trial4 (HI-GAIN) scaler:3  phase: 55   offset: -220 
  %  20130920_180341 : trial4 (HI-GAIN) scaler:4  phase: 60   offset: -220
  %  20130920_180714 : trial4 (HI-GAIN) scaler:5  phase: 67    offset: -70
  
  %  New BASE: 20130920_150701 (scaler:0) = 20130930_152814  (phase diff between angle and EMG : 44)
  %  20130930_153601 (HI-GAIN)  extraCN gain=4, offset: -150  , phase: 44
  %  20130930_154009 (HI-GAIN)  extraCN gain=10, offset: -160  , phase: 56 (velocity gain:0)
  %  20130930_174800 (HI-GAIN)  extraCN gain=4*2=8, offset:-160  phase:60  (velocity gain:0)
  %  20130930_175045 (HI-GAIN)  extraCN gain=4*3=12, offset:-160  , phase: 60 (velocity gain:0)
  %  20130930_175333 (HI-GAIN)  extraCN gain=4*4=16, offset:  -210 , phase:58 (velocity gain:0)
  %  20130930_175818 (HI-GAIN)  extraCN gain=4*5=20, offset: -250 , phase: 57
  
  
 % 20130930_184619 (HI-GAIN)  extraCN gain=4*1=4, offset: -70, phase:48? (velocity gain:30) - good data   base force level: ~ 5500
 % 20131001_180836 HI-GAIN)  extraCN gain=4*1=4, offset: -330, phase:47 (velocity gain:30) - good data (re)
 % 20131001_181851 HI-GAIN)  extraCN gain=4*1=4, offset: -270, phase:46 (velocity gain:30) - good data (re)
 % 20131001_182225 (HI-GAIN)  extraCN gain=4*1=4, offset: -210, phase:46 (velocity gain:30) - good data (re)


 % 20130930_185035 (HI-GAIN)  extraCN gain=4*2=8, offset: -100, phase:54? (velocity gain:30) - good data
 % 20131001_173404  (HI-GAIN)  extraCN gain=4*2=8, offset: -220, phase:59 (velocity gain:30) - good data (re)
 % 20131001_174120  (HI-GAIN)  extraCN gain=4*2=8, offset: -160, phase:55 (velocity gain:30) - good data (re)
 % 20131001_175052  (HI-GAIN)  extraCN gain=4*2=8, offset: -250, phase:58 (velocity gain:30) - good data (re)
 
 % 20130930_185425 (HI-GAIN)  extraCN gain=4*3=12, offset: -170, phase:58 (velocity gain:30) - good data
 % 20131001_171534 (HI-GAIN)  extraCN gain=4*3=12, offset: -140, phase:61 (velocity gain:30) - good data (re)
 % 20131001_171827 (HI-GAIN)  extraCN gain=4*3=12, offset: -160, phase:58 (velocity gain:30) - good data (re)
 % 20131001_173028 (HI-GAIN)  extraCN gain=4*3=12, offset: -170, phase:57 (velocity gain:30) - good data (re)
 
 % 20130930_185747 (HI-GAIN)   extraCN gain=4*4=16, offset: -70, phase:59 (velocity gain:30) - good data
 % 20131001_175348 (HI-GAIN)  extraCN gain=4*4=16, offset: -180, phase:58 (velocity gain:30) - good data (re)
 % 20131001_175726 (HI-GAIN)  extraCN gain=4*4=16, offset: -180, phase:64 (velocity gain:30) - good data (re)
 % 20131001_180234 (HI-GAIN)  extraCN gain=4*4=16, offset: -250, phase:62 (velocity gain:30) - good data (re)
 % 
 
 
 % 20130930_190104(HI-GAIN)  extraCN gain=4*5=20, offset: -30, phase:54 (velocity gain:30) - good data
 % 20131001_182653 (HI-GAIN)  extraCN gain=4*5=20, offset: -210, phase:57 (velocity gain:30) - good data
 % 20131001_182917 (HI-GAIN)  extraCN gain=4*5=20, offset: -210, phase:54 (velocity gain:30) - good data
 % 20131001_184446 HI-GAIN)  extraCN gain=4*5=20, offset: -160, phase:55 (velocity gain:30) - good data
 
 % 20130930_190346(HI-GAIN)  extraCN gain=4*6=24, offset: -210, phase:60 (velocity gain:30) - good data
 % 20131001_184714 (HI-GAIN)  extraCN gain=4*6=24, offset: -200, phase:60 (velocity gain:30) - good data
 % 20131001_185459 (HI-GAIN)  extraCN gain=4*6=24, offset: -300, phase:58 (velocity gain:30) - good data
 % 20131001_185835 (HI-GAIN)  extraCN gain=4*6=24, offset: -250, phase:60 (velocity gain:30) - good data
 
 % 20130930_190733(HI-GAIN)  extraCN gain=4*7=28, offset: -250, phase:62 (velocity gain:30) - good data
 % 20131001_190542 (HI-GAIN)  extraCN gain=4*7=28, offset: -250, phase:68 (velocity gain:30) - good data
 % 20131001_191541 (HI-GAIN)  extraCN gain=4*7=28, offset: 150, phase:65 (velocity gain:30) - good data
 % 20131001_191914 HI-GAIN)  extraCN gain=4*7=28, offset: -100, phase:67 (velocity gain:30) - good data
 
 % 20130930_191115(HI-GAIN)  extraCN gain=4*8=32, offset: -200, phase:74 (velocity gain:30) - ok data
 % 20131001_192308 (HI-GAIN)  extraCN gain=4*8=32, offset: -200, phase:67 (velocity gain:30) - ok data
 % 20131001_192615 (HI-GAIN)  extraCN gain=4*8=32, offset: -220, phase:72 (velocity gain:30) - ok data
 % 20131001_192844  (HI-GAIN)  extraCN gain=4*8=32, offset: -220, phase:73 (velocity gain:30) - ok data
 
 
 % 20130930_181214   (HI-GAIN)  extraCN gain=8*1=8 ,offset: -180 phase 57    (vel gain = 30.0)
 %  20130930_180219 (HI-GAIN)  extraCN gain=4*8=32, offset: -250, phase:83
 % 20130930_182233 (HI-GAIN)  extraCN gain=4*8=32, offset: -200, phase:80 (velocity gain:30)
 % 20130930_182642(HI-GAIN)  extraCN gain=8*4=32, offset: -200, phase:78 (velocity gain:30)
 % 20130930_182925 (HI-GAIN)  extraCN gain=8*5=40, offset: -200, phase:78 (velocity gain:30)
 % 20130930_181623 (HI-GAIN)  extraCN gain=8*6=48, offset: -230, phase:56 (velocity gain:30)
 % 20130930_183236 (HI-GAIN)  extraCN gain=8*6=48, offset: 20, phase:53 (velocity gain:30)
 % 20130930_183749 (HI-GAIN)  extraCN gain=8*7=56, offset: -200, phase:18 (velocity gain:30)  (could be meaning less, not really phasic b/c EMG  too randomly noisy)
 % 20130930_184141(HI-GAIN)  extraCN gain=8*8=64, offset: -200, phase:20 (velocity gain:30)

 %% special tweaking 
 % length = 1.1
 % change Ia gain
 
% 20130930_192457 extraCN gain=4*1=4, offset: -200, phase:46! (velocity gain:30) - good data Ia gain in spindle = 1.0 (normally 1.5) base forcelevel ~1800
 % 20131001_105703 extraCN gain=4*1=4, offset: -120, phase:47 (velocity gain:30) - good data Ia gain in spindle = 1.6 (normally 1.5) base forcelevel ~5600
 %20131001_110206 extraCN gain=4*1=4, offset: -220, phase: 58! (velocity gain:30) - good data Ia gain in spindle = 1.8 (normally 1.5) - base force level ~6800
 %20131001_133310 extraCN gain=4*1=4, offset: -150, phase: 60! (velocity gain:30) - good data Ia gain in spindle = 2.05 (normally 1.5) - base force level ~8400
 %20131001_143740 extraCN gain=4*1=4, offset: -170, phase: 60! (velocity gain:30) - good data Ia gain in spindle = 2.05 (normally 1.5) - base force level ~8400
 %20131001_144019 extraCN gain=4*1=4, offset: -220, phase: 57! (velocity gain:30) - good data Ia gain in spindle = 2.05 (normally 1.5) - base force level ~8400
 %20131001_144334 extraCN gain=4*1=4, offset: -220, phase: 58! (velocity gain:30) - good data Ia gain in spindle = 2.05 (normally 1.5) - base force level ~8400
 
 %20131001_110822 extraCN gain=4*1=4, offset: -220, phase: 60! (velocity gain:30) - good data Ia gain in spindle = 2.1 (normally 1.5) - base force level ~9700
% 20131001_140112 extraCN gain=4*1=4, offset: -150, phase: 57! (velocity gain:30) - good data Ia gain in spindle = 2.1 (normally 1.5) - base force level ~9700
%20131001_140446 extraCN gain=4*1=4, offset: -230, phase: 56! (velocity gain:30) - good data Ia gain in spindle = 2.1 (normally 1.5) - base force level ~9700
%20131001_140817 extraCN gain=4*1=s4, offset: -230, phase: 55! (velocity gain:30) - good data Ia gain in spindle = 2.1 (normally 1.5) - base force level ~9700
 % 20131001_111319 extraCN gain=4*1=4, offset: -220, phase: 70! (velocity gain:30) - good data Ia gain in spindle = 2.5 (normally 1.5) - base force level ~10200
 %20131001_142047 extraCN gain=4*1=4, offset: -200, phase: 70! (velocity gain:30) - good data Ia gain in spindle = 2.5 (normally 1.5) - base force level ~10200
 %20131001_142354 extraCN gain=4*1=4, offset: -230, phase: 71! (velocity gain:30) - good data Ia gain in spindle = 2.5 (normally 1.5) - base force level ~10200
 % 20131001_142837 extraCN gain=4*1=4, offset: -190, phase: 76! (velocity gain:30) - good data Ia gain in spindle = 2.5 (normally 1.5) - base force level ~10200
 %20131001_143208 extraCN gain=4*1=4, offset: -230, phase: 69! (velocity gain:30) - good data Ia gain in spindle = 2.5 (normally 1.5) - base force level ~10200
 
 %20130930_192102  extraCN gain=4*1=4, offset: -200, phase:74! (velocity gain:30) - good data Ia gain in spindle = 2.5 (normally 1.5) base forcelevel ?
 %20131001_111706 extraCN gain=4*1=4, offset: -220, phase: 73! (velocity gain:30) - good data Ia gain in spindle = 2.6 (normally 1.5) - base force level ~12400
 
 % change II gain
 % 20131001_112333 extraCN gain=4*1=4, offset: -250, phase:55 (velocity gain:30) -Ia:1.5, IIgain:0.6 (normally 0.5) base forcelevel: 6200 
 % 20131001_112716 extraCN gain=4*1=4, offset: -210, phase:50 (velocity gain:30) -Ia:1.5, IIgain:0.9 (normally 0.5) base force level: 7000 
 % 20131001_113101 extraCN gain=4*1=4, offset: -210, phase:53 (velocity gain:30) -Ia:1.5, IIgain:1.1 (normally 0.5) base force level: 7700 
 % 20131001_113500 extraCN gain=4*1=4, offset: -200, phase:58 (velocity gain:30) -Ia:1.5, IIgain:1.3 (normally 0.5) base force level: 8300 
 %20131001_113816 extraCN gain=4*1=4, offset: -210, phase:51 (velocity gain:30) -Ia:1.5, IIgain:1.5 (normally 0.5) base force level: 11000
% 20131001_114215 extraCN gain=4*1=4, offset: -200, phase:55 (velocity gain:30) -Ia:1.5, IIgain:1.8 (normally 0.5) base force level: 12400


n = 3;
start =500;
%start = 1250;
last = 12800;
% last = 1800
offset =-420; %150; %480;

t_bic= data_bic(:,1);
t_tri= data_tri(:,1);
length_bic = data_bic(:,2);
length_tri = data_tri(:,2);
vel_bic = data_bic(:,3);
vel_tri = data_tri(:,3);
f_emg_bic = data_bic(:,6);
f_emg_tri = data_tri(:,6);
force_bic = data_bic(:,5);
force_tri = data_tri(:,5);
    
if (k == 1)
    t_bic_cut= t_bic(start:last);
    t_tri_cut= t_tri(start:last);
    length_bic_cut = length_bic(start:last);
    length_tri_cut = length_tri(start:last);
    f_emg_bic_cut = f_emg_bic(start:last);
    f_emg_tri_cut = f_emg_tri(start:last);
    force_bic_cut = force_bic(start:last);
    force_tri_cut = force_tri(start:last);

else
    start = start + offset;
    last = last + offset;
%     t_bic_cut= t_bic(start:last);
%     t_tri_cut= t_tri(start:last);
    length_bic_offset = length_bic(start:last);
    length_tri_offset = length_tri(start:last);
    f_emg_bic_offset = f_emg_bic(start:last);
    f_emg_tri_offset = f_emg_tri(start:last);
    force_bic_offset = force_bic(start:last);
    force_tri_offset = force_tri(start:last);
end


% last = min(length(t_bic), 1000); %2050


[pks,high_locs] = findpeaks(length_bic)
length_bic_inverted = -length_bic;
[~,low_locs] = findpeaks(length_bic_inverted)



%% EMG processing
% Fe=33; %Samling frequency
Fe = 145;
Fc_lpf=2.0; % Cut-off frequency
Fc_hpf=1.0;
N=3; % Filter Order
[B, A] = butter(N,Fc_lpf*2/Fe,'low'); %filter's parameters
[D, C] = butter(N,Fc_hpf*2/Fe,'high'); %filter's parameters

% high pass -> rectify -> low pass
EMG_high_bic_cut=filtfilt(D, C, f_emg_bic_cut); %in the case of Off-line treatment
f_rec_emg_bic_cut = abs(EMG_high_bic_cut);  % rectify
EMG_bic_cut=filtfilt(B, A, f_rec_emg_bic_cut); %in the case of Off-line treatment

EMG_high_tri_cut=filtfilt(D, C, f_emg_tri_cut); %in the case of Off-line treatment
f_rec_emg_tri_cut = abs(EMG_high_tri_cut);  % rectify
EMG_tri_cut=filtfilt(B, A, f_rec_emg_tri_cut); %in the case of Off-line treatment
% 
% figure;
% [z,p,k] = butter(N,Fc_lpf*2/Fe,'low');
% % [z,p,k]= butter(N,Fc_hpf*2/Fe,'high')
% [sos,g] = zp2sos(z,p,k);      % Convert to SOS form
% Hd = dfilt.df2tsos(sos,g);   % Create a dfilt object
% h = fvtool(Hd);              % Plot magnitude response
% set(h,'Analysis','freq')      % Display frequency response 


%%% off set data
if (k ==2) 
    EMG_high_bic_offset=filtfilt(D, C, f_emg_bic_offset); %in the case of Off-line treatment
    f_rec_emg_bic_offset = abs(EMG_high_bic_offset);  % rectify
    EMG_bic_offset=filtfilt(B, A, f_rec_emg_bic_offset); %in the case of Off-line treatment

    EMG_high_tri_offset=filtfilt(D, C, f_emg_tri_offset); %in the case of Off-line treatment
    f_rec_emg_tri_offset = abs(EMG_high_tri_offset);  % rectify
    EMG_tri_offset=filtfilt(B, A, f_rec_emg_tri_offset); %in the case of Off-line treatment
end



hfig = figure(1);
n=3;
subplot(n, 1, 1);


if (k == 2)
    plot(t_bic_cut, length_bic_offset,'--', 'LineWidth',2, 'color', 'black');
else
     plot(t_bic_cut, length_bic_cut, 'LineWidth',2, 'color', 'black');    
%     [pks, locs] = findpeaks(length_bic_cut);
%     hold on
    % showing the peaks (manually acquired)  
    xCursor=zeros(length(cursor_info_0920), 1);
    yCursor=zeros(length(cursor_info_0920), 1);
%      cursor_offset = 0.8;
    for i = 1:length(cursor_info_0920)
        hold on
        xCursor(i)=cursor_info_0920(1, i).Position(1);
        yCursor(i)=cursor_info_0920(1, i).Position(2); 
         
        plot(xCursor(i),yCursor(i), 'r+');
    end
end
ylim([0.7 1.4])
% legend('biceps length');
% grid on
% axis off
hold on
grid on
% 
subplot(n, 1, 2);
if (k == 2)
    plot(t_bic_cut, EMG_bic_offset, '--', 'LineWidth',2, 'color', 'black');
else     
     plot(t_bic_cut, EMG_bic_cut, '-', 'LineWidth',2,'color', 'black');
end
% legend('full wave rect biceps emg');
% grid on
% ylim([-0.5 3.5]);
% axis off
hold on
grid on

subplot(n, 1, 3);
if (k == 2)
    plot(t_bic_cut, force_bic_offset, '--', 'LineWidth',3, 'color', 'black');
else
    plot(t_bic_cut, force_bic_cut, 'LineWidth',2, 'color', 'black');
end
 % legend('force bicpes');
% grid on
% axis off
hold on
grid on

%%
hfig2 = figure(2);
n=3;
subplot(n, 1, 1);

if (k == 2)
    plot(t_tri_cut,  length_tri_offset, '--', 'LineWidth',2, 'color', 'black');
else
    plot(t_tri_cut, length_tri_cut, 'LineWidth',2, 'color', 'black');
end
    % legend('triceps length');
ylim([0.7 1.3])
% grid on
axis off
hold on
grid on
% 
subplot(n, 1, 2);
if (k == 2)
    plot(t_tri_cut, EMG_tri_offset, '-', 'LineWidth',3, 'color', 'black');
else    
    plot(t_tri_cut, EMG_tri_cut, 'color', 'black');
end
% legend('full wave rect triceps emg');
% grid on
%ylim([-0.5 3.5]);
% ylim([0 40])
axis off
hold on
grid on
subplot(n, 1, 3);
if (k == 2)
    plot(t_tri_cut, force_tri_offset, '-', 'LineWidth',3, 'color', 'black');
else 
    plot(t_tri_cut, force_tri_cut, 'LineWidth',2, 'color', 'black');
end
% legend('force triceps');
% grid on
axis off
grid on
hold on
title('trial5, CN simple general, 20130824__174839/ 20130824__174958'); 
end


%%  

  


%% save figure
%print(hfig, '-dpng', (['figure' num2str(date),  datestr(now, '  HH:MM:SS')]);
% 
% fname = sprintf('myfile%d.mat', i);

print(hfig, '-dpng', [fname1, '_bic']);
print(hfig2, '-dpng', [fname1, '_tri']);

%-dpng 


%% statistical analysis



% % xcorr demo
% %
% % The signals
% figure;
% t = [0:127]*0.02;
% f = 1.0;
% s1 = sin(2*pi*f*t);
% s2 = sin(2*pi*f*(t-0.35)); % s1 lags s2 by 0.35s
% subplot(2,1,1);
% plot(t,s1,'r',t,s2,'b');
% grid
% title('signals')
% %
% % Now cross-correlate the two signals
% %
% x = xcorr(s1,s2,'coeff');
% tx = [-127:127]*0.02;
% subplot(2,1,2)
% plot(tx,x)
% grid
% %
% % Determine the lag
% %
% figure;
% [mx,ix] = max(x);
% lag = tx(ix);
% hold on
% tm = [lag,lag];
% mm = [-1,1];
% plot(tm,mm,'k')
% hold off

%%
% figure;
% a = fft(length_bic_cut);
% b = fft(length_bic_offset);
% 
% 
% plot(abs(angle(a) - angle(b)));
% averagePA=mean(abs(angle(a) - angle(b))); 
% averagePA = averagePA/3.141592*360
% 
% 
% figure;
% [c, lags] = xcorr(length_bic_cut, length_bic_offset, 'coeff');
% subplot(4, 1, 1);
% plot(t_bic_cut, length_bic_cut, 'b', t_bic_cut, length_bic_offset, 'r');
% % xc = [2.0395:0.0067/2:85];
% subplot(4, 1, 2);
% 
% [mx, ix]= max(c)
% t_bic_cut(ix)
% plot(c);
% 
% subplot(4, 1, 3);
% plot(lags);
% 
% subplot(4, 1, 4);
% stem(lags, c);



%%  interpolation

figure;
% subplot(3, 1, 1);
% plot(t_bic_cut, length_bic_cut);
% y = sin(2.3*t_bic_cut);
% subplot(3, 1, 1);
% plot(t_bic_cut,y);
% subplot(3, 1, 1);
% 
% xx = 2:0.0067:85; 
% xx_pre = transpose(xx);
% xx = xx_pre(1:length(t_bic_cut));
% 
% 
% yy = spline(xCursor, yCursor, xx);
% plot(xx, yy);

% yy=spline(t_bic_cut, , x);    % cubic spline interpolation
% plot(ppval(cs, xx));

a = unique(xCursor);

t_step=200;

%%  for cut data
t_interp = [];
len_interp = [];
EMG_interp = [];
for i = 1:length(cursor_info_0920)-1   % get rid of last cursor
    ind_temp =  find(t_bic_cut == a(i));
%     ind = [ind ind_temp];
    if i == 1
        t_interp_temp = 2:(a(i)-2)/(t_step-1):a(i);
        len_interp_temp=interp1(t_bic_cut(1:ind_temp),length_bic_cut(1:ind_temp),t_interp_temp);
        EMG_interp_temp=interp1(t_bic_cut(1:ind_temp),EMG_bic_cut(1:ind_temp),t_interp_temp);
    else
        t_interp_temp = a(i-1):(a(i)-a(i-1))/(t_step-1):a(i);
        ind = find(t_bic_cut == a(i))
        ind_prev = find(t_bic_cut == a(i-1))
        len_interp_temp=interp1(t_bic_cut(ind_prev+1:ind_temp),length_bic_cut(ind_prev+1:ind_temp),t_interp_temp);
        EMG_interp_temp=interp1(t_bic_cut(ind_prev+1:ind_temp),EMG_bic_cut(ind_prev+1:ind_temp),t_interp_temp);
    end  
    
    t_interp = [t_interp t_interp_temp];
    len_interp = [len_interp len_interp_temp];
    EMG_interp=[EMG_interp EMG_interp_temp];
end

%%  for offset data
t_interp_offset = [];
len_interp_offset = [];
EMG_interp_offset = [];
for i = 1:length(cursor_info_0920)-1 % get rid of last cursor
    ind_temp =  find(t_bic_cut == a(i));
%     ind = [ind ind_temp];
    if i == 1
        t_interp_temp = 2:(a(i)-2)/(t_step-1):a(i);
        len_interp_temp=interp1(t_bic_cut(1:ind_temp),length_bic_offset(1:ind_temp),t_interp_temp);
        EMG_interp_temp=interp1(t_bic_cut(1:ind_temp),EMG_bic_offset(1:ind_temp),t_interp_temp);
    else
        t_interp_temp = a(i-1):(a(i)-a(i-1))/(t_step-1):a(i);
        ind = find(t_bic_cut == a(i))
        ind_prev = find(t_bic_cut == a(i-1))
        len_interp_temp=interp1(t_bic_cut(ind_prev+1:ind_temp),length_bic_offset(ind_prev+1:ind_temp),t_interp_temp);
        EMG_interp_temp=interp1(t_bic_cut(ind_prev+1:ind_temp),EMG_bic_offset(ind_prev+1:ind_temp),t_interp_temp);
    end  
    
    t_interp_offset = [t_interp_offset t_interp_temp];
    len_interp_offset = [len_interp_offset len_interp_temp];
    EMG_interp_offset=[EMG_interp_offset EMG_interp_temp];
end

t_new = linspace(2, 85, 10800);
subplot(4, 1, 1);
plot(t_new, len_interp, 'LineWidth',3, 'color', 'black');
axis off
subplot(4, 1, 2);

% plot(t_new, len_interp, '-',  'LineWidth',1, 'color', 'black');
hold on
plot(t_new, len_interp_offset, 'LineWidth',3, 'color', 'black');
axis off
subplot(4, 1, 3);
plot(t_new, EMG_interp,  'LineWidth',2, 'color', 'black');

ylim([0.0 1.7])
% fill(t_new, EMG_interp, 'g');
subplot(4, 1, 4);
plot(t_new, EMG_interp_offset, 'LineWidth',2, 'color', 'black');

ylim([0.0 1.7])
% axis off




%% correlation analysis

len_interp = len_interp - mean(len_interp(~isnan(len_interp)));   % remove bias
% EMG_interp = EMG_interp - mean(EMG_interp(~isnan(EMG_interp)));   % remove bias

len_interp_offset = len_interp_offset - mean(len_interp_offset(~isnan(len_interp_offset)));   % remove bias
% EMG_interp_offset = EMG_interp_offset - mean(EMG_interp_offset(~isnan(EMG_interp_offset)));   % remove bias


[rho, pval] = corr(transpose(len_interp(~isnan(len_interp))), transpose(EMG_interp(~isnan(EMG_interp))))
 
%  [c, lags] = xcorr(transpose(len_interp(~isnan(len_interp))), transpose(EMG_interp(~isnan(EMG_interp))));

% remove nan
len_interp_nan_removed = len_interp(~isnan(len_interp));
EMG_interp_nan_removed = EMG_interp(~isnan(EMG_interp));
len_interp_offset_nan_removed = len_interp_offset(~isnan(len_interp_offset));
EMG_interp_offset_nan_removed = EMG_interp_offset(~isnan(EMG_interp_offset));

% % test phase change due to wave shift. (dramatic)
% len_interp_nan_removed = len_interp_nan_removed(1:10612-25);
% EMG_interp_nan_removed = EMG_interp_nan_removed(1:10612-25);
% 
% len_interp_offset_nan_removed = len_interp_offset_nan_removed(25:10612);
% EMG_interp_offset_nan_removed = EMG_interp_offset_nan_removed(25:10612);

figure(5);
subplot(211)
plot(len_interp_nan_removed);
subplot(212);
plot(len_interp_offset_nan_removed);

[c, lags] = xcorr(transpose(len_interp_nan_removed), transpose(EMG_interp_nan_removed));
[c_offset, lags_offset] = xcorr(transpose(len_interp_offset_nan_removed), transpose(EMG_interp_offset_nan_removed));

figure;
%  c = c(length(c)/2:end);
 subplot(2,1,1);plot(lags, c);legend('cut');
%  stem(lags, c);
subplot(2,1,2);plot(lags_offset, c_offset,'k');     

%% piecewise cross correlation 


%% Save all variables to mat files

pathname = fileparts('/home/eric/Dropbox/MATLAB/WonJoon_code/DATA_DystoniaPaper/Doornik/Doornik_FPGAfulldata/HigainSweepRawData/');

matfile = fullfile(pathname, fpgadata);
save(matfile);
  



% remove bias

% 
% Fs = 150; % Sampleing frequency
% nfft=1024; % length of FFT
% fft_len= fft(len_interp(~isnan(len_interp)), nfft);
% fft_len = fft_len(1:nfft/2); % FFT is symmetric
% p = unwrap(angle(fft_len));
% f = (0:nfft/2-1)*(Fs/nfft); %/length(fft_len)*100;  % freq vector
% figure;plot(f, p*180/pi); 
% xlabel('Frequency (Hz)')
% ylabel('Phase (Degrees)')


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % n=6;
% % 
% % subplot(n, 1, 1);
% % t= data_bic(:,1);
% % plot(t, data_bic(:,2), 'LineWidth',2);
% % ylim([0.7 1.3])
% % legend('biceps length');
% % % grid on
% % 
% % subplot(n, 1, 2);
% % plot( t, f_emg_bic);
% % legend('full wave rect biceps emg');
% % % grid on
% % %ylim([-0.5 3.5]);
% % 
% % subplot(n, 1, 3);
% % plot(t, force_bic, 'r', 'LineWidth',2);
% % legend('force bicpes');
% % % grid on
% % 
% % 
% % subplot(n, 1, 4);
% % t= data_tri(:,1);
% % plot(t, data_tri(:,2),'LineWidth',2);
% % legend('triceps length');
% % ylim([0.7 1.3])
% % % grid on
% % 
% % subplot(n, 1, 5);
% % plot(t, f_emg_tri);
% % legend('full wave rect triceps emg');
% % % grid on
% % %ylim([-0.5 3.5]);
% % % ylim([0 40])
% % 
% % 
% % subplot(n, 1, 6);
% % plot(t, force_tri, 'r', 'LineWidth',2);
% % legend('force triceps');
% % % grid on


% % % ylim([-2000 4000])
% % % subplot(3, 1, 3);
% % % endtime = 2600; 
% % % plot(t(1:endtime),  data_bic(1:endtime,5)-data_tri(1:endtime,5));
% % % legend('diff in force');
% % % grid on
% % title( ['pymunk setting, IaGain=1.5, IIGain=0.5, extraCN1: 0, CNsynGain=50.0, extraCN2: 15000*sin(t)   ', num2str(date),  datestr(now, '  HH:MM:SS')]);
% % %title( ['pymunk setting, IaGain=1.5, IIGain=1.5, extraCN1:120000, extraCN2: 80000*sin(t) ', num2str(date),  datestr(now, '  HH:MM:SS')]);
% % %title( ['pymunk setting, IaGain=1.5, IIGain=0.5, extraCN1:50000, extraCN2: 40000*sin(t)', num2str(date),  datestr(now, '  HH:MM:SS')]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% filter exploration
% ** Ap — amount of ripple allowed in the pass band in decibels (the default units). Also called Apass.
% ** Ast — attenuation in the stop band in decibels (the default units). Also called Astop.
% ** F3db — cutoff frequency for the point 3 dB point below the passband value. Specified in normalized frequency units.
% ** Fc — cutoff frequency for the point 6 dB point below the passband value. Specified in normalized frequency units.
% ** Fp — frequency at the start of the pass band. Specified in normalized frequency units. Also called Fpass.
% ** Fst — frequency at the end of the stop band. Specified in normalized frequency units. Also called Fstop.
% ** N — filter order.
% 
% 
% plot(t(1:100), f_emg_bic(1:100));
% figure
% 
% d=fdesign.highpass('N,Fc',5, 1,400);
% %designmethods(d)
% Hd = design(d);
% % fvtool(Hd);
% % d=design(h,'equiripple'); %Lowpass FIR filter
% %y=filtfilt(Hd,f_emg_bic ); %zero-phase filtering
% y1=filter(Hd,f_emg_bic); %conventional filtering
% 
% 
% plot(t(1:100), y1(1:100));
% title('Filtered Waveforms');
% figure;
% rect_y1 = abs(y1);
% plot(t(1:100), rect_y1(1:100));
% figure;
%  
% %d=fdesign.lowpass('Fp,Fst,Ap,Ast',0.15,0.25,1,60);
% d=fdesign.lowpass('N,Fc',3, 3, 400);
% designmethods(d)
% Hd = design(d);
% y2=filter(Hd, rect_y1); %conventional filtering
% plot(t(1:100), y2(1:100));
% fvtool(Hd);
% 

% y=filtfilt(d.Numerator,1, f_emg_bic); %zero-phase filtering
% y1=filter(d.Numerator,1, f_emg_bic); %conventional filtering


