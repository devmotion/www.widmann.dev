using DataStructures
using JSON

using Dates

function hfun_bar(vname)
  val = Meta.parse(vname[1])
  return round(sqrt(val), digits=2)
end

function hfun_m1fill(vname)
  var = vname[1]
  return pagevar("index", var)
end

function lx_baz(com, _)
  # keep this first line
  brace_content = Franklin.content(com.braces[1]) # input string
  # do whatever you want here
  return uppercase(brace_content)
end

function getpubdate(
    url;
    year = Dates.year(Dates.today()),
    month = Dates.month(Dates.today())
)
    pubdate = pagevar(url, :published)
    if pubdate === nothing
        return Dates.Date(year, month, 1)
    else
        return Dates.Date(pubdate, dateformat"yyyy-mm-dd")
    end
end

"""
    {{blogposts}}

Plug in the list of blog posts contained in the `/blog/` folder.
"""
function hfun_blogposts()
    curdate = Dates.today()

    urls = String[]
    dates = Date[]

    for yeardir in filter!(x -> match(r"^\d{4}$", x) !== nothing, readdir("blog"))
        # filter directories
        yearpath = joinpath("blog", yeardir)
        isdir(yearpath) || continue

        # check year
        year = parse(Int, yeardir)
        curdate >= Dates.Date(year, 1, 1) || continue

        for monthdir in filter!(x -> match(r"^\d{2}$", x) !== nothing, readdir(yearpath))
            # filter directories
            monthpath = joinpath(yearpath, monthdir)
            isdir(monthpath) || continue

            # check month
            month = parse(Int, monthdir)
            curdate >= Dates.Date(year, month, 1) || continue

            for post in filter!(p -> endswith(p, ".md"), readdir(monthpath))
                ps = splitext(post)[1]
                url = "blog/$yeardir/$monthdir/$ps"

                # check date
                pubdate = getpubdate(url; year = year, month = month)
                curdate >= pubdate || continue

                # add post
                push!(urls, url)
                push!(dates, pubdate)
            end
        end
    end

    io = IOBuffer()
    write(io, "<ul class=\"blogs\">\n")
    indices = sortperm(dates; rev=true)
    for i in indices
        url = urls[i]
        date = dates[i]

        # obtain title
        title = pagevar(url, :title)
        write(
            io,
            """
            <li>
                <a href="/$url/" class="title">$title</a>
                $(day(date)) $(monthname(date)) $(year(date))
            </li>
            """
        )
    end
    write(io, "</ul>")

    return String(take!(io))
end

"""
    {{recentblogposts(n)}}

Input the `n` most recent blog posts.
"""
function hfun_recentblogposts(n=3)
    blogs = PriorityQueue{String,Date}()

    curdate = Dates.today()

    for yeardir in filter!(x -> match(r"^\d{4}$", x) !== nothing, readdir("blog"))
        # filter directories
        yearpath = joinpath("blog", yeardir)
        isdir(yearpath) || continue

        # check year
        year = parse(Int, yeardir)
        curdate >= Dates.Date(year, 1, 1) || continue

        for monthdir in filter!(x -> match(r"^\d{2}$", x) !== nothing, readdir(yearpath))
            # filter directories
            monthpath = joinpath(yearpath, monthdir)
            isdir(monthpath) || continue

            # check month
            month = parse(Int, monthdir)
            curdate >= Dates.Date(year, month, 1) || continue

            for post in filter!(p -> endswith(p, ".md"), readdir(monthpath))
                ps = splitext(post)[1]
                url = "blog/$yeardir/$monthdir/$ps"

                # check date
                pubdate = getpubdate(url; year = year, month = month)
                curdate >= pubdate || continue

                # add to queue
                if length(blogs) < n
                    enqueue!(blogs, url => pubdate)
                elseif peek(blogs) < pubdate
                    dequeue!(blogs)
                    enqueue!(blogs, url => pubdate)
                end
            end
        end
    end

    # reverse priority queue
    m = length(blogs)
    urls = Vector{String}(undef, m)
    dates = Vector{Date}(undef, m)
    while !isempty(blogs)
        url, date = dequeue_pair!(blogs)
        urls[m] = url
        dates[m] = date
        m -= 1
    end

    io = IOBuffer()
    write(io, "<ul class=\"blogs\">\n")
    for (url, date) in zip(urls, dates)
        title = pagevar(url, :title)
        write(
            io,
            """
            <li>
                <a href="/$url/" class="title">$title</a>
                $(day(date)) $(monthname(date)) $(year(date))
            </li>
            """
        )
    end
    write(io, "</ul>\n")

    return String(take!(io))
end

function myfdplotly(
    plt;
    style = "width:80%;margin-left:auto;margin-right:auto;margin-bottom:1em;",
    kwargs...
)
    return fdplotly(json(plt); style = style, kwargs...)
end
