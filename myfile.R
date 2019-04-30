# myfile.R

#* Github Clones Data
#* @param owner github owner
#* @param repo github repo
#* @get /data/<type>
repo_data <- function(owner,repo,type){
  
  get_data(owner = owner, repo = repo, type = type)
  
}

#* heartbeat
#* @html
#* @get /heartbeat
heartbeat <- function(req,res){
res$body <- '{
    "routes": [
      "/heartbeat (GET)",
      "/badge/<views|clones|cloners|viewers> (GET)",
      "/data/<views|clones>  (GET)",
      "/dashboard  (GET)"
      ]
}'
  
  res
}

#* @param owner github owner
#* @param repo github repo
#* @get /badge/<type>
#* @html
function(owner, repo, type, req, res) {
  
  stat <- 'count'
  fixtype <- type
    
  if(type=='viewers'){
    stat <- 'uniques'
    fixtype <- 'views'
  }
  
  if(type=='cloners'){
    stat <- 'uniques'
    fixtype <- 'clones'
  }
  
  x <- sum(fetch_data(owner = owner, repo = repo, type = fixtype, stat = stat))
  uri <- sprintf("https://img.shields.io/badge/%s-%s-9cf.svg",type,x)
  
  fivemin <- format(
    Sys.time() + (5*60),
    '%a, %d %b %Y %H:%M:%S',
    tz = 'GMT',
    usetz = TRUE
  )
  
  
  res$status <- 303 # redirect
  res$setHeader("Location", uri)
  res$setHeader("Expires",fivemin)
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

#' @get /dashboard
#* @html
dashboard <- function() {
  
  tbl <- data.frame(owner = c('yonicd','yonicd','thinkr-open','metrumresearchgroup'),
                    repo = c('whereami','carbonate','remedy','covrpage'),
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
