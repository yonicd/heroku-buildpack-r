library(plumber)
library(gh)
library(RCurl)

get_repo_data <- function(owner, repo){
  
  gh::gh('/repos/:owner/:repo/contents/tests/README.md',
         owner = owner,
         repo = repo)
}

get_content <- function(obj){
  
  content <- sapply(strsplit(obj$content,'\n')[[1]],RCurl::base64Decode)
  
  content <- paste0(content,collapse = '')
    
  unlist(strsplit(content,'\n'))
  
}

badge_text <- function(status = "pass",date = Sys.Date()) {
  
  uri_colour <- switch(status,
                       "<!--- error/failed --->" = "red",
                       "<!--- skipped/warning --->" = "yellowgreen",
                       "brightgreen"
  )
  
  uri_date <- format(as.Date(date,format = '%d %B, %Y %H:%M:%S'),'%Y_%m_%d')
  
  sprintf("covrpage-Last_Build_%s-%s.svg", uri_date, uri_colour)
}


tiny <- function(uri) {
  
  host <- "tinyurl.com"
  
  if (!is.null(curl::nslookup(host, error = FALSE))) {
    
    base <- sprintf("http://%s/api-create.php", host)
    
    x <- curl::curl(sprintf("%s?url=%s", base, uri))
    
    on.exit(close(x), add = TRUE)
    
    uri_raw <- uri
    
    uri <- readLines(x, warn = FALSE)
    
  }
  
  uri
}

port <- Sys.getenv('PORT')

r <- plumber::plumb("/app/myfile.R")

if(Sys.getenv("PORT") == "") Sys.setenv(PORT = 8000)

r$run(host = "0.0.0.0", port=as.numeric(Sys.getenv("PORT")), swagger = TRUE)

# r$run(host='0.0.0.0', port=strtoi(port),swagger = TRUE)
