using Plots
using LaTeXStrings

function logistic(a, x)
    return a * x * (1 - x)
end

amin, amax = 2.8, 4.0
as = range(amin, amax, length=8000)
itmax = 5000 # number of iterations for each a 
ihide = 1000 # number of hidden iterations before plotting
xtiny = 1e-10 # initial value for x
xmin, xmax = 0, 1
nbins = 2000
xs = range(xmin, xmax, length=nbins)
data = zeros(nbins, length(as))

for a in eachindex(as)
    x = xtiny
    for i = 1:(ihide+itmax)
        x = logistic(as[a], x)
        if i > ihide
            index = ceil(Int, nbins * x)
            data[index, a] = data[index, a] + 1
        end
    end
    data[:, a] = data[:, a] / maximum(data[:, a])
end

# p = heatmap(as, xs, data, c=cgrad(:ice, rev=true),
#     legend=false, grid=false, framestyle=:box)
p = heatmap(as, xs, data,c=cgrad(:grays, rev=true),
colorbar = false, grid=false)
xlabel!("\$\\alpha\$") # instead of the L marco
ylabel!(L"x_{n}")
title!(L"x_{n}=\alpha x_{n-1}(1-x_{n-1})");
savefig(p, "plots/bifurcation_binned.pdf")
