%dae.m compare different equalization methods

%FIR channel impulse response vector
cs=input('select channel: enter 0, 1, or 2 = ');
if cs<0.5
  rawtp=[1 .9 .81 .73 .64 .55 .46 .37 .28].';
elseif cs<1.5
  rawtp=[1 1 1 0.2 -0.4 2 -1].';
else
  rawtp=[-0.2 .1 .3 1 1.2 .4 -.3 -.2 .3 .1 -.1].';
end
tpars=rawtp/(rawtp'*rawtp);

chdim=length(tpars);

%select FIR equalizer dimension
n=input('enter largest equalizer delay (try 32)= ');

%maximum delay candidate > ch dim + eq dim);
alph=chdim+n+1;

%select training sequence length
p=input('enter training sequence length (try 4000) = ');

%set up time vector
time=[1:p];

%set up white, zero-mean, BPSK source
s=sign(rand(size(time))-.5);
st=s';

%make Toeplitz input matrix for channel
toprowc=fliplr(s(1:chdim));
lcolc=s(chdim:p).';
Ach=toeplitz(lcolc,toprowc);

%create received signal r(chdim) to r(p)
rsig=Ach*tpars;
%NOTE: rsig (and r and d) index j to time index i via j=i-chdim+1 !!!
%NOTE: To use this r in forming Rbar alph-n needs to be > chdim !!!
sg=input('enter sinusoidal interferer gain (try 0.1) = ');
om=input('enter sinusoidal interferer frequency (try 1.4) = ');
ng=input('enter uniform channel noise -/+ max magnitude (try 0.02) =');
d=zeros(size(rsig));
for i=1:length(rsig),
  d(i,1)=sg*sin(om*(i-1))+ng*2*(rand-0.5);
end
r=(rsig+d)';

%compose Sbar
toprowsbar=fliplr(s(1:alph+1));
lcolsbar=s(alph+1:p);
Sbar=toeplitz(lcolsbar,toprowsbar);

%compose Rbar
toprowrbar=fliplr(r(alph-chdim-n+2:alph-chdim+2));
lcolrbar=r(alph-chdim+2:p-chdim+1);
Rbar=toeplitz(lcolrbar,toprowrbar);

%check (Rbar^T)(Rbar) invertibility
cond_number=max(eig(Rbar.'*Rbar))/min(eig(Rbar.'*Rbar))

