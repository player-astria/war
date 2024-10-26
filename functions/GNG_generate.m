function text_data = GNG_generate(~)
% generate a matrix of 3*40, which represents 3blocks and 40 trials,
% mod(n,5)+1 represents mask,,1child,2pregnant,3drunk,4criminal,5civilian;
% n/5 represents soldier_num(target). For example, 24 represents
% criminal and 5 soldiers
text_data = zeros(3,40);
for i = 1:3     
        text_data(i,:) = randperm(40)-1;
end
end

