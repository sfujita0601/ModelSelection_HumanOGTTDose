function ModelAnal 
%%      function for model analysis

save_path = '.';
TodayStr = getToday;

folder_name = TodayStr;
nutrientlist =[ {'Citrulline'},{'Ornithine'},{'Free Fatty Acid'},{'3-Hydroxybutyrate'},'Total ketone body','Acetoacetate',{'Isoleucine'}, {'Valine'},{'Leucine'} ,'Asparagine', 'Methionine', 'Arginine', 'a-ABA','Phenylalanine',  'Threonine', 'Serine',{'Tyrosine'},'Proline'];
 
ModelList = [{'model1'},'model2','model3','model4','model5',{'model6'}, 'model7',{'model8'}];
SubjectList=[{'all_Mean'}];
strSeed = 20;
parents = '20';
generations ='200'
Opt=''
Opt.modeltype ='Ssystem_Y';

for k =1:length(SubjectList)
    Opt.subject=char(SubjectList(k));
for l = 1:length(ModelList)
    Opt.model = char(ModelList(l));
for j = 1:length(nutrientlist)
    %make_Insulindata_BCDiv(char(nutrientlist(j)), save_path);
    for i = 1:strSeed
        estimateModelParameter_InsulinModel(save_path, folder_name, char(nutrientlist(j)), num2str(i), parents, generations, Opt)
        N=[];
    end
end
end
end
end

function estimateModelParameter_InsulinModel(save_path, folder_name, nutrient, strSeed, parents, generations, Opt)
matsave_dir = [save_path '/matfile/' nutrient ]; 
numExp = 6;

%Load data
maguro_Glc75g_try2 = load([matsave_dir, '/', Opt.subject, '_Glc75g_try2.mat'],'Timecourse', 'timeStepExp', 'nutrientlist', 'timerow','TimecourseA','TimecourseX','TimecourseG');
maguro_Glc50g_try2 = load([matsave_dir, '/', Opt.subject, '_Glc50g_try2.mat'],'Timecourse', 'timeStepExp', 'nutrientlist', 'timerow','TimecourseA','TimecourseX','TimecourseG');
maguro_Glc25g = load([matsave_dir, '/',Opt.subject, '_Glc25g.mat'],'Timecourse', 'timeStepExp', 'nutrientlist', 'timerow','TimecourseA','TimecourseX','TimecourseG');
maguro_Glc75g_2h = load([matsave_dir, '/',Opt.subject, '_Glc75g_2h.mat'],'Timecourse', 'timeStepExp', 'nutrientlist', 'timerow','TimecourseA','TimecourseX','TimecourseG');
maguro_Glc50g_2h = load([matsave_dir, '/',Opt.subject, '_Glc50g_2h.mat'],'Timecourse', 'timeStepExp', 'nutrientlist', 'timerow','TimecourseA','TimecourseX','TimecourseG');
maguro_Glc25g_2h = load([matsave_dir, '/',Opt.subject, '_Glc25g_2h.mat'],'Timecourse', 'timeStepExp', 'nutrientlist', 'timerow','TimecourseA','TimecourseX','TimecourseG');

%Time step
timeStep.B75 = maguro_Glc75g_try2.timeStepExp;
timeStep.B50 = maguro_Glc50g_try2.timeStepExp;
timeStep.B25 = maguro_Glc25g.timeStepExp;
timeStep.C75 = maguro_Glc75g_2h.timeStepExp;
timeStep.C50 = maguro_Glc50g_2h.timeStepExp;
timeStep.C25 = maguro_Glc25g_2h.timeStepExp;

%Timecourse of nutrient
Timecourse_nutrient.B75 = maguro_Glc75g_try2.TimecourseA;Timecourse_nutrient.B75 =(Timecourse_nutrient.B75)/std(Timecourse_nutrient.B75); 
Timecourse_nutrient.B50 = maguro_Glc50g_try2.TimecourseA;Timecourse_nutrient.B50 = (Timecourse_nutrient.B50)/std(Timecourse_nutrient.B50); 
Timecourse_nutrient.B25 = maguro_Glc25g.TimecourseA;Timecourse_nutrient.B25 = (Timecourse_nutrient.B25)/std(Timecourse_nutrient.B25);
Timecourse_nutrient.C75 = maguro_Glc75g_2h.TimecourseA;Timecourse_nutrient.C75 =  (Timecourse_nutrient.C75)/std(Timecourse_nutrient.C75);
Timecourse_nutrient.C50 = maguro_Glc50g_2h.TimecourseA;Timecourse_nutrient.C50 = (Timecourse_nutrient.C50)/std(Timecourse_nutrient.C50); 
Timecourse_nutrient.C25 = maguro_Glc25g_2h.TimecourseA;Timecourse_nutrient.C25 = (Timecourse_nutrient.C25)/std(Timecourse_nutrient.C25);

