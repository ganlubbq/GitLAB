%% 
clear



%% Synthetic  Test Signal 1
%%Sinusoidal Oscillation 
t=0:1/204:10;
x(1,:)=cos(2*pi*20*t)+randn(1,length(t))*0.5;   %SNR approximately 3dB
x(2,:)=cos(2*pi*20.5*t)+randn(1,length(t))*0.5;



              [Tf,fw]=multi_sst_TF_main(x,5,1);
              imagesc(1:length(Tf),fw*204,abs(Tf))   
              set(gca,'YDir','normal');
               colorbar;
              set(gca,'FontSize',20)
              xlabel('Samples')
              ylabel('Frequency (Hz)')
              ylim([0,0.2]*204);
              xlim([0,length(Tf)]);

              

%% Synthetic  Test Signal 2
 %%FM modulated
t=0:1/204:10;
x(1,:)=cos(2*pi*((t*10)+(3*cos(t))))+randn(1,length(t))*0.5;   %SNR approximately 3dB
x(2,:)=(cos(2*pi*((t*(10+0.1))+(3*cos(t))))+randn(1,length(t))*0.5);



              [Tf,fw]=multi_sst_TF_main(x,5,1);
              imagesc(1:length(Tf),fw,abs(Tf))   
              set(gca,'YDir','normal');
               colorbar;
              set(gca,'FontSize',20)
              xlabel('Samples')
              ylabel('Normalised Frequency')
              ylim([0,0.2]);
              xlim([0,length(Tf)]);

              
 %%  Real World Simulation 1
 
 load float.mat;
               [Tf,fw]=multi_sst_TF_main(x,5,0);
              imagesc(1:length(Tf),fw,abs(Tf))   
              set(gca,'YDir','normal');
               colorbar;
              set(gca,'FontSize',20)
              xlabel('Samples')
              ylabel('Normalised Frequency')
              ylim([0,0.2]);
              xlim([0,length(Tf)]);
%%  Real World Simulation 2

              
load doppler_car.mat;     

     [Tf,fw]=multi_sst_TF_main(x,5,1);
              imagesc(1:length(Tf),fw,abs(Tf))   
              set(gca,'YDir','normal');
               colorbar;
              set(gca,'FontSize',20)
              xlabel('Samples')
              ylabel('Normalised Frequency')
              ylim([0,0.2]);
              xlim([0,length(Tf)]);
              