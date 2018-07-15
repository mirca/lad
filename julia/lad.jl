function lad(X, y, yerr=nothing, l1_regularizer=0., maxiter=50, rtol=1e-4, eps=1e-4)::Array{Float64, 2}

    if yerr != nothing
        yerr /= sqrt(2.)
    else
        yerr = 1
    end

    X /= yerr
    y /= yerr

    p = size(X)[2]
    beta = solve(X, y, w, p)
    regfactor = norm(beta, 1.)
    lambda = diag(l1_regularizer, p)
    k = 1
    while k <= maxiter
        l1factor = vec(eps + sqrt(abs(y - X' * beta)))
        beta_k = solve(X, y, )
    end

end

function solve(X, y, w)
    return (cholfact(X' * X + w) \ ones{Float64, (p, 1)}) * X' * y
end
