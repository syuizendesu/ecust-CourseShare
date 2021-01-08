% MLP_SampleProgram.m
% ===================
% To simulate a two-layer feed-forward network for approximating a function
% y = sin(x).*cos(3*x)
% with 1 input, 15 neurons in the hidden layer and 1 output.
% Step 1
% create a two-layer feed-forward backpropagation network with
% 1 input (ranges from -pi to pi) and 15 neurons in each hidden layer.
% set bipolar sigmoid function as the activation function for the hidden
% nodes and linear function as the activation function for the output node.
% Note: unipolar sigmoid function -- 'logsig'
net2=newff([-pi pi], [15 1], {'tansig' 'purelin'});
% Step 2
% set training options.
net2.performFcn='mse';
net2.trainFcn='traingdx'; % define gradient descent training function
net2.trainParam.epochs=5000; % maximum number of epochs
net2.trainParam.goal=0.0001; % performance goal
% Step 3
% define training patterns.
x=-pi:0.1:pi;
y=sin(x).*cos(3*x);
P=x;
T=y;
% Step 4
% perform training.
% a trained network 'trained_net2' will be returned.
% 'tr' is the training record which is shown by plotpert(tr).
[trained_net2, tr]=train(net2,P,T);
% Step 5
% test the trained network.
x_t=-pi:0.15:pi;
y_t=sim(trained_net2,x_t);
% Step 6
% plot the result.
figure;
hold on;
% original function
xx=-pi:0.01:pi;
yy=sin(xx).*cos(3*xx);
plot(xx,yy,'c');
% training sample
plot(x,y,'kx');
% testing result
stem(x_t,y_t);
xlabel('x');
ylabel('y');
title('y=sin(x)*cos(3x)');