% id = input("subject's ID = ");
for id = 40:80
stimuli_order = [];
for i=1:4
    stimuli_order = [stimuli_order, randperm(48)];
end
save(sprintf("%d.mat", id),"stimuli_order",'-mat');
end