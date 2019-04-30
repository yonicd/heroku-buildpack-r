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
  res$setHeader("Location", "https://github.com")
  "<html>
  <head>
    <meta http-equiv=\"Refresh\" content=\"0; url=https://github.com\" />
  </head>
  <body>
    <p>Please follow <a href=\"https://github.com/\">this link</a>.</p>
  </body>
</html>"
}

#' @get /docs2
#* @html
docs2 <- function() {
  markdown::markdownToHTML(text = '![](https://github.com/yonicd/whereami/blob/media/whereami_shiny.gif?raw=true)')
}
