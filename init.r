# init.R
#
# Example R code to install packages if not already installed
#

install_if_missing = function(p) {
  if (p %in% rownames(installed.packages()) == FALSE) {
    install.packages(p, dependencies = TRUE)
  }
  else {
    cat(paste("Skipping already installed package:", p, "\n"))
  }
}

install_if_missing_gh = function(p) {
  if (p %in% rownames(installed.packages()) == FALSE) {
    remotes::install_github(repo = p)
  }
  else {
    cat(paste("Skipping already installed package:", p, "\n"))
  }
}

#install.packages("remotes", dependencies = TRUE)

my_packages_gh = c("igraph/rigraph")
#invisible(sapply(my_packages_gh, install_if_missing_gh))

my_packages = c('reshape2','geojson','readxl','leaflet',
                'httr','rgeolocate','shiny','ggplot2','sp',
                'widyr','slickR','ggraph','svglite',
                'dplyr')

#invisible(sapply(my_packages, install_if_missing))