function [] = redrawTruss(ts, h)
    if nargin == 1; h=gca; end;
    %figure(1);
    cla;
    
    % set axis to give us some extra space
    axis([0 ts.dx*ts.nx 0 ts.dy*ts.ny]);
    ax = gca;
    ax.XTick = 0:ts.dx:ts.dx*ts.nx;
    ax.YTick = 0:ts.dy:ts.dy*ts.ny;
    grid on;hold on;
    
    maxF=max(abs(ts.trussForces));  
    
    for n=1:size(ts.trussMembers,1) 
        if isempty(ts.trussForces)
            lineColor=[0,0,0];
        elseif ts.trussForces(n)>0
            lineColor=[0,0,abs(ts.trussForces(n))/maxF];
        else
            lineColor=[abs(ts.trussForces(n))/maxF,0,0];
        end
        
        plot([ts.trussMembers(n,1), ts.trussMembers(n,3)],...
            [ts.trussMembers(n,2), ts.trussMembers(n,4)],...
            'Color',lineColor,...
            'LineWidth',3);
        if ~isempty(ts.trussForces)
            text((ts.trussMembers(n,1)+ts.trussMembers(n,3))/2,(ts.trussMembers(n,2)+ts.trussMembers(n,4))/2,...
                num2str(ts.trussForces(n),3),...
                'horizontalAlignment', 'center',...
                'BackgroundColor',[1 1 1],...
                'FontSize',12,...
                'FontName','Tahoma')
        end
    end
    
    if ~isempty(ts.trussSupports)
        plot(ts.trussSupports(1),ts.trussSupports(2),'b^','MarkerSize',15);
        plot(ts.trussSupports(3),ts.trussSupports(4),'bo','MarkerSize',15);
    end
    
    for n=1:size(ts.trussLoads,1)
        x=ts.trussLoads(n,1);
        y=ts.trussLoads(n,2);
        Fx=ts.trussLoads(n,3);
        Fy=ts.trussLoads(n,4);
        axPos = get(h,'Position'); %# gca gets the handle to the current axes
        xMinMax = xlim;
        yMinMax = ylim;
        arrowEndX = axPos(1) + ((x - xMinMax(1))/(xMinMax(2)-xMinMax(1))) * axPos(3);
        arrowEndY = axPos(2) + ((y - yMinMax(1))/(yMinMax(2)-yMinMax(1))) * axPos(4);
        arrowStartX = axPos(1) + ((x-Fx*.08 - xMinMax(1))/(xMinMax(2)-xMinMax(1))) * axPos(3);
        arrowStartY = axPos(2) + ((y-Fy*.08 - yMinMax(1))/(yMinMax(2)-yMinMax(1))) * axPos(4);

         annotation('textarrow',...
             [arrowStartX,arrowEndX],[arrowStartY,arrowEndY],...
             'String',num2str(sqrt(Fx^2+Fy^2),3))
    end