library(plumber)
library(gh)

fetch_view_data <- function(repo, type = c('views','clones'),stat = c('count','uniques')){

  this_dat <- gh::gh('/repos/:owner/:repo/traffic/:type',
                     owner  = dirname(repo),
                     repo   = basename(repo),
                     type   = type)
  
  if(length(this_dat[[type]])==0)
    return(NULL)
  
  stat_num <- ifelse(stat=='count',2,3)

  sapply(this_dat[[type]],`[[`,stat_num)
  
}

port <- Sys.getenv('PORT')

r <- plumber::plumb("/app/myfile.R")

if(Sys.getenv("PORT") == "") Sys.setenv(PORT = 8000)

r$run(host = "0.0.0.0", port=as.numeric(Sys.getenv("PORT")), swagger = TRUE)

# r$run(host='0.0.0.0', port=strtoi(port),swagger = TRUE)
