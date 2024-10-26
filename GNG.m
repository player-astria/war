%% init
clear;clc;
% subject&study info
prompt = {'Subject''s ID:', 'Start Block:'};
subject = input(prompt{1});
block = input(prompt{2});
% debug
debug = 0;
AssertOpenGL;
commandwindow;
if debug
    ListenChar(0);
    ShowCursor();
    PsychDebugWindowConfiguration;
else
    ListenChar(2);
    HideCursor();
end
% global veriable  
global x
% screen settings
x.ins_color = [255 255 255];
x.bg_color = [122 122 122];
Screen('Preference', 'SkipSyncTests', 1);
PsychDefaultSetup(2);
x.screenNumber = max(Screen('Screens'));
[x.window, x.windowRect] = Screen('OpenWindow', x.screenNumber, x.bg_color);
[x.x_center, x.y_center] = RectCenter(x.windowRect);
Screen('TextFont', x.window, 'Simsun');
Screen('Preference','TextEncodingLocale','UTF-8');
% keyboard defination
KbName('UnifyKeyNames');
continue_key = KbName('space');
quit_key = KbName('ESCAPE');
reaction_key = KbName('space');
% port setting
port_address = hex2dec('037F');
    %config_io;
    % outp(port_address, 0);
%{
Stimulus Markers
    Low=1 High=2 / Netural=1 Pain=2 / Woman=1 Man=2 Tree=3
    NeutralWoman-LowSoldier=11 NeutralMan-LowSoldier=12 Tree-LowSoldier=13
    NeutralWoman-HighSoldier=21 NeutralMan-HighSoldier=22 Tree-HighSoldier=23
Choice Markers
    ChoiceStart=99 Launch=100 Non-launch=200 Non-response=199
SolderNumber Markers
    low=1 High=2
Others
    RunStart=88 Rest=66
%}
% experiment settings
n_block = 3;
n_trial = 40;
trial_duration = 1;
% create result data
mkdir(sprintf('result/GNG/sub_%d', subject));
result = table();
result = addvars(result, string.empty(), 'NewVariableNames', "stimulus");
%% Practice Block
if block == 1
    % introduction
    IntroImage = imread('stimuli_GNG/introduction.png');
    PracticeImage = imread('stimuli_GNG/practice.png');
    ShowPicWaitKey(IntroImage);
    ShowPicWaitKey(imread('stimuli_GNG/introduction/intro_SN1.png'));
    ShowPicWaitKey(imread('stimuli_GNG/introduction/intro_child.png'));
    ShowPicWaitKey(imread('stimuli_GNG/introduction/intro_launch.png'));
    ShowPicWaitKey(imread('stimuli_GNG/introduction/intro_SN2.png'));
    ShowPicWaitKey(imread('stimuli_GNG/introduction/intro_drunk.png'));
    ShowPicWaitKey(imread('stimuli_GNG/introduction/intro_launch.png'));
    ShowPicWaitKey(PracticeImage);
    % 15 practice trials(3target,5 mask,12345NG,678910free,1child,2pregnant,3drunk,4criminal,5civilian)
    load("stimuli_GNG/practice/prac_order.mat")
    for i = 1:2
        prac_trial = prac_order(i);
        mask = mod(prac_trial,5)+1; 
        IntroStimPic1 = imread(sprintf('stimuli_GNG/practice/prac_target%d.png',prac_trial));    
        IntroStimPic2 = imread(sprintf('stimuli_GNG/practice/prac_mask%d.png',mask));  
        choice = imread('stimuli_GNG/practice/prac_launch.png');
        % Practice Screen
        FlipFix();
        ShowPicWaitSec(IntroStimPic1,1);   
        FlipFix();
        ShowPicWaitSec(IntroStimPic2,1);  
        ShowPic(choice);  
        t_start = Screen('Flip', x.window);
        while KbCheck(), end           
        while GetSecs - t_start < trial_duration
            [keyIsDown, t_end, keyCode] = KbCheck();      
            if keyIsDown
                    if keyCode(quit_key)
                        ListenChar(0);
                        ShowCursor();
                        Screen('CloseAll');
                        return; 
                    elseif ~keyCode(reaction_key)
                        fb=0;%false alarm
                        break;
                    elseif keyCode(reaction_key)
                        if ismember(prac_trial,1:1:5)
                            fb=0;%false alarm
                            break;
                        else
                            fb=1;%correct
                            break;
                        end
                    end
            end
        end
            if  GetSecs - t_start >= trial_duration
                if ismember(prac_trial,11:1:15)
                    fb=0;%missing
                else
                    fb=1;%correct missing
                end
            end        
            feedback(fb);
    end
end
%% formal exp
% introduction
expintro_image = imread('stimuli_GNG/exp.png');
ShowPicWaitKey(expintro_image);
% load(sprintf("order/%d.mat",subject));
% generate stimulation order, probe1-child, probe2-pregnant, probe3-drunk,
% probe4-criminal, probe5-civilian
exp_text = GNG_generate;
BreakPic = imread('stimuli_GNG/break.png');
for i = block:n_block
%     outp(port_address, 88);
%     WaitSecs(0.004);
%     outp(port_address, 0);
    
    for j = 1:n_trial
        order = exp_text(i,j); %0-39
% count soldier_num and identity        
        mask = mod(order,5)+1;
        soldier_num = (order-mask+1)/5+1;
    switch mask 
        case 1
            mask_type = 'child';
        case 2
            mask_type = 'pregnant';
        case 3
            mask_type = 'drunk';
        case 4
            mask_type = 'criminal';
        case 5
            mask_type = 'civilian';
    end
