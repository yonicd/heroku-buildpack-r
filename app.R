tw <- toddlr::toc%>%
  toddlr::tweet_threading_fw()

shiny::shinyApp(
  ui = miniUI::miniPage(
    miniUI::gadgetTitleBar(title = '"Toddler in Chief" Thread Analytics Dashboard',
                           left = miniUI::miniTitleBarButton("gh", "toddlr"),
                           right = NULL
    ),
    miniUI::miniContentPanel(
      shiny::sidebarLayout(
        sidebarPanel = shiny::sidebarPanel(
          shiny::sliderInput(
            inputId = 'date',
            label = 'Status Dates',
            min = min(tw$created_at),
            max = max(tw$created_at),
            drag = TRUE,
            value = range(tw$created_at)
          ),
          shiny::selectizeInput(
            inputId = 'prox',
            label = 'Select Circle of Trust',
            choices = c('himself','intel','friends','congress','staff','GOP','allies'),
            selected = c('himself','intel','friends','congress','staff','GOP','allies'),
            multiple = TRUE
          ),
          shiny::sliderInput(
            inputId = 'slickslide',
            label = 'Last N Statuses to Show',
            min = 1,
            max = 30,
            value = 5
          ),
          slickR::slickROutput('slick'),
          shiny::br(),
          shiny::wellPanel(
            shiny::radioButtons(
              inputId      = 'dltype',
              label        = 'Export Format',
              choiceNames  = c('CSV','RDS'),
              choiceValues = c('csv','rds'),
              selected     = 'csv',
              inline       = TRUE),
            shiny::downloadButton('downloadData','Export Thread')
          ),
          
          width = 3
        ),
        mainPanel = shiny::mainPanel(
          shiny::plotOutput('plot',height = 800),
          width = 9
        )
      )
    )
  ),
  server = function(input, output, session) {
    
    shiny::observeEvent(input$done, {
      shiny::stopApp()
    })
    
    shiny::observeEvent(input$gh, {
      browseURL('https://github.com/yonicd/toddlr')
    })
    
    plot_dat <- shiny::eventReactive(c(input$date,input$prox),{
      
      tw <- tw%>%
        toddlr:::create_whoami()%>%
        toddlr:::create_prox()%>%
        dplyr::filter(prox %in% input$prox )
      
      ret_plots <- tw%>%
        toddlr:::toddlr_status()%>%
        dplyr::left_join(
          tw%>%toddlr:::toddlr_stats(),
          by = c('ym','prox'))
      
      ret_plots <- ret_plots%>%
        dplyr::group_by(prox)%>%
        dplyr::mutate(
          now = dplyr::between(
            x = as.Date(sprintf('%s-01',ym),format = '%Y-%m-%d'),
            left = as.Date(sprintf('%s-01',strftime(input$date[1],'%Y-%m')),format = '%Y-%m-%d'),
            right = as.Date(sprintf('%s-01',strftime(input$date[2],'%Y-%m')),format = '%Y-%m-%d')
          ),
          nn=cumsum(n)
        )%>%
        dplyr::ungroup()%>%
        dplyr::mutate(
          i = as.numeric(as.factor(ym))
        )
      
      ret_filter <- tw%>%
        dplyr::filter(
          dplyr::between(
            x = created_at,
            left = input$date[1],
            right = input$date[2]
          )
        )
      
      ret_snippets <- ret_filter%>%
        dplyr::count(prox,whoami)
      
      ret_twe <- ret_filter%>%
        dplyr::select(screen_name,status_id)
      
      list(time = ret_plots , snips = ret_snippets, twe_dat = ret_twe)
    })
    
    output$plot <- shiny::renderPlot({
      
      toddlr_plots(plot_dat())
      
    })
    
    shiny::observeEvent(c(input$date,input$prox,input$slickslide),{
      output$slick <- slickR::renderSlickR({
        
        all_dat <- plot_dat()
        
        all_dat$twe_dat%>%
          dplyr::slice(1:input$slickslide)%>%
          toddlr_slick(width = '40%', height = '40%')
      })
      
    })
    
    output$downloadData <- downloadHandler(
      filename = function() {
        sprintf('toddlr-data-%s.%s', Sys.Date(), input$dltype)
      },
      content = function(con) {
        if(input$dltype=='csv'){
          data_out <- tw[,!sapply(toc,inherits,what='list')]
          write.csv(data_out, con)  
        }else{
          saveRDS(tw,con)
        }
        
      }
    )
    
  }
  
)