% P81 exercise 3.8.m
% ===================
% [1 -1 -1]--A
% [-1 1 -1]--I
% [-1 -1 1]--O

% Step 1
% define training patterns.
A=[1 1 1 1 1 0 0 1 1 1 1 1 1 0 0 1];
I=[0 1 0 0 0 1 0 0 0 1 0 0 0 1 0 0];
O=[1 1 1 1 1 0 0 1 1 0 0 1 1 1 1 1];
x=[A; I; O]';
y=[1 -1 -1; -1 1 -1; -1 -1 1];

% Step 2
% with 16 input, 15 neurons in the hidden layer and 3 output.
% create a two-layer feed-forward backpropagation network with
% 16 input (ranges from 0 to 1) and 15 neurons in each hidden layer.
% set bipolar sigmoid as the transfer function for the hidden nodes 
% and bipolar sigmoid function for the output node.
% Note: unipolar sigmoid function -- 'logsig'
net=newff(minmax(x), [15 3], {'tansig' 'tansig'});
% Step 3
% set training options.
net.performFcn='mse';
net.trainFcn='traingdx'; % define gradient descent training function
net.trainParam.epochs=5000; % maximum number of epochs
net.trainParam.goal=0.0001; % performance goal

% Step 4
% perform training.
% a trained network 'trained_net2' will be returned.
% 'tr' is the training record which is shown by plotpert(tr).
[trained_net, tr]=train(net,x,y);
% Step 5
% test the trained network.
x_t=[1 1 1 1 1 0 0 1 1 1 1 1 1 0 0 1]';
y_t=sim(trained_net,x_t)
% Step 6
% plot the result.