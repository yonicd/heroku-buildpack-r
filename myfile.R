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
  
  ret <- httr::GET(url = uri,
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
#* @get /creds/<userid>/<key>
creds <- function(userid, key, req, res){
  
  db_con <- connect_creds()
  
  on.exit(DBI::dbDisconnect(db_con),add = TRUE)
  
  db     <- dbplyr::src_dbi(db_con)
  
  creds_db <- dplyr::tbl(db, "CREDS")
  
  ret <- creds_db%>%
    dplyr::filter(SLACK_KEY_ID==key&USER_ID==userid)%>%
    dplyr::select(api_token = ACCESS_TOKEN,
                  incoming_webhook_url = INCOMING_WEBHOOK_URL)%>%
    dplyr::collect()%>%
    as.list()
  
  lapply(ret,jsonlite::unbox)
  
}


# Localhost
# http://127.0.0.1:3000/creds/U6GMPP81H/965a8c62f782ef465fadfb52cf4bab3862eaa641
# http://127.0.0.1:3000/auth
# http://localhost:3000/auth/redirect
# plumber::plumb(file='myfile.R')$run(port = 3000L,host = '0.0.0.0',swagger = FALSE)

# Heroku
# https://slackr-auth.herokuapp.com/creds/U6GMPP81H/965a8c62f782ef465fadfb52cf4bab3862eaa641
# https://slackr-auth.herokuapp.com/auth/redirect
