@def title = "PalmerPenguins.jl"
@def hascode = true
@def hasplotly = true
@def published = "2020-07-28"

# PalmerPenguins.jl

Are you looking for a dataset for data exploration and visualization?
Maybe you should consider the
[Palmer penguins dataset](https://allisonhorst.github.io/palmerpenguins/),
which was published as an
[R package](https://cloud.r-project.org/web/packages/palmerpenguins/index.html)
recently \citep{Horst2020}.
I created the Julia package
[`PalmerPenguins.jl`](https://github.com/devmotion/PalmerPenguins.jl) to simplify
its use with the Julia programming language and increase its adoption
within the Julia community.

## TL;DR

The Palmer penguins dataset is an alternative to the controversial
`iris` dataset for data exploration and visualization (but, of course,
[not the only one](https://www.meganstodel.com/posts/no-to-iris/)).
The Julia package
[`PalmerPenguins.jl`](https://github.com/devmotion/PalmerPenguins.jl)
provides access to the raw and simplified versions of this dataset,
similar to the original R package, without having to download and parse
the raw data manually.

## Palmer penguins dataset

The Palmer penguins dataset was proposed as an alternative to the
[`iris` dataset](https://en.wikipedia.org/wiki/Iris_flower_data_set) by \citet{Fisher1936}
for data exploration and visualization.

~~~
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
~~~

Fisher was a vocal proponent of eugenics and published the `iris` dataset
in the *Annals of Eugenics* in 1936 (!). Hence there is growing sentiment in the
scientific community that the use of the `iris` dataset is
inappropriate.

> One does not publish in the Annals of Eugenics in 1936 on a misunderstanding. \\
> \\
> By using this dataset in 2020, we are sending a very strong message. \\
> \\
> &mdash; [Timothée Poisot](https://armchairecology.blog/iris-dataset)

> Many people using iris will be unaware that it was first published in work by
> R A Fisher, a eugenicist with vile and harmful views on race. In fact, the iris
> dataset was originally published in the Annals of Eugenics. It is clear to me
> that knowingly using work that was itself used in pursuit of racist ideals is
> totally unacceptable. \\
> \\
> &mdash; [Megan Stodel](https://www.meganstodel.com/posts/no-to-iris)

> I’ve long known about Ronald Fisher’s eugenicist past, but I admit that I have
> often thoughtlessly turned to iris when needing a small, boring data set to
> demonstrate a coding or data principle. \\
> \\
> But Daniella and Timothée Poisot are right: it’s time to retire iris. \\
> \\
> &mdash; [Garrick Aden-Buie](https://www.garrickadenbuie.com/blog/lets-move-on-from-iris)

Apart from that, the `iris` dataset is quite boring: it contains no
missing values and:

> With the exception of one or two points, the classes are linearly
> separable, and so classification algorithms reach almost perfect accuracy. \\
> \\
> &mdash; [Timothée Poisot](https://armchairecology.blog/iris-dataset)

The Palmer penguins dataset consists of measurements of 344 penguins from
three islands in the
[Palmer Archipelago, Antarctica](https://en.wikipedia.org/wiki/Palmer_Archipelago),
that were collected by
[Dr. Kristen Gorman](https://www.uaf.edu/cfos/people/faculty/detail/kristen-gorman.php)
and the [Palmer Station, Antarctica LTER](https://pal.lternet.edu/)
\citep{Gorman2014}. The simplified version of the dataset contains at most
seven measurements for each penguin, namely the species (`Adelie`, `Chinstrap`,
and `Gentoo`), the island (`Torgersen`, `Biscoe`, and `Dream`),
the bill length (measured in mm), the bill depth (measured in mm),
the flipper length (measured in mm), the body
mass (measured in g), and the sex (`male` and `female`). In total,
19 measurements are missing.

~~~
<figure>
    <img src="https://allisonhorst.github.io/palmerpenguins/reference/figures/lter_penguins.png" alt="Palmer penguins">
    <figcaption>Palmer penguins. Artwork by <a href="https://twitter.com/allison_horst">@allison_horst</a>.</figcaption>
</figure>
~~~

## Julia package

The Julia package `PalmerPenguins.jl` is available in the standard Julia
package registry, so you can install it and load it in the usual way by running
```julia-repl
julia> import Pkg; Pkg.add("PalmerPenguins")

julia> using PalmerPenguins
```
in the Julia REPL. The package uses [`DataDeps.jl`](https://github.com/oxinabox/DataDeps.jl) to download a fixed (and hence reproducible) version of the dataset
once instead of including a copy of the original dataset.

As explained in the
[package's README](https://github.com/devmotion/PalmerPenguins.jl/blob/master/README.md),
the simplified and the raw version of the Palmer penguins dataset
can be loaded in a
[Tables.jl-compatible format](https://github.com/JuliaData/Tables.jl).
We can inspect the names and types of the features in the simplified
and the raw version by running

```julia:schema
using PalmerPenguins
using Tables

ENV["DATADEPS_ALWAYS_ACCEPT"] = true # hide
const TABLE = PalmerPenguins.load()

Tables.schema(TABLE)
```
\show{schema}

and

```julia:schema_raw
const TABLE_RAW = PalmerPenguins.load(; raw = true)

Tables.schema(TABLE_RAW)
```
\show{schema_raw}

We also see that the names of the features in the
simplified dataset are normalized to lowercase characters
without whitespace and brackets.

You might want to convert the tables to a `DataFrame` object for
downstream analyses. The following code extracts the first five rows
of the simplified dataset:

```julia:dataframe
using DataFrames

first(DataFrame(TABLE), 5)
```

\show{dataframe}

Data can be extracted with the Tables.jl-interface as well without
creating a `DataFrame` object, as shown in the following visualizations
of the Palmer penguins dataset. The following plots replicate the
[official examples](https://allisonhorst.github.io/palmerpenguins/#examples)
(even interactively!).

```julia:ex1
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
```

\textoutput{ex1}

```julia:ex2
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
```

\textoutput{ex2}

## References

* \biblabel{Fisher1936}{Fisher (1936)}Fisher, R. A. (1936). The use of multiple measurements in taxonomic prolems. *Annals of Eugenics*, *7*(2), 179--188. doi:[10.1111/j.1469-1809.1936.tb02137.x](https://doi.org/10.1111/j.1469-1809.1936.tb02137.x)

* \biblabel{Gorman2014}{Gorman, Williams, & Fraser (2014)}Gorman, K. B., Williams, T. D., & Fraser, W. R. (2014). Ecological sexual dimorphism and environmental variability within a community of Antarctic penguins (genus *Pygoscelis*). *PLoS ONE*, 9(3):e90081. doi:[10.1371/journal.pone.0090081](https://doi.org/10.1371/journal.pone.0090081)

* \biblabel{Horst2020}{Horst, Hill, & Gorman (2020)}Horst, A. M., Hill, A. P., & Gorman, K. B. (2020). *palmerpenguins: Palmer Archipelago (Antarctica) penguin data*. R package version 0.1.0. doi:[10.5281/zenodo.3960218](https://doi.org/10.5281/zenodo.3960218)

