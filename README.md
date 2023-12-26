# Cluster regression model for control of complex dynamical systems
A matlab library for construction of cluster based, deterministic model for control of high dimensional systems using limited measurements.
For details please see [arXiv](https://arxiv.org/abs/2312.14186).

The code does the following
- Generates time series data for the forced Lorenz system
- Clusters the Lorenz attractor using kmeans clustering
- Generates a predictive model for the trajectories based on cluster centroids
- Drive the trajectory towards a point located outside the attractor

Run ALLRUN.m 

To employ the model for flow control using existing CFD codes please contact [me](https://www.linkedin.com/in/nitiesharya)
