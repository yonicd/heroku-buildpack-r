library(plumber)
library(gh)

fetch_data <- function(owner, repo, type = c('views','clones'),stat = c('count','uniques')){

  this_dat <- gh::gh('/repos/:owner/:repo/traffic/:type',
                     owner  = owner,
                     repo   = repo,
                     type   = type)
  
  if(length(this_dat[[type]])==0)
    return(NULL)
  
  stat_num <- ifelse(stat=='count',2,3)

  sapply(this_dat[[type]],`[[`,stat_num)
  
}

build_svg <- function(type,value){
  sprintf(
  '<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="68" height="20">
  <linearGradient id="b" x2="0" y2="100%%">
    <stop offset="0" stop-color="#bbb" stop-opacity=".1"/>
    <stop offset="1" stop-opacity=".1"/>
  </linearGradient>
  <clipPath id="a">
    <rect width="68" height="20" rx="3" fill="#fff"/>
  </clipPath>
  <g clip-path="url(#a)">
    <path fill="#555" d="M0 0h45v20H0z"/>
    <path fill="#f39f37" d="M45 0h23v20H45z"/>
    <path fill="url(#b)" d="M0 0h68v20H0z"/>
  </g>
  <g fill="#fff" text-anchor="middle" font-family="DejaVu Sans,Verdana,Geneva,sans-serif" font-size="110">
    <text x="235" y="150" fill="#010101" fill-opacity=".3" transform="scale(.1)" textLength="350">%s</text>
    <text x="235" y="140" transform="scale(.1)" textLength="350">%s</text>
    <text x="555" y="150" fill="#010101" fill-opacity=".3" transform="scale(.1)" textLength="130">%s</text>
    <text x="555" y="140" transform="scale(.1)" textLength="130">%s</text>
  </g> 
  </svg>',type,type,value,value)
}

port <- Sys.getenv('PORT')

r <- plumber::plumb("/app/myfile.R")

if(Sys.getenv("PORT") == "") Sys.setenv(PORT = 8000)

r$run(host = "0.0.0.0", port=as.numeric(Sys.getenv("PORT")), swagger = TRUE)

# r$run(host='0.0.0.0', port=strtoi(port),swagger = TRUE)
