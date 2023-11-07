

U_Matrix = zeros(nPoints,10);
%b = zeros(1,3);
%a = zeros(1,3);

for i = 1:nPoints
   
    b = [x(i,1) x(i,2)  x(i,3)];
    for j = 1:10
        a = [centroids(j,1) centroids(j,2) centroids(j,3)];
        % computing distnaces
        distance_matrix(i,j) = norm(b-a);
    end 

end