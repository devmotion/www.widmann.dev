+++
title = "PalmerPenguins.jl"
author = ["David Widmann"]
date = 2020-07-28
aliases = ["/blog/2020/07/palmerpenguins"]
tags = ["penguins", "julia"]
draft = false
+++

<script src="https://cdn.plot.ly/plotly-2.12.1.min.js"></script>
<script>
  const PlotlyJS_json = async (div, url) => {
    response = await fetch(url); // get file
    fig = await response.json(); // convert it to json
    // Make the plot fit the screen responsively. See the documentation of plotly.js. https://plotly.com/javascript/responsive-fluid-layout/
    if (typeof fig.config === 'undefined') { fig["config"]={} }
    delete fig.layout.width
    delete fig.layout.height
    fig["layout"]["autosize"] = true
    fig["config"]["autosizable"] = true
    fig["config"]["responsive"] = true

    // make it easier to scroll throught the website rather than being blocked by a figure.
    fig.config["scrollZoom"] = false

    // PlotlyJS.savefig by default add the some more attribute to make a static plot.
    // Disable them to make the website fancier.
    delete fig.config.staticPlot
    delete fig.config.displayModeBar
    delete fig.config.doubleClick
    delete fig.config.showTips

    Plotly.newPlot(div, fig);
  };
</script>

