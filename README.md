# Apportionment

[![CI status](https://github.com/fmhahne/Apportionment.jl/actions/workflows/CI.yml/badge.svg)](https://github.com/fmhahne/Apportionment.jl/actions/workflows/CI.yml)
[![Code Style: Blue](https://img.shields.io/badge/code%20style-blue-4495d1.svg)](https://github.com/invenia/BlueStyle)

Proportional apportionment of seats to parties or constituencies. Available methods are `SainteLague`, `DHondt`, `HuntingtonHill`, and largest remainders with `Droop`, `Hare` and `HagenbachBischoff` quotas.

```julia
using Apportionment
votes = [10, 8, 3, 2]

apportionment(votes, 8, SainteLague())
# 4-element Vector{Int64}:
#  3
#  3
#  1
#  1
```

It is also possible to use [biproportional apportionment][] with the `SainteLague` or `DHondt` methods:

[biproportional apportionment]: https://en.wikipedia.org/wiki/Biproportional_apportionment

```julia
votes = [770 130; 20 380; 10 190]
marginals1 = apportionment(sum(votes; dims=1), 15, DHondt())
marginals2 = [7; 5; 3]
seats = biproportional(votes, marginals1, marginals2, DHondt())
# 3×2 Matrix{Int64}:
#  7  0
#  1  4
#  0  3
```
