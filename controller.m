%% Initialization
clear all ; close all; clc
k= 24; dt= 0.01;
b = 8;m = 25;
%% TRAINING ON _ OFF CONTROLLER
% Loading Data / We start by first loading the dataset. 
% Load Training Data of step input
fprintf('Loading controller Data ...\n')
load('controller_on_off');
load('controller_input');
% prepairing Data
controller_error = controller_input.data;
controller_on_off = [controller_on_off.time , controller_on_off.data];
time = controller_on_off(:,1);
force = controller_on_off(:,2);
acceleration = controller_on_off(:,3);
velocity = controller_on_off(:,4);
possiotion = controller_on_off(:,5);
%inputs
controller_error(1) = []; 
force_input = force ;force_output = force;
force_input (end) = [];
force_output (1) = []; 
X = [controller_error , force_input];
%outputs
y = force_output;
fprintf('Training on_off controller to network ...\n')
pause;
%% training
%   X - input data.
%   y - target data.

x = X';
t = y';

% 'trainlm' is usually fastest.
% 'trainbr' takes longer but may be better for challenging problems.
% 'trainscg' uses less memory. Suitable in low memory situations.
% 'traingd' gradient descent
trainFcn = 'trainlm';  % Levenberg-Marquardt backpropagation.
% Create a Fitting Network
hiddenLayerSize = 6;
net = fitnet(hiddenLayerSize,trainFcn);
net = configure(net, x, t);
rng(0);
%% net.layers{i}.transferFcn = 'tansig';
%% seeting net training parameters
net.trainParam.epochs = 1000;	%Maximum number of epochs to train
net.trainParam.goal = 0;	%Performance goal
net.trainParam.showCommandLine = false;	 %Generate command-line output
net.trainParam.showWindow = true;	%Show training GUI
net.trainParam.lr = 0.001;	%Learning rate
net.trainParam.max_fail = 10;	%Maximum validation failures
net.trainParam.min_grad	= 1e-5; %Minimum performance gradient
net.trainParam.show = 25;	%Epochs between displays (NaN for no displays)
net.trainParam.time	= inf;	%Maximum time to train in seconds
%% train
net.divideFcn = 'divideblock';  % Divide data
net.divideParam.trainRatio = 80/100;
net.divideParam.valRatio = 10/100;
net.divideParam.testRatio = 10/100;
net.performFcn = 'mse';  % Mean Squared Error
net.plotFcns = {'plotperform','plottrainstate','ploterrhist', ...
    'plotregression', 'plotfit'};

% Train the Network
[net,tr] = train(net,x,t);
 
% Test the Network
y = net(x);
e = gsubtract(t,y);
performance = perform(net,t,y)

% Recalculate Training, Validation and Test Performance
trainTargets = t .* tr.trainMask{1};
valTargets = t .* tr.valMask{1};
testTargets = t .* tr.testMask{1};
trainPerformance = perform(net,trainTargets,y)
valPerformance = perform(net,valTargets,y)
testPerformance = perform(net,testTargets,y)

% View the Network
view(net)

% Plots
% Uncomment these lines to enable various plots.
figure, plotperform(tr)
figure, plottrainstate(tr)
figure, ploterrhist(e)
figure, plotregression(t,y)
figure, plotfit(net,x,t)
pause;
%% plot
plot(y, 'g', 'LineWidth',2)
title('network output vs desired output')
ylabel('force error')
xlabel('time [microsec]')
hold on
plot(t, 'b--')
 pause;          
