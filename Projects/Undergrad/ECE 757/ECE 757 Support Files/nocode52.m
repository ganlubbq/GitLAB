% nocode52.m

text1=' Here is a very secret message for your eyes only: 213465listen ';
text2=' WOLF, meeting with a Lamb astray from the fold, do not to lay violent hands on him, but to find some plea to justify to the Lamb the Wolfs right to eat him.  He thus addressed him: "Sirrah, last year you grossly insulted me."  "Indeed," bleated the Lamb in a mournful tone of voice, "I was not then born."  Then said the Wolf, "You feed in my pasture."  "No, good sir," replied the Lamb, "I have not yet tasted grass."  Again said the Wolf, "You drink of my well."  "No," exclaimed the Lamb, "I never yet drank water, for as yet my mothers milk is both food and drink to me."  Upon which the Wolf seized him and ate him up, saying, "Well! I wont remain supperless, even though you refute every one of my imputations."  The tyrant will always find a pretext for his tyranny. ';
n=text2bin(text2);                           % change text into 7 bit binary using text2bin

% Here's where the (5,2) block encoding goes
% The output of the coding process is a binary vector
% containing the coded message

coded_txt=n;

j=1; mpam=zeros(1,ceil(length(coded_txt)/2));  % change 0-1 codewords to 4-PAM
for i=1:2:length(coded_txt)-1                  % and then into 4-PAM
  if coded_txt(i:i+1)==[0,0]
    mpam(j)=-3;
  elseif coded_txt(i:i+1)==[0,1]
    mpam(j)=-1;
  elseif coded_txt(i:i+1)==[1,0]
    mpam(j)=1;
  elseif coded_txt(i:i+1)==[1,1]
    mpam(j)=3;
  end
  j=j+1;
end

% transmitter and receiver go here

varnoise=0.0;                             % amount of noise to add
r=mpam+varnoise*randn(size(mpam));        % add noise to 4-PAM signal
j=1; y=zeros(1,2*length(mpam));
rq=quantalph(r,[-3,-1,1,3]);              % quantize back to 4-PAM
for i=1:length(r)                         % translate back into 0-1 binary
  if rq(i)==3
    y(j:j+1)=[1,1];
  elseif rq(i)==1
    y(j:j+1)=[1,0];
  elseif rq(i)==-1
    y(j:j+1)=[0,1];
  elseif rq(i)==-3
    y(j:j+1)=[0,0];
  end
  j=j+2;
end

% Here's where the (5,2) block decoding goes
% The output of the decoding process is a binary vector
% that can be translated back into text with bin2text

% meaure how well it all went

ytext=bin2text(y)
numerr=length(find(ytext~=text2))
