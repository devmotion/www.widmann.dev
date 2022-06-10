# This file was generated, do not modify it. # hide
using Pkg; Pkg.activate("./blog/2020/07/palmerpenguins/"); Pkg.instantiate() # hide
using PalmerPenguins
using Tables
Pkg.activate() # hide

Tables.schema(PalmerPenguins.load())