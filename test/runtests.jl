using PartiallyCoherentSources, Test, Random

Random.seed!(1234)

basis = randn(ComplexF32, 32, 32, 10)
weights = rand(Float32, 10)

N = 10^4
fields = generate_fields(basis, weights, N)

I1 = sum(x -> abs2.(x), eachslice(fields, dims=3)) / N

I2 = sum(pair -> pair[1] * abs2.(pair[2]), zip(weights, eachslice(basis, dims=3)))

@test isapprox(I1, I2, rtol=1e-2)