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
#* @html
#* @param repo github owner/repo
#* @param stat uniques or count
#* @get /clones
clones <- function(repo = 'yonicd/whereami',stat = 'uniques'){
  
  sum(fetch_data(repo, type = 'clones', stat = stat))
  
  
}

#* Github Views
#* @html
#* @param repo github owner/repo
#* @param stat uniques or count
#* @get /views
views <- function(repo = 'yonicd/whereami',stat = 'uniques'){
  
  sum(fetch_data(repo, type = 'views', stat = stat))
  
}

