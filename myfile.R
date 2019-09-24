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
  #root_redirect <- 'http://localhost:3000'
  root_redirect <- 'https://slackr-auth.herokuapp.com'
  
  uri <- sprintf('%s?code=%s&client_id=%s&client_secret=%s&redirect_uri=%s',
                 root,
                 req$args$code,
                 Sys.getenv('SLACK_CLIENT_ID'),
                 Sys.getenv('SLACK_CLIENT_SECRET'),
                 sprintf('%s/auth/redirect',root_redirect))
  
  ret <- httr::GET(url = uri,
            encode = 'json',
            body = FALSE,
            httr::verbose()
  )

  h <- httr::content(ret)
  
  if(!h$ok){
    
    list(error=jsonlite::unbox(h$error))    
    
  }else{
    
    store_creds(h)
    
    jsonlite::unbox('Success!')
    
  }
  
}

# Localhost
# http://127.0.0.1:3000/auth
# http://localhost:3000/auth/redirect
