# myfile.R

#* start
#* @get /start
ask <- function(req,res){
  
  redirect_uri <- 'https://slackr-auth.herokuapp.com/slack/auth/redirect'
  
  uri <- sprintf('https://slack.com/oauth/authorize?client_id=%s&scope=%s',
                 Sys.getenv('SLACK_CLIENT_ID'),
                 paste0(scopes(),collapse = ',')
                 )
  
  httr::GET(url = uri,encode = 'json',body = FALSE,httr::verbose())
  
}

#* submit
#* @post /slack/auth/redirect
auth <- function(req,res){
  
  signing_secret <- Sys.getenv('SLACK_SIGNING_SECRET')
  
  slack_code <- req$code
  
  post_req <- httr::POST(url = "https://slack.com/api/oauth.access",
                         encode = 'form',
                         config = list(
                           httr::authenticate(
                             Sys.getenv('SLACK_CLIENT_ID'),
                             Sys.getenv('SLACK_CLIENT_SECRET')
                          ),
                           httr::add_headers(
                           "code"          =  slack_code,
                           "redirect_uri"  = "https://slackr-auth.herokuapp.com/slack/auth/redirect"
                         )),
                         body = FALSE,
                         httr::verbose()
  )
  
  uri <- redirect_uri(post_req$app_id)

  res$status <- 303 # redirect
  res$setHeader("Location", uri)
  res$setHeader("Expires",fivemin())
  res$setHeader("Cache-Control","max-age=300, public")
  
  res$body <- sprintf('<html>
  <head>
    <meta http-equiv=\"Refresh\" content=\"0; url=%s\" />
  </head>
  <body>
    <p>Please follow <a href=\"%s\">this link</a>.</p>
  </body>
</html>',uri,uri)
  
  res
  
}
