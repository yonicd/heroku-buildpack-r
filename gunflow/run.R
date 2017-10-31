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

source('www/funs.R')

plot_size = 16

capitalize=function(x){
  gsub("(^|[[:space:]])([[:alpha:]])", "\\1\\U\\2", x, perl=TRUE)
}

Sys.setenv(MAPBOX_ACCESS_TOKEN=read.dcf('www/MYTOKEN')[1])

states <- geojsonio::geojson_read('www/us-states.geojson', what = "sp")

load('www/gun_mat_heroku.rda')

whereami <- rgeolocate::ip_api(httr::content(httr::GET('https://api.ipify.org?format=json'))[1])

thisstate <- 'Illinois'

if(whereami$country_code=='US'){
  thisstate <- whereami$region_name
}

net_flow <- calc(side = 'from')%>%
  left_join(calc(side = 'to'),by=c('year','state'))%>%
  mutate(net=state_sum_from-state_sum_to,
         ratio_net=ratio_from-ratio_to)%>%
  arrange(desc(ratio_net))

network_dat <- net_dat(gun_mat)

tot <- scatter_fun(gun_mat)

load('www/gun_ranking_heroku.rda')

load('www/atf_data_heroku.rda')

tot <- tot%>%mutate(state=as.character(state))%>%left_join(gun_ranking,by=c('year','state'))

tot$state_grade <- gsub('NA','',paste(tot$state,tot$grade,tot$smart_law))

tot$grade_round <- gsub('[+-]','',tot$grade)

#shiny::runApp()

shiny::runApp(
  appDir = getwd(),
  host = '0.0.0.0',
  port = as.numeric(port)
)
