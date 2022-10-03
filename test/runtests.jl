using Test
using Apportionment

@testset "Sainte-Laguë method" begin
    votes = [10, 8, 3, 2]
    seats = apportionment(votes, 8)
    div_min, div_max = divisors(votes, seats)

    @test seats == [3, 3, 1, 1]
    @test round.(Int64, prevfloat.(votes / div_min)) == seats
    @test round.(Int64, nextfloat.(votes / div_max)) == seats
end

@testset "D'Hondt method" begin
    votes = [10, 8, 3, 2]
    seats = apportionment(votes, 8, DHondt())
    div_min, div_max = divisors(votes, seats, DHondt())

    @test seats == [4, 3, 1, 0]
    @test floor.(Int64, prevfloat.(votes / div_min)) == seats
    @test floor.(Int64, nextfloat.(votes / div_max)) == seats
end

@testset "Biproportional Sainte-Laguë method" begin
    votes = [770 130; 20 380; 10 190]
    marginals1 = apportionment(sum(votes; dims=1), 15)
    marginals2 = [7; 5; 3]
    seats = biproportional(votes, marginals1, marginals2, SainteLague())
    @test seats == [7 0; 1 4; 0 3]
end
