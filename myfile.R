# myfile.R

#* Github repos using covrpage
#* @get /repos
repos <- function(){

  out <- gh::gh('/search/code?q=covrpage+filename:README.md+path:tests')
  
  x <- sapply(out$items,function(x) x$repository$full_name)

  list(total_count = out$total_count, repos = x)
    
}

#* tiny url to owner/repo/tests/README.md
#* @html
#* @get /url/<owner>/<repo>
url <- function(owner, repo, req, res){
  
  dat <- get_repo_data(owner,repo)
  
  res$body <- tiny(dat$html_url)
  
  res
}

#* @get /badge/<owner>/<repo>
#* @html
function(owner, repo,req, res) {
  
  dat <- get_repo_data(owner,repo)
  
  content <- get_content(dat)
  
  txt <- badge_text(content[length(content)],content[3])
  
  uri_md <- tiny(dat$html_url)
  
  uri <- sprintf("https://img.shields.io/badge/%s?link=https://github.com/metrumresearchgroup/covrpage&link=%s",txt,uri_md)
  
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
