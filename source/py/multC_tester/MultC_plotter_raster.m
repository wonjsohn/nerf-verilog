    clc; clear;close all;

% load('/home/eric/nerf_verilog_eric/source/py/multC_tester/rack_test_20130815_063450.mat');
% load('/home/eric/nerf_verilog_eric/source/py/multC_tester/rack_CN_general_20130815_063452.mat');
% load('/home/eric/nerf_verilog_eric/source/py/multC_tester/rack_emg_20130815_063455.mat');
cd /home/eric/nerf_verilog_eric/source/py/multC_tester

fname = sprintf('rack_emg_20140319_121658');
fname2 = sprintf('rack_test_20140319_121657');
load([fname, '.mat']);
load([fname2, '.mat']);


%% three boards
[r, c]=size(raster0_31_MN1)
t = 1:1:r;

% mixed_input
% Ia_spindle0
% f_emg
% total_force
% raster0_31_MN1
% fixed_drive_to_CN

% legend('length', 'Ia__spindle', 'spkcnt__Ia', 'spkcnt__II', 'emg__MN', 'RECT__EMG', 'spkcnt__CN', 'spkcnt__total__MNs', 'total__force');
% title( ['threeboards__normal, stretch_from 0.8 to 1.4, syn_SN_Ia_gain: 2.0, syn_SN_II_gain: 1.5, syn_CN_gain:50 ', num2str(date),  datestr(now, '  HH:MM:SS')]);
%
%% process EMG
% t_bic= data_bic(:,1);
% t_tri= data_tri(:,1);
% length_bic = data_bic(:,2);
% length_tri = data_tri(:,2);
% vel_bic = data_bic(:,3);
% vel_tri = data_tri(:,3);
% f_emg_bic = data_bic(:,6);
% f_emg_tri = data_tri(:,6);
% force_bic = data_bic(:,5);
% force_tri = data_tri(:,5);

n = 7;
start =50;
%start = 1250;
last = min(length(t), 40000); 
% last = min(length(t_bic), 1000); %2050
% subplot(n, 1, 1);




%% EMG processing
Fe=150; %Samling frequency
Fc_lpf=20.0; % Cut-off frequency
Fc_hpf=1;
N=2; % Filter Order
[B, A] = butter(N,Fc_lpf*2/Fe,'low'); %filter's parameters
[D, C] = butter(N,Fc_hpf*2/Fe,'high'); %filter's parameters

% high pass -> rectify -> low pass
EMG_high_bic=filtfilt(D, C, f_emg); %in the case of Off-line treatment
f_rec_emg_bic = abs(EMG_high_bic);  % rectify
EMG_bic=filtfilt(B, A, f_rec_emg_bic); %in the case of Off-line treatment

% EMG_high_tri=filtfilt(D, C, f_emg_tri); %in the case of Off-line treatment
% f_rec_emg_tri = abs(EMG_high_tri);  % rectify
% EMG_tri=filtfilt(B, A, f_rec_emg_tri); %in the case of Off-line treatment

%%
figure_width  = 8*2;
figure_height = 6*2;
FontSize = 11*1.5;
FontName = 'MyriadPro-Regular';

hfig  = figure(1); 




