function ret = alpha_m(v)
    ret = 0.1*(v+40.0)/(1.0-exp(-(v+40.0)/10.0));
end