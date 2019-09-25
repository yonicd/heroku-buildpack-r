library(plumber)
library(httr)
library(jsonlite)
library(RPostgres)
library(DBI)

connect_creds <- function(db_url = Sys.getenv('DATABASE_URL')){

  if(!nzchar(db_url)){
  
    config <- processx::run(
      command = "heroku", 
      args = c("config:get", "DATABASE_URL", "-a", "slackr-auth")
    )
    
    db_url <- config$stdout
    
  }

  pg     <- httr::parse_url(db_url)  
    
  DBI::dbConnect(drv      = RPostgres::Postgres(),
                 dbname   = trimws(pg$path),
                 host     = pg$hostname,
                 port     = pg$port,
                 user     = pg$username,
                 password = pg$password,
                 sslmode  = "require"
  )
  
}

update_creds <- function(h){
  
  con <- connect_creds()
  
  on.exit(DBI::dbDisconnect(con),add = TRUE)

  DBI::dbAppendTable(con,'CREDS',get_to_creds(h))

  return(digest::sha1(h))
}

query_creds <- function(memberid,key){
  
  con <- connect_creds()
  
  on.exit(DBI::dbDisconnect(con),add = TRUE)
  
  query_root <- paste('SELECT "ACCESS_TOKEN" AS "api_token"',
                      '"INCOMING_WEBHOOK_URL" AS "incoming_webhook_url"',
                      '"INCOMING_WEBHOOK_CHANNEL" AS "channel" FROM "CREDS"',
                      sep = ', ')
  
  query <- sprintf('%s WHERE ("SLACK_KEY_ID" = %s AND "USER_ID" = %s)',
                   query_root, shQuote(key),shQuote(memberid))
  
  ret <- DBI::dbGetQuery(con, query)
  
}

get_to_creds <- function(x){
  
  x <- append(list(SLACK_KEY_ID = digest::sha1(x)),x)
  
  ret <- data.frame(t(unlist(x,recursive = TRUE)),stringsAsFactors = FALSE)
  
  names(ret) <- gsub('[.]','_',toupper(names(ret)))
  
  ret
  
}

port <- Sys.getenv('PORT')

r <- plumber::plumb("/app/myfile.R")

if(Sys.getenv("PORT") == "") Sys.setenv(PORT = 8000)

r$run(host = "0.0.0.0", port=as.numeric(Sys.getenv("PORT")), swagger = FALSE)
