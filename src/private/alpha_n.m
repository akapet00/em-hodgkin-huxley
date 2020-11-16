function ret = alpha_n(v)
    ret = 0.01*(v+55.0)/(1-exp(-(v+55.0)/10.0));
end