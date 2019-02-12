library(slickR)
library(timevis)
library(treemap)
library(d3treeR)
library(ggplot2)
library(dplyr)

axios <- readRDS('www/axios.Rds')

test_background <- axios%>%
  dplyr::mutate(start = DATE_TIME,
                end = DATE_TIME_END,
                style = NA,
                type = 'background',
                dat_type = 'schedule')%>%
  dplyr::select(start,end,type,dat_type,style,TYPE)

test_point <- axios%>%
  dplyr::mutate(start = as.POSIXct(created_at),
                end = as.POSIXct(created_at),
                style = dplyr::case_when(
                  source=="Twitter for iPhone" ~ "background-color: red;",
                  source=="Twitter Media Studio" ~ "background-color: blue;",
                  source=="Twitter for iPad" ~ "background-color: green;"
                ),
                type = 'background',
                dat_type = 'tweet')%>%
  dplyr::select(start,end,type,dat_type,style,TYPE)

group_data <- axios%>%
  dplyr::select(TYPE)%>%
  dplyr::distinct()%>%
  dplyr::mutate(group=1:dplyr::n())

test <- dplyr::bind_rows(test_background,test_point)%>%dplyr::mutate(id = 1:dplyr::n())

test <- test%>%dplyr::left_join(group_data,by='TYPE')

group_data <- group_data%>%dplyr::rename(content = TYPE,id=group)

shiny::runApp(
  appDir = getwd(),
  host = '0.0.0.0',
  port = as.numeric(Sys.getenv('PORT'))
)

