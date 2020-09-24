K = 10;                             % Number of arms/actions
T = 1000;                           % Number of time-steps
P = 2000;                           % Number of plays

count_opt = zeros(T,1);             % Number of times optimal action taken across all runs
Avg_reward = zeros(T,1);            % Average of rewards across 2000 runs

x = input('Enter the algorithm to test:\n1 -> E-Greedy\n2 -> Softmax\n3 -> UCB1 (Default)\n');

for runs = 1:P
        
    q = normrnd(0,1,[K,1]);                            % True action values by Gaussian distribution    

    At_opt = 1;
    for i = 2:K
        if q(At_opt) < q(i)
            At_opt = i;             % Finding the optimal action
        end
    end
    
    count = zeros(K,1);             % Count of actions taken  
    Qt = zeros(K,1);                % Estimated rewards for each action
    At_max = randi(K);              % Initialize greedy action choice
    MEA_round = 1;                  % No. of rounds 'l', for Median Elimination Algorithm
    MEA_arms = zeros(K,1);          % Set of arms to sample for Median Elimination Algorithm
    
    for t = 1:T    
                                    % Selecting action using proposed algorithm     
        if x == 1
            At = EGreedy_Select(Qt, K, At_max);
        elseif x == 2
            At = Softmax_Select(Qt, K); 
        else
            At = UCB1_Select(Qt, K, count, t);                            
        end
        
        count(At) = count(At) + 1;                              % Updating count of action taken
        Rt = normrnd(q(At),1);                                  % Actual reward or action value at time t
        Qt(At) = Qt(At) + ((Rt - Qt(At)) / count(At));          % Updating reward estimate
        Avg_reward(t) = Avg_reward(t) + Rt;                     % Updating the average reward at time t                              
                       
        if Qt(At) > Qt(At_max)
            At_max = At;            % Check if updated action is higher than Greedy action 
        end
        
        if At == At_opt
            count_opt(t) = count_opt(t) + 1;                    % Updating optimal action count
        end
        
    end
    
end

count_opt = count_opt * (100 / P);
Avg_reward = Avg_reward / P;

z = input('Optimal action graph (Y/N)?','s');
if z == 'Y'
    plot(count_opt);                % Plotting optimal action graph
end

z = input('Average reward graph (Y/N)?','s');
if z == 'Y'    
    plot(Avg_reward);               % Plotting average reward graph
end   