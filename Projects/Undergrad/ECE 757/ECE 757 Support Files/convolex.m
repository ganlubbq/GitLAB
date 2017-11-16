% convolex.m: example of numerical convolution
Ts=1/100; time=10;        % sampling interval and total time
t=0:Ts:time;              % create time vector
h=exp(-t);                % define impulse response
x=zeros(size(t));         % input = sum of two delta functions
x(1/Ts)=3; x(3/Ts)=2;     % at times t=1 and t=3
y=conv(h,x);              % do convolution
subplot(3,1,1), plot(t,x) % and plot
subplot(3,1,2), plot(t,h)
subplot(3,1,3), plot(t,y(1:length(t)))

% actual commands used to draw figure:
subplot(3,1,1), plot(t,x)
ylabel('input')
subplot(3,1,2), plot(t,h)
ylabel('impulse response')
subplot(3,1,3), plot(t,y(1:length(t)))
ylabel('output')
xlabel('time in seconds')

