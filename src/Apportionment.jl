module Apportionment

export apportionment, divisors, biproportional
export SainteLague, DHondt

struct SainteLague end
struct DHondt end

function signpost(n::T, method::SainteLague) where {T<:Integer}
    if n <= 0
        return 0.0
    else
        return n - 0.5
    end
end

function signpost(n::T, method::DHondt) where {T<:Integer}
    if n <= 0
        return 0
    else
        return n
    end
end

rounding(x::T, method::SainteLague) where {T<:Real} = round(Int64, x)
rounding(x::T, method::DHondt) where {T<:Real} = floor(Int64, x)

function apportionment(votes, num, method=SainteLague())
    seats = zeros(Int64, size(votes))

    while sum(seats) < num
        quotients = broadcast((v, s) -> v / signpost(s + 1, method), votes, seats)
        next_seat = argmax(quotients)
        seats[next_seat] += 1
    end

    return seats
end

function divisors(votes, seats, method=SainteLague())
    div_min = maximum(broadcast((v, s) -> v / signpost(s + 1, method), votes, seats))
    div_max = minimum(broadcast((v, s) -> v / signpost(s, method), votes, seats))

    return (div_min, div_max)
end

function biproportional(votes, marginals1, marginals2, method=SainteLague(); max_iters=100)
    seats = zero(votes)
    N1, N2 = size(votes)

    num = sum(marginals1)
    if sum(marginals2) != num
        error("Marginals don't match")
    end

    divisors1 = ones(Float64, N1, 1)
    divisors2 = ones(Float64, 1, N2)

    count = 1
    while (sum(seats; dims=1) != marginals1 || sum(seats; dims=2) != marginals2) && count <= max_iters
        if isodd(count)
            for i in axes(votes, 1)
                weights = votes ./ (oneunit.(divisors1) * divisors2)
                result = apportionment(weights[i, :], marginals2[i], method)
                divisors1[i] = sum(divisors(weights[i, :], result, method)) / 2.0
            end
        else
            for j in axes(votes, 2)
                weights = votes ./ (divisors1 * oneunit.(divisors2))
                result = apportionment(weights[:, j], marginals1[j], method)
                divisors2[j] = sum(divisors(weights[:, j], result, method)) / 2.0
            end
        end

        weights = votes ./ (divisors1 * divisors2)
        seats = broadcast(w -> rounding(w, method), weights)
        count += 1
    end

    return seats
end

end # module Apportionment
