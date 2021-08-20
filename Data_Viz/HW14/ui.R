library(shiny)
library(shinydashboard)
library(shinyWidgets)
library(lubridate)
library(plotly)


dashboardPage(
  dashboardHeader(title = "Covid 19 Vaccinations"),
  dashboardSidebar(
    dateRangeInput("dates", "Select a Date Range:",
                   start = floor_date(Sys.Date(), "month"),
                   end = Sys.Date() - 1,
                   min = "2020-12-20",
                   max = Sys.Date()
    ),
    selectInput("state", "State(s):",
                choices = "Alabama",
                selected = "Alabama",
                multiple = TRUE),
    selectInput("metric", "Metric:",
                choices = list("Total Vaccinated" = 'people_vaccinated',
                               "Total Fully Vaccinated" = "people_fully_vaccinated",
                               "Daily Vaccinations" = "daily_vaccinations",
                               "Total Distributed" = "total_distributed",
                               "Vaccine Usage Ratio" = "ratio",
                               "Full/Partial Vaccination Ratio" = "fpratio"
                               ))
  ),
  dashboardBody(
    fluidRow(
      column(width = 8,
               box(title = "Plot",
                   status = 'primary',
                   solidHeader = TRUE,
                   width = 12,
                   plotlyOutput("metricTS"))              
             ),
     column(width = 4,
       box(title = "Table",
           status = 'primary',
           solidHeader = TRUE,
           width = 12,
           tableOutput('totals'))
     )
    ),
    fluidRow(
      column(width = 8,
       box(title = "Metric Info",
           status = 'primary',
           solidHeader = TRUE,
           width = 12,
           textOutput('info'))),
      valueBoxOutput(outputId="total.vax",
                     width=4)
    )
  )
    
)
