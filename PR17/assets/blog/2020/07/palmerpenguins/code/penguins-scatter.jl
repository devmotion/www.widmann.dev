# This file was generated, do not modify it. # hide
using Pkg; Pkg.activate("./blog/2020/07/palmerpenguins/"); Pkg.instantiate() # hide
using PalmerPenguins
using PlotlyJS
using Tables
Pkg.activate() # hide

trace = let data = PalmerPenguins.load()
    scatter(;
        mode="markers",
        x=Tables.getcolumn(data, :flipper_length_mm),
        y=Tables.getcolumn(data, :body_mass_g),
        transforms=[
            attr(;
                type="groupby",
                groups=Tables.getcolumn(data, :species),
            ),
        ],
    )
end

layout = Layout(;
    title=attr(; text="Flipper length and body mass", x=0.5, xanchor="center"),
    xaxis=attr(; title="Flipper length (mm)"),
    yaxis=attr(; title="Body mass (g)"),
    template=templates["simple_white"],
)

plt = PlotlyJS.plot([trace], layout)
savejson(plt, joinpath(@OUTPUT, "penguins-scatter.json")) # hide