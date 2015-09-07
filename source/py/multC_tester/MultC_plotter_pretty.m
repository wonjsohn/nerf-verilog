<<<<<<< HEAD
    % clc; clear;
    close all;
=======
     clc; clear;%close all;
>>>>>>> development
%   load('/home/eric/nerf_verilog_eric/projects/balance_limb_pymunk/20130808_174406.mat');  %
% load('/home/eric/nerf_verilog_eric/projects/balance_limb_pymunk/20130808_174627.mat');%
%  load('/home/eric/nerf_verilog_eric/projects/balance_limb_pymunk/20130808_174801.mat');%
% load('/home/eric/nerf_verilog_eric/projects/balance_limb_pymunk/20130808_174912.mat');
%load('/home/eric/nerf_verilog_eric/projects/balance_limb_pymunk/20130808_175015.mat');
<<<<<<< HEAD
% cd /home/eric/nerf_verilog_eric/projects/balance_limb_pymunk_minos
cd /home/eric/nerf_verilog_eric/projects/balance_limb_pymunk_overflow


fname = sprintf('20131028_184722'); 
% 20131009_152401: base line (control) : 63 seconds
% 20131009_153808: HI-GAIN: 4*1=4
% 20131009_153455: TONIC: 2000*1 = 2000: 63 seconds
=======
cd /home/eric/nerf_verilog_eric/projects/balance_limb_pymunk

fname = sprintf('20130827_175923');
>>>>>>> development

load([fname, '.mat']);


<<<<<<< HEAD


%% process EMG
t_ind_flex= data_index_flexor(:,1);
t_ind_ext= data_index_extensor(:,1);
length_ind_flex = data_index_flexor(:,2);
length_ind_ext = data_index_extensor(:,2);
linearV_ind_flex = data_index_flexor(:,3);
linearV_ind_ext = data_index_extensor(:,3);
spikecnt_ind_flex = data_index_flexor(:,4);
spikecnt_ind_ext = data_index_extensor(:,4);
force_ind_flex = data_index_flexor(:,5);
force_ind_ext = data_index_extensor(:,5);
f_emg_ind_flex = data_index_flexor(:,6);
f_emg_ind_ext = data_index_extensor(:,6);
% timeindex_bic = data_index_flexor(:,7);
% timeindex_tri = data_index_extensor(:,7);
% timewave_bic = data_index_flexor(:,8);
% timewave_tri = data_index_extensor(:,8);
% timewaveFromFpga_bic = data_index_flexor(:,9);
% timewaveFromFpga_tri = data_index_extensor(:,9);

% MN1_spikes_bic = data_index_flexor(:,7);
% MN2_spikes_bic = data_index_flexor(:,8);
% MN3_spikes_bic = data_index_flexor(:,9);
% MN4_spikes_bic = data_index_flexor(:,10);
% MN5_spikes_bic = data_index_flexor(:,11);
% MN6_spikes_bic = data_index_flexor(:,12);

t_mid_flex= data_middle_flexor(:,1);
t_mid_ext= data_middle_extensor(:,1);
length_mid_flex = data_middle_flexor(:,2);
length_mid_ext = data_middle_extensor(:,2);
linearV_mid_flex = data_middle_flexor(:,3);
linearV_mid_ext = data_middle_extensor(:,3);
spikecnt_mid_flex = data_middle_flexor(:,4);
spikecnt_mid_ext = data_middle_extensor(:,4);
force_mid_flex = data_middle_flexor(:,5);
force_mid_ext = data_middle_extensor(:,5);
f_emg_mid_flex = data_middle_flexor(:,6);
f_emg_mid_ext = data_middle_extensor(:,6);


n = 3;
start =100;
%start = 1250;
last = min(length(t_ind_flex), 22000); 
% last =635;
% last = min(length(t_ind_flex), 1000); %2050
subplot(n, 1, 1);


[pks,high_locs] = findpeaks(length_ind_flex)
length_ind_flex_inverted = -length_ind_flex;
[~,low_locs] = findpeaks(length_ind_flex_inverted)
=======
%% process EMG
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

n = 3;
start =200;
%start = 1250;
last = min(length(t_bic), 22000); 
% last = min(length(t_bic), 1000); %2050
subplot(n, 1, 1);


