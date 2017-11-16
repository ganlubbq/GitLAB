function  [band,power,x_scale]=multi_bandwidth_check(sst_out,w_channel,scale,x,fw);

[m,n]=size(x);

scale=fliplr(scale);
 for i=1:length(scale)
          [s,l]=min(abs(fw-scale(i)));
          fw_scale(i)=l(1);  %partitioning of the scales using the NA-MEMD
     end


for c=1:n %for all the channels  calculate the instantneous amplitude and frequency based on the                                                                                         
     sst(:,:)=sst_out(c,:,:);  %c channel index
     w_temp(:,:)=w_channel(c,:,:);
     for j=1:m   %m time index
     for i=1:length(scale)-1   
         count=fw_scale(i);
         x_scale(c,i,j)=real(sum(sst(fw_scale(i+1):fw_scale(i)-1,j),1));  %sum of the SST coefficients in each scale.        
     end
     end
end
     
%estimate the bandwidth in each frequency scale, for all the channels. 
    for i=1:length(scale)-1
        x1(:,:)=x_scale(:,i,:);
         [band(i),power(i)]=multi_bandwidth(x1');
         
    end
    