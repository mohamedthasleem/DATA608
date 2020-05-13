# Loading up the needed library files 
library(shiny)
library(leaflet)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("DATA 608 - Locations of Earthquakes"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      sliderInput("stations",
                  "Stations less than or equal to",
                  1,15,
                  value = 4,
                  step = 1),
      sliderInput("depth",
                  "Depth less than or equal to",
                  0,600,
                  value = mean(quakes$depth), 
                  step = 50),
      sliderInput("magnitude", 
                  "Magnitude less than or equal to", 
                  1, 8,
                  value = mean(quakes$mag), step = 0.5), 
      checkboxInput("plotAll", "Plot all points", FALSE),
      actionButton("resetAll", "Reset inputs to its mean value"),
      uiOutput("sliderValues"),
      htmlOutput("txt1"), width = 3,h5("Stations List")
      ,h6("1 - Alaska")
      ,h6("2 - California")
      ,h6("3 - Puerto Rico")
      ,h6("4 - Hawaii")
      ,h6("5 - Oklahoma-Kansas")
      ,h6("6 - France")
      ,h6("7 - Montana")
      ,h6("8 - Mexico")
      ,h6("9 - Tennessee-Arkansas-Missouri")
      ,h6("10 - Canada")
      ,h6("11 - Argentina")
      ,h6("12 - US South East")
      ,h6("13 - Asia and Europe")
      ,h6("14 - Utah")
      ,h6("15 -Washington-Canada-Oregon")
      ,h6("NOTE: Sample Record from USGS (Jan-2019)")
    ),
    # Show a plot of the generated distribution
    mainPanel(
      leafletOutput("quakePlot", width = "100%", height = 820),
      h4(textOutput("lCount"), align = "right"),
      htmlOutput("txt2", align = "left")
    )
  )
))