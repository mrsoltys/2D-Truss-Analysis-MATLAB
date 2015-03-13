function [] = computeTruss(ts)
for i=1:size(ts.trussMembers,1);
    memberLengths(i)=sqrt((ts.trussMembers(i,1)-ts.trussMembers(i,3))^2+...
        (ts.trussMembers(i,2)-ts.trussMembers(i,4))^2);
end

trussJoints = unique([ts.trussMembers(:,1:2);ts.trussMembers(:,3:4)],'rows');
% Need to make a 2J x 2J matrix, and a 2J x 1 matrix of loadings
solvMat=zeros(size(trussJoints,1)*2,size(trussJoints,1)*2);
rhs    =zeros(size(trussJoints,1)*2,1);
for i=1:size(trussJoints,1)
    %Note, find X and y components at each joint
    for j=1:size(ts.trussMembers,1)
        if isequal(trussJoints(i,:),ts.trussMembers(j,1:2)) 
            solvMat(2*i-1,j)=(ts.trussMembers(j,3)-ts.trussMembers(j,1))/memberLengths(j);
            solvMat(2*i,j)  =(ts.trussMembers(j,4)-ts.trussMembers(j,2))/memberLengths(j);
        elseif isequal(trussJoints(i,:),ts.trussMembers(j,3:4))
            solvMat(2*i-1,j)=(ts.trussMembers(j,1)-ts.trussMembers(j,3))/memberLengths(j);
            solvMat(2*i,j)  =(ts.trussMembers(j,2)-ts.trussMembers(j,4))/memberLengths(j);
        end
    end
    
    %don't forget pin and roller
    if isequal(trussJoints(i,:),ts.trussSupports(1:2))
        solvMat(2*i-1,j+1)=1;
        solvMat(2*i,j+2)=1;
    elseif isequal(trussJoints(i,:),ts.trussSupports(3:4))
         solvMat(2*i,j+3)=1;
    end
    
    for j=1:size(ts.trussLoads,1)
        if isequal(trussJoints(i,:),ts.trussLoads(j,1:2))
            rhs(2*i-1,1)=ts.trussLoads(j,3);
            rhs(2*i,1)  =ts.trussLoads(j,4);
        end
    end
    
end

ts.trussForces = -solvMat\rhs
redrawTruss(ts);