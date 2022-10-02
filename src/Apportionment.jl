module Apportionment

export apportionment, divisors
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

function apportionment(votes, size, method=SainteLague())
    seats = zero(votes)

    while sum(seats) < size
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

end # module Apportionment
