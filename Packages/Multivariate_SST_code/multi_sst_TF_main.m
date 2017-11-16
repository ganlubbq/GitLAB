function [Tf,fw,sst_out]=multi_sst_TF_main(x,V,wavelet)

%This code implements a multivariate time-frequency representation based on
%the synchrosqueezing transform, from the paper entitled "Synchrosqueezing-based time-frequency analysis of multivariate data".  

%x :input data
%V :level of the frequency partitions  (typically V=5)
%wavelet :Specify mother wavelet function 0 being morlet and 1 being bump
%wavelets.  Typically  the bump wavelet is used 



%%
        [m,n]=size(x);
        if m<n 
                 x=x';
        end

     [m,n]=size(x);
        %Wavelet applied to multivariate data set     
        for i=1:n             
             [Wx(i,:,:),w(i,:,:),as(i,:,:),dWx(i,:,:)] = cwavelet_transform(x(:,i),32,wavelet); %channel wise wavelet tansform
        end

        %SST operation applied channl-wise. 
        for i=1:n 
            temp(:,:)=Wx(i,:,:);
            tempw(:,:)=w(i,:,:);
            tempas(:,:)=as(i,:,:);           
            [sst_out(i,:,:),fw,Tw]=sst_wavelet_linear(temp,tempw,tempas,32,x(:,i));
            w_channel(i,:,:)=Tw(:,:);  
        end

        
  
  %%  Multvariate Frequency Partitioning Algorithm 
              
        scale=zeros(V,2^V);
        for vs=1:V
            scale(vs,1:(2^vs)+1)=linspace(0,0.5,(2^vs)+1);
        end
        
        %check=zeros(5,32);
        band_f=zeros(V,2^V);
        power_f=zeros(V,2^V);        
        for g=1:V  
            fw_scale=scale(g,1:(2^g)+1);
            [band,power]=multi_bandwidth_check(sst_out,w_channel,fw_scale,x,fw);  %for each scale estimate the multivariate bandwidth 
            band_f(g,1:(2^g))=sqrt(band(1:end)); %estimated multivairate bandwidth
            power_f(g,1:(2^g))=power(1:end);
            clear fw_scale
        end
        
        band_power=zeros(V,2^V);
        for g=1:V           %estimate the bandwidth with power of the signal accounted for. 
            k=(2^g)/2;
        for h=1:k           
             band_power(g,h)=sum((band_f(g,((h-1)*2)+1:(2*h)).*power_f(g,((h-1)*2)+1:(2*h)))/sum(power_f(g,((h-1)*2)+1:(2*h))));
        end
        end
        
        %calculate a binary mask 
 bin_mask=zeros(V,2^V);
        for g=2:V           %estimate the bandwidth with power of the signal accounted for. 
            k=(2^g)/2;
        for h=1:k           
           if band_f(g-1,h)> (band_power(g,h)*1.0) % 
               bin_mask(g,h)=1;   %split the frequency bin
           else
               bin_mask(g,h)=0;
           end
           if (power_f(g,2*k))/(sum(power_f(g,:),2))>0.4  %split the lowest frequency band if power level is higher then the other freqeuncy bands
               if  abs(((band_f(g-1,h)-(band_power(g,h)*1.0))/(band_power(g,h)*1.0))*100)<9
                bin_mask(g,h)=1; 
               end
           end
        end
        end
        for g=2:(V-1)
             k=(2^g)/2;
        for h=1:k
            if bin_mask(g,h)==0
                bin_mask(g+1,((h-1)*2)+1:(2*h))=0;
            end
        end
        end

            scale_temp=zeros(V,2^V);
            scale_temp(1,1:2)=[0.25,0.5];
            
            for g=2:V
                 k=(2^g)/2;
            for h=1:k
                if bin_mask(g,h)==1
                    h1=k+1-h;
                   scale_temp(g,h)=((2*h1)-1)/(2^(g+1));
                end
            end
            end
            
            
            fin_scale=reshape(scale_temp,1,(2^V)*V);
            [fin]=sort(fin_scale,'descend');
            clear scale
            temp1=find(fin>0);
            scale=fin(temp1);
            scale(end+1)=0;     %adaptive scales determined from the multivariate bandwidth

            
     
%% Multivariate time-frequency representation
         
         for i=1:length(scale)
              [s,l]=min(abs(fw-scale(i)));
              fw_scale(i)=l(1);  %partitioning of the scales using the NA-MEMD
         end

         
         inst_freq=zeros(n,length(scale)-1,m);
         inst_amp=zeros(n,length(scale)-1,m);
          for c=1:n %for all the scales calculate the instantneous amplitude and frequency based on the                                                                                         
         sst(:,:)=sst_out(c,:,:);
         w_temp(:,:)=w_channel(c,:,:);
         for j=1:m
         for i=1:length(scale)-1               
             inst_freq(c,i,j)=sum((abs(sst(fw_scale(i+1):fw_scale(i)-1,j)).^2).*w_temp(fw_scale(i+1):fw_scale(i)-1,j))./sum(abs(sst(fw_scale(i+1):fw_scale(i)-1,j)).^2); %channel wise instantaneous freqeuncy          
             inst_amp(c,i,j)=sum(abs(sst(fw_scale(i+1):fw_scale(i)-1,j)).^2);  %instantaneous amplitude 
       
             if isnan(inst_freq(c,i,j))==1
                 inst_freq(c,i,j)=0;
             end     
             if isnan(inst_amp(c,i,j))==1
                  inst_amp(c,i,j)=0;
             end     
         end
         end
         end

        %joint instantaneous frequency and amplitude estimate
         joint_inst_freq=zeros(length(scale)-1,m);
         joint_inst_amp=zeros(length(scale)-1,m);
        for j=1:m
            for i=1:length(scale)-1
            temp_freq(:,:)=inst_freq(:,i,j);    
            temp_amp(:,:)=inst_amp(:,i,j);
            joint_inst_freq(i,j)=sum(temp_amp.*temp_freq)/sum(temp_amp);
            joint_inst_amp(i,j)=sqrt(sum(temp_amp));
            end
        end


        %%%%%Generate time-frequency representations
        N=m;
        freq = 2*pi*linspace(0,0.5,floor(N/2)+1);
        nfreq = length(freq);
        freq=freq/(2*pi);
        df = freq(2)-freq(1);     

        Tf = zeros(nfreq,N);
        dw=joint_inst_freq;
         for j=1:length(scale)-1
            for m=1:N        
                 if dw(j,m)<0          
                 else
                     l = round(dw(j,m)/df+1);
                     if l>0 && l<=nfreq  && isfinite(l) 
                         Tf(l,m)=joint_inst_amp(j,m);     
                     end
                 end
            end
         end    

       
          
 
      
    
 
 
      
