
library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
   
   # Application title
   titlePanel("CityBike"),
   
   # Sidebar with conditional Panel for different Input types for ech tabsetPanel
   sidebarLayout(
      
      conditionalPanel( condition = "input.tabsetPanel != 'dataPanel'"
                      , sidebarPanel( width = 2
                                   
                                    , conditionalPanel( condition = "input.tabsetPanel == 'stationPanel'"
                                                      , sliderInput(inputId = "stationSlider"
                                                                  , label = "Stations:"
                                          # +0 on min and max is a bugfix for the slider otherwise the min or
                                          # max value would not be displayed or accessible
                                                                  , min = min(dat$start.station.id)+0
                                                                  , max = max(dat$start.station.id)+0
                                                                  , value = c(min(dat$start.station.id)
                                                                             ,min(dat$start.station.id)+10))
                                                      , actionButton("btn_upd", label = "Update Map")
                                                      , helpText("Note: Use the Slider to Change the Stations",
                                                                 "and press the Update-Button to show them. ",
                                                                 "For more details click on the marker") 
                                                      )
                                    , conditionalPanel( condition = "input.tabsetPanel == 'bikeHistPanel' |
                                                                     input.tabsetPanel == 'bikeHistPanel2'"
                                                      , selectInput(inputId = "bikeSelect"
                                                                  , label = "BikeId:"
                                                                  , choices = dat[order(dat$bikeid),]$bikeid)
                                                      , conditionalPanel(condition = "input.tabsetPanel == 'bikeHistPanel'"
                                                                       , helpText("Note: choose a BikeId (e.g. 20977) from the list", 
                                                                          "to display it's (air)Route"))
                                                      , conditionalPanel(condition = "input.tabsetPanel == 'bikeHistPanel2'"
                                                                       , helpText("Note: choose a BikeId (e.g. 20977) from the list", 
                                                                         "to Display it's Starting-Stations. ",
                                                                         "Click on the marker to see more details"))
                                                      )
                                    )
      )

      # mainPanel with different aspects of the data
    , mainPanel(
         tabsetPanel( id = "tabsetPanel"
                    , tabPanel(title = "Station overview"
                             , value = "stationPanel"
                             , mapOutput('StationChart'))
                    , tabPanel(title = "Bikeroute history"
                             , value ="bikeHistPanel"
                             , mapOutput('BikeHistChart'))
                    , tabPanel(title = "Bikeroute history 2"
                             , value ="bikeHistPanel2"
                             , mapOutput('BikeHistChart2'))
                    )
               )
   )
))
