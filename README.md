# Apportionment

Allocate seats to parties or constituencies using the [Saintë-Lague][] or the [D'Hondt][] method.

[Saintë-Lague]: https://en.wikipedia.org/wiki/Webster/Sainte-Lagu%C3%AB_method
[D'Hondt]: https://en.wikipedia.org/wiki/D%27Hondt_method

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
```
