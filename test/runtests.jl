using Test
using Apportionment

@testset "Saintë-Lague method" begin
    votes = [10, 8, 3, 2]
    seats = apportionment(votes, 8)

    @test seats == [3, 3, 1, 1]
    @test @.(round(votes / divisor(votes, seats))) == seats
end

@testset "D'Hondt method" begin
    votes = [10, 8, 3, 2]
    seats = apportionment(votes, 8, DHondt())
    @test seats == [4, 3, 1, 0]
end
