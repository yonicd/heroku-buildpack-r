shiny::shinyApp(
  ui = shiny::fluidPage(
  shiny::sidebarLayout(
    shiny::sidebarPanel(
      shiny::h4('Time Filter'),
      timevis::timevisOutput("appts"),
      shiny::hr(),
      shiny::h4('Task Category Filter'),
      shiny::h5('Size of box is equal to porportion from total'),
      d3treeR::d3tree3Output('plot')
    ),
    shiny::mainPanel(
        shiny::h3('POTUSVIZ: Visualize POTUS Private Schedule'),
        shiny::h5('as published by Axios and cross referenced with @realDonaldTrump Twitter feed'),
        shiny::hr(),
        shiny::column(
          shiny::sliderInput(
          inputId = 'n',
          label = 'Tweets to load',
          min = 1,
          max = 5,
          value = 5),
        width = 6),
        shiny::column(
        shiny::radioButtons(
          inputId      = 'dltype',
          label        = 'Export Format',
          choiceNames  = c('CSV','RDS'),
          choiceValues = c('csv','rds'),
          selected     = 'csv',
          inline       = TRUE),
        shiny::downloadButton('downloadData','Export Data'),
      width = 6),
      shiny::hr(),
      slickR::slickROutput('slick',width = '95%')
    )
  )
),

server = function(input, output,session) {
  
  output$appts <- timevis::renderTimevis({
    timevis::timevis(data = test,groups = group_data)
  })
  
  output$window <- renderText({
    w <- input$appts_window
    w1 <- strptime(w[1],'%Y-%m-%dT%H:%M:%S',tz = 'UTC') - 6*60*60
    w2 <- strptime(w[2],'%Y-%m-%dT%H:%M:%S',tz = 'UTC') - 6*60*60
    paste(as.character(w1), "to", as.character(w2))
  })
  
  dat <- eventReactive(c(input$appts_window),{
    
    w    <- input$appts_window
    ret  <- axios
    
    if ( !is.null(w) ) {
      
      w1 <- strptime(w[1],'%Y-%m-%dT%H:%M:%S',tz = 'UTC') - 6*60*60
      w2 <- strptime(w[2],'%Y-%m-%dT%H:%M:%S',tz = 'UTC') - 6*60*60
      
      ret <- ret%>%
        dplyr::filter(created_at>=w1 & created_at<=w2)
    }
    
    ret
    
  })
  
  dat_d <- dat%>% 
    shiny::throttle(1000)
  
  observeEvent(c(input$appts_window,input$plot_click$name),{
    
    d <- dat_d()
    
    type <- input$plot_click$name
    
    if ( ! is.null(type) ) {
      
      if(input$plot_click$name != "Private Schedule"){
        
        d <- d%>%
          dplyr::filter(TYPE %in% type)
        
      }
      
    }
    
    nd <- nrow(d)
    now_n <- input$n
    
    shiny::updateSliderInput(
      session = session,
      inputId = 'n',
      max = nd,
      value = pmin(nd,now_n))
    
    
  })
  
  observeEvent(c(input$appts_window,input$plot_click$name,input$n),{
    output$slick <- slickR::renderSlickR({
      
      d <- dat_d()
      
      type <- input$plot_click$name
      
      if ( ! is.null(type) ) {
        
        if(input$plot_click$name != "Private Schedule"){
          
          d <- d%>%
            dplyr::filter(TYPE %in% type)
          
        }
        
      }
      
      if( nrow(d) > 0 ){
        
        thisdat <- d%>%
          utils::head(input$n)%>%
          dplyr::mutate(
            slickdat  = sprintf('<p> %s: %s %s </p>', TYPE, TASK,embed)
          )%>%
          dplyr::pull(slickdat)
        
        slickR::slickR(
          thisdat,
          slideType = 'iframe',
          slickOpts = list(
            initialSlide = 0,
            slidesToShow = pmin(length(thisdat),3),
            slidesToScroll = pmin(length(thisdat),3),
            focusOnSelect = TRUE,
            dots = TRUE
          ),
          width = '95%',
          height=350)
        
      }
      
    })
  })
  
  observeEvent(input$appts_window,{
    output$plot <- d3treeR::renderD3tree3({
      
      d <- dat_d()
      
      if(nrow(d)>0){
        freq <- d%>%
          dplyr::count(TYPE,TASK)%>%
          dplyr::group_by(TYPE)%>%
          dplyr::mutate(
            p = n/sum(n),
            TASK_WRAP = purrr::map_chr(TASK,.f=function(x){
              paste0(strwrap(x,width = 20),collapse = '\n')
            }))
        
        d3treeR::d3tree3(
          treemap::treemap(freq,
                           index=c("TYPE","TASK_WRAP"),
                           vSize="n",
                           vColor = "TYPE.p",
                           palette=viridis::plasma(10),
                           type="index"
          ),rootname = 'Private Schedule',celltext='name') 
      }
    })
  })
  
  output$downloadData <- downloadHandler(
    filename = function() {
      sprintf('potusviz-data.%s', input$dltype)
    },
    content = function(con) {
      if(input$dltype=='csv'){
        write.csv(axios, con)  
      }else{
        saveRDS(axios,con)
      }
      
    }
  )
  
  
}
)
