using Test
using Apportionment

@testset "Saintë-Lague method" begin
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