%% raster plot
% ax(1) = subplot (n,1,1);
% 
% 
% binaryMN1 = dec2bin(raster0_31_MN1);
% [r,c] = size(binaryMN1);  % 761, 32
% % imagesc((1:c),(1:r),binaryMN1);
% 
% line=0;
% hold on
% plot(0, c);
% plot(last, 0);
% for i=1:c,  % 32
%     for j=1:r, %761
%         if binaryMN1(line*r+j) == '1'
%              plot(j, i, '.');
%         end
%     end
%     line = line + 1;
% end
% axis off
% 
% ax(2) = subplot (n,1,2);
% binaryMN2 = dec2bin(raster0_31_MN2);
% [r,c] = size(binaryMN2);  % 761, 32
% % imagesc((1:c),(1:r),binaryMN1);
% 
% line=0;
% hold on
% plot(0, c);
% plot(last, 0);
% for i=1:c,  % 32
%     for j=1:r, %761
%         if binaryMN2(line*r+j) == '1'
%              plot(j, i, '.');
%         end
%     end
%     line = line + 1;
% end
% axis off
%             
% ax(3) = subplot (n,1,3);
% binaryMN3 = dec2bin(raster0_31_MN3);
% [r,c] = size(binaryMN3);  % 761, 32
% % imagesc((1:c),(1:r),binaryMN1);
% 
% 
% line=0;
% hold on
% plot(0, c);
% plot(last, 0);
% for i=1:c,  % 32
%     for j=1:r, %761
%         if binaryMN3(line*r+j) == '1'
%              plot(j, i, '.');
%         end
%     end
%     line = line + 1;
% end
% axis off
%             
% ax(4) = subplot (n,1,4);
% binaryMN4 = dec2bin(raster0_31_MN4);
% [r,c] = size(binaryMN4);  % 761, 32
% % imagesc((1:c),(1:r),binaryMN1);
% 
% 
% line=0;
% hold on
% plot(0, c);
% plot(last, 0);
% for i=1:c,  % 32
%     for j=1:r, %761
%         if binaryMN4(line*r+j) == '1'
%              plot(j, i, '.');
%         end
%     end
%     line = line + 1;
% end
% axis off    
% 
% ax(5) = subplot (n,1,5);
% binaryMN5 = dec2bin(raster0_31_MN5);
% [r,c] = size(binaryMN5);  % 761, 32
% % imagesc((1:c),(1:r),binaryMN1);
% 
% line=0;
% hold on
% plot(0, c);
% plot(last, 0);
% for i=1:c,  % 32
%     for j=1:r, %761
%         if binaryMN5(line*r+j) == '1'
%              plot(j, i, '.');
%         end
%     end
%     line = line + 1;
% end
% axis off
% 
% ax(6) = subplot (n,1,6);
% binaryMN6 = dec2bin(raster0_31_MN6);
% [r,c] = size(binaryMN6);  % 761, 32
% % imagesc((1:c),(1:r),binaryMN1);
% 
% 
% line=0;
% hold on
% plot(0, c);
% plot(last, 0);
% for i=1:c,  % 32
%     for j=1:r, %761
%         if binaryMN6(line*r+j) == '1'
%              plot(j, i, '.');
%         end
%     end
%     line = line + 1;
% end
%         
% axis off
%    
%             
%
% ax(7) = subplot (n,1,7);
figure; subplot(2, 1, 1);
plot (t,  mixed_input, 'LineWidth',3, 'color', 'black');
%axis([0 700, 0.5 1.6])
axis off    


%% using rasterplot
% 
% a = [];
% 
% for i=1:1,
%     for j = 1:c,
%         a_temp= mod(raster0_31_MN1(i), 2);
%         raster0_31_MN1(i) = bitsra(raster0_31_MN1(i), 1);
%         a = [a a_temp];
%     end    
% end
% a
% 

%% SN spikes

SNIa_spikeindex=[]; 
SNII_spikeindex=[];
binarySNIa = dec2bin(population_neuron0);
binarySNII = dec2bin(population_neuron0_II);

numofrow = 32;
for i=1:last*numofrow,  % get two rows for each MN
    if binarySNIa(i) =='1'
        SNIa_spikeindex = [SNIa_spikeindex i]; 
    end
    if binarySNII(i) =='1'
        SNII_spikeindex = [SNII_spikeindex i]; 
    end
    
end


allSN_raster = [SNIa_spikeindex (last*numofrow*1)+SNII_spikeindex (last*numofrow*2)];

% subplot(2, 1, 1);

hfig2  = figure(2);
rasterplot(allSN_raster, numofrow*2, last);axis off    




%% MN spikes
MN1_spikeindex=[]; 
MN2_spikeindex=[];
MN3_spikeindex=[];
MN4_spikeindex=[];
MN5_spikeindex=[];
MN6_spikeindex=[];

binaryMN1 = dec2bin(raster0_31_MN1);
binaryMN2 = dec2bin(raster0_31_MN2);
binaryMN3 = dec2bin(raster0_31_MN3);
binaryMN4 = dec2bin(raster0_31_MN4);
binaryMN5 = dec2bin(raster0_31_MN5);
binaryMN6 = dec2bin(raster0_31_MN6);
[r,c] = size(binaryMN1);  % 761, 32


