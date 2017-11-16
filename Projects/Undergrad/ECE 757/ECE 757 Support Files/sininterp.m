% sininterp.m: demonstrate interpolation/reconstruction using sin
f=20; Ts=1/100; time=20;       % sampling interval and time 
t=Ts:Ts:time;                  % time vector
w=sin(2*pi*f*t);               % w(t) = a sine wave of f Hertz
over=100;                      % # of data points in smoothing 
intfac=10;                     % how many interpolated points 
tnow=10.0/Ts:1/intfac:10.5/Ts; % interpolate from 10 to 10.5 sec
wsmooth=zeros(size(tnow));     % save smoothed data here
for i=1:length(tnow)           % and loop for next point
  wsmooth(i)=interpsinc(w,tnow(i),over);
end                           
plot(Ts*tnow,wsmooth,'b')            % original=red & interpolated=blue
hold on, plot(Ts*tnow,w(round(tnow)),'r')
xlabel('time')
ylabel('amplitude')
hold off
% P=1; beta=0;                       % constants for sinc interpolation
% s=srrc(over,beta,P,tau);           % generate sinc pulse
