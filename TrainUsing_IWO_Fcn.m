function [Network2] = TrainUsing_IWO_Fcn(Network,Xtr,Ytr)
%% Problem Statement
IW = Network.IW{1,1}; IW_Num = numel(IW);
LW = Network.LW{2,1}; LW_Num = numel(LW);
b1 = Network.b{1,1}; b1_Num = numel(b1);
b2 = Network.b{2,1}; b2_Num = numel(b2);

TotalNum = IW_Num + LW_Num + b1_Num + b2_Num;

VarSize =[1 TotalNum];

VarMin = -1;
VarMax = 1;

FunName = 'Cost_ANN_EA';

%% IWO Parameters

MaxIt = 50;    % Maximum Number of Iterations

nPop0 = 10;     % Initial Population Size
nPop = 100;     % Maximum Population Size

Smin = 0;       % Minimum Number of Seeds
Smax = 5;       % Maximum Number of Seeds

Exponent = 2;           % Variance Reduction Exponent
sigma_initial = 1;      % Initial Value of Standard Deviation
sigma_final = 0.001;	% Final Value of Standard Deviation




% Empty Plant Structure
empty_plant.Position = [];
empty_plant.Cost = [];

pop = repmat(empty_plant, nPop0, 1);    % Initial Population Array

for i = 1:numel(pop)
    
    % Initialize Position
    pop(i).Position = unifrnd(VarMin, VarMax, VarSize);
    
    % Evaluation
    pop(i).Cost = feval(FunName,pop(i).Position,Xtr,Ytr,Network);

    
    
end

% Initialize Best Cost History
BestCosts = zeros(MaxIt, 1);

%% IWO Main Loop

for it = 1:MaxIt
    
    % Update Standard Deviation
    sigma = ((MaxIt - it)/(MaxIt - 1))^Exponent * (sigma_initial - sigma_final) + sigma_final;
    
    % Get Best and Worst Cost Values
    Costs = [pop.Cost];
    BestCost = min(Costs);
    WorstCost = max(Costs);
    
    % Initialize Offsprings Population
    newpop = [];
    
    % Reproduction
    for i = 1:numel(pop)
        
        ratio = (pop(i).Cost - WorstCost)/(BestCost - WorstCost);
        S = floor(Smin + (Smax - Smin)*ratio);
        
        for j = 1:S
            
            % Initialize Offspring
            newsol = empty_plant;
            
            % Generate Random Location
            newsol.Position = pop(i).Position + sigma * randn(VarSize);
            
            % Apply Lower/Upper Bounds
            newsol.Position = max(newsol.Position, VarMin);
            newsol.Position = min(newsol.Position, VarMax);
            
            % Evaluate Offsring
            
             newsol.Cost = feval(FunName,newsol.Position,Xtr,Ytr,Network);

            % Add Offpsring to the Population
            newpop = [newpop
                      newsol];  %#ok
            
        end
        
    end
    
    % Merge Populations
    pop = [pop
           newpop];
    
    % Sort Population
    [~, SortOrder]=sort([pop.Cost]);
    pop = pop(SortOrder);

    % Competitive Exclusion (Delete Extra Members)
    if numel(pop)>nPop
        pop = pop(1:nPop);
    end
    
    % Store Best Solution Ever Found
    BestSol = pop(1);
    
    % Store Best Cost History
    BestCosts(it) = BestSol.Cost;
    
    % Display Iteration Information
    disp(['Iteration ' num2str(it) ': Best Cost = ' num2str(BestCosts(it))]);
    
end

%% Final Result Demonstration
BestSolution = BestSol;
BestCost =  BestSol.Cost;
Network2 = ConsNet_Fcn(Network,BestSolution.Position);