%% trainig feedback
y_net = net (x);
controller_error (1) = [];
y_net(end) = [];
X = [controller_error , y_net'];
t(1) = [];

x = X';
fprintf('Training feedback ...\n')
pause;
trainFcn = 'trainlm';  % Levenberg-Marquardt backpropagation.
%% train
net.divideFcn = 'dividerand';  % Divide data
%net.divideMode = 'sample';  % Divide up every sample
net.divideParam.trainRatio = 100/100;
net.divideParam.valRatio = 0/100;
net.divideParam.testRatio = 0/100;
% Choose a Performance Function
net.performFcn = 'mse';  % Mean Squared Error
% Choose Plot Functions
net.plotFcns = {'plotperform','plottrainstate','ploterrhist', ...
    'plotregression', 'plotfit'};

% Train the Network
[net,tr] = train(net,x,t);

% Test the Network
y = net(x);
e = gsubtract(t,y);
performance = perform(net,t,y)

% View the Network
view(net)
%% plot
plot(y, 'g', 'LineWidth',2)
title('network output vs desired output')
ylabel('force [N]')
xlabel('time [microsec]')
hold on
plot(t, 'b--')
 pause; 
%% UNSUPERVISED LEARNING
for i=1:20 
%% Runing simulink
sim ('unsupervised_controller');
 %% update input output
 % Loading Data / We start by first loading the dataset. 
% Load Training Data of step input
fprintf('Loading controller Data ...\n')
load('controller_us');
load('controller_us_input');
% prepairing Data
controller_error = controller_us_input.data;
controller_us = [controller_us.time , controller_us.data];
time = controller_us(:,1);
force = controller_us(:,2);
acceleration = controller_us(:,3);
velocity = controller_us(:,4);
possiotion = controller_us(:,5);
xax = 0:0.01:30;
pax = 5.142*exp(-0.001159*xax)-5.154*exp(-0.4824*xax);
vax =(1553931*exp(-(603*xax)/1250))/625000 - ...
    (13741851269163728853*exp(-(5344944095357343*xax)/4611686018427387904))/2305843009213693952000;
aax = (73449426800395482479100247394517579*exp(-(5344944095357343*xax)/4611686018427387904))...
    /10633823966279326983230456482242756608000 - (937020393*exp(-(603*xax)/1250))/781250000;
% yprime = -2e-7.*x.^6 + 3e-5.*x.^5 - 0.0012.*x.^4 + 0.0285.*x.^3 - 0.3467.*x.^2 + 2.1167.*x - 0.0044;
% pos = yax;
% deltap = pos - possiotion;
% deltaF = -k*deltap+ b*velocity+ m*acceleration;
y = k*pax+ b*vax+ m*aax;
y=y';
%inputs
controller_error(1) = []; 
force_input = y;
force_input (end) = [];
X = [controller_error , force_input];
%outputs
y(1) = [];
fprintf('Training step input to network ...\n')
% pause;
net.trainParam.epochs = 1000;	%Maximum number of epochs to train
net.trainParam.goal = 0;	%Performance goal
net.trainParam.showCommandLine = false;	 %Generate command-line output
net.trainParam.showWindow = true;	%Show training GUI
net.trainParam.lr = 0.001;	%Learning rate
net.trainParam.max_fail = 6;	%Maximum validation failures
net.trainParam.min_grad	= 1e-4; %Minimum performance gradient
net.trainParam.show = 25;	%Epochs between displays (NaN for no displays)
net.trainParam.time	= inf;	%Maximum time to train in seconds
%% setting initial weights
IW = net.IW{1,1};
LW = net.LW{2,1};
b1 = net.b{1};
b2 = net.b{2};
net.IW{1,1} = IW;
net.LW{2,1} = LW;
net.b{1} = b1;
net.b{2} = b2;
x = X';
t = y';
% Train the Network
[net,tr] = train(net,x,t);
fprintf ('training feedback...\n');
pause;
y_net = net (x);
controller_error (1) = [];
y_net(end) = [];
X = [controller_error , y_net'];
t(1) = [];
x = X';
[net,tr] = train(net,x,t);
%% plot
% hold off
% plot(y, 'g', 'LineWidth',2)
% title('network output vs desired output')
% ylabel('acceleration [m/s^2]')
% xlabel('time [ms]')
% hold on
% plot(t, 'b--')
%  pause;
%  plot (possiotion)
end