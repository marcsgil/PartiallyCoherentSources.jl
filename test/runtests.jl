using PartiallyCoherentSources

basis = rand(ComplexF32, 32, 32, 10)
weights = rand(Float32, size(basis, 3))

fields = generate_fields(basis, weights, 10^4)

I1 = sum(x -> abs2.(x), eachslice(fields, dims=3)) / size(fields, 3)
I2 = sum(pair -> pair[1] * abs2.(pair[2]), zip(weights, eachslice(basis, dims=3)))

isapprox(I1, I2, rtol=1e-2)