# init.R
#
# Example R code to install packages if not already installed
#

my_packages = c("plotly","viridis","jsonlite","RColorBrewer",
                "readxl","DT","xtable","htmltools","htmlwidgets",
                "shinyHeatmaply","dplyr","heatmaply")

install_if_missing = function(p) {
  if (p %in% rownames(installed.packages()) == FALSE) {
    install.packages(p, dependencies = TRUE)
  }
  else {
    cat(paste("Skipping already installed package:", p, "\n"))
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
