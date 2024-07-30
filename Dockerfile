# start from the rstudio/plumber image
FROM rocker/r-ver:4.4.1

# install the linux libraries needed for plumber
RUN apt-get update -qq && apt-get install -y  libssl-dev  libcurl4-gnutls-dev  libpng-dev
    
    
# install plumber, tidyverse, and caret packages. They are used in the myAPI.R script
RUN R -e "install.packages('plumber')"
RUN R -e "install.packages('tidyverse')"
RUN R -e "install.packages('caret')"

# copy everything from the current directory into the container
COPY myAPI.R myAPI.R

# open port to traffic
EXPOSE 8000

# when the container starts, start the myAPI.R script
ENTRYPOINT ["R", "-e", \
    "pr <- plumber::plumb('myAPI.R'); pr$run(host='0.0.0.0', port=8000)"]