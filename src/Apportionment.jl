module Apportionment

export apportionment, divisors, biproportional
export SainteLague, DHondt, HuntingtonHill
export largest_remainder, quota
export Hare, Droop, HagenbachBischoff

struct SainteLague end
struct DHondt end
struct HuntingtonHill end

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

function signpost(n::T, method::HuntingtonHill) where {T<:Integer}
    if n <= 0
        return 0
    else
        return sqrt(n * (n - 1))
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

function apportionment(dict::T, num, method) where {T<:AbstractDict}
    parties = keys(dict)
    votes = collect(values(dict))
    seats = apportionment(values(votes), num, method)
    return Dict(zip(parties, seats))
end

function divisors(votes, seats, method=SainteLague())
    div_min = maximum(broadcast((v, s) -> v / signpost(s + 1, method), votes, seats))
    div_max = minimum(broadcast((v, s) -> v / signpost(s, method), votes, seats))

    return (div_min, div_max)
end

struct Droop end
struct Hare end
struct HagenbachBischoff end

function quota(total_votes, total_seats, method::Droop)
    return floor(Int64, total_votes / (total_seats + 1)) + 1
end

function quota(total_votes, total_seats, method::Hare)
    return total_votes / total_seats
end

function quota(total_votes, total_seats, method::HagenbachBischoff)
    return total_votes / (total_seats + 1)
end

function largest_remainder(votes, num, method=Droop())
    q = votes / quota(sum(votes), num, method)
    seats = floor.(Int64, q)

    while sum(seats) < num
        next_seat = argmax(q - seats)
        seats[next_seat] += 1
    end

    return seats
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
    while (sum(seats; dims=1) != marginals1 || sum(seats; dims=2) != marginals2) &&
        count <= max_iters
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
