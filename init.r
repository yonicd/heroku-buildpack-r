#
# Example R code to install packages
# See http://cran.r-project.org/doc/manuals/R-admin.html#Installing-packages for details
#

reset_packages <- function(lib){
  
  ip <- installed.packages()
  pkgs.to.remove <- ip[!(ip[,"Priority"] %in% c("base", "recommended")), 1]
  remove.packages(pkgs.to.remove,lib)  
  
}

reset_packages(lib = .libPaths()[1])

###########################################################
# Update this line with the R packages to install:

my_packages = c("plumber","httr","jsonlite","digest","RPostgres","DBI")

###########################################################

install_if_missing = function(p) {
  if (p %in% rownames(installed.packages()) == FALSE) {
    install.packages(p, dependencies = TRUE)
  }
  else {
    cat(paste("Skipping already installed package:", p, "\n"))
  }
}
invisible(sapply(my_packages, install_if_missing))
