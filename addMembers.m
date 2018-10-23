function [trussMembers] = addMembers(ts)
title('Click two points to create a member. Retrace a member to delete it. Press Return when finished drawing truss.')
% Get a pair of X,Y coordnates using the mouse as an input
[x1,y1] = ginput(1);
%Keep getting points until I say so...
while ~isempty(x1)
    %Check for offscreen click
        if x1<0
            break;
        else
            [x2,y2] = ginput(1);
        end 
        
    % Round input to grid coordinates
    x1=round(x1/ts.dx)*ts.dx;
    x2=round(x2/ts.dx)*ts.dx;
    y1=round(y1/ts.dy)*ts.dy;
    y2=round(y2/ts.dy)*ts.dy;
    
    %If start point is bigger than endpoint, swap them
    if x1>x2
        temp=x1;x1=x2;x2=temp;
        temp=y1;y1=y2;y2=temp;
    elseif x1==x2 && y1>y2
        temp=x1;x1=x2;x2=temp;
        temp=y1;y1=y2;y2=temp;
    end
    
    %Save the member as the same format as in the trussMembers struct:
    newMember= [x1, y1, x2, y2];
     
    delete=false;
    % Ignore the input if user double clicks at point          
    if isequal([x1 y1],[x2 y2])
        delete=true;
    end
    
    % Check for retracing segements
    n=1;
    while n<=size(ts.trussMembers,1) && ~delete
        % check for matching segment
        if isequal(ts.trussMembers(n,:), newMember)
            delete=true;
            % delete the member
            ts.trussMembers(n,:)=[];
        end
        n=n+1;
    end
        
    % Add the newMember to the trussMembers matrix
    if ~delete
        ts.trussMembers=[ts.trussMembers; newMember]
    end
    
    %Redraw the truss.
    redrawTruss(ts);
    title('Click two points to create a member. Retrace a member to delete it. Press Return when finished drawing truss.')
        
    %Get next 2 points
    [x1,y1] = ginput(1);
end

%Check for Indeterminite Truss
if 2*size(unique([ts.trussMembers(:,1:2);ts.trussMembers(:,3:4)],'rows'),1)<...
        (size(unique(ts.trussMembers,'rows'),1)+3)
      prompt={'The truss is indeterminite.Would you like to fix your truss?' };
      name = 'Warning: Indeterminite Truss';
      defaultans = {'yes'};
      options.Interpreter = 'tex';
      answer = inputdlg(prompt,name,[1 40],defaultans,options);

      %comparing user answer to fix truss
      if strcmp(char(lower(answer)),'yes')
        ts.trussMembers = addMembers(ts);
      end
%Check for unstable truss
elseif 2*size(unique([ts.trussMembers(:,1:2);ts.trussMembers(:,3:4)],'rows'),1)>...
            (size(unique(ts.trussMembers,'rows'),1)+3)
      prompt={'The truss is unstable, would you like to fix your truss?' };
      name = 'Warning: Unstable Truss';
      defaultans = {'yes'};
      options.Interpreter = 'tex';
      answer = inputdlg(prompt,name,[1 40],defaultans,options);

      %comparing user answer to fix truss
      if strcmp(char(lower(answer)),'yes') 
          ts.trussMembers = addMembers(ts);
      end
end

trussMembers=ts.trussMembers;
end