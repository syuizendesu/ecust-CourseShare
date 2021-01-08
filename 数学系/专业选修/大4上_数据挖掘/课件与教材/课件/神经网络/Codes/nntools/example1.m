        P = [0 1 2 3 4 5 6 7 8 9 10];
       T = [0 1 2 3 4 3 2 1 2 3 4];
 
    
 
       net = newff([0 10],[5 1],{'tansig' 'purelin'});
 
    
       %Y = sim(net,P);
        %plot(P,T,P,Y,'o')
 
    
 
       net.trainParam.epochs = 5000;
       net.trainParam.goal=0.001;
       net = train(net,P,T);
       Y = sim(net,P);
        plot(P,T,P,Y,'o')
 