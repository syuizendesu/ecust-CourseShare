clear all;
close all;

% working random seed
rand('state',1);
randn('state',1);

% not working random seed
%rand('state',12345);
%randn('state',12345);


%
% XOR Problem
%

% Feed-Forward Network
net = newff([0 1; 0 1],[2  1],{'logsig','logsig'});

% Initialize Network
net.IW{1,1} = rand(size(net.IW{1,1})) * 2 / sqrt(2) - 1 / sqrt(2);
net.LW{2,1} = rand(size(net.LW{2,1})) * 2 / sqrt(2) - 1 / sqrt(2);


% Inputs and Targets
input = [1 1 0 0; 1 0 1 0];
target = [0 1 1 0];

fig1 = figure;
gscatter(input(1,:),input(2,:), target, 'rb', 'so')
hold on;

pause

% Train the Network
net.trainParam.show = 10;
net.trainParam.epochs = 1000;
net.trainFcn = 'trainlm';
[net, perf] = train(net,input,target);


% Simulate the Network
[output] = sim(net,input)

% Display W
net.IW{1,1}
net.LW{2,1}

% Plot the seperate Line
neuron = 1;

x = -1:0.1:1;

figure(fig1);

y = (-net.b{1}(neuron) - x * net.IW{1,1}(neuron,1)) / net.IW{1,1}(neuron,2);
plot(x,y);

neuron = 2;
y = (-net.b{1}(neuron) - x * net.IW{1,1}(neuron,1)) / net.IW{1,1}(neuron,2);
plot(x,y);
