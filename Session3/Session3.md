## Session 3

__AIM__ *In this session we will try to recreate the illustration 3.7 of the textbook and note some properties of the projection matrix P. We will also try to see the difference between actual computation and numerical computation*

#### Data Preparation
We want to get data for the sub-sample of married (spouse present) Black female wage earners with 12 years potential
work experience. 
```matlab
urlwrite('https://www.ssc.wisc.edu/~bhansen/econometrics/cps09mar.txt', 'data.txt'); 
dat=importdata('data.txt'); 
experience = dat(:,1)-dat(:,4)-6; %assume 6 years of schooling
mbf = (dat(:,11)==2)&(dat(:,12)<=2)&(dat(:,2)==1)&(experience==12); 
dat=dat(mbf,:);
```
Your assignment is to recreate the __Observations Table__ from the illustration including headers. 

#### Getting the value of <img src="https://render.githubusercontent.com/render/math?math=\beta">
```matlab
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
```
We first find the value of XX and then XY and then get the value of <img src="https://render.githubusercontent.com/render/math?math=\beta"> using <img src="https://render.githubusercontent.com/render/math?math=\beta = (X'X)^{-1}X'Y">.

__Reminder__ why do we use the backslash to calculate this.

#### Verify <img src="https://render.githubusercontent.com/render/math?math=(X'e)=0">

```matlab
e=Y-X*beta;
%Show that X'e=0
disp("The value of X'e is")
display(X'*e);
```
#### Now unto the properties of the projection matrix

```matlab
%Properties of the projection matrix
%define P
P=X*inv(XX)*X';
P2=P*P;

disp("The rank of P is")
rank(P)
disp("The eigen values of P are")
eig(P)
```

We can see that the projection matrix has rank 2 and has two eigen values of 1 and 18 eigen values of 0.
Now let us check if it is symmetric and idempotent

```matlab
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
```

__WHAT IS HAPPENING?__
P is not idempotent and symmetric. But everyone seems to think so. What do you think the issue is ?

#### Scientific Computing and Errors
You noticed that when we looked at the value of <img src="https://render.githubusercontent.com/render/math?math=(X'e)"> in MATLAB, it was not exactly zero. Programming languages work on a computer, so they cannot truly do continuous operations. All code that we write is converted to binary and the methods we use are discrete in nature. In short, this means that there is a small error that comes due to this and therefore P might look symmetric and idempotent to the naked eye but it is not. However fear not, we can solve this in a simple manner.

```matlab
P=round(P,2);
P2=round(P2,2);
if issymmetric(P)
    disp("P is symmetric now")
end
if isequal(P2,P)
    disp("P is Idempotent now")
end
```

Rounding off the projection matrix solves our problems but we have another problem now. Somehow rounding off has made the rank of the projection matrix to be 5. 
```matlab
disp("The rank of P is")
rank(P)
```

Can you explain why?
