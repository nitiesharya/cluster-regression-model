
function  PLOT_TRAIN_TEST_m(K,tspan,tspan_V,trainPoints,xMODEL_train_m,xMODEL_test_m,centroids,X_ORG)


SOLUTION_train_m = zeros(trainPoints-5,3);
SOLUTION_test_m = zeros(trainPoints-5,3);
 

SOLUTION_train_m(:,1) = xMODEL_train_m(:,1:K)*centroids(:,1);
SOLUTION_train_m(:,2) = xMODEL_train_m(:,K+1:2*K)*centroids(:,2);
SOLUTION_train_m(:,3) = xMODEL_train_m(:,2*K+1:3*K)*centroids(:,3);



SOLUTION_test_m(:,1) = xMODEL_test_m(:,1:K)*centroids(:,1);
SOLUTION_test_m(:,2) = xMODEL_test_m(:,K+1:2*K)*centroids(:,2);
SOLUTION_test_m(:,3) = xMODEL_test_m(:,2*K+1:3*K)*centroids(:,3);


x1 = X_ORG(:,1);
x2 = X_ORG(:,2);
x3 = X_ORG(:,3);

SOLUTION_train_FINAL_m(:,1) = min(x1(1:end)) + SOLUTION_train_m(:,1)*(max(x1(1:end)) - min(x1(1:end)));
SOLUTION_train_FINAL_m(:,2) = min(x2(1:end)) + SOLUTION_train_m(:,2)*(max(x2(1:end)) - min(x2(1:end)));
SOLUTION_train_FINAL_m(:,3) = min(x3(1:end)) + SOLUTION_train_m(:,3)*(max(x3(1:end)) - min(x3(1:end)));

SOLUTION_test_FINAL_m(:,1) = min(x1(1:end)) + SOLUTION_test_m(:,1)*(max(x1(1:end)) - min(x1(1:end)));
SOLUTION_test_FINAL_m(:,2) = min(x2(1:end)) + SOLUTION_test_m(:,2)*(max(x2(1:end)) - min(x2(1:end)));
SOLUTION_test_FINAL_m(:,3) = min(x3(1:end)) + SOLUTION_test_m(:,3)*(max(x3(1:end)) - min(x3(1:end)));


%%  PLot X

 figure(10)
 graycolor = [0.7 0.7 0.7];
  plot (tspan(3:end-3),X_ORG(3:(end-1)/2-2,1),'LineWidth',6,'Color',graycolor,LineStyle='-');
  hold on;
  plot (tspan_V,X_ORG((end-1)/2+1:end,1),'LineWidth',5,'Color',graycolor,LineStyle='-');
  hold on;
  plot (tspan(3:end-3),SOLUTION_train_FINAL_m(:,1),'Color','b','LineWidth',3);
  hold on;
  plot (tspan_V(1:end-5),SOLUTION_test_FINAL_m(:,1),'Color','g','LineWidth',3);
  box off;
   grid on;
%   grid minor;
  xlabel('$t$', Interpreter='latex');
  ylabel('$X$', Interpreter='latex');

yticks([-20 0 20])

 ax = gca;
 ax.XAxis.FontSize = 30;
 ax.YAxis.FontSize = 30;
 ax.TickLabelInterpreter = 'latex';
 ax.LineWidth=2;


 %%  PLot Y

 figure(11)
 graycolor = [0.7 0.7 0.7];
  plot (tspan(3:end-3),X_ORG(3:(end-1)/2-2,2),'LineWidth',6,'Color',graycolor,LineStyle='-');
  hold on;
  plot (tspan_V,X_ORG((end-1)/2+1:end,2),'LineWidth',5,'Color',graycolor,LineStyle='-');
  hold on;
  plot (tspan(3:end-3),SOLUTION_train_FINAL_m(:,2),'Color','b','LineWidth',3);
  hold on;
  plot (tspan_V(1:end-5),SOLUTION_test_FINAL_m(:,2),'Color','g','LineWidth',3);
  box off;
   grid on;
%   grid minor;
  xlabel('$t$', Interpreter='latex');
  ylabel('$Y$', Interpreter='latex');

yticks([-20 0 20])

 ax = gca;
 ax.XAxis.FontSize = 30;
 ax.YAxis.FontSize = 30;
 ax.TickLabelInterpreter = 'latex';
 ax.LineWidth=2;


 %%  PLot Z

 figure(12)
 graycolor = [0.7 0.7 0.7];
  plot (tspan(3:end-3),X_ORG(3:(end-1)/2-2,3),'LineWidth',6,'Color',graycolor,LineStyle='-');
  hold on;
  plot (tspan_V,X_ORG((end-1)/2+1:end,3),'LineWidth',5,'Color',graycolor,LineStyle='-');
  hold on;
  plot (tspan(3:end-3),SOLUTION_train_FINAL_m(:,3),'Color','b','LineWidth',3);
  hold on;
  plot (tspan_V(1:end-5),SOLUTION_test_FINAL_m(:,3),'Color','g','LineWidth',3);
  box off;
   grid on;
%   grid minor;
  xlabel('$t$', Interpreter='latex');
  ylabel('$Z$', Interpreter='latex');

%yticks([ 0 10])

 ax = gca;
 ax.XAxis.FontSize = 30;
 ax.YAxis.FontSize = 30;
 ax.TickLabelInterpreter = 'latex';
 ax.LineWidth=2;

end