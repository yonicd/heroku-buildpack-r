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

shiny::runApp(
  appDir = getwd(),
  host = '0.0.0.0',
  port = as.numeric(port)
)
