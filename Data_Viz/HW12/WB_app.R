library(shiny)
library(plotly)
library(tidyverse)

ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      sliderInput(
        inputId = 'year',
        label = 'Year',
        min = min(wb$Year),
        max = max(wb$Year)-1,
        value = 2000,
        step = 1,
        sep = ""
      ),
      selectInput(
        inputId = 'regions',
        label = "Select regions",
        choices = unique(wb$Region),
        selected = NULL,
        multiple = TRUE
      ),
      selectInput(
        inputId = 'countries',
        label = 'Select countries',
        choices = NULL,
        multiple = TRUE
      ),
    ),
    mainPanel(
      plotlyOutput('scatter')
    )
  )
)



server <- function(input, output, session) {
  
  observeEvent(list(input$regions),{
    if (length(input$regions != 0)){
      df <- wb %>% filter(Region==input$regions)
      updateSelectInput(session,
                        inputId = 'countries',
                        choices = unique(df$Country))
    } 
  },ignoreInit = TRUE)
  
  
  
  df <- reactive({
    wb %>% filter(Year == input$year)
  })
  
  countries <- reactive({ input$countries })
  
  output$scatter <- renderPlotly({
    c = countries()
    
    df <- df()
    ifelse(!is.null(c),
           df <- df %>% filter(Country==c),df)
    plot <- plot_ly(df,
                    type = 'scatter',
                    mode='markers',
                    x = ~Fertility,
                    y = ~LifeExpectancy,
                    size = ~Population,
                    color = ~Region,
                    hoverinfo = 'text',
                    text = paste0("<b>Country:</b> ", df$Country,"<br>",
                                  "<b>Life Expectancy:</b> ", df$LifeExpectancy,"<br>",
                                  "<b>Fertility Rate:</b> ", df$Fertility,"<br>",
                                  "<b>Populaion:</b> ",df$Population)
    ) %>%
      layout(xaxis=list(title = 'Fertility Rate',
                        range = c(0,10)),
             yaxis=list(title = 'Life Expectancy',
                        range = c(10,90)))
  })
}

shinyApp(ui = ui, server = server)
