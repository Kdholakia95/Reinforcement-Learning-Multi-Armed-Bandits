function At = UCB1_Select(Qt, K, count, t)
    c = 1;                                  % Confidence paramter
    Uq = zeros(K,1);                        % Upper bounds for each action value    
    At = randi(K);                          % Random initialization of At
    for arm = 1:K                                  
        Uq(arm) = Qt(arm) + c * sqrt(2 * log(t) / count(arm));                   
                                            % Calculating upper bounds for each arm 
        if Uq(arm) > Uq(At)
            At = arm;                       % Choosing the action with highest upper bound for reward
        end
    end    
end