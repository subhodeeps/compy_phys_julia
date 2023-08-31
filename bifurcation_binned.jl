"""
Generate a bifurcation diagram of the logistic equation

Author: Subhodeep Sarkar
Contact: subhodeep.sarkar1@gmail.com
Date: 01-08-2023

Note: Modify a_N, itMAX, nBINS to control the quality
of the bifurcation diagram

"""

# import packages

using Plots
using LaTeXStrings
using BenchmarkTools

# define functions

function logistic(a_val, x_val)
    return a_val * x_val * (1 - x_val)
end

function compute_data(data, as, x0, ithide, itmax, nbins)
    for a_idx in eachindex(as)
        x = x0
        for i = 1:ithide
            x = logistic(as[a_idx], x)
        end
        for i = 1:itmax
            x = logistic(as[a_idx], x)
            index = ceil(Int, nbins * x)
            data[index, a_idx] += 1
        end
    end
    return data
end

@btime begin

    # parameters and initialization
    amin, amax, a_N = 2.8, 4.0, 10000 # limits of the x axis and number of points
    as_vals = range(amin, amax, a_N) # range of a (x axis)
    itMAX = 2500000 # number of iterations for each a 
    itHIDE = 100000 # number of hidden iterations before plotting
    xtiny = 1e-10 # initial value for x
    nBINS = 3000 # resolution along the y axis
    data_arr = zeros(nBINS, a_N) # array to store the computed data

    # main execution
    data_arr = compute_data(data_arr, as_vals, xtiny, itHIDE, itMAX, nBINS)
    data_arr ./= maximum(data_arr, dims=1) # normalization

    # plotting 
    xmin, xmax = 0, 1 # range of x axis
    xs = range(xmin, xmax, length=nBINS)
    p = heatmap(as_vals, xs, log10.(data_arr), c=cgrad(:darktest, rev=false),
        colorbar=false, grid=false, framestyle=:box)
    xlabel!("\$\\alpha\$") # instead of the L marco
    ylabel!(L"x_{n}")
    title!(L"x_{n}=\alpha x_{n-1}(1-x_{n-1})")
    savefig(p, "plots/bifurcation_binned.pdf")

end

