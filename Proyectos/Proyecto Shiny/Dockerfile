FROM rocker/r-base:latest
LABEL maintainer="Daniel Behar <danielbehar@ufm.edu>"
LABEL maintainer="Cruz del Cid <cldelcid@ufm.edu>"
RUN apt-get update && apt-get install -y --no-install-recommends \
    sudo \
    libcurl4-gnutls-dev \
    libcairo2-dev \
    libxt-dev \
    libssl-dev \
    libssh2-1-dev \
    && rm -rf /var/lib/apt/lists/*
RUN install.r shiny
RUN install.r plotly
RUN install.r dplyr
RUN install.r DT
RUN echo "local(options(shiny.port = 3838, shiny.host = '0.0.0.0'))" > /usr/lib/R/etc/Rprofile.site
RUN addgroup --system app \
    && adduser --system --ingroup app app
WORKDIR /home/app
COPY /. /home/app
RUN chown app:app -R /home/app
USER app
EXPOSE 3838
CMD ["R", "-e", "shiny::runApp('/home/app')"]