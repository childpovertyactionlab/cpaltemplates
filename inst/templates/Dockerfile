# R base image
FROM rocker/r-ver:4.4.1

WORKDIR /app

# Linux dependencies
RUN apt-get update && apt-get install -y \
build-essential \
pkg-config \
libxml2-dev \
libgdal-dev \
libproj-dev \
libgit2-dev \
libfontconfig1-dev \
libfreetype6-dev \
libharfbuzz-dev \
libfribidi-dev \
libudunits2-dev \
zlib1g-dev \
libgl1-mesa-dev \
libmagick++-dev \
libcurl4-gnutls-dev \
protobuf-compiler \
libprotobuf-dev \
libjq-dev \
cmake \
libmagick++-dev

# R packages
RUN R -e "install.packages(c('tidyverse', 'tidycensus', 'googlesheets4', 'sf', 'tidygeocoder', 'shiny', 'leaflet', 'leaflet.extras', 'reactable', 'DT', 'rio', 'highcharter', 'broom', 'janitor', 'mapgl'))"

# GitHub packages
RUN R -e "devtools::install_github(c('childpovertyactionlab/cpaltemplates', 'childpovertyactionlab/cpaltools'))"

EXPOSE 3000

COPY . .

CMD ["Rscript", "run_app.R"]
