% IMF Test Suite

t = (1/100:1/100:50) * pi;
% raw_data = sin(1/2*t) + sin(3*t);
raw_data = sin(1*t) + sin(5*t) + sin(13*t);
% raw_data = sin(1*t) + sin(2*t);% + sin(3*t);

data_buffer = Buffer(100,1,5000,'No filter',0);

EMD_Object = EMD(data_buffer);

blocksize = 100;
blocksize = 512; %causes bug!
blocksize = 500;
% Feed data to the buffer x, <blocksize> samples at a time.
% After each block is fed in, call the EMD's update function.
for iter = 1:floor( numel(raw_data) / blocksize )
    new_data_block = raw_data(1+(iter-1)*blocksize:iter*blocksize);
    data_buffer.Update(new_data_block);
    EMD_Object.Update();
end

% Plot the calculated EMD's.
figure (51);
subplot(5,1,1);
plot(raw_data);
set(gca,'XLim',[-100,5000]);
ylabel('Original');

for n = 1:4
    subplot(5,1,n+1);
    plot(EMD_Object.IMFs(n).mode);
    set(gca,...
        'XLim',[-100,5000], ...
        'YLim',[-2.5,2.5]);
    ylabel(sprintf('IMF #%i',n));
end