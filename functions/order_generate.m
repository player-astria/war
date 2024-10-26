function text_data = order_generate(~)
% generate a matrix of 3*30, which represents 3blocks and 30 trials, 0-9 
% represents child trials, 10-19 represents adult trials and 20-29 
% represents none_damage
text_data = zeros(3,30);
for i = 1:3     
        text_data(i,:) = randperm(30)-1;
end
end

