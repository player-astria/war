function text_data = oddball_generate(~)
% generate a matrix of 5*50, which represents 5blocks and 50 trials, 0-9 
% represents target trials, 10-19 represents probes trials and 20-49 
% represents standard trials
text_data = zeros(5,50);
for i = 1:5     
        text_data(i,:) = randperm(50)-1;
end
end

