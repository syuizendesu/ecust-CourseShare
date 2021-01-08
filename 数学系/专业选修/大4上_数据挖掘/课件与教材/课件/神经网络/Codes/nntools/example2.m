clear all;
close all;
net = newff([0 1; 0 1],[2 1],{'logsig','logsig'});


% Setze Inputs und Targets
input = [1 1 0 0; 1 0 1 0];
target = [0 1 1 0];
plotpv(input,target)

% Train Network
net.trainParam.show=NaN;
net.trainParam.epochs = 1000;
net = train(net,input,target);


% Simulate Network
output = sim(net,input)

% Display the weights
net.IW{1,1}
net.LW{2,1}

