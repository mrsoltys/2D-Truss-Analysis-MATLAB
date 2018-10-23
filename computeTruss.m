function [] = computeTruss(ts)
% This fills in the matrix Ax=B for the truss and solves it using x=A\B
%========
% Inputs:
% ts is a structure that contains the following fields:
%   * ts.trussMembers is a [nx4] matrix where n is the number of members. 
%       each row contains the x, y start and x, y stop coordnate of each 
%       member. 
%   * ts.trussSupports is a [1x4] matrix containing the x, y coordinates 
%       of the pin and roller, respectively
%   * ts.trussLoads is a [nx4] matrix where n is the number of loading points.
%       each row contains x and y coordinates of the loading points, 
%       as well as the x and y magnitude of the loading
%   * ts.trussForces contains x matrix of unknowns in Ax=B equation
%       its size shoud be [(N+3)x1], where N is the number of members. 
%=========
% Outputs:
% Updates ts with trussForces updated

% compute the length of each member and store this in memberLengths
for i=1:size(ts.trussMembers,1)
    memberLengths(i)=sqrt((ts.trussMembers(i,1)-ts.trussMembers(i,3))^2+...
        (ts.trussMembers(i,2)-ts.trussMembers(i,4))^2);
end

% Compute coordinate of each unique joint.
trussJoints = unique([ts.trussMembers(:,1:2);ts.trussMembers(:,3:4)],'rows');
% create empty A and B matrix. A should be [2J x 2J]m, B should be[2J x 1]
A = zeros(size(trussJoints,1)*2,size(trussJoints,1)*2);
B = zeros(size(trussJoints,1)*2,1);

% Fill in A matrix
% ================
for i=1:size(trussJoints,1)
    %Note: find X and y components for each member at each joint
    for j=1:size(ts.trussMembers,1)
        if isequal(trussJoints(i,:),ts.trussMembers(j,1:2)) 
            A(2*i-1,j)=(ts.trussMembers(j,3)-ts.trussMembers(j,1))/memberLengths(j);
            A(2*i,j)  =(ts.trussMembers(j,4)-ts.trussMembers(j,2))/memberLengths(j);
        elseif isequal(trussJoints(i,:),ts.trussMembers(j,3:4))
            A(2*i-1,j)=(ts.trussMembers(j,1)-ts.trussMembers(j,3))/memberLengths(j);
            A(2*i,j)  =(ts.trussMembers(j,2)-ts.trussMembers(j,4))/memberLengths(j);
        end
    end
    
    %don't forget unkowns at pin and roller
    if isequal(trussJoints(i,:),ts.trussSupports(1:2))
        A(2*i-1,j+1)=1;
        A(2*i,j+2)=1;
    elseif isequal(trussJoints(i,:),ts.trussSupports(3:4))
         A(2*i,j+3)=1;
    end
    
    % fill in B matrix with loading
    for j=1:size(ts.trussLoads,1)
        if isequal(trussJoints(i,:),ts.trussLoads(j,1:2))
            B(2*i-1,1)=ts.trussLoads(j,3);
            B(2*i,1)  =ts.trussLoads(j,4);
        end
    end
end

disp('Solving A\B with A:')
A
disp('and B:')
B
-A\B
ts.trussForces = -A\B;
redrawTruss(ts);