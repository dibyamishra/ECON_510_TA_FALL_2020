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
e=Y-X*beta;
```
We first find the value of XX and then XY and then get the value of <img src="https://render.githubusercontent.com/render/math?math=\beta"> using <img src="https://render.githubusercontent.com/render/math?math=\beta (X'X)^{-1}X'Y">. __Reminder__ why do we use the backslash to calculate this.


