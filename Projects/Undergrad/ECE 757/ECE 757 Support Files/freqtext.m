% freqtext.m frequency of occurrence of letters t and T 
% in the char variable textstring, e.g.
%  textstring='TasdfttTjkasT'
little=length(find(textstring=='t'));     % how many times t occurs
big=length(find(textstring=='T'));        % how many times T occurs
freq=(little+big)/length(textstring)      % percentage