[pks,high_locs] = findpeaks(length_bic)
length_bic_inverted = -length_bic;
[~,low_locs] = findpeaks(length_bic_inverted)
>>>>>>> development

%% 


%% EMG processing
<<<<<<< HEAD
Fe=1024; %Samling frequency
Fc_lpf=450.0; % Cut-off frequency
Fc_hpf=0.5;
N=3; % Filter Order
=======
Fe=150; %Samling frequency
Fc_lpf=20.0; % Cut-off frequency
Fc_hpf=1;
N=2; % Filter Order
>>>>>>> development
[B, A] = butter(N,Fc_lpf*2/Fe,'low'); %filter's parameters
[D, C] = butter(N,Fc_hpf*2/Fe,'high'); %filter's parameters

% high pass -> rectify -> low pass
<<<<<<< HEAD
EMG_high_bic=filtfilt(D, C, f_emg_ind_flex); %in the case of Off-line treatment
f_rec_emg_bic = abs(EMG_high_bic);  % rectify
EMG_bic=filtfilt(B, A, f_rec_emg_bic); %in the case of Off-line treatment

EMG_high_tri=filtfilt(D, C, f_emg_ind_ext); %in the case of Off-line treatment
f_rec_emg_tri = abs(EMG_high_tri);  % rectify
EMG_tri=filtfilt(B, A, f_rec_emg_tri); %in the case of Off-line treatment
 
=======
EMG_high_bic=filtfilt(D, C, f_emg_bic); %in the case of Off-line treatment
f_rec_emg_bic = abs(EMG_high_bic);  % rectify
EMG_bic=filtfilt(B, A, f_rec_emg_bic); %in the case of Off-line treatment

EMG_high_tri=filtfilt(D, C, f_emg_tri); %in the case of Off-line treatment
f_rec_emg_tri = abs(EMG_high_tri);  % rectify
EMG_tri=filtfilt(B, A, f_rec_emg_tri); %in the case of Off-line treatment

>>>>>>> development
%%
figure_width  = 8*2;
figure_height = 6*2;
FontSize = 11*1.5;
FontName = 'MyriadPro-Regular';

<<<<<<< HEAD
Fe=33; %Samling frequency
Fc_lpf=1.0; % Cut-off frequency
Fc_hpf=0.5;
N=3; % Filter Ord
[B, A] = butter(N,1.0*2/Fe,'low'); %filter's parameters
length_ind_flex_lpf=filtfilt(B, A, length_ind_flex); %in the case of Off-line treatment

=======
>>>>>>> development
hold on
hfig  = figure(1); 

    set(gcf, 'units', 'centimeters', 'pos', [0 0 figure_width figure_height])
    % set(gcf, 'Units', 'pixels', 'Position', [100 100 500 375]);
    set(gcf, 'PaperPositionMode', 'auto');
    set(gcf, 'Color', [1 1 1]); % Sets figure background
    set(gca, 'Color', [1 1 1]); % Sets axes background
    set(gcf, 'Renderer', 'painters'); 


% axis off;  
<<<<<<< HEAD
hLine1 = line(t_ind_flex(start:last), length_ind_flex_lpf(start:last));
% hdots_high = line(t_ind_flex(high_locs),length_ind_flex(high_locs));
% hdots_low = line(t_ind_flex(low_locs),length_ind_flex(low_locs));
 
set(hLine1                        , ...
  'LineStyle'       , '-'        , ...
  'LineWidth'       , 3           , ... 
  'Color'           , 'black'  );
% set(gca,'YLim',[0.65 1.4])
hYLabel = ylabel('flexor angle');
=======
hLine1 = line(t_bic(start:last), length_bic(start:last));
% hdots_high = line(t_bic(high_locs),length_bic(high_locs));
% hdots_low = line(t_bic(low_locs),length_bic(low_locs));
 
set(hLine1                        , ...
  'LineStyle'       , '-'        , ...
  'LineWidth'       , 2           , ... 
  'Color'           , [0.75 0 1]  );
set(gca,'YLim',[0.85 1.4])
hYLabel = ylabel('flexor length');
>>>>>>> development

