function [IMFs, res] = Offline_EMD (x)
% t = (1/100:1/100:50) * pi;
% x = sin(1/2*t) + sin(3*t);
% x = sin(1*t) + 1/2 * sin(2*t) + 1/3 * sin(3*t);

NUMBER_OF_IMFS = 5;
xlen = numel(x);

IMFs = zeros(NUMBER_OF_IMFS,xlen);
res = x;
for n = 1:NUMBER_OF_IMFS
    [mode,res] = Extract_Mode (res );
    IMFs(n,:) = mode;
end

figure;
subplot(NUMBER_OF_IMFS+1,1,1);
plot(x);

for n = 1:NUMBER_OF_IMFS
    subplot(NUMBER_OF_IMFS+1,1,n+1);
    plot(IMFs(n,:));
end

end

function [mode, res] = Extract_Mode (x)
NUM_SIFTING_ITERATIONS = 20;
xlen = numel(x);
t_spline = 1:xlen;

d = zeros(NUM_SIFTING_ITERATIONS+1,xlen);
d(1,:) = x;

for n = 1:NUM_SIFTING_ITERATIONS
    [imin, imax, ~] = extr(d(n,:));
    vmin = d(n,imin);
    vmax = d(n,imax);
    
%     env_min = hermite_spline(imin,vmin,t_spline);
%     env_max = hermite_spline(imax,vmax,t_spline);
    env_min = pchip(imin,vmin,t_spline);
    env_max = pchip(imax,vmax,t_spline);
    env_mean = (env_min + env_max) ./ 2;
    d(n+1,:) = d(n,:) - env_mean;
end

mode = d(end,:);
res = x - mode;
end