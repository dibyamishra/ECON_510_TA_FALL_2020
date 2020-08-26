%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%  Author - Dibya Deepta Mishra
%  Last Modified - 18 Aug 2020
%% session2.m
close,clear,clc;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

urlwrite("https://www.ssc.wisc.edu/~bhansen/econometrics/cps09mar.txt", "data.txt");
dat=importdata("data.txt");
experience = dat(:,1)-dat(:,4)-6; %assume 6 years of schooling
mbf = (dat(:,11)==2)&(dat(:,12)<=2)&(dat(:,2)==1)&(experience==12);
sam = (dat(:,11)==4)&(dat(:,12)==7)&(dat(:,2)==0);
dat1 = dat(mbf,:);
dat2 = dat(sam,:);
y = log(dat1(:,5)./(dat1(:,6).*dat1(:,7)));
x = [dat1(:,4),ones(length(dat1),1)];
xx = x'*x;
xy = x'*y;
beta = xx\xy

% Second regression
y = log(dat2(:,5)./(dat2(:,6).*dat2(:,7)));
experience = dat2(:,1)-dat2(:,4)-6;
exp2 = (experience.^2)/100;
x = [dat2(:,4),experience,exp2,ones(length(dat2),1)];
xx = x'*x;
xy = x'*y;
beta = xx\xy;display(beta);
% Create leverage and influence
e = y-x*beta;
xxi = inv(xx);
leverage = sum((x.*(x*xxi))')';
d = leverage.*e./(1-leverage);
influence = max(abs(d));
display(influence);


% Now using lmfit
x= [dat2(:,4),experience,exp2];
mdl=fitlm(x,y)
