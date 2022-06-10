# This file was generated, do not modify it. # hide
using Pkg; Pkg.activate("./blog/2020/07/palmerpenguins/"); Pkg.instantiate() # hide
using PalmerPenguins
using PlotlyJS
using Tables
Pkg.activate() # hide

trace = let data = PalmerPenguins.load()
    histogram(;
        x=Tables.getcolumn(data, :flipper_length_mm),
        opacity=0.75,
        transforms=[
            attr(;
                type="groupby",
                groups=Tables.getcolumn(data, :species),
            ),
        ],
    )
end

layout = Layout(;
    title=attr(; text="Flipper length", x=0.5, xanchor="center"),
    xaxis=attr(; title="Flipper length (mm)"),
    yaxis=attr(; title="Frequency"),
    barmode="overlay",
    template=templates["simple_white"],
)

plt = PlotlyJS.plot([trace], layout)
savejson(plt, joinpath(@OUTPUT, "penguins-hist.json")) # hide