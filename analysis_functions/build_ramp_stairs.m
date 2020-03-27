% stim = [ones(1,500)*0   (1:400)/400*0.1+0 ...
%         ones(1,500)*0.1 (1:400)/400*0.1+0.1 ...
%         ones(1,500)*0.2 (1:400)/400*0.1+0.2 ...
%         ones(1,500)*0.3 (1:400)/400*0.1+0.3 ...
%         ones(1,500)*0.4 (1:400)/400*0.1+0.4 ...
%         ones(1,500)*0.5 (1:400)/400*-0.1+0.5 ...
%         ones(1,500)*0.4 (1:400)/400*-0.1+0.4 ...
%         ones(1,500)*0.3 (1:400)/400*-0.1+0.3 ...
%         ones(1,500)*0.2 (1:400)/400*-0.1+0.2 ...
%         ones(1,500)*0.1 (1:400)/400*-0.1+0.1 ...
%         ones(1,500)*0];
%     
% t=(1:length(stim))/1000;

t=0.001:0.001:10;

fmod=0.05; A=sin(2*pi*fmod*t); 
phi=0; 

f=1; om=2*pi*f;

stim = A .* sin(om*t + phi);

plot(t,stim)

return
%% WW1
sr=1000;
t=0.001:0.001:10;
phi=0; 

A1=2; f1=1;   om1=2*pi*f1;
A2=2; f2=1.3; om2=2*pi*f2;

stim = A1 .* sin(om1*t + phi) + A2 .* sin(om2*t + phi);

figure
plot(t,stim)

%% WW2
sr=1000;
t=0.001:0.001:10;
phi=0; 

A1=3; f1=1;   om1=2*pi*f1;
A2=2.5; f2=1.5; om2=2*pi*f2;

stim = A1 .* sin(om1*t + phi) + A2 .* sin(om2*t + phi);

plot(t,stim)

%% WW3
sr=1000;
t=0.001:0.001:8;
dt = 0;

A1=2; f1=1/1;   om1=2*pi*f1;
A2=2; f2=1/0.8; om2=2*pi*f2;

stim = A1 .* sin(om1*(t+dt)) + A2 .* sin(om2*(t+dt));
stim = [zeros(1,1000) stim zeros(1,1000)];
t=0.001:0.001:10;

plot(t,stim)

%% Pseudo1

[x,xi]=pseudogen3(3,[0 1 -1],[1 0 1],200);

stim = xi/(max(xi)-min(xi))*6;
t=(1:length(stim))/sr;

plot(t,stim)