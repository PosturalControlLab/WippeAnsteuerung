% function feedback = Learning_feedback(data)
global n fb

addpath(genpath('C:\Users\PosturalControlLab\Documents\MATLAB\LA_toolbox'))

fo = fit(t',data(:,6),'poly1');

x = data(:,6)-fo.p1*t';

[yo,yoo,f] = getSpec(x',1000);
n=n+1;

fb(1,n) = sum(abs(yo(1:16)));
fb(2,n) = fo.p1;
fb(3,n) = round(fb(1,n)*100) + round(abs(fb(2,n)*1000));
% plot(n,fb_t,'kx'); hold on;

% round((fb(n,4)+fb(n,1))*1000)

figure(50)
subplot(2,2,1)
cla
plot(t,data(:,6),t,fo.p1*t+fo.p2);
ylim([-4 6])

subplot(2,2,2)
cla
plot(f(1:16),abs(yo(1:16)),'x'); hold on
plot_lines([1,1.25],'','r');
ylim([0 0.4])

subplot(2,2,3)
cla
Dr_p = abs(round(fb(2,n)*1000/fb(3,n)*100));
Sw_p = round(fb(1,n)*100/fb(3,n)*100);
if Dr_p > 60
    text(0.1,0.8,['Drift: ' num2str(round(fb(2,n)*1000)) '; ' num2str(Dr_p) '%'], 'Color','r')
else
    text(0.1,0.8,['Drift: ' num2str(round(fb(2,n)*1000)) '; ' num2str(Dr_p) '%'])
end
if Sw_p > 60
    text(0.1,0.6,['Sway: ' num2str(round(fb(1,n)*100)) '; ' num2str(Sw_p) '%'], 'Color','r')
else
    text(0.1,0.6,['Sway: ' num2str(round(fb(1,n)*100)) '; ' num2str(Sw_p) '%'])
end
text(0.1,0.3,['Feedback: ' num2str(fb(3,n))])
title(fname,'Interpreter','None');



subplot(224)
cla
plot(1:n,fb(3,:),'kx'); hold on;
axis([1 75 0 800])

if mod(n,5)==0
    title(['n = ' num2str(n) '; Augen auf'], 'Color', 'r')
elseif mod(n,25)==0
    title(['n = ' num2str(n) '; Pause'],'Color', 'r')
else
    title(['n = ' num2str(n)],'Color', 'k')
end

