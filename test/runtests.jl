using Test
using Apportionment

votes = [10, 8, 3, 2]
seats_sainte_lague = apportionment(votes, 8)
seats_dhondt = apportionment(votes, 8, DHondt())

@test seats_sainte_lague == [3, 3, 1, 1]
@test @.(round(votes / divisor(votes, seats_sainte_lague))) == seats_sainte_lague

@test seats_dhondt == [4, 3, 1, 0]
