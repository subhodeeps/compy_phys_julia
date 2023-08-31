# import packages

using Plots
using LaTeXStrings
using LoopVectorization

# define functions

function logistic(a, x)
    return a * x * (1 - x)
end

function compute_data!(data, as, xtiny, ithide, itmax, nbins)
    for (a_idx, a) in enumerate(as)
        x = xtiny
        for i = 1:ithide
            x = logistic(a, x)
        end
        for i = 1:itmax
            x = logistic(a, x)
            index = ceil(Int, nbins * x)
            data[index, a_idx] += 1
        end
    end
    return data
end

# parameters and initialization

amin, amax, a_N = 2.8, 4.0, 8000 # limits of the x axis and number of points
as = range(amin, amax, a_N) # range of a (x axis)
itmax = 5000 # number of iterations for each a 
ithide = 0 # number of hidden iterations before plotting
xtiny = 1e-10 # initial value for x
nbins = 2000 # resolution along the y axis
data = zeros(nbins, a_N) # array to store the computed data

# main execution
data = compute_data!(data, as, xtiny, ithide, itmax, nbins)

data ./= maximum(data, dims=1)

# plotting 

xs = range(xmin, xmax, length=nbins)

p = heatmap(as, xs, data, c=cgrad(:grays, rev=true),
    colorbar=false, grid=false)
xlabel!("\$\\alpha\$") # instead of the L marco
ylabel!(L"x_{n}")
title!(L"x_{n}=\alpha x_{n-1}(1-x_{n-1})");
savefig(p, "plots/bifurcation_binned.pdf")
