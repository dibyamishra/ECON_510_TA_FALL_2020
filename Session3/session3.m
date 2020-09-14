%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%  Author - Dibya Deepta Mishra
%  Last Modified - 14 Sep 2020
%% session3.m
close,clear,clc;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
urlwrite('https://www.ssc.wisc.edu/~bhansen/econometrics/cps09mar.txt', 'data.txt'); 
dat=importdata('data.txt'); 
experience = dat(:,1)-dat(:,4)-6; %assume 6 years of schooling
mbf = (dat(:,11)==2)&(dat(:,12)<=2)&(dat(:,2)==1)&(experience==12); 
%married black female with 12 yrs exp
dat=dat(mbf,:);
%%
earnings=dat(:, 5);     % extract earnings
hours=dat(:, 6);        % extract hours
week=dat(:, 7);         % extract week
wage=earnings./(hours.*week);     % defining Y=earnings/(hoursxweek)
Y=log(wage);
educ=dat(:, 4);         % extract education
X=[educ,ones(length(dat),1),];   %creating X - years of education and an intercept
XX=X'*X                % QXX
XY=X'*Y               % QXY
beta=XX\XY;            %beta
display(beta); 
%%
e=Y-X*beta;
%Show that X'e=0
disp("The value of X'e is")
display(X'*e);
%%
%Properties of the projection matrix
%define P
P=X*inv(XX)*X';
P2=P*P;

disp("The rank of P is")
rank(P)
disp("The eigen values of P are")
eig(P)
%%
%Symmetric and Idempotent
if issymmetric(P)
    disp("Symmetric")
else
    disp("P is not symmetric")
end
if isequal(P2,P)
    disp("Idempotent")
else
    disp("P is not idempotent")
end


%%
P=round(P,2);
P2=round(P2,2);
if issymmetric(P)
    disp("P is symmetric now")
end
    
if isequal(P2,P)
    disp("P is Idempotent now")
end
%%
disp("The rank of P is")
rank(P)


