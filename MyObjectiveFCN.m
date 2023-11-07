function J = MyObjectiveFCN(uopt,x,N,xref,u0,p,Q,R,Ru,K,centroids,var1,var2,var3)
%% Cost function of nonlinear MPC for HIV system
%
% Inputs:
%   u:      optimization variable, from time k to time k+N-1
%   x:      current state at time k
%   Ts:     controller sample time
%   N:      prediction horizon
%   xref:   state references, constant from time k+1 to k+N
%   u0:     previous controller output at time k-1
%
% Output:
%   J:      objective function cost
%

Nvar = length(x);
%% Nonlinear MPC design parameters
%Q = diag([1,1,1])
% R = 0.01;

u = uopt;
% u = zeros(N,1);
% u(1:Nu) = uopt;
% if Nu<N
%     u(1:Nu+1:N) = uopt(end);
% end
%% Integrate system


    Ns = size(x,1);
    xk = zeros(Ns,N+1); xk(:,1) = x;
    for ct=1:N
        % Obtain plant state at next prediction step.
        lib_func(1,:) = [xk(var1,ct) xk(var2,ct) xk(var3,ct)];
        xk(:,ct+1) = rk4u_m(@sparseGalerkinControl_Discrete_m,xk(:,ct),u(ct),p.dt,1,[],lib_func,var1,var2,var3,p);
    end
    xk = xk(:,2:N+1);

%% Cost Calculation
% Set initial plant states, controller output and cost.
uk = u(1);
J = 0;
% Loop through each prediction step.
for ct=1:N
    % Obtain plant state at next prediction step.
    
    xk1 = xk(:,ct);
   
    weight_temp = xk1.';

    %------CALC DIST FROM FIXED POINT LIKE EURIKA----

    xt = weight_temp(1,1:K)*centroids(:,1);
    yt = weight_temp(1,K+1:2*K)*centroids(:,2);
    zt = weight_temp(1,2*K+1:3*K)*centroids(:,3);
  
    XT = [xt yt zt]';

    %------------------------------------------------

    dist_x = weight_temp(1,1:K)*centroids(:,1) - centroids(:,1).';
    dist_y = weight_temp(1,K+1:2*K)*centroids(:,2) - centroids(:,2).';
    dist_z = weight_temp(1,2*K+1:3*K)*centroids(:,3) - centroids(:,3).';

    dist_ptsToclustr = (abs(dist_x)).^2 + (abs(dist_y)).^2 + (abs(dist_z)).^2;
    dist_ptsToclustr = dist_ptsToclustr.^(1/2);

    [out,idx] = sort(dist_ptsToclustr);

    dist_x = dist_x.';  dist_y = dist_y.'; dist_z = dist_z.';
    dist = [dist_x dist_y dist_z];
  

    %dist1 = dist(idx,:);

    clustrIndexMPC = idx(1);

    %nextCluster = findNextCluster(clustrIndexMPC); 

    % accumulate state tracking cost from x(k+1) to x(k+N).
      J = J + (XT-xref)'*Q*(XT-xref);
    

     %------THIS ONE USED for cluster based control---------------------------------- 
     %J = J + ((dist(nextCluster,:))*Q*(dist(nextCluster,:))');
     %--------------------------------------------------------
     %J = J + ((dist(1,:) + dist(2,:) + dist(5,:) + dist(4,:))*Q*(dist(1,:) + dist(2,:) + dist(5,:) + dist(4,:))');
     %J = J + norm((dist(1,:))*Q*(dist(1,:))') + norm((dist(2,:))*Q*(dist(2,:))') + norm((dist(5,:))*Q*(dist(5,:))') + norm((dist(4,:))*Q*(dist(4,:))');
  
    % accumulate MV rate of change cost from u(k) to u(k+N-1).
    if ct==1
        J = J + ((uk-u0)'*R*(uk-u0)) + Ru*abs(uk);
    else
        J = J + ((uk-u(ct-1))'*R*(uk-u(ct-1))) +Ru*abs(uk);
    end
    % Update uk for the next prediction step.
    if ct<N
        uk = u(ct+1);
    end
end