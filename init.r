# init.R
#
# Example R code to install packages if not already installed
#

my_packages = c('reshape2','geojson','readxl','leaflet',
                'httr','rgeolocate','shiny','ggplot2','sp',
                'widyr','igraph','slickR','ggraph','svglite',
                'dplyr')

install_if_missing = function(p) {
  if (p %in% rownames(installed.packages()) == FALSE) {
    install.packages(p, dependencies = TRUE)
  }
  else {
    cat(paste("Skipping already installed package:", p, "\n"))
  }
}

invisible(sapply(my_packages, install_if_missing))