% hTitle  = title ('extra cortical drive scale: 7 ');
% hTitle  = title ('flexor muscle length. High Trascortical reflex gain: 3 ');

subplot (n,1, 2);
<<<<<<< HEAD
hLine2 = line(t_ind_flex(start:last), f_emg_ind_flex(start:last));
set(hLine2                        , ...
  'LineStyle'       , '-'         , ...
  'LineWidth'       , 1           , ...   
  'Color'           , 'black'  );
set(gca,'YLim',[-6.5 6.5])
% axis off;


subplot (n,1, 3);
hLine3 = line(t_ind_flex(start:last), force_ind_flex(start:last));
set(hLine3                        , ...
  'LineStyle'       , '-'         , ...
  'LineWidth'       , 3           , ...   
  'Color'           , 'black'  );
=======
hLine2 = line(t_bic(start:last), f_emg_bic(start:last));
set(hLine2                        , ...
  'LineStyle'       , '-'         , ...
  'LineWidth'       , 0.2           , ...   
  'Color'           , [0 0 0.75]  );
axis off;


subplot (n,1, 3);
hLine3 = line(t_bic(start:last), force_bic(start:last));
set(hLine3                        , ...
  'LineStyle'       , '-'         , ...
  'LineWidth'       , 2           , ...   
  'Color'           , [0.5 0 0.5]  );
>>>>>>> development
% set(gca,'YLim',[0 200])
% axis off;

hXLabel = xlabel('time (s)');
hYLabel = ylabel('flexor force');

% subplot (n,1, 4);
<<<<<<< HEAD
% hLine4 = line(t_ind_flex(start:last), timeindex_bic(start:last));
% set(hLine4                        , ...
%   'LineStyle'       , '-'         , ...
%   'LineWidth'       , 3           , ...   
%   'Color'           , 'black'  );
% % set(gca,'YLim',[0 200])
% % axis off;
% 
% hXLabel = xlabel('time (s)');
% hYLabel = ylabel('time index ');
% 
% subplot (n,1, 5);
% hLine4 = line(t_ind_flex(start:last), timewave_bic(start:last));
% set(hLine4                        , ...
%   'LineStyle'       , '-'         , ...
%   'LineWidth'       , 3           , ...   
%   'Color'           , 'black'  );
% % set(gca,'YLim',[0 200])
% % axis off;
% 
% hXLabel = xlabel('time (s)');
% hYLabel = ylabel('timewavex ');

% subplot (n,1, 4);
% hLine4 = line(t_ind_flex(start:last), timewaveFromFpga_bic(start:last));
% set(hLine4                        , ...
%   'LineStyle'       , '-'         , ...
%   'LineWidth'       , 3           , ...   
%   'Color'           , 'black'  );
% % set(gca,'YLim',[0 200])
% % axis off;
% 
% hXLabel = xlabel('time (s)');
% hYLabel = ylabel('timewaveFromFpga ');

%% graphical user input
[x_onset, y_onset]=ginput(1);

onset_ind = find(t_ind_flex >= x_onset, 1, 'first');
start  = onset_ind - 800;
last = start + 3200;

t_cut= t_ind_flex(start:last);
length_cut = length_ind_flex(start:last);
EMG_cut = EMG_bic(start:last);
timewaveFromFpga_cut = timewaveFromFpga_bic(start:last);
% total_spike_count_sync_cut = total_spike_count_sync(start:last);


hfig2 = figure(2);
n=3;
subplot(n, 1, 1);

plot(t_cut, length_cut, 'LineWidth',2, 'color', 'black');    
%     [pks, locs] = findpeaks(length_ind_flex_cut);

axis off

subplot(n, 1, 2); 
plot(t_cut, EMG_cut, 'LineWidth',2, 'color', 'black');
axis off

subplot(n, 1, 3); 
plot(t_cut, timewaveFromFpga_cut, 'LineWidth',2, 'color', 'black');
axis off

cd /home/eric/wonjoon_codes/matlab_wjsohn/latencyAnalysis
% [pathstr,fname,ext] = fileparts(fname) 
% [pathstr,second_recent_name,ext] = fileparts(second_recent_file) 

save(['CUT_', fname], 't_cut', 'length_cut', 'EMG_cut', 'timewaveFromFpga_cut');





