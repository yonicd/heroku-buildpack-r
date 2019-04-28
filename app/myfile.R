# myfile.R

#* @get /mean
normalMean <- function(samples=10){
  data <- rnorm(samples)
  mean(data)
}

#* Return the sum of two numbers
#* @param a The first number to add
#* @param b The second number to add
#* @post /sum
addTwo <- function(a, b){
  as.numeric(a) + as.numeric(b)
}
