library(plumber)
library(httr)
library(jsonlite)

store_creds <- function(h){
  
  if(!file.exists(Sys.getenv('CREDS_PATH'))){
    
    creds <- list()
    
  }else{
    
    creds <- jsonlite::read_json(Sys.getenv('CREDS_PATH'))  
    
  }
    
  if(h$team_name%in%names(creds)){
    
    if(h$user_id%in%names(creds[[h$team_name]])){
      
      webhookid <- basename(h$incoming_webhook$configuration_url)
        
      if(!webhookid%in%names(creds[[h$team_name]][[h$user_id]])){
        
        creds[[h$team_name]][[h$user_id]][[webhookid]] <- h
        
      }else{
        
        return(invisible(NULL))
        
      }
      
    }else{
      
      creds[[h$team_name]][[h$user_id]] <- h
      
    }
    
  }else{
    
    creds[[h$team_name]] <- list()
    creds[[h$team_name]][[h$user_id]] <- list()
    webhookid <- basename(h$incoming_webhook$configuration_url)
    creds[[h$team_name]][[h$user_id]][[webhookid]] <- h
    
  }
  
  jsonlite::write_json(creds,path = Sys.getenv('CREDS_PATH'))
  
}

port <- Sys.getenv('PORT')

r <- plumber::plumb("/app/myfile.R")

if(Sys.getenv("PORT") == "") Sys.setenv(PORT = 8000)

r$run(host = "0.0.0.0", port=as.numeric(Sys.getenv("PORT")), swagger = FALSE)
