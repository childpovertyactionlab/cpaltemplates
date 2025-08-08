# {name}

{description}

**Author:** {author}
**Created:** {date}

## Setup

```r
# install dependencies
renv::restore()
```

## Project structure

* data/ – raw & processed data

* scripts/ – analysis scripts

* output/ – tables, intermediate files

* figures/ – plots & maps

* assets/ – logos, tex, images

* {if type=="shiny"}- app/ – Shiny app code{/if}

* {if type=="report"}- report/ – Quarto report{/if}