% subplot (n,1, 4);
% 
% extraCN = transpose(ones(1, length(t_ind_flex)));
% extraCN(1600:last) = 7;
% hLine4 = line(t_ind_flex(start:last), extraCN(start:last));
=======
% 
% extraCN = transpose(ones(1, length(t_bic)));
% extraCN(1600:last) = 7;
% hLine4 = line(t_bic(start:last), extraCN(start:last));
>>>>>>> development
% hYLabel  = ylabel('extra drive');
% 
% set(hLine4                        , ...
%   'LineStyle'       , '-'         , ...
%   'LineWidth'       , 2           , ...   
%   'Color'           , [.1 .4 .4]  );
% set(gca,'YLim',[0 10])

% % %% velocity
% subplot (n,1, 4);
<<<<<<< HEAD
% hLine8 = line(t_ind_flex(start:last), vel_bic(start:last));
=======
% hLine8 = line(t_bic(start:last), vel_bic(start:last));
>>>>>>> development
% set(hLine8                        , ...
%   'LineStyle'       , '-'         , ...
%   'LineWidth'       , 2           , ...   
%   'Color'           , [0.5 0 0.5]  );
% % set(gca,'YLim',[0 200])
% axis off;
% 
% hXLabel = xlabel('time (s)');
% hYLabel = ylabel('vel');



%%
hfig2  = figure(2); 
<<<<<<< HEAD
last = min(length(t_ind_ext), 22000) 
% last = 635

=======
last = min(length(t_tri), 22000) 
>>>>>>> development
set(gcf, 'units', 'centimeters', 'pos', [0 0 figure_width figure_height])
    % set(gcf, 'Units', 'pixels', 'Position', [100 100 500 375]);
    set(gcf, 'PaperPositionMode', 'auto');
    set(gcf, 'Color', [1 1 1]); % Sets figure background
    set(gca, 'Color', [1 1 1]); % Sets axes background
    set(gcf, 'Renderer', 'painters'); 

<<<<<<< HEAD
    
[B, A] = butter(N,1.0*2/Fe,'low'); %filter's parameters
length_ind_ext_lpf=filtfilt(B, A, length_ind_ext); %in the case of Off-line treatment

subplot(n, 1, 1);
hLine4 = line(t_ind_ext(start:last), length_ind_ext_lpf(start:last));
set(hLine4                        , ...
  'LineStyle'       , '-'        , ...
  'LineWidth'       , 3           , ... 
  'Color'           , 'black'  );
% set(gca,'YLim',[0.55 1.1])
% set(gca,'YLim',[0.65 1.4])

hYLabel = ylabel('Extensor angle');

subplot (n,1, 2);
hLine5 = line(t_ind_ext(start:last), abs(f_emg_ind_ext(start:last)));
set(hLine5                        , ...
  'LineStyle'       , '-'         , ...
  'LineWidth'       , 1           , ...   
  'Color'           , 'black'  );
% axis off;
set(gca,'YLim',[-1.5 2.5])

subplot (n,1, 3);
hLine6 = line(t_ind_ext(start:last), force_ind_ext(start:last));
set(hLine6                        , ...
  'LineStyle'       , '-'         , ...
  'LineWidth'       , 3           , ...   
  'Color'           , 'black');
% axis off;
=======
subplot(n, 1, 1);
hLine4 = line(t_tri(start:last), length_tri(start:last));
set(hLine4                        , ...
  'LineStyle'       , '-'        , ...
  'LineWidth'       , 2           , ... 
  'Color'           , [0.75 0 0]  );
% set(gca,'YLim',[0.55 1.1])
set(gca,'YLim',[0.65 1.2])
hYLabel = ylabel('Extensor length');

subplot (n,1, 2);
hLine5 = line(t_tri(start:last), f_emg_tri(start:last));
set(hLine5                        , ...
  'LineStyle'       , '-'         , ...
  'LineWidth'       , 0.2           , ...   
  'Color'           , [0 0 0.75]  );
axis off;

subplot (n,1, 3);
hLine6 = line(t_tri(start:last), force_tri(start:last));
set(hLine6                        , ...
  'LineStyle'       , '-'         , ...
  'LineWidth'       , 2           , ...   
  'Color'           , [0.5 0 0.5]  );
