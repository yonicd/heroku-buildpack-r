# myfile.R

#* auth
#* @get /auth
auth <- function(req,res){
  
  plumber::include_html(file = 'add_to_slack.html',res)
  
}

#* redirect
#* @get /auth/redirect
auth <- function(req,res){

  root <- 'https://slack.com/api/oauth.access'
  root_redirect <- 'https://slackr-auth.herokuapp.com'
  #root_redirect <- 'http://localhost:3000'
  
  uri <- sprintf('%s?code=%s&client_id=%s&client_secret=%s&redirect_uri=%s',
                 root,
                 req$args$code,
                 Sys.getenv('SLACK_CLIENT_ID'),
                 Sys.getenv('SLACK_CLIENT_SECRET'),
                 sprintf('%s/auth/redirect',root_redirect))
  
  ret <- httr::GET(
    url = uri,
    encode = 'json',
    body = FALSE,
    httr::verbose()
  )

  h <- httr::content(ret)
  
  if(!h$ok){
    
    list(error=jsonlite::unbox(h$error))    
    
  }else{
    
    cred_key <- update_creds(h)
    
    list(SLACK_KEY_ID = jsonlite::unbox(cred_key))
    
  }
  
}

#* creds
#* @get /creds/<memberid>/<key>
creds <- function(memberid, key, req, res){
  
  ret <- query_creds(memerid,key)
  
  ret_list <- as.list(ret)

  lapply(ret_list,jsonlite::unbox)
  
}


# Localhost
# http://127.0.0.1:3000/creds/MEMBERID/SLACK_KEY_ID
# http://127.0.0.1:3000/auth
# http://localhost:3000/auth/redirect
# plumber::plumb(file='myfile.R')$run(port = 3000L,host = '0.0.0.0',swagger = FALSE)

# Heroku
# https://slackr-auth.herokuapp.com/creds//MEMBERID/SLACK_KEY_ID
# https://slackr-auth.herokuapp.com/auth/redirect
