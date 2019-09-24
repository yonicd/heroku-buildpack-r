library(plumber)
library(httr)
library(jsonlite)

store_creds <- function(h){
  
  if(!file.exists(Sys.getenv('CREDS_PATH'))){
    
    creds <- list()
    
  }else{
    
    creds <- jsonlite::read_json(Sys.getenv('CREDS_PATH'))  
    
  }
    
  sh <- digest::sha1(h)
  
  creds[[sh]] <- h
  
  jsonlite::write_json(creds,path = Sys.getenv('CREDS_PATH'))
  
  return(sh)
  
}

port <- Sys.getenv('PORT')

r <- plumber::plumb("/app/myfile.R")

if(Sys.getenv("PORT") == "") Sys.setenv(PORT = 8000)

r$run(host = "0.0.0.0", port=as.numeric(Sys.getenv("PORT")), swagger = FALSE)
