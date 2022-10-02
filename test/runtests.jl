using Test
using Apportionment

votes = [10, 8, 3, 2]
seats = apportionment(votes, 8)

@test seats == [3, 3, 1, 1]
@test @.(round(votes / divisor(votes, seats))) == seats
