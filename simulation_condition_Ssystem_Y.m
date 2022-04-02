

function [param_k, init_conc, slope] = simulation_condition_Y(estimated_param, Timecourse,TimecourseX, t, opt,i)
%%      function for preparation of model structure 
%%      and initial values for simulation 
param_k = zeros(1,4);

switch opt.model 
case {'model1'}     
  param_k(1) = 1;
  param_k(2) = estimated_param(2);
  param_k(3) = 1;
  param_k(4) = estimated_param(3);
  param_k(5) = estimated_param(4);
  param_k(6) = estimated_param(5); 
  param_k(7) = 1; 
case {'model2'} 
  param_k(1) = 1;
  param_k(2) = estimated_param(2);
  param_k(3) = 1;
  param_k(4) = estimated_param(3);
  param_k(5) = estimated_param(4);
  param_k(6) = -1*estimated_param(5); 
  param_k(7) = 1;
case {'model3'} 
  param_k(1) = 1;
  param_k(2) = estimated_param(2);
  param_k(3) = 1;
  param_k(4) = -1*estimated_param(3);
  param_k(5) = estimated_param(4);
  param_k(6) = estimated_param(5); 
  param_k(7) = 1;
 case {'model4'} 
  param_k(1) = 1;
  param_k(2) = estimated_param(2);
  param_k(4) = -1*estimated_param(3);
  param_k(5) = estimated_param(4);
  param_k(6) = -1*estimated_param(5); 
  param_k(7) = 1;
case {'model5'} 
  param_k(1) = 1;
  param_k(2) = estimated_param(2);
  param_k(4) = 0;
  param_k(5) = estimated_param(4);
  param_k(6) = estimated_param(5); 
  param_k(7) = 1;
case {'model6'} 
  param_k(1) = 1;
  param_k(2) = estimated_param(2);
  param_k(4) = 0;
  param_k(5) = estimated_param(4);
  param_k(6) = -1*estimated_param(5); 
  param_k(7) = 1;         
case {'model7'} 
  param_k(1) = 1;
  param_k(2) = estimated_param(2);
  param_k(4) = estimated_param(3);
  param_k(5) = estimated_param(4);
  param_k(6) = 0;
  param_k(7) = 1; 
 case {'model8'} 
  param_k(1) = 1;
  param_k(2) = estimated_param(2);
  param_k(3) = 1;
  param_k(4) = -1*estimated_param(3);
  param_k(5) = estimated_param(4);
  param_k(6) = 0;
  param_k(7) = 1;          
end     
X = TimecourseX(1); 
A = Timecourse(1);

Y = X * param_k(1)/param_k(2);
slope = zeros(1,length(t)-1);
for i = 1:length(t)-1
slope(i) = (TimecourseX(i+1,1) - TimecourseX(i,1)) / (t(i+1)-t(i));
end
param_k(3) = (A^param_k(7))*param_k(5)*Y^(param_k(6)-param_k(4));%
init_conc = [X Y A]; 
end