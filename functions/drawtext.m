clear;clc;
sca;
KbName('UnifyKeyNames');
% 打开窗口
[wPtr, rect] = Screen('OpenWindow', 0, [122, 122, 122], [0, 0, 1920, 1080]);

pw=1920;  %screen size pixel
ph=1080;
viewDist=80; % 眼睛距离屏幕的距离，文中提到大概80
ScrWidth=26; % 屏幕宽
ScrHeight=27;%屏幕高
%now calculate how many pixels correspond to 1 deg visual angle
widthDeg = round(2*180*atan(ScrWidth/(2*viewDist))/pi); % visual angle deg of the ScrWidth
deg2pix  = round(pw/widthDeg);

% 设置字体和颜色
Screen('TextFont', wPtr, 'Microsoft YaHei'); 
Screen('TextColor', wPtr, 30); % 文字颜色设置为30（灰色）
Screen('TextStyle', wPtr, 1);


% 定义每一行文字及其字号 
size_ = floor(0.4*deg2pix); 

for k=1:9
    s = sprintf('%d',k);
    damage = '其他  ';           
    id=sprintf([damage, '     名']);

texts={
'士兵       名',505,size_;
id,575,size_;
};

Screen('TextSize',wPtr,size_);
DrawFormattedText(wPtr, double(s), 1000, 505, [255, 255, 255]);
DrawFormattedText(wPtr, double('0'), 1000 , 575, [255, 255, 255]);

% 遍历每一行文字并绘制
for i = 1:size(texts, 1)        
Screen('TextSize',wPtr,texts{i, 3});
        DrawFormattedText(wPtr, double(texts{i, 1}), 'Center', texts{i,2}, [255, 255, 255]);
end



t = Screen('Flip', wPtr);

while KbCheck(), end 
while GetSecs - t < 10 
    [keyIsDown, t_end, keyCode] = KbCheck();
       if keyIsDown
                if  keyCode(KbName('space'))
                    break;
                elseif keyCode(KbName('ESCAPE'))
                    sca;
                else 
                    continue;
                end
       end
end
end
sca;
%% 指导语部分
% texts = {
%     '实验任务:', 400 , size_;
%     '请想象你的国家和另一个国家之间发生了战争。', 480, size_;
%     '你的国家发射了一些导弹打击敌国的士兵，但同时也可能造成一定的平民伤亡。', 535 , size_;
%     '你作为军队的指挥官将会收到一系列战报，报告了某次导弹发射造成的伤亡数量。', 590 , size_;
%     '伤亡数量包括成功击杀的敌国士兵数量，以及误杀的平民数量（被称为附带伤害）。', 645 , size_;
%     '战报中有发射任务成功，击杀了一定数量的敌国士兵的战报；', 700, size_;
%     '也有任务失败，没有击杀任何士兵的战报。',755,size_;
%     '为了总结失败的经验，你需要把任务失败的战报标记出来。',810,size_;
%     '按下空格键进行标记。',865,size_'
%     '实验总共大概35分钟。', 950 , size_;
%     '请集中注意力，保持头不动，尽量不眨眼。', 1000 , size_;
%     '按任意键继续', 105 0, size_
%     };
% 
%% 练习部分

% texts = {
%     '练习任务:', 550 , size_;
%     '接下来将进行15次的练习。', 630, size_;
%     '请在看到任务失败的战报时按下空格键进行标记。', 685 , size_;
%     '在正确地标记了任务失败的战报之后会呈现绿色的  ；', 740 , size_;
%     '反之，在错误地标记了成功任务，或者没有标记失败任务之后，会呈现红色的  。', 795, size_;
%     '练习部分大概1分钟。', 875 , size_;
%     '请集中注意力，保持头不动，尽量不眨眼。', 925 , size_;
%     '按任意键继续', 975, size_
%     };
% DrawFormattedText(wPtr, '                                                                                                              ×', 'Center', 795, [255, 0, 0]);
% DrawFormattedText(wPtr, '                                                                       √', 'Center', 740, [0, 255, 0]);


%% 正式实验
% texts = {
%     '正式实验部分:', 530 , size_;
%     '接下来将开始正式实验，你会收到一系列战报。', 610, size_;
%     '屏幕上会呈现导弹发射造成的士兵伤亡和平民伤亡。', 665 , size_;
%     '请在看到任务失败的战报时按下空格键进行标记。', 720 , size_;
%     '正式实验部分不会出现绿色的   或者红色的  。',775,size_;
%     '正式实验部分大概持续30分钟。', 880 , size_;
%     '请集中注意力，保持头不动，尽量不眨眼。', 940 , size_;
%     '按任意键继续', 1000, size_
%     };
% DrawFormattedText(wPtr, '                      √', 'Center', 775, [0, 255, 0]);
% DrawFormattedText(wPtr, '                                                              ×  ', 'Center', 775, [255, 0, 0]);


%% 实验刺激部分
% for k=1:5
%         switch k
%             case 1
%                 damage='儿童   ';
%             case 2
%                 damage='孕妇   ';
%             case 3  
%                 damage='瘾君子';
%             case 4
%                 damage='罪犯   ';
%             case 5
%                 damage='平民   ';
%         end
%             
%     id=sprintf([damage, '     名']);
% 
% texts={
% '士兵        名',505,size_;    
% id,575,size_;
% };
% % 把后面一个end补上

% %放在实验程序里
% Screen('TextSize',wPtr,size_);
% DrawFormattedText(wPtr, double('5'), 1000, 505, [255, 255, 255]);
% DrawFormattedText(wPtr, double('0'), 1000, 575, [255, 255, 255]);
%% distractor
% for k=1:9
%     s = sprintf('%d',k);
%     damage = '其他  ';           
%     id=sprintf([damage, '     名']);
% 
% texts={
% '士兵       名',505,size_;
% id,575,size_;
% };
% 
% Screen('TextSize',wPtr,size_);
% DrawFormattedText(wPtr, double(s), 1000, 505, [255, 255, 255]);
% DrawFormattedText(wPtr, double('0'), 1000 , 575, [255, 255, 255]);
