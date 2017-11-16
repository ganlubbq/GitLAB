%% Kirsch's CDMA Solution
clear, clc, clf, format compact

L = 16;                         % Create L=16 Walsh Codes

x = 1;
for i = 1:log2(L)
    x = [x x; x -x]
end

user = randi([1 16],2,1); 

N = 10;                         % Create users bit sequences      
disp('User Signals')
s = 2*round(rand(2,N))-1

t = 1:N*L;

% two users with perfect channel
S = s(1,:)' * x(user(1),:) + s(2,:)' * x(user(2),:);

% Plot the perfect received signal
figure(1)
stairs(reshape(S',1,size(S,1)*size(S,2)))

%received signal
r(1,:) = sign((x(user(1),:) * S')/L);
r(2,:) = sign((x(user(2),:) * S')/L);

disp('Decoded signals')
r

% plt the received signal and the decoded signals
figure(2)
stairs(t,reshape(S',1,N*L),'k-')
hold on
stairs(t,reshape((r(1,:)'*ones(1,L))',1,N*L),'r-')
stairs(t,reshape((r(2,:)'*ones(1,L))',1,N*L),'b-')
hold off
legend('Received Signal','User 1 decoded','User 2 decoded')

disp('Errors per use with a perfect channel')
err = sum(s-r,2)

%% Noise addition AWGN

noise = 2;
Sn = S + noise*randn(N,L);

% Received signal
rn(1,:) = sign((x(user(1),:) * Sn')/L);
rn(2,:) = sign((x(user(2),:) * Sn')/L);

disp('Decoded Signals')
rn

% plot the received signal and the decoded signals
figure(3)
plot(t,reshape(Sn',1,N*L),'k-')
hold on
stairs(t,reshape((rn(1,:)'*ones(1,L))',1,N*L),'r-')
stairs(t,reshape((rn(2,:)'*ones(1,L))',1,N*L),'b-')
hold off
legend('Received Signal','User 1 decoded','User 2 decoded')
disp(['Errors per use with a noisy channel, n = ' num2str(noise) ])
errn = sum(s -rn,2)


%% Tau offset with circshift

c = 0;
for i = [1 2 5]
    rs(1+2*c,:) = sign( (circshift(x(user(1),:) ,[1 -i]) * Sn') /L);
    rs(2+2*c,:) = sign( (circshift(x(user(2),:) ,[1 -i]) * Sn') /L);
    c = c+1;
end

disp(['Errors per use with a shift of t = ' num2str(1)])
err - abs(sum(s - rs(1:2,:),2))

disp(['Errors per use with a shift of t = ' num2str(2)])
err = abs(sum(s - rs(3:4,:),2))

disp(['Errors per use with a shift of t = ' num2str(5)])
err = abs(sum(s - rs(5:6,:),2))
