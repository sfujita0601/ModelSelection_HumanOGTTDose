function [bestIndv,bestScore,report]=copasiep(objfun,numParents,numGeneration,lb,ub,origin,minvar)
%%% This function searches x which minimize objfun(x) by using evolutionary
%%% programming method of Copasi (biochemical simulator software). Because 
%%% this function uses random generator, you should write wrapper function 
%%% which initialize ranodm generator with different seed when you use 
%%% pararell computing toolbox.
%%%
%%% input list
%%%  objfun : objective function to be optimized (function handle). 
%%%  numParents : number of parents in each generation (scalar).
%%%  numGenereation : number of generation (scalara).
%%%  lb : lower bound of parameters (vector).
%%%  ub : upper bound of parameters (vector).
%%%  origin : array of parameters which specify initial individuals
%%%           (optional).
%%%  minvar : set minimum variance (optional).
%%% 
%%% output list
%%%  bestIndv : vector of parameters of best individual.
%%%  bestScore : best score of objfun by bestIndv (i.e. best parameters).
%%%  report : report of optimization process, includes
%%%           [bestScore,meanScore,lap,stall] in every generation.

%%% population = [individual1 (row vector); individual2, ...]

if nargin < 6
    origin = [];
end
if nargin < 7
    minvar = 1e-8; 
end

tic;
numParam = size(lb,2);
tau1 = 1/sqrt(2*numParam);
tau2 = 1/sqrt(2*sqrt(numParam));
numCreate = numParents - size(origin,1);
report = zeros(numGeneration,4);




parents = [origin;create(numCreate,lb,ub)];
historyParents = parents/2;

scoreParents = zeros(numParents,1);
for p=1:numParents
    scoreParents(p) = objfun(parents(p,:));
end
[bestScore,bestId] = min(scoreParents);
bestIndv = parents(bestId,:);

meanScore = mean(scoreParents);
lap = toc;
lastScore = bestScore;
stall = 0;
fprintf('\t%s\t\t%s\t\t%s\t\t%s\t\t%s\n',...
    'Generation','Best f(x)','Mean f(x)', 'lap (sec)','StallGen');
fprintf('\t%5d\t\t\t%2.4e\t\t%2.4e\t\t\t%3.3f\t\t%5d\n',...
    1,bestScore,meanScore,lap,stall);
report(1,:) = [bestScore,meanScore,lap,stall];

for p=2:numGeneration
    tic;
    [children historyChildren]= replicate(parents,historyParents,tau1,tau2,lb,ub,minvar);
    
    scoreChildren = zeros(numParents,1);
    for q=1:numParents
        scoreChildren(q) = objfun(children(q,:));
    end
    
    population = [parents;children];
    scores = [scoreParents;scoreChildren];
    history = [historyParents;historyChildren];
    
    selectId = select(scores,numParents);
    parents = population(selectId,:);
    scoreParents = scores(selectId);
    historyParents = history(selectId,:);
    
    [bestScore,bestId] = min(scoreParents);
    bestIndv = parents(bestId,:);
    
    if bestScore>=lastScore;
        stall = stall+1;
    else
        stall = 0;
        lastScore = bestScore;
    end
    
    meanScore = mean(scoreParents);
    lap = toc;
    
    fprintf('\t%5d\t\t\t%2.4e\t\t%2.4e\t\t\t%3.3f\t\t%5d\n',...
        p,bestScore,meanScore,lap,stall);
    report(p,:) = [bestScore,meanScore,lap,stall];
end
end

function parents = create(numCreate,lb,ub)
numParam = size(lb,2);
parents = zeros(numCreate,numParam);
for p=1:numParam
    if lb(p) >= 0        % param(p) >= 0
        scale = log10(ub(p)) - log10(lb(p));
        if scale < 1.8  % linear scale
            tmpParam = lb(p) + (ub(p)-lb(p))*rand(numCreate,1);
        else            % log scale
            tmpParam = power(10, log10(lb(p))+scale*rand(numCreate,1));
        end
    elseif ub(p) > 0    % 0 is in the [lb,ub]
        scale = log10(ub(p)) + log10(-lb(p));
        if scale < 3.6  % linear scale
            tmpParam = lb(p) + (ub(p)-lb(p))*rand(numCreate,1);
        else            % log scale
            mean = (lb(p)+ub(p))/2;
            sigma = mean/100;
            tmpParam = zeros(numCreate,1);
            for q=1:numCreate
                tmpParam(q) = mean + sigma*randn;
                if (tmpParam(q)<lb || tmpParam(q)>ub)
                    q = q-1;        % repeat the loop until lb<param<ub
                end
            end
        end
    else                % param(p) < 0
        scale = log10(-lb(p)) - log10(-ub(p));
        if scale < 1.8  % linear scale
            tmpParam = lb(p) + (ub(p)-lb(p))*rand(numCreate,1);
        else
            tmpParam = -power(10, log10(-ub(p))+scale*rand(numCreate,1));
        end
    end
    parents(:,p) = tmpParam;
end

end

function selectId = select(scores,numParents)
%%% copasiではひとつの組み合わせごとにどちらかに必ず勝敗がついていたが、
%%% この関数ではenemyに負けた場合にのみスコアがつくように実装してある。
numPopulation = size(scores,1);
numEnemy = max(floor(numPopulation/5),1);

%%% (NaN>0) = 0 となってしまうので、scoreがNaNやInfの場合負けがカウントできず、
%%% その個体が生き残ってしまう.勝ちであれば同様にカウントできなくても、その個体は
%%% 排除されるので問題ない。 2010/1/18 modified by Toyoshima
% numLose = sum((repmat(scores,[1,numEnemy]) - ...
%     scores(ceil(numPopulation.*rand(numPopulation,numEnemy))))>0,2);
% [unused,id] = sort(numLose);

numWin = sum((repmat(scores,[1,numEnemy]) - ...
    scores(ceil(numPopulation.*rand(numPopulation,numEnemy))))<0,2);
[unused,id] = sort(numWin,'descend');

selectId = id(1:numParents);
end


function [children historyChildren]= replicate(parents,historyParents,tau1,tau2,lb,ub,minvar)
[numParents numParam] = size(parents);
lb = repmat(lb,[numParents,1]);
ub = repmat(ub,[numParents,1]);
historyChildren = max(minvar, historyParents.*exp(repmat((tau1*randn(numParents,1)),[1,numParam])...
    + tau2*randn(numParents,numParam)));
children = parents + historyChildren.*randn(numParents,numParam);
children = min(max(children,lb),ub);
end