numofrow = 10;
for i=1:last*numofrow,  % get two rows for each MN
    if binaryMN1(i) =='1'
        MN1_spikeindex = [MN1_spikeindex i]; 
    end
    if binaryMN2(i) =='1'
        MN2_spikeindex = [MN2_spikeindex i]; 
    end
    if binaryMN3(i) =='1'
        MN3_spikeindex = [MN3_spikeindex i]; 
    end
    if binaryMN4(i) =='1'
        MN4_spikeindex = [MN4_spikeindex i]; 
    end
    if binaryMN5(i) =='1'
        MN5_spikeindex = [MN5_spikeindex i]; 
    end
    if binaryMN6(i) =='1'
        MN6_spikeindex = [MN6_spikeindex i]; 
    end
    
end


allMN_raster = [MN1_spikeindex (last*numofrow*1)+MN2_spikeindex (last*numofrow*2)+MN3_spikeindex (last*numofrow*3)+MN4_spikeindex (last*numofrow*4)+MN5_spikeindex (last*numofrow*5)+MN6_spikeindex];


% subplot(2, 1, 2);

rasterplot(allMN_raster, numofrow*6, last);axis off    





% axis off
% 
% set(hLine5                        , ...
%   'LineStyle'       , '.'         , ...
%   'LineWidth'       , 0.2           , ...   
%   'Color'           , 'black'  );
% % set(gca,'YLim',[0 200])
% % axis off;
% 
% hXLabel = xlabel('time (s)');
% hYLabel = ylabel('raster MN1');

%%
% hfig2  = figure(2); 
% last = min(length(t_tri), 22000) 
% set(gcf, 'units', 'centimeters', 'pos', [0 0 figure_width figure_height])
%     % set(gcf, 'Units', 'pixels', 'Position', [100 100 500 375]);
%     set(gcf, 'PaperPositionMode', 'auto');
%     set(gcf, 'Color', [1 1 1]); % Sets figure background
%     set(gca, 'Color', [1 1 1]); % Sets axes background
%     set(gcf, 'Renderer', 'painters'); 
% 
% subplot(n, 1, 1);
% hLine4 = line(t_tri(start:last), length_tri(start:last));
% set(hLine4                        , ...
%   'LineStyle'       , '-'        , ...
%   'LineWidth'       , 2           , ... 
%   'Color'           , [0.75 0 0]  );
% % set(gca,'YLim',[0.55 1.1])
% set(gca,'YLim',[0.65 1.2])
% hYLabel = ylabel('Extensor length');
% 
% subplot (n,1, 2);
% hLine5 = line(t_tri(start:last), f_emg_tri(start:last));
% set(hLine5                        , ...
%   'LineStyle'       , '-'         , ...
%   'LineWidth'       , 0.2           , ...   
%   'Color'           , [0 0 0.75]  );
% axis off;
% 
% subplot (n,1, 3);
% hLine6 = line(t_tri(start:last), force_tri(start:last));
% set(hLine6                        , ...
%   'LineStyle'       , '-'         , ...
%   'LineWidth'       , 2           , ...   
%   'Color'           , [0.5 0 0.5]  );
% % set(gca,'YLim',[0 200])
% % axis off;
% 
% hXLabel = xlabel('time (s)');
% hYLabel = ylabel('Extensor force');
% 
% 
% % subplot (n,1, 4);
% % 
% % extraCN = transpose(ones(1, length(t_tri)));
% % extraCN(1600:last) = 7;
% % hLine4 = line(t_tri(start:last), extraCN(start:last));
% % hYLabel  = ylabel('extra drive');
% % 
% % set(hLine4                        , ...
% %   'LineStyle'       , '-'         , ...
% %   'LineWidth'       , 2           , ...   
% %   'Color'           , [.1 .4 .4]  );
% % set(gca,'YLim',[0 10])
% % 
% % 
% 
% 
% 
% 
% %% vel 
% subplot (n,1, 4);
% hLine9 = line(t_tri(start:last), vel_tri(start:last));
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
print(hfig2, '-dpng', [fname, '_raster']);
% print(hfig2, '-dpng', [fname, '_perturb_tri']);

%-dpng 


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


