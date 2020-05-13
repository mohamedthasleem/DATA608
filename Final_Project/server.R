# Loading up the needed library files 
library(shiny)
library(leaflet)

quakex <- read.csv("https://raw.githubusercontent.com/mohamedthasleem/DATA608/master/Final_Project/data_2019_01.csv", sep = ",", stringsAsFactors = F)
quakex$depth <- abs(quakex$depth) 
quakex$mag <- abs(quakex$mag) 

# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
  
  ## Plot all points available in the dataset 
  output$sliderValues <- renderUI ({
    if (input$plotAll == TRUE) 
    {
      updateSliderInput(session, "stations", value = max(quakex$stations))
      updateSliderInput(session, "depth", value = max(quakex$depth))
      updateSliderInput(session, "magnitude", value = max(quakex$mag))
      titlePanel("")
    }
    if (input$plotAll == FALSE) 
    {
      updateSliderInput(session, "stations", value = mean(quakex$stations))
      updateSliderInput(session, "depth", value = mean(quakex$depth))
      updateSliderInput(session, "magnitude", value = mean(quakex$mag))
      titlePanel("")
    }
  })
  
  ## Reset All action button observer 
  observeEvent(input$resetAll, {
    session$sendCustomMessage(type = 'testmessage',
                              message = 'Filters reset')
    updateSliderInput(session, "stations", value = mean(quakex$stations))
    updateSliderInput(session, "depth", value = mean(quakex$depth))
    updateSliderInput(session, "magnitude", value = mean(quakex$mag))
    updateCheckboxInput(session,"plotAll", value = FALSE)
    titlePanel("")
  })
  
  # Generate Filtered data set based on inputs from ui.R
  x <- reactive({ quakex[quakex$stations <= input$stations & quakex$depth <=input$depth & quakex$mag<=input$magnitude,] 
  })
  
  output$quakePlot <- renderLeaflet({
    # draw the map with leaflet function and consider the depth, stations and magnitude input filters
    leaflet(x()) %>% addTiles() %>%
      fitBounds(~min(long), ~min(lat), ~max(long), ~max(lat))    
    
  })
  
  
  # Incremental changes to the map (in this case, replacing the
  # circles when a new color is chosen) should be performed in
  # an observer. Each independent set of things that can change
  # should be managed in its own observer.
  observe({
    leafletProxy("quakePlot", data = x()) %>%
      clearShapes() %>%
      addCircleMarkers(color = "red", radius = ~sqrt(depth) , popup = ~paste("Magnitude:",mag, ", Depth:", depth), clusterOptions = markerClusterOptions()
      )
  })
  
  # Generate the Plotted Location count and render it in UI 
  output$lCount <- renderText({
    paste("Plotted location Count:  ",nrow(x()))
  })
  
  # Generate the output text under side panel 
  output$txt1 <- renderText({
    HTML("")
  })
  
  
  # Generate the output text under main panel 
  output$txt2 <- renderText({
    HTML("")
  })
  
})