Are you looking for a dataset for data exploration and visualization?
Maybe you should consider the [Palmer penguins dataset](https://allisonhorst.github.io/palmerpenguins/), which was published as an [R package](https://cloud.r-project.org/web/packages/palmerpenguins/index.html) recently (<a href="#citeproc_bib_item_3">Horst, Hill, and Gorman 2020</a>).
I created the Julia package [`PalmerPenguins.jl`](https://github.com/devmotion/PalmerPenguins.jl) to simplify its use with the Julia programming language and increase its adoption within the Julia community.


## TL;DR {#tl-dr}

The Palmer penguins dataset is an alternative to the controversial `iris` dataset for data exploration and visualization (but, of course, [not the only one](https://www.meganstodel.com/posts/no-to-iris/)).
The Julia package [`PalmerPenguins.jl`](https://github.com/devmotion/PalmerPenguins.jl) provides access to the raw and simplified versions of this dataset, similar to the original R package, without having to download and parse the raw data manually.


## Palmer penguins dataset {#palmer-penguins-dataset}

The Palmer penguins dataset was proposed as an alternative to the [`iris` dataset](https://en.wikipedia.org/wiki/Iris_flower_data_set) by Fisher (<a href="#citeproc_bib_item_1">1936</a>) for data exploration and visualization.

<blockquote class="twitter-tweet">
  <p lang="en" dir="ltr">
  🐧🐧🐧
  <br><br>
  This penguin data is a great alternative to iris &amp; available for use by CC0 🤩 Thank you Dr. Kristen Gorman w/ <a href="https://twitter.com/UAFcfos?ref_src=twsrc%5Etfw">@UAFcfos</a>, Marty Downs w/ <a href="https://twitter.com/USLTER?ref_src=twsrc%5Etfw">@USLTER</a>, &amp; <a href="https://twitter.com/PalmerLTER?ref_src=twsrc%5Etfw">@PalmerLTER</a> for help, info &amp; making it available for use 🎉
  <br><br>
  Data, examples, &amp; use info here: <a href="https://t.co/dSIqWNFlVw">https://t.co/dSIqWNFlVw</a> 🧵 1/6 <a href="https://t.co/2Eu4AxoeZl">pic.twitter.com/2Eu4AxoeZl</a>
  </p>
  <br><br>
  &mdash; Allison Horst (@allison_horst) <a href="https://twitter.com/allison_horst/status/1270046399418138625?ref_src=twsrc%5Etfw">June 8, 2020</a>
</blockquote>

<script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

Fisher was a vocal proponent of eugenics and published the `iris` dataset in the **Annals of Eugenics** in 1936 (!).
Hence there is growing sentiment in the scientific community that the use of the `iris` dataset is inappropriate.

> One does not publish in the Annals of Eugenics in 1936 on a misunderstanding.
> By using this dataset in 2020, we are sending a very strong message.
>
> — [Timothée Poisot](https://armchairecology.blog/iris-dataset)

<!--quoteend-->

> Many people using iris will be unaware that it was first published in work by R A Fisher, a eugenicist with vile and harmful views on race.
> In fact, the iris dataset was originally published in the Annals of Eugenics.
> It is clear to me that knowingly using work that was itself used in pursuit of racist ideals is totally unacceptable.
>
> — [Megan Stodel](https://www.meganstodel.com/posts/no-to-iris)

<!--quoteend-->

> I’ve long known about Ronald Fisher’s eugenicist past, but I admit that I have often thoughtlessly turned to iris when needing a small, boring data set to demonstrate a coding or data principle.
>
> But Daniella and Timothée Poisot are right: it’s time to retire iris.
>
> — [Garrick Aden-Buie](https://www.garrickadenbuie.com/blog/lets-move-on-from-iris)

Apart from that, the `iris` dataset is quite boring:
it contains no missing values and:

> With the exception of one or two points, the classes are linearly separable, and so classification algorithms reach almost perfect accuracy.
>
> — [Timothée Poisot](https://armchairecology.blog/iris-dataset)

The Palmer penguins dataset consists of measurements of 344 penguins from three islands in the [Palmer Archipelago, Antarctica](https://en.wikipedia.org/wiki/Palmer_Archipelago), that were collected by [Dr. Kristen Gorman](https://www.uaf.edu/cfos/people/faculty/detail/kristen-gorman.php) and the [Palmer Station, Antarctica LTER](https://pal.lternet.edu/) (<a href="#citeproc_bib_item_2">Gorman, Williams, and Fraser 2014</a>).
The simplified version of the dataset contains at most seven measurements for each penguin, namely the species (`Adelie`, `Chinstrap`, and `Gentoo`), the island (`Torgersen`, `Biscoe`, and `Dream`), the bill length (measured in mm), the bill depth (measured in mm), the flipper length (measured in mm), the body mass (measured in g), and the sex (`male` and `female`).
In total, 19 measurements are missing.

{{< figure src="https://allisonhorst.github.io/palmerpenguins/reference/figures/lter_penguins.png" alt="Palmer penguins" caption="<span class=\"figure-number\">Figure 1: </span>Palmer penguins. Artwork by [@allison_horst](https://twitter.com/allison_horst)." >}}


## Julia package {#julia-package}

The Julia package `PalmerPenguins.jl` is available in the standard Julia package registry, so you can install it and load it in the usual way by running

```julia
using Pkg
Pkg.add("PalmerPenguins")

using PalmerPenguins
```

in the Julia REPL.
The package uses [`DataDeps.jl`](https://github.com/oxinabox/DataDeps.jl) to download a fixed (and hence reproducible) version of the dataset once instead of including a copy of the original dataset.

As explained in the [package's README](https://github.com/devmotion/PalmerPenguins.jl/blob/master/README.md), the simplified and the raw version of the Palmer penguins dataset can be loaded in a [Tables.jl-compatible format](https://github.com/JuliaData/Tables.jl).
We can inspect the names and types of the features in the simplified and the raw version by running

```julia
using Tables

Tables.schema(PalmerPenguins.load())
```

```text
Tables.Schema:
 :species            InlineStrings.String15
 :island             InlineStrings.String15
 :bill_length_mm     Union{Missing, Float64}
 :bill_depth_mm      Union{Missing, Float64}
 :flipper_length_mm  Union{Missing, Int64}
 :body_mass_g        Union{Missing, Int64}
 :sex                Union{Missing, InlineStrings.String7}
```

and

```julia
Tables.schema(PalmerPenguins.load(; raw=true))
```

```text
Tables.Schema:
 :studyName                     InlineStrings.String7
 Symbol("Sample Number")        Int64
 :Species                       String
 :Region                        InlineStrings.String7
 :Island                        InlineStrings.String15
 :Stage                         InlineStrings.String31
 Symbol("Individual ID")        InlineStrings.String7
 Symbol("Clutch Completion")    Bool
 Symbol("Date Egg")             Dates.Date
 Symbol("Culmen Length (mm)")   Union{Missing, Float64}
 Symbol("Culmen Depth (mm)")    Union{Missing, Float64}
 Symbol("Flipper Length (mm)")  Union{Missing, Int64}
 Symbol("Body Mass (g)")        Union{Missing, Int64}
 :Sex                           Union{Missing, InlineStrings.String7}
 Symbol("Delta 15 N (o/oo)")    Union{Missing, Float64}
 Symbol("Delta 13 C (o/oo)")    Union{Missing, Float64}
 :Comments                      Union{Missing, String}
```

We also see that the names of the features in the simplified dataset are normalized to lowercase characters without whitespace and brackets.

You might want to convert the tables to a `DataFrame` object for downstream analyses.
The following code extracts the first five rows of the simplified dataset:

```julia
using DataFrames

first(DataFrame(PalmerPenguins.load()), 5)
```

```text
5×7 DataFrame
 Row │ species   island     bill_length_mm  bill_depth_mm  flipper_length_mm  body_mass_g  sex
     │ String15  String15   Float64?        Float64?       Int64?             Int64?       String7
─────┼─────────────────────────────────────────────────────────────────────────────────────────────
   1 │ Adelie    Torgersen            39.1           18.7                181         3750  male
   2 │ Adelie    Torgersen            39.5           17.4                186         3800  female
   3 │ Adelie    Torgersen            40.3           18.0                195         3250  female
   4 │ Adelie    Torgersen       missing        missing              missing      missing  missing
   5 │ Adelie    Torgersen            36.7           19.3                193         3450  female
```

Data can be extracted with the Tables.jl-interface as well without creating a `DataFrame` object, as shown in the following visualizations of the Palmer penguins dataset.
The following plots replicate the [official examples](https://allisonhorst.github.io/palmerpenguins/#examples) (even interactively!).

```julia
using PlotlyJS

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
```

<div id="penguins-scatter"></div>
<script>
  graphDiv = document.getElementById("penguins-scatter");
  plotlyPromise = PlotlyJS_json(graphDiv, "scatter.json")
</script>

```julia
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
```

<div id="penguins-hist"></div>
<script>
  graphDiv = document.getElementById("penguins-hist");
  plotlyPromise = PlotlyJS_json(graphDiv, "hist.json")
</script>

## References

<style>.csl-entry{text-indent: -1.5em; margin-left: 1.5em;}</style><div class="csl-bib-body">
  <div class="csl-entry"><a id="citeproc_bib_item_1"></a>Fisher, R. A. 1936. “The Use of Multiple Measurements in Taxonomic Problems.” <i>Annals of Eugenics</i> 7 (2): 179–88. <a href="https://doi.org/10.1111/j.1469-1809.1936.tb02137.x">https://doi.org/10.1111/j.1469-1809.1936.tb02137.x</a>.</div>
  <div class="csl-entry"><a id="citeproc_bib_item_2"></a>Gorman, K. B., T. D. Williams, and W. R. Fraser. 2014. “Ecological Sexual Dimorphism and Environmental Variability within a Community of Antarctic Penguins (Genus Pygoscelis).” <i>PLoS ONE</i> 9 (3): e90081. <a href="https://doi.org/10.1371/journal.pone.0090081">https://doi.org/10.1371/journal.pone.0090081</a>.</div>
  <div class="csl-entry"><a id="citeproc_bib_item_3"></a>Horst, A. M., A. P. Hill, and K. B. Gorman. 2020. “Palmerpenguins: Palmer Archipelago (Antarctica) Penguin Data.” <a href="https://doi.org/10.5281/zenodo.3960218">https://doi.org/10.5281/zenodo.3960218</a>.</div>
</div>
