module Apportionment

export apportionment, divisor
export SainteLague, DHondt

struct SainteLague end
struct DHondt end

function signpost(n::T, method::SainteLague) where {T<:Integer}
    if n <= 0
        return 0.0
    end
    return n - 0.5
end

function signpost(n::T, method::DHondt) where {T<:Integer}
    if n <= 0
        return 0.0
    end
    return n
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

function divisor(votes, seats, method=SainteLague())
    div_min = maximum(broadcast((v, s) -> v / signpost(s + 1, method), votes, seats))
    div_max = minimum(broadcast((v, s) -> v / signpost(s, method), votes, seats))

    return round(Int, (div_min + div_max) / 2)
end

end # module Apportionment
