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
