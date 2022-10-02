# Apportionment

Allocate seats to parties or constituencies using the [Saintë-Lague method](https://en.wikipedia.org/wiki/Webster/Sainte-Lagu%C3%AB_method).

```julia
using Apportionment

votes = [10, 8, 3, 2]
seats = apportionment(votes, 8)
# 4-element Vector{Int64}:
#  3
#  3
#  1
#  1
```
