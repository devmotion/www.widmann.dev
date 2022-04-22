# This file was generated, do not modify it. # hide
trace = histogram(
    x = Tables.getcolumn(TABLE, :flipper_length_mm),
    opacity = 0.75,
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
    title = "Flipper length",
    xaxis = attr(title = "Flipper length (mm)"),
    yaxis = attr(title = "Frequency"),
    barmode = "overlay",
)
p = PlotlyJS.plot([trace], layout)

fdplotly(json(p); style="") # hide