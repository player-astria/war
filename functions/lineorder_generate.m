function text_data = lineorder_generate(~)
% generate a matrix of 5*225, which represents 5 blocks and 225 trials, 1
% represents soldier number in the first line, 2 represents probe number in
% the first line
clc;
clear;
rng('shuffle');
text_data = zeros(5,225);
for i = 1:5
    for j = 1:112
        text_data(i,j)=1;
    
    end
    
    for j =113:225
        text_data(i,j)=2;
    
    end
    idx = randperm(225); % random
text_data(i,:) = text_data(i,idx);
end


end