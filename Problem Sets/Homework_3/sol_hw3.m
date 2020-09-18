%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%  Author - Dibya Deepta Mishra, Jintao Sun
%  Last Modified - 14 Sep 2020
%% hw3solution.m
close,clear,clc;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
urlwrite('https://www.ssc.wisc.edu/~bhansen/econometrics/cps09mar.txt', 'data.txt'); 
dat=importdata('data.txt'); 
experience = dat(:,1)-dat(:,4)-6; %assume 6 years of schooling
%%
earnings=dat(:, 5);     % extract earnings
hours=dat(:, 6);        % extract hours
week=dat(:, 7);         % extract week
wage=earnings./(hours.*week);     % defining Y=earnings/(hoursxweek)
Y=wage;
educ=dat(:, 4);         % extract education
X=[educ,educ.^2,ones(length(dat),1)];   %creating X - years of education and an intercept
XX=X'*X ;               % QXX
XY=X'*Y ;             % QXY
beta=XX\XY;            %beta
%%
fprintf("Q_XX is ")
XX
fprintf("Q_XY is ")
XY
fprintf('The value of beta is [%3.3f,%3.3f,%3.3f].\n',beta(1),beta(2),beta(3));

%%
e=Y-X*beta;
%Show that X'e=0
disp("The value of X'e almost close to zero")
display(X'*e);
%%
X1=[ones(length(dat),1)]; 
X2=[educ,educ.^2]; 
beta1=(X1'*X1)\(X1'*X2);
e1=X2-X1*beta1;
beta2=(X1'*X1)\(X1'*Y);
e2=Y-X1*beta2;
beta_final=(e1'*e1)\(e1'*e2)
fprintf('The value of beta from normal regression is [%3.3f,%3.3f] and from FWL is [%3.3f,%3.3f].\n',beta(1),beta(2),beta_final(1), beta_final(2));

