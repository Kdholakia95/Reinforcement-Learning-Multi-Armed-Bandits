K = 10;                           	% Number of arms/actions
P = 2000;                           % Number of plays
E = 0.8;                            % Accuracy parameter
d = 0.1;                            % Confidence parameter

count_opt = zeros(P,K);             % Number of times optimal action taken across all runs

MEA_round = 0;                                      % No. of rounds 'l', for Median Elimination Algorithm
E_l = E / 4;                                        % Accuracy parameter for round 'l'
d_l = d / 2;                                        % Confidence parameter for round 'l'
ts = ceil((4 * log(3 / d_l)) / (E_l ^ 2));          % No. of times to sample an arm each round
S = K;                                              % Set of active arms
    
q = normrnd(0,1,[P,K]);                             % True action values by Gaussian distribution    
[~,At_opt] = max(q');                               % Finding optimal actions for all bandit plays

for runs = 1:P
    count_opt(runs, At_opt(runs)) = 1;              % Count set to 1 for all matrix indices corresponding to the optimal actions
end
count_opt_sum = sum(count_opt);                    	% Summing the number of optimal actions taken at one timestep across 2000 plays

count = zeros(P,K);                                 % Count of actions taken  
Qt = zeros(P,K);                                    % Estimated rewards for each action
MEA_arms = ones(P,K);                               % '0' - Arm is active, '1' - Arm is eliminated

Ar = [];                                            % Average reward array
Oa = [];                                            % Optimal action array

t_l = 1;                            

while (S ~= 1) || (t_l <= ts)    
    
    if t_l <= ts
        
        t_l = t_l + 1;
        count = count + 1;
        Rt = normrnd(q,1,[P,S]);                                        % Generating rewards for all arms across all bandit plays      
        Qt = Qt + ((Rt - Qt) ./ count);                                 % Updating reward estimate
        Ar = [Ar mean(Rt)];                                            	% Concatenating each iteration of arms to average reward array
        Oa = [Oa count_opt_sum];                                        % Concatenating each iteration of arms to optimal action array   
            
    else        
        MEA_round = MEA_round + 1                                       % Updating all parameters for next round                        
        E_l = 0.75 * E_l;                                               
        d_l = 0.5 * d_l;                                                                  
        ts = ts + ceil((4 * log(3 / d_l)) / (E_l ^ 2));  
        previous_S = S;
        S = ceil(S/2);
        
        median_arms = median(Qt');                                      % Calculating medians along all plays
                
        Qt_new = zeros(P,S);                                            % Temporary arrays for updating estimates and counts
        q_new = zeros(P,S);
        count_opt_new = zeros(P,S);
        count_new = zeros(P,S);
        
        for runs = 1:P            
            index = 1;
            for arm = 1:previous_S
                
                if Qt(runs,arm) >= median_arms(runs)
                                                                        % Eliminating sub-median arms and updating the estimates and counts.                                  
                    Qt_new(runs,index) = Qt(runs,arm);
                    q_new(runs,index) = q(runs,arm);
                    count_opt_new(runs,index) = count_opt(runs,arm);
                    count_new(runs,index) = count(runs,arm);
                    index = index + 1;
                    
                end
                
            end
        end
        
        Qt = Qt_new;    
        q = q_new;
        count_opt = count_opt_new;
        count = count_new;
        count_opt_sum = sum(count_opt);        
    end                                  
                
end 

Oa = (Oa / P) * 100;			

z = input('Optimal action graph (Y/N)?','s');
if z == 'Y'
    plot(Oa');                % Plotting optimal action graph
end

z = input('Average reward graph (Y/N)?','s');
if z == 'Y'    
    plot(Ar');               % Plotting average reward graph
end