% set(gca,'YLim',[0 200])
axis off;
>>>>>>> development

hXLabel = xlabel('time (s)');
hYLabel = ylabel('Extensor force');


<<<<<<< HEAD
%% graphical user input




% subplot (n,1, 4);
% 
% extraCN = transpose(ones(1, length(t_ind_ext)));
% extraCN(1600:last) = 7;
% hLine4 = line(t_ind_ext(start:last), extraCN(start:last));
=======
% subplot (n,1, 4);
% 
% extraCN = transpose(ones(1, length(t_tri)));
% extraCN(1600:last) = 7;
% hLine4 = line(t_tri(start:last), extraCN(start:last));
>>>>>>> development
% hYLabel  = ylabel('extra drive');
% 
% set(hLine4                        , ...
%   'LineStyle'       , '-'         , ...
%   'LineWidth'       , 2           , ...   
%   'Color'           , [.1 .4 .4]  );
% set(gca,'YLim',[0 10])
% 
% 



% 
% %% vel 
% subplot (n,1, 4);
<<<<<<< HEAD
% hLine9 = line(t_ind_ext(start:last), vel_tri(start:last));
=======
% hLine9 = line(t_tri(start:last), vel_tri(start:last));
>>>>>>> development
% set(hLine9                        , ...
%   'LineStyle'       , '-'         , ...
%   'LineWidth'       , 2           , ...   
%   'Color'           , [0.5 0 0.5]  );
% % set(gca,'YLim',[0 200])
% % axis off;
% 
% hXLabel = xlabel('time (s)');
% hYLabel = ylabel('vel');


% % 
% hLegend = legend( ...
%   [hdots, hLine1, hLine2, hLine3], ...
%   'Data' , ...
%   'Model'    , ...  
%   'Fit'      , ...
%   'Validation Data'       , ...  
%   'location', 'Best' );
 
  %'Data (\mu \pm \sigma)' , ...
  %'Model (\it{C x^3})'    , ...  
  %'Fit (\it{C x^3})'      , ...
  

%% save figure
%print(hfig, '-dpng', (['figure' num2str(date),  datestr(now, '  HH:MM:SS')]);
% 
% fname = sprintf('myfile%d.mat', i);
<<<<<<< HEAD
print(hfig, '-deps', [fname, '_perturb_bic']);
print(hfig2, '-deps', [fname, '_perturb_tri']);

% -dpng 

% %% Raster plot
% MN1_spikeindex=[]; 
% MN2_spikeindex=[];
% MN3_spikeindex=[];
% MN4_spikeindex=[];
% MN5_spikeindex=[];
% MN6_spikeindex=[];
% 
% binaryMN1 = dec2bin(MN1_spikes_bic);
% binaryMN2 = dec2bin(MN2_spikes_bic);
% binaryMN3 = dec2bin(MN3_spikes_bic);
% binaryMN4 = dec2bin(MN4_spikes_bic);
% binaryMN5 = dec2bin(MN5_spikes_bic);
% binaryMN6 = dec2bin(MN6_spikes_bic);
% [r,c] = size(binaryMN1);  % 761, 32
% 
% 
% numofrow = 32;
% for i=1:r*numofrow,  % get two rows for each MN
%     if binaryMN1(i) =='1'
%         MN1_spikeindex = [MN1_spikeindex i]; 
%     end
%     if binaryMN2(i) =='1'
%         MN2_spikeindex = [MN2_spikeindex i]; 
%     end
%     if binaryMN3(i) =='1'
%         MN3_spikeindex = [MN3_spikeindex i]; 
%     end
%     if binaryMN4(i) =='1'
%         MN4_spikeindex = [MN4_spikeindex i]; 
%     end
%     if binaryMN5(i) =='1'
%         MN5_spikeindex = [MN5_spikeindex i]; 
%     end
% %     if binaryMN6(i) =='1'
% %         MN6_spikeindex = [MN6_spikeindex i]; 
% %     end
%     
% end
% 
% 
% allMN_raster = [MN1_spikeindex (r*numofrow*1)+MN2_spikeindex (r*numofrow*2)+MN3_spikeindex (r*numofrow*3)+MN4_spikeindex (r*numofrow*4)+MN5_spikeindex ];% (r*numofrow*5)+MN6_spikeindex];
% 
% 
% rasterplot(allMN_raster, numofrow*5, r);axis off    






