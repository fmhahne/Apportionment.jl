# Apportionment

Allocate seats to parties or constituencies using the [Sainte-Laguë][], [D'Hondt][], or [Huntington–Hill][] method.

[Sainte-Laguë]: https://en.wikipedia.org/wiki/Webster/Sainte-Lagu%C3%AB_method
[D'Hondt]: https://en.wikipedia.org/wiki/D%27Hondt_method
[Huntington–Hill]: https://en.wikipedia.org/wiki/Huntington%E2%80%93Hill_method

```julia
using Apportionment
votes = [10, 8, 3, 2]

apportionment(votes, 8, SainteLague())
# 4-element Vector{Int64}:
#  3
#  3
#  1
#  1

apportionment(votes, 8, DHondt())
# 4-element Vector{Int64}:
#  4
#  3
#  1
#  0

apportionment(votes, 8, HuntingtonHill())
# 4-element Vector{Int64}:
#  3
#  3
#  1
#  1
```

It is also possible to use [biproportional apportionment][] with the Sainte-Laguë or D'Hondt methods:

[biproportional apportionment]: https://en.wikipedia.org/wiki/Biproportional_apportionment

```julia
votes = [770 130; 20 380; 10 190]
marginals1 = apportionment(sum(votes; dims=1), 15)
marginals2 = [7; 5; 3]
seats = biproportional(votes, marginals1, marginals2)
# 3×2 Matrix{Int64}:
#  7  0
#  1  4
#  0  3
```
