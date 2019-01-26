library(toddlr)

shiny::runApp(
  appDir = getwd(),
  host = '0.0.0.0',
  port = as.numeric(Sys.getenv('PORT'))
)
