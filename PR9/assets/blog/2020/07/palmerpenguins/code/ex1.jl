# This file was generated, do not modify it. # hide
using ColorBrewer
using PlotlyJS

const COLORS = palette("Dark2", 3)

trace = scatter(
    mode = "markers",
    x = Tables.getcolumn(TABLE, :flipper_length_mm),
    y = Tables.getcolumn(TABLE, :body_mass_g),
    transforms = [
        attr(
            type = "groupby",
            groups = Tables.getcolumn(TABLE, :species),
            styles = [
                attr(target = "Gentoo", value_marker_color = COLORS[1]),
                attr(target = "Adelie", value_marker_color = COLORS[2]),
                attr(target = "Chinstrap", value_marker_color = COLORS[3]),
            ],
        ),
    ],
)

layout = Layout(;
    title = "Flipper length and body mass",
    xaxis = attr(title = "Flipper length (mm)"),
    yaxis = attr(title = "Body mass (g)"),
)
p = PlotlyJS.plot([trace], layout)

fdplotly(json(p); style="") # hide