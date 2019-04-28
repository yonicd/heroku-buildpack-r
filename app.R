library(plumber)

port <- Sys.getenv('PORT')

r <- plumber::plumb("app/myfile.R")

r$run(host='0.0.0.0', port=strtoi(port))
