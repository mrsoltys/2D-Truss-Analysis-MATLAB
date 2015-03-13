function [trussMembers] = addMembers(ts);
title('Click two points to create a member. Retrace a member to delete it. Press Return when finished drawing truss.')

[x,y] = ginput(2);
while ~isempty(x)
    if x(1)>x(2)
        temp=x(1);x(1)=x(2);x(2)=temp;
        temp=y(1);y(1)=y(2);y(2)=temp;
    elseif x(1)==x(2) && y(1)>y(2)
        temp=x(1);x(1)=x(2);x(2)=temp;
        temp=y(1);y(1)=y(2);y(2)=temp;
    end
    
    roundedInput=[round(x(1)/ts.dx)*ts.dx, round(y(1)/ts.dy)*ts.dy,...
                  round(x(2)/ts.dx)*ts.dx, round(y(2)/ts.dy)*ts.dy];
    % Check for double click at point          
    if ~isequal(roundedInput(1:2),roundedInput(3:4))
        
        % Check for retracing segements
        delete=false;n=1;
        while n<=size(ts.trussMembers,1) && ~delete
            if isequal(ts.trussMembers(n,:), roundedInput)
                    ts.trussMembers(n,:)=[];
                    %%i = i-1;
                    delete=true;
            end
            n=n+1;
        end
        
        if delete %need to replot
            redrawTruss(ts)
            title('Click two points to create a member. Retrace a member to delete it. Press Return when finished drawing truss.')

        else % otherwise add the point and plot
            ts.trussMembers=[ts.trussMembers; roundedInput] ;
            %%i=i+1;
            plot([ts.trussMembers(size(ts.trussMembers,1),1), ts.trussMembers(size(ts.trussMembers,1),3)],...
                 [ts.trussMembers(size(ts.trussMembers,1),2), ts.trussMembers(size(ts.trussMembers,1),4)],...
                 'Color',[0.1,0.1,0.1],...
                 'LineWidth',3);
        end
    end    
    [x,y] = ginput(2)
    
    if isempty(x)
        if 2*size(unique([ts.trussMembers(:,1:2);ts.trussMembers(:,3:4)],'rows'),1)<...
                (size(unique(ts.trussMembers,'rows'),1)+3)
            warning('Truss is indeterminite')
            text(0,-.2,'Indeterminite');
        elseif 2*size(unique([ts.trussMembers(:,1:2);ts.trussMembers(:,3:4)],'rows'),1)>...
                (size(unique(ts.trussMembers,'rows'),1)+3)
            warning('Truss is not stable')
            text(0,-.2,'Not Stable');
        end
    end
end

trussMembers=ts.trussMembers;
end