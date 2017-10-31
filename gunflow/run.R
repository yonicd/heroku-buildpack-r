library(shiny)
library(reshape2)
library(geojson)
library(readxl)
library(leaflet)
library(httr)
library(rgeolocate)
library(ggplot2)
library(sp)
library(widyr)
library(igraph)
library(slickR)
library(ggraph)
library(svglite)
library(dplyr)

port <- Sys.getenv('PORT')

shiny::runApp(
  appDir = getwd(),
  host = '0.0.0.0',
  port = as.numeric(port)
)
