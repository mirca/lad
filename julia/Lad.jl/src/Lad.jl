module Lad

function lad(X, y, yerr=nothing, l1regularizer=0., maxiter=50, rtol=1e-4, eps=1e-4)::Array{Float64, 2}

    if yerr != nothing
        yerr /= sqrt(2.)
    else
        yerr = 1
    end

    X /= yerr
    y /= yerr

    p = size(X)[2]
    l1regularizer = Diagonal(eye(p) * l1regularizer)
    beta = solve(X, y, l1regularizer, p)
    regfactor = norm(beta, 1.)
    k = 1
    while k <= maxiter
        l1factor = vec(eps + sqrt.(abs.(y - X * beta)))
        beta_k = solve(X./l1factor, y./l1factor, l1regularizer, p)
        relerr = norm(beta_k - beta, 1) / max(1., regfactor)

        if relerr < rtol
            break
        end
        beta = beta_k
        regfactor = norm(beta, 1.)
        k += 1
    end

    return beta
end

function solve(X, y, W, p)
    return (cholfact(X' * X + W) \ eye(p)) * X' * y
end

end