=======
print(hfig, '-dpng', [fname, '_perturb_bic']);
print(hfig2, '-dpng', [fname, '_perturb_tri']);

%-dpng 
>>>>>>> development


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % n=6;
% % 
% % subplot(n, 1, 1);
<<<<<<< HEAD
% % t= data_index_flexor(:,1);
% % plot(t, data_index_flexor(:,2), 'LineWidth',2);
=======
% % t= data_bic(:,1);
% % plot(t, data_bic(:,2), 'LineWidth',2);
>>>>>>> development
% % ylim([0.7 1.3])
% % legend('biceps length');
% % % grid on
% % 
% % subplot(n, 1, 2);
<<<<<<< HEAD
% % plot( t, f_emg_ind_flex);
=======
% % plot( t, f_emg_bic);
>>>>>>> development
% % legend('full wave rect biceps emg');
% % % grid on
% % %ylim([-0.5 3.5]);
% % 
% % subplot(n, 1, 3);
<<<<<<< HEAD
% % plot(t, force_ind_flex, 'r', 'LineWidth',2);
=======
% % plot(t, force_bic, 'r', 'LineWidth',2);
>>>>>>> development
% % legend('force bicpes');
% % % grid on
% % 
% % 
% % subplot(n, 1, 4);
<<<<<<< HEAD
% % t= data_index_extensor(:,1);
% % plot(t, data_index_extensor(:,2),'LineWidth',2);
=======
% % t= data_tri(:,1);
% % plot(t, data_tri(:,2),'LineWidth',2);
>>>>>>> development
% % legend('triceps length');
% % ylim([0.7 1.3])
% % % grid on
% % 
% % subplot(n, 1, 5);
<<<<<<< HEAD
% % plot(t, f_emg_ind_ext);
=======
% % plot(t, f_emg_tri);
>>>>>>> development
% % legend('full wave rect triceps emg');
% % % grid on
% % %ylim([-0.5 3.5]);
% % % ylim([0 40])
% % 
% % 
% % subplot(n, 1, 6);
<<<<<<< HEAD
% % plot(t, force_ind_ext, 'r', 'LineWidth',2);
=======
% % plot(t, force_tri, 'r', 'LineWidth',2);
>>>>>>> development
% % legend('force triceps');
% % % grid on


% % % ylim([-2000 4000])
% % % subplot(3, 1, 3);
% % % endtime = 2600; 
<<<<<<< HEAD
% % % plot(t(1:endtime),  data_index_flexor(1:endtime,5)-data_index_extensor(1:endtime,5));
=======
% % % plot(t(1:endtime),  data_bic(1:endtime,5)-data_tri(1:endtime,5));
>>>>>>> development
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
<<<<<<< HEAD
% plot(t(1:100), f_emg_ind_flex(1:100));
=======
% plot(t(1:100), f_emg_bic(1:100));
>>>>>>> development
% figure
% 
% d=fdesign.highpass('N,Fc',5, 1,400);
% %designmethods(d)
% Hd = design(d);
% % fvtool(Hd);
% % d=design(h,'equiripple'); %Lowpass FIR filter
<<<<<<< HEAD
% %y=filtfilt(Hd,f_emg_ind_flex ); %zero-phase filtering
% y1=filter(Hd,f_emg_ind_flex); %conventional filtering
=======
% %y=filtfilt(Hd,f_emg_bic ); %zero-phase filtering
% y1=filter(Hd,f_emg_bic); %conventional filtering
>>>>>>> development
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

<<<<<<< HEAD
% y=filtfilt(d.Numerator,1, f_emg_ind_flex); %zero-phase filtering
% y1=filter(d.Numerator,1, f_emg_ind_flex); %conventional filtering
=======
% y=filtfilt(d.Numerator,1, f_emg_bic); %zero-phase filtering
% y1=filter(d.Numerator,1, f_emg_bic); %conventional filtering
>>>>>>> development


