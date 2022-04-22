# This file was generated, do not modify it. # hide
using PalmerPenguins
using Tables

ENV["DATADEPS_ALWAYS_ACCEPT"] = true # hide
const TABLE = PalmerPenguins.load()

Tables.schema(TABLE)