function [TimeCourseSim,flux,statenames, reactions] = getTimeCourseSim(t,init_conc,param_k,slope,opt)
%%    function for extraction of time courses 
%%    from simulation results of "getTimeCourseSimRaw"
%%
result = getTimeCourseSimRaw(t,init_conc,param_k,slope,opt);

TimeCourseSim = result.statevalues;
flux = result.reactionvalues;
statenames = result.states;
reactions = result.reactions;

end

function result = getTimeCourseSimRaw(t,init_conc,param_k,slope,Opt)
%% 
%%    function for simulation 
%%
	param = [param_k,slope];
	% parameters for mex ode
	opt.abstol = 1e-12;		% absolute accuracy
	opt.reltol = 1e-6;		% relative precision
	opt.maxnumsteps = 1e+7;	% Maximum Step
	% simulation of the mex model
    switch Opt.modeltype
        case {'Ssystem_Y'}
            result = Insulinmodel_Ssystem_Y_mex(t,init_conc,param,opt);             
    end

 
end