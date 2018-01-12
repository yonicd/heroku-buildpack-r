# init.R
#
# Example R code to install packages if not already installed
#

library(shiny)
library(plotly)
library(viridis)
library(jsonlite)
library(RColorBrewer)
library(readxl)
library(DT)
library(xtable)
library(htmltools)
library(htmlwidgets)
library(shinyHeatmaply)
library(dplyr)
library(heatmaply)

my_packages = c("plotly","viridis","jsonlite","RColorBrewer",
                "readxl","DT","xtable","htmltools","htmlwidgets",
                "shinyHeatmaply","dplyr","heatmaply")

install_if_missing = function(p) {
  if (p %in% rownames(installed.packages()) == FALSE) {
    install.packages(p)
  }
}

invisible(sapply(my_packages, install_if_missing))

# my_gh_packages = c("jsTree")
# 
# install_if_missing_gh = function(p) {
#   if (p %in% rownames(installed.packages()) == FALSE) {
#     devtools::install_github('metrumresearchgroup/jsTree')
#   }
# }

#invisible(sapply(my_gh_packages, install_if_missing_gh))
