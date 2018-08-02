using Lad
using Base.Test

n = 1000
beta = [3. 10.]'
X = rand(Float64, n, 1)
X = [X ones(Float64, n, 1)]
y = X * beta + randn(Float64, n, 1)

beta_lad = Lad.lad(X, y)
@test beta ≈ beta_lad rtol=1e-1

