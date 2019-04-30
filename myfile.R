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
#* @get /repo_data
repo_data <- function(owner,repo,type){
  
  get_data(owner = owner, repo = repo, type = type)
  
}

