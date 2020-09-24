function At = EGreedy_Select(Qt, K, At_max)
    E = 0.1;                              % Epsilon value    
    At = randi(K);                      % Random initialization of At
    if randi(100) <= (E * 100)                       
        return;                         % Exploring
    else    
        At = At_max;                    % Exploiting, same as the previous greedy choice                             
    end
end