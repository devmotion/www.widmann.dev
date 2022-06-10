# This file was generated, do not modify it. # hide
using Pkg; Pkg.activate("./blog/2020/07/palmerpenguins/"); Pkg.instantiate() # hide
using DataFrames
using PalmerPenguins
Pkg.activate() # hide

first(DataFrame(PalmerPenguins.load()), 5)