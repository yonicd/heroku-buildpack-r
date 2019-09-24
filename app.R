library(plumber)
library(httr)

fivemin <- function(){
  
  format(
    Sys.time() + (5*60),
    '%a, %d %b %Y %H:%M:%S',
    tz = 'GMT',
    usetz = TRUE
  )
  
}

redirect_uri <- function(app_id){
  sprintf('https://slack.com/app_redirect?%s',app_id)
}

scopes <- function(){
  c('incoming-webhook',
              'files:read',
              'files:write:user',
              'chat:write:bot',
              'chat:write:user',
              'mpim:write',
              'mpim:read',
              'mpim:history',
              'im:write',
              'im:read',
              'im:history',
              'groups:write',
              'groups:read',
              'groups:history',
              'channels:write',
              'channels:read',
              'channels:history',
              'emoji:read',
              'usergroups:read',
              'users:read')
}

port <- Sys.getenv('PORT')

r <- plumber::plumb("/app/myfile.R")

if(Sys.getenv("PORT") == "") Sys.setenv(PORT = 8000)

r$run(host = "0.0.0.0", port=as.numeric(Sys.getenv("PORT")), swagger = TRUE)

# r$run(host='0.0.0.0', port=strtoi(port),swagger = TRUE)
