%%
function [Err] = PLOT_MPC(K,xU,xHistory,tHistory,uHistory,centroids,X_ORG)
sizeMPC = size(tHistory,2);
SOLUTION_MPC = zeros(sizeMPC,3);
SOLUTION_MPC_FINAL = zeros(sizeMPC,3);

x1 = X_ORG(:,1);
x2 = X_ORG(:,2);
x3 = X_ORG(:,3);

SOLUTION_MPC(:,1) = xHistory(:,1:K)*centroids(:,1);
SOLUTION_MPC(:,2) = xHistory(:,K+1:2*K)*centroids(:,2);
SOLUTION_MPC(:,3) = xHistory(:,2*K+1:3*K)*centroids(:,3);


SOLUTION_MPC_FINAL(:,1) = min(x1(1:end)) + SOLUTION_MPC(:,1)*(max(x1(1:end)) - min(x1(1:end)));
SOLUTION_MPC_FINAL(:,2) = min(x2(1:end)) + SOLUTION_MPC(:,2)*(max(x2(1:end)) - min(x2(1:end)));
SOLUTION_MPC_FINAL(:,3) = min(x3(1:end)) + SOLUTION_MPC(:,3)*(max(x3(1:end)) - min(x3(1:end)));

%%

figure(15)
graycolor = [0.7 0.7 0.7];


ref1 = -15.5788;
ref2 = -4.4200;
ref3 = 25.4147;

%xtrain_valid = [x;xA];

scatter3 (SOLUTION_MPC_FINAL(:,1),SOLUTION_MPC_FINAL(:,2),SOLUTION_MPC_FINAL(:,3),"filled");
hold on;
plot3 (xU(:,1),xU(:,2),xU(:,3),'Color',graycolor,'LineWidth',2);
hold on;
h = scatter3(-15.5788,-4.4200,25.4147,100,"filled",MarkerEdgeColor='black');
h.SizeData = 200;
h.MarkerFaceColor = "red";
h.Marker = "o";

box off;
grid on;
grid minor;
xlabel('$X$', Interpreter='latex');
ylabel('$Y$', Interpreter='latex');
zlabel('$Z$', Interpreter='latex');

yticks([-10 0 10])
xticks([-10 0 10])
zticks([0 20 40])
ax = gca;
ax.XAxis.FontSize = 20;
ax.YAxis.FontSize = 20;
ax.ZAxis.FontSize = 20;
ax.TickLabelInterpreter = 'latex';
ax.LineWidth = 1.2;
view([-150 15]);
end