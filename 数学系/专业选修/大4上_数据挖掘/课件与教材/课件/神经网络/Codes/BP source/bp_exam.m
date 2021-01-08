%function main()
  SamNum=100;
  TestSamNum=101;
  HiddenUnitNum=10;
  InDim=1;
  OutDim=1;
  
  % IN OUT sample  created
  rand('state',sum(100*clock))
  NoiseVar=0.1;
  Noise=NoiseVar*randn(1,SamNum);
  SamIn=8*rand(1,SamNum)-4;
  SamOutNoNoise=1.1*(1-SamIn+2*SamIn.^2).*exp(-SamIn.^2/2);
  SamOut=SamOutNoNoise+Noise;
  
  % Test Sample Created
  TestSamIn=-4:0.08:4;
  TestSamOut=1.1*(1-TestSamIn+2*TestSamIn.^2).*exp(-TestSamIn.^2/2);
  
  figure
  hold on
  grid
  plot(SamIn,SamOut,'go');
  plot(TestSamIn,TestSamOut,'r*');
  
  %Now ANN
  MaxEpochs=20000;
  lr=0.003;
  E0=0.5;
  
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
      HiddenOut=logsig(W1Ex*SamInEx);
      HiddenOutEx=[HiddenOut' ones(SamNum,1)]';
      NetworkOut=W2Ex*HiddenOutEx;
      
      %judge error
      Error=SamOut-NetworkOut;
      SSE=sumsqr(Error);
      
      %record it
      ErrHistory=[ErrHistory SSE];
      if SSE<E0 
          break
      end
      
      %backward error
      Delta2=Error;
      Delta1=W2'*Delta2.*HiddenOut.*(1-HiddenOut);
      
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
  TestHiddenOut=logsig(W1*TestSamIn+repmat(B1,1,TestSamNum));
  TestNNOut=W2*TestHiddenOut + repmat(B2,1,TestSamNum);
  plot(TestSamIn,TestNNOut,'k+')
  
  figure
  hold on
  grid
  [xx Num]=size(ErrHistory);
  plot(1:Num,ErrHistory,'bs');
  
  
  
  