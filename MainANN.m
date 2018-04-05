%% Start of Program
clc
clear
close all

%% Data Loading
[~,train] = xlsread('Amozesh.xls');
[~,test] = xlsread('test.xls');
[Inputtrain,Outputtrain]=ReadyData(train);
[Inputtest,Outputtest]=ReadyData(test);
trainNum=size(Inputtrain,1);
testNum=size(Inputtest,1);

X=[Inputtrain;Inputtest];
Y=[Outputtrain,Outputtest]';
% X = Data(:,1:end-1);
% Y = Data(:,end);

DataNum = size(X,1);
InputNum = size(X,2);
OutputNum = size(Y,2);

%% Normalization
MinX = min(X);
MaxX = max(X);

MinY = min(Y);
MaxY = max(Y);

XN = X;
YN = Y;

for ii = 1:InputNum
    XN(:,ii) = Normalize_Fcn(X(:,ii),MinX(ii),MaxX(ii));
end

for ii = 1:OutputNum
    YN(:,ii) = Normalize_Fcn(Y(:,ii),MinY(ii),MaxY(ii));
end

%% Test and Train Data
% TrPercent = 80;
% TrNum = round(DataNum * TrPercent / 100);
% TsNum = DataNum - TrNum;
% 
% R = randperm(DataNum);
% trIndex = R(1 : TrNum);
% tsIndex = R(1+TrNum : end);

% Xtr = XN(trIndex,:);
% Ytr = YN(trIndex,:);

% Xts = XN(tsIndex,:);
% Yts = YN(tsIndex,:);

Xtr=X(1:trainNum,:);
Ytr=Y(1:trainNum);

Xts=X(1:testNum,:);
Yts=Y(1:testNum);

%% Network Structure
pr = [-1 1];
PR = repmat(pr,InputNum,1);

Network = newff(PR,[5 OutputNum],{'tansig' 'tansig'});

%% Training
Network = TrainUsing_IWO_Fcn(Network,Xtr,Ytr);

%% Assesment
YtrNet = sim(Network,Xtr')';
YtsNet = sim(Network,Xts')';

MSEtr = mse(YtrNet - Ytr)
MSEts = mse(YtsNet - Yts)

RMSEtr=sqrt(MSEtr)
RMSEts=sqrt(MSEts)
%% MAE
MAEtr=mae(YtrNet - Ytr)
MAEts=mae(YtsNet - Yts)

%% Display
figure(1)
plot(Ytr,'-or');
hold on
plot(YtrNet,'-sb');
hold off

figure(2)
plot(Yts,'-or');
hold on
plot(YtsNet,'-sb');
hold off

figure(3)
t = -1:.1:1;
plot(t,t,'b','linewidth',2)
hold on
plot(Ytr,YtrNet,'ok')
hold off

figure(4)
t = -1:.1:1;
plot(t,t,'b','linewidth',2)
hold on
plot(Yts,YtsNet,'ok')
hold off





