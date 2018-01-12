library(shiny)
library(plotly)
library(viridis)
library(jsonlite)
library(RColorBrewer)
library(readxl)
library(DT)
library(xtable)
library(htmltools)
library(htmlwidgets)
library(shinyHeatmaply)
library(dplyr)
library(heatmaply)

port <- Sys.getenv('PORT')

d=data(package='datasets')$results[,'Item']
d=d[!grepl('[\\()]',d)]
d=d[!d%in%c('UScitiesD','eurodist','sleep','warpbreaks')]
d=d[unlist(lapply(d,function(d.in) eval(parse(text=paste0('ncol(as.data.frame(datasets::',d.in,'))')))))>1]
d=d[-which(d=='mtcars')]
d=c('mtcars',d)

# shiny::runApp(
#   appDir = getwd()
# )

shiny::runApp(
  appDir = getwd(),
  host = '0.0.0.0',
  port = as.numeric(port)
)
