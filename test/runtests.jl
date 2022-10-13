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

@testset "Dictionary argument" begin
    votes = Dict("A" => 10, "B" => 8, "C" => 3, "D" => 2)
    seats = apportionment(votes, 8)
    @test seats == Dict("A" => 3, "B" => 3, "C" => 1, "D" => 1)
end

@testset "D'Hondt method" begin
    votes = [10, 8, 3, 2]
    seats = apportionment(votes, 8, DHondt())
    div_min, div_max = divisors(votes, seats, DHondt())

    @test seats == [4, 3, 1, 0]
    @test floor.(Int64, prevfloat.(votes / div_min)) == seats
    @test floor.(Int64, nextfloat.(votes / div_max)) == seats
end

@testset "Huntington-Hill method" begin
    votes = [10, 8, 3]
    seats = apportionment(votes, 8)

    @test seats == [4, 3, 1]
end

@testset "Biproportional Sainte-Laguë method" begin
    votes = [770 130; 20 380; 10 190]
    marginals1 = apportionment(sum(votes; dims=1), 15)
    marginals2 = [7; 5; 3]
    seats = biproportional(votes, marginals1, marginals2, SainteLague())
    @test seats == [7 0; 1 4; 0 3]
end

@testset "Biproportional D'Hondt method" begin
    votes = [770 130; 20 380; 10 190]
    marginals1 = apportionment(sum(votes; dims=1), 15, DHondt())
    marginals2 = [7; 5; 3]
    seats = biproportional(votes, marginals1, marginals2, DHondt())
    @test seats == [7 0; 1 4; 0 3]
end

@testset "Hare quota" begin
    votes = [47000, 16000, 15800, 12000, 6100, 3100]
    seats = apportionment(votes, 10, Hare())
    @test seats == [5, 2, 1, 1, 1, 0]
end

@testset "Droop quota" begin
    votes = [47000, 16000, 15800, 12000, 6100, 3100]
    seats = apportionment(votes, 10, Droop())
    @test seats == [5, 2, 2, 1, 0, 0]
end
