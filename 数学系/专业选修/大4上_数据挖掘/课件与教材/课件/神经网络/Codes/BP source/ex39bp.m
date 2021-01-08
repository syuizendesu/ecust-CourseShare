%function main()
  SamNum=9;
  TestSamNum=9;
  HiddenUnitNum=15;
  InDim=2;
  OutDim=3;
  
  % IN OUT sample  created
  %rand('state',sum(100*clock))
  %NoiseVar=0.1;
  %Noise=NoiseVar*randn(1,SamNum);
  %SamIn=8*rand(1,SamNum)-4;
  %SamOutNoNoise=1.1*(1-SamIn+2*SamIn.^2).*exp(-SamIn.^2/2);
  %SamOut=SamOutNoNoise+Noise;
  
  SamIn=[1/4 3/4 3/4 1/4 1/2 3/4 1/4 1/2 3/4;
   1/4 1/8 3/4 3/4 1/8 1/4 1/2 1/2 1/2];
  SamOut=[1 1 1 -1 -1 -1 -1 -1 -1;
   -1 -1 -1 1 1 1 -1 -1 -1;
   -1 -1 -1 -1 -1 -1 1 1 1];
  % Test Sample Created
  TestSamIn=SamIn;
  TestSamOut=SamOut;
  
  figure
  hold on
  grid
  plot(SamIn(1,1:3),SamIn(2,1:3),'+');
  plot(SamIn(1,4:6),SamIn(2,4:6),'o');
  plot(SamIn(1,7:9),SamIn(2,7:9),'*');
  
  %Now ANN
  MaxEpochs=20000;
  lr=0.05;
  E0=0.05;
  
  W1=0.2*rand(HiddenUnitNum,InDim) - 0.1;
  B1=0.2*rand(HiddenUnitNum,1) - 0.1;
  W2=0.2*rand(OutDim,HiddenUnitNum) - 0.1;
  B2=0.2*rand(OutDim,1) - 0.1;
  
  W1Ex=[W1 B1];  %阈值纳入权值中
  W2Ex=[W2 B2];
  
  SamInEx=[SamIn' ones(SamNum,1)]'; %输入样本加1元素
  ErrHistory=[];
  
  for i=1:MaxEpochs
      %forward 
      HiddenOut=tansig(W1Ex*SamInEx);
      HiddenOutEx=[HiddenOut' ones(SamNum,1)]';
      NetworkOut=tansig(W2Ex*HiddenOutEx);
      
      %judge error
      Error=SamOut-NetworkOut;
      SSE=sumsqr(Error);
      
      %record it
      ErrHistory=[ErrHistory SSE];
      if SSE<E0 
          break
      end
      
      %backward error
      Delta2=Error.*(1-NetworkOut.^2)./2;
      %Delta2=Error;
      %Delta1=W2'*Delta2.*HiddenOut.*(1-HiddenOut);
      Delta1=W2'*Delta2.*(1-HiddenOut.^2)./2;
      
      % modify the weights
      dW2Ex=Delta2*HiddenOutEx';
      dW1Ex=Delta1*SamInEx';
      W1Ex=W1Ex+lr*dW1Ex;
      W2Ex=W2Ex+lr*dW2Ex;
      
      % 去掉extension的权值
      W2=W2Ex(:,1:HiddenUnitNum);
  end    
  
  %show up
  i
  W1=W1Ex(:,1:InDim)
  B1=W1Ex(:,InDim+1)
  W2
  B2=W2Ex(:,1+HiddenUnitNum)
  
  %test
  TestHiddenOut=tansig(W1*TestSamIn+repmat(B1,1,TestSamNum));
  TestNNOut=tansig(W2*TestHiddenOut + repmat(B2,1,TestSamNum))
  %plot(TestSamIn,TestNNOut,'k+')
  
  figure
  hold on
  grid
  [xx Num]=size(ErrHistory);
  plot(1:Num,ErrHistory,'bs');
  
  
  
  