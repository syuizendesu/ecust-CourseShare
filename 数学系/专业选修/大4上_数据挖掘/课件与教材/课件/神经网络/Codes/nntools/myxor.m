clear all;
close all;
net = newff([0 1; 0 1], [2 1],{'logsig','logsig'});

input=[1 1 0 0; 1 0 1 0];
target=[0 1 1 0];

net = train(net, input,target);
output=sim(net,input)
