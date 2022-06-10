SHELL := /bin/bash
JULIA := JULIA_LOAD_PATH="@:tools:@v\#.\#:@stdlib" julia -L tools/L.jl

.PHONY: serve optimize

serve:
	${JULIA} -e 'Franklin.serve(; clear=true, verb=true)'
optimize:
	${JULIA} -e 'Franklin.optimize(; prerender=false, minify=false)'
