function trussLoads=addLoads(ts)
    title('Click on joint to apply loading. Press Return when finished.')
    [x,y] = ginput(1);
    while ~isempty(x)
        x = round(x/ts.dx)*ts.dx;
        y = round(y/ts.dy)*ts.dy;
        
        %Check for repeating loads
        repeat = false;i=1;
        while i<=size(ts.trussLoads,1) && ~repeat
            if isequal([x,y],ts.trussLoads(i,(1:2)))
                repeat = true;
            else
                i=i+1;
            end
        end
        
        %Prompt User for Input
        prompt = {'$F_x$ [kips/kN]',...
                '$F_y$ [kips/kN]'};
        dlg_title = 'Enter Loads';
        num_lines = 1;
        if repeat
            def = {num2str(ts.trussLoads(i,3)),...
                   num2str(ts.trussLoads(i,4))};
        else
            def = {'1','-1.5'};
        end
        
        answer =  inputdlg(prompt,dlg_title,num_lines,def);
        Fx=str2num(answer{1});
        Fy=str2num(answer{2});
        
        if ~repeat
            ts.trussLoads = [ts.trussLoads;...
                         [x,y,Fx,Fy]];
        else
            ts.trussLoads(i,:) = [x,y,Fx,Fy];
        end
        
        redrawTruss(ts);
        %Plot Load 
        %Note: Might make Plot Loads a different function to call after
        %calculations also...

        
        [x,y] = ginput(1);
    end

trussLoads=ts.trussLoads;        
end