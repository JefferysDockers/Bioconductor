FROM rocker/r-ver:4.1.0

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    bzip2 \
    ca-certificates \
    curl \
    libbz2-dev \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    liblzma-dev \
    openssl \
    pkg-config \
    zlib1g-dev

RUN R -e 'install.packages("BiocManager")' \
 && R -e 'BiocManager::install( \
    update= FALSE, \
    ask= FALSE, \
    version= "3.13" \
)'
