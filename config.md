<!-- RSS settings -->

+++
website_title = "David Widmann"
website_description = "My personal website. I am a PhD student at Uppsala University and write about research and programming."
website_url = get(ENV, "PREVIEW_FRANKLIN_WEBSITE_URL", "https://www.widmann.dev")
generate_rss = true
+++

<!-- Theme specific options -->
+++
author = "David Widmann"
hasplotly = false
+++

<!-- Support for Github previews -->
@def prepath = get(ENV, "PREVIEW_FRANKLIN_PREPATH", "")

<!-- Files and directories ignored by Franklin -->
@def ignore = [".JuliaFormatter.toml", "Makefile", "Manifest.toml", ".github/", "tools/"]