%Timecourse of insulin
TimecourseX.B75 = maguro_Glc75g_try2.TimecourseX;TimecourseX.B75 = (TimecourseX.B75)/std(TimecourseX.B75);
TimecourseX.B50 = maguro_Glc50g_try2.TimecourseX;TimecourseX.B50 = (TimecourseX.B50)/std(TimecourseX.B50);
TimecourseX.B25 = maguro_Glc25g.TimecourseX;TimecourseX.B25 = (TimecourseX.B25)/std(TimecourseX.B25);
TimecourseX.C75 = maguro_Glc75g_2h.TimecourseX;TimecourseX.C75 = (TimecourseX.C75)/std(TimecourseX.C75);
TimecourseX.C50 = maguro_Glc50g_2h.TimecourseX;TimecourseX.C50 = (TimecourseX.C50)/std(TimecourseX.C50);
TimecourseX.C25 = maguro_Glc25g_2h.TimecourseX;TimecourseX.C25 = (TimecourseX.C25)/std(TimecourseX.C25);
%Timecourse of glucose
TimecourseG.B75 = maguro_Glc75g_try2.TimecourseG;TimecourseG.B75=(TimecourseG.B75)/std(TimecourseG.B75);
TimecourseG.B50 = maguro_Glc50g_try2.TimecourseG;TimecourseG.B50=(TimecourseG.B50)/std(TimecourseG.B50);
TimecourseG.B25 = maguro_Glc25g.TimecourseG;TimecourseG.B25=(TimecourseG.B25)/std(TimecourseG.B25);
TimecourseG.C75 = maguro_Glc75g_2h.TimecourseG;TimecourseG.C75 = (TimecourseG.C75)/std(TimecourseG.C75);
TimecourseG.C50 = maguro_Glc50g_2h.TimecourseG;TimecourseG.C50 = (TimecourseG.C50)/std(TimecourseG.C50);
TimecourseG.C25 = maguro_Glc25g_2h.TimecourseG;TimecourseG.C25 = (TimecourseG.C25)/std(TimecourseG.C25);

opt.display = false; 
save_dir = [save_path '/result/' folder_name '/estimate/' Opt.subject '/' Opt.model]; 

 if exist(save_dir, 'dir') ==0 
    mkdir(save_dir) 
 end


numParents = str2num(parents);
numGeneration = str2num(generations);
currentTime = clock; % current time as random seed
second = currentTime(6);
seed = str2num(strSeed)*second*1000;
RandStream.setGlobalStream(RandStream('mt19937ar', 'Seed', seed)); % create a random seed using Mersenne Twister

lb = [1e-4*ones(1,6)  ];
ub = [1e+0*ones(1,6)  ];

%% Estimation


     
%Parameter estimation with Evolutionary Algorithm:Global solution
[estIndv,estScore,report] = copasiep(@(estimated_param)calcRss(timeStep,estimated_param,TimecourseX,TimecourseG,Timecourse_nutrient,numExp, Opt...
    ),numParents,numGeneration,lb,ub);

%Start with a global solution and obtain a local solution
[bestIndv,fval,exitflag,output] = fminsearchbnd(@(estimated_param)calcRss(timeStep,estimated_param,TimecourseX,TimecourseG,Timecourse_nutrient,numExp, Opt...
    ),estIndv,lb,ub);


save([save_dir, '/', nutrient, '_', strSeed], 'bestIndv', 'fval', 'report');

