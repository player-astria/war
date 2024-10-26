%% init
clear;clc;
% subject&study info
prompt = {'Subject''s ID:', 'Start Run:'};
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
launch_key = KbName('leftarrow');
cancel_key = KbName('rightarrow');
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
n_trial = 30;
trial_duration = 5;
% create result data
mkdir(sprintf('result/exp1/sub_%d', subject));
result = table();
result = addvars(result, string.empty(), 'NewVariableNames', "stimulus");
%% Practice Block
if block == 1
    % introduction
    IntroImage = imread('stimuli/introduction.png');
    PracticeImage = imread('stimuli/practice.png');
    IntroChoiceOnset = imread('stimuli/practice/choice_onset.png');
    IntroChoiceLaunch = imread('stimuli/practice/choice_launch.png');
    IntroChoiceCancel = imread('stimuli/practice/choice_cancel.png');
    ShowPicWaitKey(IntroImage);
    ShowPicWaitKey(imread('stimuli/introduction/intro_SN1.png'));
    ShowPicWaitKey(imread('stimuli/introduction/intro_adult.png'));
    ShowPicWaitKey(imread('stimuli/introduction/intro_SN2.png'));
    ShowPicWaitKey(imread('stimuli/introduction/intro_child.png'));
    ShowPicWaitKey(PracticeImage);
    % 5 practice trials
    for i = 1:3
        IntroSoldNumPic = imread(sprintf('stimuli/practice/SNP%d.png',i));
        switch i
            case 1
                IntroStimPic = imread(sprintf('stimuli/practice/prac_child.png'));
            case 2
                IntroStimPic = imread(sprintf('stimuli/practice/prac_adult.png'));
            case 3
                IntroStimPic = imread(sprintf('stimuli/practice/none_damage.png'));
        end
        % Scree 1
        FlipFix();
        ShowPicWaitSec(IntroSoldNumPic,1);
        % Screen 2
        FlipFix();
        ShowPicWaitSec(IntroStimPic,3);
        FlipFix();
        ShowPic(IntroChoiceOnset);
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
                elseif keyCode(launch_key)
                    ShowPic(IntroChoiceLaunch);
                    Screen('Flip', x.window);
                    WaitSecs(1);
                    break
                elseif keyCode(cancel_key)
                    ShowPic(IntroChoiceCancel);
                    Screen('Flip', x.window);
                    WaitSecs(1);
                    break
                else
                    continue;
                end
            end
        end
    end
end
%% formal exp
% introduction
expintro_image = imread('stimuli/exp.png');
ShowPicWaitKey(expintro_image);
% load(sprintf("order/%d.mat",subject));
% generate stimulation order
exp_data = order_generate;
ChoiceOnset = imread('stimuli/choice/choice_onset.png');
ChoiceLaunch = imread('stimuli/choice/choice_launch.png');
ChoiceCancel = imread('stimuli/choice/choice_cancel.png');
BreakPic = imread('stimuli/break.png');
for i = block:n_block
%     outp(port_address, 88);
%     WaitSecs(0.004);
%     outp(port_address, 0);
    for j = 1:n_trial
        order = exp_text(i,j);
% count soldier_num and identity        
        soldier_num = mod(order,10)+1;
        identity = (order-soldier_num+1)/10;
%         stim_marker = identity;
%         sold_marker = soldier_num;
        % Fixation
        if j>1
            test_reaction = result.rt(6*(j-1));
        elseif j==1
            test_reaction = trial_duration;
        end
        t = FlipFix(test_reaction,trial_duration);
        warning off
        result.stimulus(6*j-5) = "fixation";
        result.response(6*j-5) = 99;
        result.rt(6*j-5) = t;
        warning on
        % Soldier number
        SoldNumPic = imread(sprintf('stimuli/soilder-number/SN%d.png',soldier_num));
%         outp(port_address, sold_marker);
%         WaitSecs(0.004);
%         outp(port_address, 0);
        ShowPicWaitSec(SoldNumPic,1);
        warning off
        result.stimulus(6*j-4) = sprintf("杀死%d士兵",soldier_num);
        result.response(6*j-4) = 99;
        result.rt(6*j-4) = 1;
        warning on
        t = FlipFix();
        warning off
        result.stimulus(6*j-3) = "fixation";
        result.response(6*j-3) = 99;
        result.rt(6*j-3) = t;
        warning on
        % Decision-making
%         outp(port_address, stim_marker);
%         WaitSecs(0.004);
%         outp(port_address, 0);
        if identity==0
            idpic = imread('stimuli/exp/child.png');
        elseif identity==1
            idpic = imread('stimuli/exp/adult.png');
        else
            idpic = imread('stimuli/exp/none_damage.png');
        end
        ShowPicWaitSec(idpic,1);
        warning off
        result.stimulus(6*j-2) = j;
        result.response(6*j-2) = 99;
        result.rt(6*j-2) = 1;
        warning on
        t = FlipFix();
        warning off
        result.stimulus(6*j-1) = "fixation";
        result.response(6*j-1) = 99;
        result.rt(6*j-1) = t;
        warning on
%         outp(port_address, 99);
%         WaitSecs(0.004);
%         outp(port_address, 0);
        ShowPic(ChoiceOnset);
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
                elseif keyCode(launch_key)
                    result.rt(6*j) = GetSecs - t_start;
%                     outp(port_address, 100);
%                     WaitSecs(0.004);
%                     outp(port_address, 0);
                    response = 1;
                    ShowPicWaitSec(ChoiceLaunch,1);
                    break
                elseif keyCode(cancel_key)
                    result.rt(6*j) = GetSecs - t_start;
%                     outp(port_address, 200);
%                     WaitSecs(0.004);
%                     outp(port_address, 0);
                    response = 0;
                    ShowPicWaitSec(ChoiceCancel,1);
                    break
                else
                    continue;
                end
            end
        end
        if GetSecs - t_start >= trial_duration % don't response
%             outp(port_address, 199);
%             WaitSecs(0.004);
%             outp(port_address, 0);
            response = 99;
            result.rt(6*j) = 6;
        end
        result.stimulus(6*j) = j;
        result.response(6*j) = response;
        warning on
    end
    % save data
    writetable(result, sprintf('result/exp1/sub_%d/block_%d.csv', subject, i));
    % rest
    if i < 3
%         outp(port_address, 66);
%         outp(port_address, 0);9  
        ShowPicWaitKey(BreakPic);
    end
end
%% finish
finish_image = imread('stimuli/finish.png');
ShowPicWaitKey(finish_image);
Screen('CloseAll');
ListenChar(0);
ShowCursor();
final_data = readtable(sprintf('result/exp1/sub_%d/block_1.csv', subject));
for i = 2:3
    final_data = vertcat(final_data, readtable(sprintf('result/exp1/sub_%d/block_%d.csv', subject, i)));
end
writetable(final_data, sprintf('result/exp1/sub_%d/result.csv', subject));

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
function fixation_duration = FlipFix(t,trial_duration)
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