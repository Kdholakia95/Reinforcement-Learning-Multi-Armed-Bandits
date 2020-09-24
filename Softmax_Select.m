function At = Softmax_Select(Qt, K)    
    temp = 0.3;                     % Temperature value    
    Pr = zeros(K,1);                % Initializing probabilities of each action
    ex_Qt_Sum = 0;                  
    
    for i = 1:K
        ex_Qt_Sum = ex_Qt_Sum + exp(Qt(i)/temp);    % Summing the exponential of all reward estimates
    end         
    
    for i = 1:K
        Pr(i) = exp(Qt(i)/temp) / ex_Qt_Sum;        % Calculating the probabilities
    end    
    
    sample = rand;                  % Sampling from the Gibbs distribution
    cdf = 0;                        % derived from the probabilities calculated earlier
    for i = 1:K                     
        cdf = cdf + Pr(i);
        if sample < cdf
            At = i;
            return;
        end
    end   
end