%Evaluation function used in parameter estimation: sum of residual squares of simulated and experimental values
   function rss = calcRss(time,estimated_param,TimecourseXStruct,TimecourseGStruct,Timecourse_nutrient,numExp,opt) 
       try %Controls to prevent stopping in the event of an error during simulation
             diff = zeros(length(time.B75),numExp);
           for  i = 1:numExp
                   newtindex = [2,7,12,17:38];%time points after 0min & cover both Bolus & Continuous
                   if i ==1
                       Timecourse_N = Timecourse_nutrient.B25;
                       Timecourse_N =Timecourse_N(newtindex);Timecourse_N(1)=mean(Timecourse_nutrient.B25(1:2));
                       Timecourse_X = TimecourseXStruct.B25;t=time.B25;
                       Timecourse_X =Timecourse_X(newtindex) ;Timecourse_X(1)=mean(TimecourseXStruct.B25(1:2));
                       Timecourse_G = TimecourseGStruct.B25;t=time.B25;
                       Timecourse_G =Timecourse_G(newtindex) ;Timecourse_G(1)=mean(TimecourseGStruct.B25(1:2));                       
                   elseif i == 2
                       Timecourse_N = Timecourse_nutrient.B50;
                       Timecourse_N =Timecourse_N(newtindex);Timecourse_N(1)=mean(Timecourse_nutrient.B50(1:2));
                       Timecourse_X = TimecourseXStruct.B50;t=time.B50;
                       Timecourse_X =Timecourse_X(newtindex) ;Timecourse_X(1)=mean(TimecourseXStruct.B50(1:2));
                       Timecourse_G = TimecourseGStruct.B50;
                       Timecourse_G =Timecourse_G(newtindex) ;Timecourse_G(1)=mean(TimecourseGStruct.B50(1:2));   
                   elseif i == 3
                       Timecourse_N = Timecourse_nutrient.B75;
                       Timecourse_N =Timecourse_N(newtindex);Timecourse_N(1)=mean(Timecourse_nutrient.B75(1:2));
                       Timecourse_X = TimecourseXStruct.B75;t=time.B75;
                       Timecourse_X =Timecourse_X(newtindex) ;Timecourse_X(1)=mean(TimecourseXStruct.B75(1:2));
                       Timecourse_G = TimecourseGStruct.B75;
                       Timecourse_G =Timecourse_G(newtindex) ;Timecourse_G(1)=mean(TimecourseGStruct.B75(1:2));   
                   elseif i == 4
                       Timecourse_N = Timecourse_nutrient.C25(2:end);Timecourse_N(1)=mean(Timecourse_nutrient.C25(1:2));
                       Timecourse_X = TimecourseXStruct.C25(2:end);t=time.C25;Timecourse_X(1)=mean(TimecourseXStruct.C25(1:2));
                       Timecourse_G = TimecourseGStruct.C25(2:end);Timecourse_G(1)=mean(TimecourseGStruct.C25(1:2));
                       
                   elseif i == 5
                       Timecourse_N = Timecourse_nutrient.C50(2:end);Timecourse_N(1)=mean(Timecourse_nutrient.C50(1:2));
                       Timecourse_X = TimecourseXStruct.C50(2:end);t=time.C50;Timecourse_X(1)=mean(TimecourseXStruct.C50(1:2));
                       Timecourse_G = TimecourseGStruct.C25(2:end);Timecourse_G(1)=mean(TimecourseGStruct.C25(1:2));
                   elseif i == 6
                       Timecourse_N = Timecourse_nutrient.C75(2:end);Timecourse_N(1)=mean(Timecourse_nutrient.C75(1:2));
                       Timecourse_X = TimecourseXStruct.C75(2:end);t=time.C75;Timecourse_X(1)=mean(TimecourseXStruct.C75(1:2));
                       Timecourse_G = TimecourseGStruct.C25(2:end);Timecourse_G(1)=mean(TimecourseGStruct.C25(1:2));
                   end
                    t = [0,10,20,30,40,50,60,70,80,90,100,110,120,130,140,150,160,170,180,190,200,210,220,230,240];
               switch opt.modeltype                       
                   case {'Ssystem_Y'}
                       [param_k, init_conc, slope]  = simulation_condition_Ssystem_Y(estimated_param, Timecourse_N,Timecourse_X,t, opt,i);    
                       metaboN = 3;     
               end
               TimeCourseSim = getTimeCourseSim(t,init_conc,param_k,slope,opt);                    

                for j = 1:length(t)
                     diff(j,i) = (Timecourse_N(j,:) - TimeCourseSim(j,metaboN))/ (max(Timecourse_N) - min(Timecourse_N)); % residual error 20201103modify:TimeCourseSim(j,:)->TimeCourseSim(j,2)
                end
           rss = nansum(diff(:).^2) ;   
           end
         catch ME
          rss = inf;  
        end
  end


function rss = calcRss2(t,estimated_param)
%%
%% for lsqnonlin
%% calculating "residual error" between experimental and computational data
%%
[param_k, init_conc, slope, TimecourseA]  = simulation_condition(nutrient,estimated_param, Timecourse, nutrientlist);
try
TimeCourseSim = getTimeCourseSim(t,init_conc,param_k,slope);
diff = TimecourseA - TimeCourseSim;  % residual error
rss = diff;                           

catch
    rss = inf;                         %error handling
end
end


end
function Today = getToday()
    Today = num2str(datestr(now, 'yyyymmdd'));
end

%%  