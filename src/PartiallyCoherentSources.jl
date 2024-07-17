module PartiallyCoherentSources

using Random, KernelAbstractions

export generate_fields, generate_fields!

@kernel function random_phases_kernel(output, basis, weights, random_numbers)
    j, k, m = @index(Global, NTuple)

    tmp_sum = zero(eltype(output))
    for n ∈ eachindex(weights)
        tmp_sum += √weights[n] * cis(2π * random_numbers[m, n]) * basis[j, k, n]
    end

    output[j, k, m] = tmp_sum
end

function generate_fields!(output, basis, weights)
    @assert size(basis, 3) == length(weights)
    N = size(output, 3)

    random_numbers = similar(basis, real(eltype(basis)), N, size(basis, 3))
    random_numbers = rand!(random_numbers)

    backend = KernelAbstractions.get_backend(output)
    kernel! = random_phases_kernel(backend)
    kernel!(output, basis, weights, random_numbers, ndrange=size(output))

    output
end

function generate_fields(basis, weights, N)
    output = similar(basis, complex(eltype(basis)), size(basis, 1), size(basis, 2), N)
    generate_fields!(output, basis, weights)
end

end