%         stim_marker = mask;
%         sold_marker = soldier_num;
        % stim picture
        StimPic_target = imread(sprintf('stimuli_GNG/soilder-number/SN%d.png',soldier_num));
        StimPic_mask = imread(sprintf(['stimuli_GNG/exp/', mask_type, '.png']));
        Choice_exp = imread('stimuli_GNG/launch.png');
        t = FlipFix();
        warning off
        result.stimulus(5*j-4) = "fixation";
        result.response(5*j-4) = 99;
        result.rt(5*j-4) = t;
        warning on
%         outp(port_address, sold_marker);
%         WaitSecs(0.004);
%         outp(port_address, 0);
        ShowPicWaitSec(StimPic_target,1);
        result.stimulus(5*j-3) = sprintf('杀死了%d名士兵',soldier_num);
        result.response(5*j-3) = 99;
        result.rt(5*j-3) = 1;
        t = FlipFix();
        warning off
        result.stimulus(5*j-2) = "fixation";
        result.response(5*j-2) = 99;
        result.rt(5*j-2) = t;
        warning on
%         outp(port_address, stim_marker);
%         WaitSecs(0.004);
%         outp(port_address, 0);
        ShowPicWaitSec(StimPic_mask,1);
        result.stimulus(5*j-1) = mask;
        result.response(5*j-1) = 99;
        result.rt(5*j-1) = 1;
%         outp(port_address, 99);
%         WaitSecs(0.004);
%         outp(port_address, 0);
        ShowPic(Choice_exp);
        t_start = Screen('Flip', x.window);
        warning off
        while KbCheck(), end
        while GetSecs - t_start < trial_duration
            [keyIsDown, t_end, keyCode] = KbCheck();
            if keyIsDown
                    if keyCode(quit_key)
                        ListenChar(0);
                        ShowCursor();
                        Screen('CloseAll');
                        return; 
                    elseif ~keyCode(reaction_key)
                        result.rt(6*j) = GetSecs - t_start;
                        response=0;
                        break;    %false alarm
                    elseif keyCode(reaction_key)
                        result.rt(6*j) = GetSecs - t_start;
                        response=1;
% outp(port_address, 100);
% WaitSecs(0.004);
% outp(port_address, 0);
                        break;
                    end
            end
        end
        if  GetSecs - t_start >= trial_duration
                response = 99;
                result.rt(6*j) = trial_duration;
        end      

        result.stimulus(6*j) = order;
        result.response(6*j) = response;
        warning on
    end
    % save data
    writetable(result, sprintf('result/GNG/sub_%d/block_%d.csv', subject, i));
    % rest
    if i < n_block
%         outp(port_address, 66);
%         outp(port_address, 0);
        ShowPicWaitKey(BreakPic);
    end
end
%% finish
finish_image = imread('stimuli_GNG/finish.png');
ShowPicWaitKey(finish_image);
Screen('CloseAll');
ListenChar(0);
ShowCursor();
final_data = readtable(sprintf('result/GNG/sub_%d/block_1.csv', subject));
for i = 2:5
    final_data = vertcat(final_data, readtable(sprintf('result/GNG/sub_%d/block_%d.csv', subject, i)));
end
writetable(final_data, sprintf('result/GNG/sub_%d/result.csv', subject));

%% function
% Show picture untill key is press down
function ShowPicWaitKey(image)
global x
texture = Screen('MakeTexture', x.window, image);
Screen('DrawTexture', x.window, texture);
Screen('Flip', x.window);
while KbCheck(), end
KbStrokeWait;
Screen('Flip', x.window);
end

%% Draw fixation
function fixation_duration = FlipFix(t)
global x %#ok<*GVMIS> 
if nargin < 1
	fixation_duration = 0.1*(randi([8,14]));
else 
    fixation_duration = 0.1*(randi([8,14]))+trial_duration-t;
end 

fixation = '+';
fixation_size = 100;
Screen('TextSize', x.window, fixation_size);
rect = Screen('TextBounds', x.window, fixation);
width = rect(3) - rect(1);
% highth = rect(2) - rect(1);
fix_x = (2*x.x_center-width)/2;
% fix_y = (2*x.y_center-highth)/2;
DrawFormattedText(x.window, fixation, fix_x, x.y_center+50, x.ins_color);
% Screen('DrawText', x.window, fixation, x.x_center-0.5*fixation_size, x.y_center-0.5*fixation_size, x.ins_color);
Screen('Flip', x.window);
WaitSecs(fixation_duration);
end

%% Draw picture on screen
function DrawPic(image,y)
global x
texture = Screen('MakeTexture', x.window, image);
width = 0.20 * x.windowRect(3);
height = width*(5/4);
rect = [x.x_center-0.5*width, y-0.5*height, x.x_center+0.5*width, y+0.5*height];
Screen('DrawTexture', x.window, texture, [], rect);
end

%% Show picture untill key is press down
function ShowPicWaitSec(image,t)
global x
texture = Screen('MakeTexture', x.window, image);
Screen('DrawTexture', x.window, texture);
Screen('Flip', x.window);
WaitSecs(t);
end

function ShowPic(image)
global x
texture = Screen('MakeTexture', x.window, image);
Screen('DrawTexture', x.window, texture);
% Screen('Flip', x.window);
end 

%% give feedback in practice
function feedback(tf)
global x
if tf==0
ShowPic(imread('stimuli_oddball\practice\red.png')); 
Screen('Flip', x.window);
WaitSecs(1);
else
ShowPic(imread('stimuli_oddball\practice\green.png'));  %correct
Screen('Flip', x.window);
WaitSecs(1);
end
end