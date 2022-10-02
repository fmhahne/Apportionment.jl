module Apportionment

export apportionment, divisor

function signpost(n::T) where {T<:Integer}
    if n <= 0
        return 0.0
    end
    return floor(n - 0.5) + 0.5
end

function apportionment(votes, size)
    seats = zero(votes)

    while sum(seats) < size
        quotients = @. votes / signpost(seats + 1)
        next_seat = argmax(quotients)
        seats[next_seat] += 1
    end

    return seats
end

function divisor(votes, seats)
    div_min = maximum(@. votes / signpost(seats + 1))
    div_max = minimum(@. votes / signpost(seats))

    return round(Int, (div_min + div_max) / 2)
end

end # module Apportionment
