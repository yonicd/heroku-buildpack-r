# myfile.R

#* Github Clones
#* @serializer contentType list(type="image/svg+xml")
#* @param owner github owner
#* @param repo github repo
#* @param stat uniques or count
#* @get /clones
clones <- function(owner,repo,stat){
  
  x <- sum(fetch_data(owner = owner, repo = repo, type = 'clones', stat = stat))
  
  build_svg('clones',x)
  
}

#* Github Views
#* @serializer contentType list(type="image/svg+xml")
#* @param owner github owner
#* @param repo github repo
#* @param stat uniques or count
#* @get /views
views <- function(owner, repo, stat){
  
  x <- sum(fetch_data(owner = owner, repo = repo, type = 'views', stat = stat))
  
  build_svg('views',x)
  
}

#* Github Clones Data
#* @param owner github owner
#* @param repo github repo
#* @param type type of data clones or views
#* @get /data
repo_data <- function(owner,repo,type){
  
  get_data(owner = owner, repo = repo, type = type)
  
}

#* heartbeat
#* @html
#* @get /heartbeat
heartbeat <- function(){
  '{
    "routes": [
      "/docs (GET)",
      "/heartbeat (GET)",
      "/clones (GET)",
      "/views (GET)",
      "/data  (GET)"
      ]
  }'
}

#' @get /docs
#' @html
function(req, res) {
  res$status <- 303 # redirect
  res$setHeader("Location", "https://img.shields.io/badge/clones-132-9cf.svg")
  "<html>
  <head>
    <meta http-equiv=\"Refresh\" content=\"0; url=https://img.shields.io/badge/clones-132-9cf.svg\" />
  </head>
  <body>
    <p>Please follow <a href=\"https://img.shields.io/badge/clones-132-9cf.svg\">this link</a>.</p>
  </body>
</html>"
}

#' @get /dashboard
#* @html
dashboard <- function() {
  
  tbl <- data.frame(owner = 'yonicd',
                    repo = c('whereami','carbonate'),
                    stringsAsFactors = FALSE)
  
  tbl$views <- NA
  tbl$viewers <- NA
  tbl$clones <- NA
  tbl$cloners <- NA
  
  for(i in 1:nrow(tbl)){
    
  tbl$views[i] <- sprintf('![](https://img.shields.io/badge/views-%s-9cf.svg)',
                      sum(fetch_data(owner = tbl$owner[i], repo = tbl$repo[i], type = 'views', stat = 'count'))
                      )
  
  tbl$viewers[i] <- sprintf('![](https://img.shields.io/badge/viewers-%s-9cf.svg)',
                          sum(fetch_data(owner = tbl$owner[i], repo = tbl$repo[i], type = 'views', stat = 'uniques'))
  )
  
  tbl$clones[i] <- sprintf('![](https://img.shields.io/badge/clones-%s-9cf.svg)',
                       sum(fetch_data(owner = tbl$owner[i], repo = tbl$repo[i], type = 'clones', stat = 'count')))
  
  tbl$cloners[i] <- sprintf('![](https://img.shields.io/badge/cloners-%s-9cf.svg)',
                           sum(fetch_data(owner = tbl$owner[i], repo = tbl$repo[i], type = 'clones', stat = 'uniques')))
  }
  
  markdown::markdownToHTML(text = knitr::kable(tbl))
}
