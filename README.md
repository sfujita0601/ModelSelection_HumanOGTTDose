# Overview
S system insulin model analysis for human OGTT data

# Contentes
- `simulation_condition_Ssystem_Y.m`  
A MATLAB script to set model structure and initial values.  
- `MoelAnal_DivBC.m`  
A MATLAB script to run data generation and simulation.  
- `make_Insulindata_BCDiv.m`  
A MATLAB script to generate `.mat` data  
- `Insulinmodel_Ssystem_Y_mex.mexmaci64`  
Mexed model.  
- `getTimeCourseSim.m`  
A MATLAB script to run simulations with mexed model.    
- `fminsearchbnd.m`, `copasiep.m`  
MATLAB scripts for optimization.  

# Requirements
This programs has been tested on the following.  
MATLAB R2021a 

# Data
Data used for S system insulin model analysis is not yet available.

# matfile  
`.mat` data used for simulation is not yet available.


# Reference
Fujita, S., Karasawa, Y., Fujii, M., Hironaka, K., Uda, S., Kubota, H., Inoue, H., Sumitomo, Y., Hirayama, A., Soga, T., & Kuroda, S. (2022). Four features of temporal patterns characterize similarity among individuals and molecules by glucose ingestion in humans. Npj Systems Biology and Applications 2022, 8(1), 1–16. https://doi.org/10.1038/s41540-022-00213-0

