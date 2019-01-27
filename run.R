library(toddlr)

options(shiny.host = '0.0.0.0')
options(shiny.port = Sys.getenv('PORT'))

# shiny::runApp(
#   appDir = getwd(),
#   host = '0.0.0.0',
#   port = as.numeric(Sys.getenv('PORT'))
# )
