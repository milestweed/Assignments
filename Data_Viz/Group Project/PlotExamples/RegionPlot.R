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
locations <- read_csv2('../data/locations.csv')

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Sea Turtle Data"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            selectInput(inputId = "location",
                        label = "Select a region:",
                        choices = locations$location)
        ),
        # Show a plot of the generated distribution
        mainPanel(
           plotlyOutput("locationPlot")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
    
    loc <- reactive({locations %>% filter(location==input$location)})

    df <-  reactive({animals %>% 
                        filter(locationName == input$location) %>%  
                        as_tsibble(key = eventDate, index = index)%>% 
                        mutate(sevenDayAvgLat = slide_index_dbl(.x = decimalLatitude,
                                                                .i = eventDate,
                                                                .f = mean,
                                                                .before = 6),
                               sevenDayAvgLon = slide_index_dbl(.x = decimalLongitude,
                                                                .i = eventDate,
                                                                .f = mean,
                                                                .before = 6))})

    output$locationPlot <- renderPlotly({
        center = loc()
        plotdf <- df()
        p <- plot_ly(
                data = plotdf,
                type = "scattermapbox",
                mode = "markers",
                lat = ~sevenDayAvgLat,
                lon = ~sevenDayAvgLon,
                legendgroup = ~vernacularName,
                color = ~vernacularName,
                marker = list(opacity = 0.5),
                hovertemplate = paste("<b>Event Date:</b>", plotdf$eventDate, "<br>",
                                      "<b>Vernacular Name:</b>", plotdf$vernacularName, "<br>",
                                      "<b>Organism ID:</b>", plotdf$organismID,"<br>",
                                      "<extra></extra>"))
        
        
        p <- p %>%  layout(legend = list(traceorder = 'grouped'),
                           autosize=FALSE,
                            mapbox= list(
                                    style = "white-bg",
                                    bearing=0,
                                    zoom = center$zoom,
                                    center = list(lon = center$lons ,
                                                  lat = center$lats),
                            layers = list(list(
                                        below = 'traces',
                                        sourcetype = "raster",
                                        source = list("https://basemap.nationalmap.gov/arcgis/rest/services/USGSImageryOnly/MapServer/tile/{z}/{y}/{x}")))),
                           margin = list(t=0, r=0, l=0, b=0)) %>% 
                    config(displayModeBar = FALSE)
        })
}

# Run the application 
shinyApp(ui = ui, server = server)
