
function trussSupports = addSupports(ts)
    ts.trussSupports=[];
    redrawTruss(ts);
    
    title('Click on joint for pin support')
    [pinX,pinY] = ginput(1);
    pinX = round(pinX/ts.dx)*ts.dx;
    pinY = round(pinY/ts.dy)*ts.dy;
    plot(pinX,pinY,'b^','MarkerSize',15);

    title('Click on joint for roller support')
    [rollerX,rollerY] = ginput(1);
    rollerX = round(rollerX/ts.dx)*ts.dx;
    rollerY = round(rollerY/ts.dy)*ts.dy;
    ts.trussSupports = [pinX,pinY,rollerX,rollerY];
    redrawTruss(ts)
    
    trussSupports = [pinX,pinY,rollerX,rollerY];
end