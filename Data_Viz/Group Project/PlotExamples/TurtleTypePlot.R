#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(tidyverse)
library(plotly)
library(tsibble)
library(slider)

animals <- read_csv2('../data/finalAnimals.csv')

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Sea Turtle Data"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            selectInput(inputId = 'type',
                        label = 'Select a type:',
                        choices = unique(animals$vernacularName)),
            selectInput(inputId = "turtle",
                        label = "Select a Turtle:",
                        choices = NULL)
        ),
        # Show a plot of the generated distribution
        mainPanel(
           plotlyOutput("locationPlot")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output, session) {
    
    observe({
        choices <- animals %>% filter(vernacularName == input$type) %>% select(organismID)
        updateSelectInput(session, inputId = 'turtle', choices = choices)
    })

    df <-  reactive({if(!is.na(input$turtle)){animals %>% 
                        filter(organismID == input$turtle) %>%  
                        as_tsibble(key = eventDate, index = index)%>% 
                        mutate(sevenDayAvgLat = slide_index_dbl(.x = decimalLatitude,
                                                                .i = eventDate,
                                                                .f = mean,
                                                                .before = 6),
                               sevenDayAvgLon = slide_index_dbl(.x = decimalLongitude,
                                                                .i = eventDate,
                                                                .f = mean,
                                                                .before = 6))}
                    else{animals %>%  
                            as_tsibble(key = eventDate, index = index)%>% 
                            mutate(sevenDayAvgLat = slide_index_dbl(.x = decimalLatitude,
                                                                    .i = eventDate,
                                                                    .f = mean,
                                                                    .before = 6),
                                   sevenDayAvgLon = slide_index_dbl(.x = decimalLongitude,
                                                                    .i = eventDate,
                                                                    .f = mean,
                                                                    .before = 6))}
        
        })

    output$locationPlot <- renderPlotly({
        
        plotdf <- df()
        plot_ly(data = plotdf,
                type = "scattermapbox",
                mode = "markers+lines",
                lat = ~sevenDayAvgLat,
                lon = ~sevenDayAvgLon,
                color = ~vernacularName,
                hovertemplate = paste("<b>Event Date:</b>", plotdf$eventDate, "<br>",
                                      "<b>Vernacular Name:</b>", plotdf$vernacularName, "<br>",
                                      "<b>Organism ID:</b>", plotdf$organismID,"<br>",
                                      "<extra></extra>"),
                hoverlabel = list(align = "left")) %>% 
            layout(legend = list(traceorder = 'grouped'),
                   autosize=FALSE,
                   mapbox= list(
                       style = "white-bg",
                       bearing=0,
                       zoom = 3,
                       center = list(lon = mean(plotdf$decimalLongitude) ,
                                     lat = mean(plotdf$decimalLatitude)),
                       layers = list(list(
                           below = 'traces',
                           sourcetype = "raster",
                           source = list("https://basemap.nationalmap.gov/arcgis/rest/services/USGSImageryOnly/MapServer/tile/{z}/{y}/{x}")))),
                   margin = list(t=0, r=0, l=0, b=0))
})}

# Run the application 
shinyApp(ui = ui, server = server)
