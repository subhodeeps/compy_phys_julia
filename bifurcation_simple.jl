using Plots
using LaTeXStrings

function logistic(a, x)
    return a * x * (1 - x)
end

amin, amax, aN = 2.8, 4.0,2000
as = range(amin, amax, length=aN) #2000
itmax = 1000 # number of iterations for each a 
ihide = 1000 # number of hidden iterations before plotting
xtiny = 1e-10 # initial value for x
y = []
xx = []
zc = [] # for colours
for a in as
    x = xtiny
    ic = 0 # for colours
    for i = 1:(ihide+itmax)
        x = logistic(a, x)
        if i > ihide
            push!(y, x)
            push!(xx, a)
            ic = mod(ic, 50) + 1
            push!(zc, ic)
        end
    end
end
da = (amax-amin)/aN
p = scatter(xx, y, zcolor=zc, xlimits=(amin-2*da, amax+2*da), ylimits=(0, 1),
    ms=0.2, msw=0, color=palette(:bluesreds, length(unique(zc))), legend=false, grid=false, framestyle=:box)
xlabel!("\$\\alpha\$") # instead of the L marco
ylabel!(L"x_{n}")
title!(L"x_{n}=\alpha x_{n-1}(1-x_{n-1})");
savefig(p, "plots/bifurcation_simple.pdf")
