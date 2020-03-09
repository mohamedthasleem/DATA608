#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
library(shiny)
library(ggplot2)
library(tidyverse)
library(shinythemes)

#load the data
cdc <-
    read.csv(
        "https://raw.githubusercontent.com/charleyferrari/CUNY_DATA608/master/lecture3/data/cleaned-cdc-mortality-1999-2010-2.csv",
        sep = ",",
        stringsAsFactors = F,
        header = T
    )

states <- unique(cdc$State)
death_causes <- unique(cdc$ICD.Chapter)
years <- unique(cdc$Year)

#Define server logic
server <- function(input, output) {
    output$question1 <- renderPlot(height = 800, units="px",{
        ggplot(cdc[which(cdc$ICD.Chapter == input$death & cdc$Year == input$years), ] , aes(x = reorder(State, Crude.Rate), y = Crude.Rate)) +
            labs(x = "State", y = "Crude Mortality Rate") + 
            geom_bar(stat = "identity" , fill = "#49B2E2") + 
            coord_flip() +   geom_text(aes(label=Crude.Rate),
                                       size=3,
                                       hjust=-0.5,
                                       color="black")
    })
    
    output$question2 <- renderPlot({
        cdc %>%
            group_by(Year, ICD.Chapter) %>%
            mutate(
                sum_pop = sum(Population),
                sum_death = sum(Deaths),
                crude_rate = 10^5 * (sum_death / sum_pop)
            ) %>%
            group_by(Year, ICD.Chapter, State) %>%
            mutate(
                sum_death1 = sum(Deaths),
                crude_rate1 = 10^5 * (sum_death1 / Population)
            ) %>%
            select(ICD.Chapter, State, Year, crude_rate, crude_rate1) %>%
            filter(ICD.Chapter == input$death1, State == input$state1) %>%
            ggplot() +
            geom_bar(aes(x = Year, weight = crude_rate1) ,fill = "#49B2E2",) +
            geom_text(aes(x = Year,y=crude_rate1,label=round(crude_rate1)),
                      position = position_dodge(width = 1),
                      vjust = -0.5, size = 3) +
            labs(x = "Year", y = "Crude Mortality Rate") +
            geom_line(
                aes(
                    x = Year,
                    y = crude_rate,
                    linetype = "National Avg"),
                col = "blue",lwd = 1
            ) + 
            
            geom_text(aes(x = Year,y=crude_rate,label=round(crude_rate)),
                      position = position_dodge(width = 1),
                      vjust = -0.5, size = 3,color="#421022") +
            
            
            theme_minimal() + 
            theme(legend.position="bottom") + theme(legend.title = element_blank())
        
    })
    
}
#round(crude_rate1)

#define UI
ui <- fluidPage(theme = shinytheme("cerulean"),navbarPage(
    "DATA 608 - Module 3",
    tabPanel(
        "Question 1",
        titlePanel("Crude mortality rate across all States"),
        
        #sidebar layout Question 1
        sidebarLayout(
            #sidebar panel for inputs
            sidebarPanel(
                selectInput("years",
                            "Year", years, selected = 2010),
                selectInput("death",
                            "Cause of death", death_causes, selected =
                                "Neoplasms")
                
            ),
            
            #main panel for displaying outputs
            mainPanel(plotOutput("question1"))
        )
    ),
    
    tabPanel(
        "Question 2",
        titlePanel("Mortality rates (per cause)"),
        
        #sidebar layout for Question 2
        sidebarLayout(
            #sidebar panel for inputs
            sidebarPanel(
                selectInput("state1",
                            "State", states),
                selectInput("death1",
                            "Cause of death", death_causes, selected =
                                "Neoplasms")
                
            ),
            
            #main panel for displaying outputs
            mainPanel(plotOutput("question2"))
        )
    )
    
))


#run shiny app
shinyApp(ui, server)