%compute Fbarast
Fbarast=(inv((Rbar.')*Rbar))*Rbar.'*Sbar;

%compute Phi
Phi= Sbar.'*(Sbar-Rbar*Fbarast);

%determine minimum achievable average cost and locate optimum delay
[phidmin,phidminloc]=min(diag(Phi));
Jmin=phidmin/(p-alph)
delt=phidminloc-1

%extract optimum equalizer
fopt=Fbarast(:,phidminloc);

%channel-equalizer combination impulse response
combo=conv(fopt,tpars);
[yo,yoyo]=max(abs(combo));
deltchk=yoyo-1;

%create optimum equalizer output
y=Rbar*fopt;
figure(1)
subplot(2,2,1)
plot([1:length(r)],r,'.')
title('received signal')
subplot(2,2,2)
plot([1:length(y)],y,'.')
title('optimal equalizer output')
subplot(2,2,3)
plot([0:length(combo)-1],combo,'o')
title('combined chan and opt eq imp resp')
subplot(2,2,4)
plot([1:length(y)],sign(y).'-s(alph-delt+1:p-delt),'.')
title('decision device recovery error')
percent_dec_errs=100*sum(abs(sign(y).'-s(alph-delt+1:p-delt)))/length(y)
figure(2)
subplot(2,2,1)
axis equal
axis square
zplane(roots(tpars),[])
set(findobj(gcf, '-property', 'markersize'), 'markersize', 8)
title('fir channel zeros')
subplot(2,2,3)
axis equal
axis square
zplane(roots(combo),[])
set(findobj(gcf, '-property', 'markersize'), 'markersize', 8)
title('chan-optimum eq combo zeros')
ww=[0:pi/100:pi];
[frtp]=freqz(tpars,1,ww);
[frfo]=freqz(fopt,1,ww);
[frco]=freqz(combo,1,ww);
subplot(2,2,2)
axis normal
plot(ww,20*log10(abs(frtp)),'.',ww,20*log10(abs(frfo)),'--',...
  ww,20*log10(abs(frco)),'-')
title('Freq Resp Magnitude')  %chan: dot, eq: dash, combo:solid
ylabel('db')
xlabel('radians')
subplot(2,2,4)
plot(ww,unwrap(angle(frtp)),'.',ww,unwrap(angle(frfo)),'--',...
  ww,unwrap(angle(frco)),'-')
title('Freq Resp Phase')  %chan: dot, eq: dash, combo:solid
ylabel('radians')
xlabel('radians')

adapt=input('enter 0 to stop or 1 to solve recursively = ');
if adapt >0.5
  algch=input('select algorithm: 0 - LMS, 1 - DD LMS, 2 - CMA =  ');
  
  mu=input('enter stepsize (try 0.01) = ');
  itno=p-length(tpars)-length(fopt);
  
  %adaptive equalizer simulation loop
  thet=zeros(n+1,itno);
  sspe=zeros(1,itno);
  e=zeros(size(st));
  strt=1+max(delt,length(tpars))+n;
  df=input('enter initial eq disp factor about optimal soln (try 0.5) = ');
  thet(:,strt)=fopt-df*2*(rand(size(thet(:,strt)))-0.5*ones(size(thet(:,strt))));
  sspe(strt)=(fopt-thet(:,strt))'*(fopt-thet(:,strt));
  yeq=zeros(size(st));
  for i=strt:itno-1,
    yeq(i)=thet(:,i)'*flipud(r(i-n-chdim+1:i-chdim+1)');
    e(i)=st(i-delt,1)-yeq(i);
    if algch < 0.5
      thet(:,i+1)=thet(:,i)+mu*e(i)*flipud(r(i-n-chdim+1:i-chdim+1)');  %LMS
    elseif algch < 1.5
      thet(:,i+1)=thet(:,i)+mu*(sign(yeq(i))-yeq(i))...
        *flipud(r(i-n-chdim+1:i-chdim+1)');  %DD LMS
    else
      thet(:,i+1)=thet(:,i)+mu*yeq(i)*(1-yeq(i)*yeq(i))...
        *flipud(r(i-n-chdim+1:i-chdim+1)');  %CMA
    end
    sspe(i+1)=(fopt-thet(:,i+1))'*(fopt-thet(:,i+1));
  end
  
  %plot summed squared parameter errors
  figure(3)
  subplot(2,2,1)
  axis('normal')
  semilogy([1:itno-strt+1],sspe(strt:itno),'.')
  xlabel('iterations')
  ylabel('summed squared parameter error')
  
  %plot squared prediction errors
  subplot(2,2,2)
  axis('normal')
  plot([1:itno-strt],e(strt:itno-1).*e(strt:itno-1),'.')
  xlabel('iterations')
  ylabel('squared prediction error')
  
  %plot equalizer output
  subplot(2,2,3)
  axis('normal')
  plot([1:itno-strt],yeq(strt:itno-1),'.')
  xlabel('iterations')
  ylabel('adaptive equalizer output')
  
  %plot combined channel and last adapted equalizer frequency response
  subplot(2,2,4)
  axis('normal')
  ww=[0:pi/100:pi];
  [fras]=freqz(conv(tpars,thet(:,itno)),1,ww);
  plot(ww,20*log10(abs(fras)),'.', ww,20*log10(abs(frco)),'-')
  title('Combo Freq Resp Magnitude')  %adap: dot, opt:solid
  ylabel('db')
  xlabel('radians')
end

