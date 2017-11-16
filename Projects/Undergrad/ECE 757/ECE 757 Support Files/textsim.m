% textsim.m use (large) text to simulate transition probabilities
m=1;                                  % # terms for transition
linelength=60;                        % # letters in each line
load OZ.mat                           % file for input
n=text(1:m); nline=n; nlet='x';       % initialize variables
for i=1:100                           % # lines in output
  j=1;
  while j<linelength | nlet~=' '      % scan through file
    k=findstr(text,n);                % all occurrences of seed
    ind=round((length(k)-1)*rand)+1;  % pick one
    nlet=text(k(ind)+m);
    if abs(nlet)==13                  % treat carriage returns
      nlet=' ';                       % as spaces
    end
    nline=[nline, nlet];              % add next letter
    n=[n(2:m),nlet];                  % new seed
    j=j+1;
  end
  disp([nline setstr(13)])            % format output/ add CRs
  nline='';                           % initialize next line
end
