function [Input,Output]=ReadyData(X)
Input=zeros();
Output=[];
for i=2:size(X,1)-1
    for j=2:size(X,2)
        Input(i-1,j-1)=str2num(X{i,j});
      
        
        
    end
      Output(i-1)=str2num(X{i+1,5});
end


end