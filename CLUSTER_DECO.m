
function [Weight_matrix,Weight_matrix_V] = CLUSTER_DECO(X,centroids,trainPoints)

Weight_matrix_X = X(1:trainPoints,1)*pinv(centroids(:,1));
Weight_matrix_Y = X(1:trainPoints,2)*pinv(centroids(:,2));
Weight_matrix_Z = X(1:trainPoints,3)*pinv(centroids(:,3));

Weight_matrix = [Weight_matrix_X Weight_matrix_Y Weight_matrix_Z];



Weight_matrix_XV = X(trainPoints+1:2*trainPoints-1,1)*pinv(centroids(:,1));
Weight_matrix_YV = X(trainPoints+1:2*trainPoints-1,2)*pinv(centroids(:,2));
Weight_matrix_ZV = X(trainPoints+1:2*trainPoints-1,3)*pinv(centroids(:,3));

Weight_matrix_V = [Weight_matrix_XV Weight_matrix_YV Weight_matrix_ZV];

end