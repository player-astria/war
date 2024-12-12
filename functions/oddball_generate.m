function text_data = oddball_generate(~)
% generate a matrix of 5*225, which represents 5 blocks and 225 trials
clc;
clear;
rng('shuffle');
text_data = zeros(5,225);
      
for i = 1:5 %block
n=1;
%45 probe
    for j = 1:5 % probe
        for k = 0:3:6 % probe_num(0-low,3-middle,6-high)
            for l = 0:3:6 % soldier_num(0-low,3-middle,6-high)
        text_data(i,n) = j*100 + (k+randi(3))*10 + (l+randi(3));
            n = n+1;
            end
        end
    end

%45 target
    for n = 46:90
        text_data(i,n) = 600;
    end

%135 disrtactor
n = n + 1; % n=91
    for k = 1:15 % 15 repeated
        for j = 1:9 % 9 num
        text_data(i,n) = 6*100+j;
        n = n+1;
        end
    end
idx = randperm(225); % random
text_data(i,:) = text_data(i,idx);

end


end
