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
#* @serializer unboxedJSON
#* @param owner github owner
#* @param repo github repo
#* @param stat uniques or count
#* @get /clones
clones <- function(owner,repo,stat){
  
  sum(fetch_data(owner = owner, repo = repo, type = 'clones', stat = stat))
  
  
}

#* Github Views
#* @serializer unboxedJSON
#* @param owner github owner
#* @param repo github repo
#* @param stat uniques or count
#* @get /views
views <- function(owner, repo, stat){
  
  sum(fetch_data(owner = owner, repo = repo, type = 'views', stat = stat))
  
}

