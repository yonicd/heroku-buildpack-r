# myfile.R

#* Random sample
#* @param samples sample size
#* @get /mean
normalMean <- function(samples=10){
  rnorm(samples)
}

#* Return the sum of two numbers
#* @param a The first number to add
#* @param b The second number to add
#* @post /sum
addTwo <- function(a, b){
  as.numeric(a) + as.numeric(b)
}

#* Github Clones
#* @param repo github owner/repo
#* @param stat uniques or count
#* @get /clones
clones <- function(repo = 'yonicd/whereami',stat = 'uniques'){
  
  x <- fetch_data(repo, type = 'clones', stat = stat)
  
  sprintf('https://img.shields.io/badge/clones-%s-f39f37.svg',x[1])
}

#* Github Views
#* @param repo github owner/repo
#* @param stat uniques or count
#* @get /views
views <- function(repo = 'yonicd/whereami',stat = 'uniques'){
  
  fetch_data(repo, type = 'views', stat = stat)
  
}

