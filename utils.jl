using Franklin: Franklin

using Dates: Dates
using Printf: Printf

function getpubdate(url; year=Dates.year(Dates.today()), month=Dates.month(Dates.today()))
    pubdate = Franklin.pagevar(url, :published)
    if pubdate === nothing
        return Dates.Date(year, month, 1)
    else
        return Dates.Date(pubdate, Dates.dateformat"yyyy-mm-dd")
    end
end

"""
    {{blogposts(n_string=["-1"])}}

List of blog posts contained in the `/posts/` folder.

If `n >= 0` where `n = parse(Int, only(n_string))`, then only the `n` most recent posts are shown.
Otherwise all posts are listed.
"""
function hfun_blogposts(n_string::Vector{String}=["-1"])
    n = parse(Int, only(n_string))
    recent = blogposts(n)

    io = IOBuffer()
    write(io, "<ul class=\"blogs\">\n")
    for (post, date) in recent
        # obtain title and url
        title = Franklin.pagevar(post, :title)
        url = basename(post) == "index.md" ? dirname(post) : post
        write(
            io,
            """
            <li>
                <a href="/$url/" class="title">$title</a>
                $(day(date)) $(monthname(date)) $(year(date))
            </li>
            """,
        )
    end
    write(io, "</ul>")

    return String(take!(io))
end

function blogposts(n::Int=-1)
    curyear = Dates.year(Dates.today())
    nposts = 0
    recent = Vector{Pair{String,Date}}(undef, 0)
    n > 0 && sizehint!(recent, n)

    for year in curyear:-1:2019, month in 12:-1:1
        nposts == n && break

        base = joinpath("blog", string(year), Printf.@sprintf("%02d", month))
        isdir(base) || continue

        m = nposts
        for post in readdir(base; join=true)
            if isdir(post) && isfile(joinpath(post, "index.md"))
                post = joinpath(post, "index.md")
            end
            endswith(post, ".md") || continue
            pubdate = getpubdate(post)

            if nposts != n
                push!(recent, (post => pubdate))
                for i in nposts:-1:(m + 1)
                    pubdate <= recent[i][2] && break
                    recent[i], recent[i + 1] = recent[i + 1], recent[i]
                end
                nposts += 1
            elseif nposts > m && pubdate > recent[end][2]
                recent[end] = (post => pubdate)
            end
        end
    end

    return recent
end

hfun_get_url() = Franklin.get_url(Franklin.locvar("fd_rpath"))

function hfun_markdown2html(args)
    arg = only(args)
    if arg == "website_description" || arg == "title" || arg == "markdown_title"
        str = Franklin.locvar(arg)
        @assert str !== nothing
        return Franklin.md2html(str; stripp=true)
    else
        error("unknown argument arg = $arg")
    end
end
