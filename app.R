library(plumber)
library(httr)
library(jsonlite)

library(processx)
library(RPostgres)
library(dbplyr)
library(DBI)

connect_creds <- function(){
  
  pg     <- httr::parse_url(Sys.getenv('DATABASE_URL'))
  
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
  
  db_con <- connect_creds()
  
  on.exit(DBI::dbDisconnect(db_con),add = TRUE)
  
  db     <- dbplyr::src_dbi(db_con)
  
  dplyr::db_insert_into( con = db$con, table = "CREDS", values = get_to_creds(h))
  
  return(digest::sha1(h))
}

get_to_creds <- function(x){
  
  x <- append(list(SLACK_KEY_ID = digest::sha1(x)),x)
  ret <- tibble::as_tibble(t(unlist(x,recursive = TRUE)))
  names(ret) <- gsub('[.]','_',toupper(names(ret)))
  ret
  
}

port <- Sys.getenv('PORT')

r <- plumber::plumb("/app/myfile.R")

if(Sys.getenv("PORT") == "") Sys.setenv(PORT = 8000)

r$run(host = "0.0.0.0", port=as.numeric(Sys.getenv("PORT")), swagger = FALSE)
