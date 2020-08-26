## Session 2

__AIM__ *In this session, we will provide an introduction to MATLAB and try to generate some examples in the textbook.* 

#### Prerequisites
1. Install MATLAB - Rice University has a online repository of available software [here](https://kb.rice.edu/page.php?id=68559) with instructions on how to install. If you have problems installing, feel free to contact me. It is imperative that you have MATLAB installed before the session. 
2. The alternative is using MATLAB online, where you can use your credentials to run MATLAB on the browser without installation. However for the purpose of the course, all troubleshooting will be done for the standalone version. 


#### Hello World 
##### Why use MATLAB?
MATLAB stands for "MATRIX LABARATORY". It is a high level programming language(Essentially means that writing code is very close to writing english). There are many dedicated sets of code (called __toolboxes__) which make coding in MATLAB a pleasant experience. There are dedicated toolboxes for machine learning, econometrics, optimization, statistics etc. There are also innumerable tutorials and lecture notes which are useful to learn MATLAB on your own. Feel free to explore the web. __The truth is out there__. Once you get the hang of the syntax it is pretty straightforward to transfer what you write in math to MATLAB code. 

##### Examples
As a first  example lets aim at solving the following equation <img src="https://render.githubusercontent.com/render/math?math=x^3 - 2x^2 %2B2=0">. Assuming that you have enabled the optimization tool box the following code will find the solution for you. 

```matlab
fun = @(x) x^3+ 2*x^2 - 2 ; %Objective function
ezplot ( fun , [ -10 ,10]) ; % plot for -10<=x<=10 
answer= fzero ( fun , 0)  %Optimize using 0 as an initial guess
```

In case of equations which have multiple solutions changing intital guess will change which solution you get. 

As a second example, lets try another simple optimization exercise. Lets try to minimize the following expression <img src="https://render.githubusercontent.com/render/math?math=f(x)=100(x_2-x_1^2) %2B (1 -x_1)^2"> <img src="https://render.githubusercontent.com/render/math?math=\ s.t \ x_1^2 %2B x_2^2 \leq 1">. This function is the Rosenbrock's function and is used as a standard test function in optimization (Check the MATLAB website). Solving this problem is almost writing things out in English. You can learn more about this problem [here](https://www.mathworks.com/help/optim/ug/solve-nonlinear-optimization-problem-based.html). 

```matlab
x = optimvar('x',1,2); % set the optimization variable
obj = 100*(x(2) - x(1)^2)^2 + (1 - x(1))^2; % set the objective function
prob = optimproblem('Objective',obj); % set up the main problem
nlcons = x(1)^2 + x(2)^2 <= 1; %Set up the constraints
prob.Constraints.circlecons = nlcons; %define the problem with the constraints
show(prob) %print out the problem in english

x0.x = [0 0]; %set initial values
[sol,fval,exitflag,output] = solve(prob,x0) %Solve the problem
```

### ECON 510

Our primary textbook for the course is going to be Econometrics by Bruce Hansen. [This](https://www.ssc.wisc.edu/~bhansen/econometrics/) is a link to the book and the data required for the class. 

### Today's plan

Today we just aim to make sure that everyone has MATLAB installed and can load data and run a basic regression. For starters lets try to run the example just before the exercises on the third chapter of the current edition of the book(Pg 92). We show how to run the regression using the matrix format and then using the command __fitlm__.

#### Basics
Lets start with the basics first. We will learn how to read data from an online txt file or csv file. Then we will try and convert the data to a format which will allow us to run least square on our data. 

__MATLAB Windows__
There are four main windows that you see when you start MATLAB, which are *Current Folder, Editor, Workspace, Command Window*. You can write code directly on the command window or you can create a new script, edit your code on the editor window and run it. We will use the latter method as it allows for reproducibility.

__Load data from Bruce Hansen's website__
We can load data from an url by first by getting data from a url and writing it to a file locally and then reading the file using the required MATLAB code. For example, for a text file we can use.

```matlab
urlwrite("https://www.ssc.wisc.edu/~bhansen/econometrics/cps09mar.txt", "data.txt");
dat=importdata("data.txt");
```
The dat file is a matrix whose columns are the needed datasets.

__Getting columns from the matrix dataset__
First get the description of the data from [here](https://www.ssc.wisc.edu/~bhansen/econometrics/cps09mar_description.pdf). Knowing the description we know that the fourth column of the data consists of education. Lets try and subset this data to get a variable called education.

```matlab
education = dat(:,4); %education is the 4th column
```

__Stack Columns together__
Note that X is a n x k matrix including ones. To convert a column to a matrix you need to stack data together which is pretty simple in MATLAB.
```matlab
X = [ones(size(education,1),1),education]; %create x variable by stacking
Y = log(dat(:,5)./(dat(:,6).*dat(:,7))); % create y by manipulating columns of the data
```

__Get the matrics__
Now we can create the X'X and X'Y matrices to get the coefficient of regression of Y on education.

```matlab
XX=X'*X;
invXX=inv(X'*X); %get the inverse
XY=X'*Y;
```

__Find Beta__
Now its just a matter of simple multiplication to find beta
```matlab
beta=invXX*XY 

%Alternatively
beta= XX\XY
```

__Using fitlm__
Alternatively you can just run a regression of Y on education using *fitlm*
```matlab
fitlm(education,Y)
```

__Comparing both methods__
One can compare how much time it takes for both methods by using *tic* and *toc*. 
```matlab
%Method 1
tic
XX=X'*X;
XY=X'*Y;
beta= XX\XY
toc

%Method 2
tic
XX=X'*X;
invXX=inv(X'*X);
beta=invXX*XY 
toc

%Method3
tic
fitlm(education,Y)
toc
```
__Which method do you think will take less time and why?__
The XX\XY method uses the fact that if you want to solve <img src="https://render.githubusercontent.com/render/math?math=X^TX\beta=X^TY"> for 
<img src="https://render.githubusercontent.com/render/math?math=\beta">, then you can solve it by first taking the __Cholesky decomposition__ of <img src="https://render.githubusercontent.com/render/math?math=X^TX=LDL^*"> and then solving <img src="https://render.githubusercontent.com/render/math?math=L\Gamma=X^TY"> for <img src="https://render.githubusercontent.com/render/math?math=\Gamma"> and then solving <img src="https://render.githubusercontent.com/render/math?math=DL^*\beta=\Gamma"> for <img src="https://render.githubusercontent.com/render/math?math=\beta">. A link to the wikipedia page for Cholesky decomposition can be found [here.](https://en.wikipedia.org/wiki/Cholesky_decomposition) __*Hint: This will help you answer the question.*__

#### Ordinary Least Squares

__For starters lets use a small example using the inbuilt data set in MATLAB.__

We can use the inbuilt function to get the coefficients directly.
```matlab
load carsmall
X = [Weight,Horsepower,Acceleration]; % dont need to add ones in this because fitlm does it automatically.
Y=MPG;
mdl = fitlm(X,MPG);
```

__Now lets recreate the example in the third chapter of our textbook.__

```matlab
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%  Author - Dibya Deepta Mishra
%  Last Modified - 18 Aug 2020
%% session1.m
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
beta = xx\xy % this is another way of saying (inv(xx)) * xy

% Matrix regression
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
```

Run the regression and lets discuss whats the results are.

__Assignment(Optional) - In the example based on the inbuilt dataset on MATLAB, try finding coefficients of regression using beta=(X'*X)\X'*Y;. Does it work? If yes, report the results. If no, then write the code to get the value of the coefficients.__
