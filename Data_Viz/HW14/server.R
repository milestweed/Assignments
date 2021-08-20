library(shiny)
library(shinydashboard)
library(tidyverse)
library(tsibble)
library(plotly)
library(slider)


shinyServer(function(input, output, session) {
  
  df <- reactiveFileReader(
          intervalMillis = 86400000,
          session = session,
          filePath = "https://raw.githubusercontent.com/owid/covid-19-data/master/public/data/vaccinations/us_state_vaccinations.csv",
          readFunc = read_csv)
  
  
  observe({
    print(input$dates)
    updateSelectInput(session, 
                      inputId = "state",
                      selected = "Alabama",
                      choices = unique(req(df()$location)))
  })
  
  output$metricTS <- renderPlotly({
    
    switch (input$metric,
      'people_vaccinated' = {df <- df() %>% 
        filter(between(date, input$dates[1], input$dates[2])) %>% 
        select(date, location, metric = people_vaccinated) %>% 
        as_tsibble(key = location)
      metric.name <- "Total Number Vaccinated"
      },
      
      "people_fully_vaccinated" = {df <- df() %>% 
        filter(between(date, input$dates[1], input$dates[2])) %>% 
        select(date, location, metric = people_fully_vaccinated) %>% 
        as_tsibble(key = location)
      metric.name <- "Total Number Fully Vaccinated"
      },
    
      "daily_vaccinations" = {df <- df() %>% 
        filter(between(date, input$dates[1], input$dates[2])) %>% 
        select(date, location, metric = daily_vaccinations) %>% 
        as_tsibble(key = location)
      metric.name <- "Daily Vaccinations"
      },
  
      "total_distributed" = {df <- df() %>% 
        filter(between(date, input$dates[1], input$dates[2])) %>% 
        select(date, location, metric = total_distributed) %>% 
        as_tsibble(key = location)
      metric.name <- "Vaccines Recieved"
      },

      'ratio' = {df <- df() %>% 
        filter(between(date, input$dates[1], input$dates[2])) %>% 
        mutate(ratio = total_vaccinations/total_distributed) %>% 
        select(date, location, metric = ratio) %>% 
        as_tsibble(key = location)
      metric.name <- "Proportion of Vaccines Used to Recieved"
      },
      
      'fpratio' = {df <- df() %>% 
        filter(between(date, input$dates[1], input$dates[2])) %>% 
        mutate(ratio = people_fully_vaccinated/people_vaccinated) %>% 
        select(date, location, metric = ratio) %>% 
        as_tsibble(key = location)
      metric.name <- "Full/Partial Vaccination Ratio"
      }
    )
    
    
    if (length(input$state)==1){
      plotdf <- df %>% filter(location == input$state) %>%  
        select(-location) %>% 
        fill_gaps() %>% 
        tidyr::fill(metric, .direction = "down")
      
      if(input$metric != "daily_vaccinations") {
        plotDf7day <- plotdf %>%  
          mutate(use7DayAvg = slide_index_dbl(.x = metric,
                                              .i = date,
                                              .f = mean,
                                              .before = 6))
      } else {
        plotDf7day <- plotdf %>%  
          mutate(use7DayAvg = metric)
      }
      
    p <- plot_ly(data = plotDf7day,
                 type = "scatter",
                 mode = "lines",
                 y = ~metric,
                 x = ~date,
                 name = input$state)  %>% 
      layout(title=paste("Time series of", metric.name),
             xaxis=list(title="Date"),
             yaxis=list(title=metric.name)) %>% 
      config(displayModeBar = FALSE)
    
    return(p)
    
    } else {
      
      basedf <- df %>% filter(location == input$state[1]) %>%  
        select(-location) %>% 
        fill_gaps() %>% 
        tidyr::fill(metric, .direction = "down")
      
      baseDf7day <- basedf %>%  
        mutate(SevenDayAvg = slide_index_dbl(.x = metric,
                                            .i = date,
                                            .f = mean,
                                            .before = 6))
      
      p <- plot_ly(data = baseDf7day,
                   type = "scatter",
                   mode = "lines",
                   y = ~SevenDayAvg,
                   x = ~date,
                   name = input$state[1]) %>% 
        layout(title=paste("Time series of", metric.name),
               xaxis=list(title="Date"),
               yaxis=list(title=metric.name)) %>% 
        config(displayModeBar = FALSE)
      
      for (state in input$state[-1]) {
        
        plotdf <- df %>% filter(location == state) %>%  
          select(-location) %>% 
          fill_gaps() %>% 
          tidyr::fill(metric, .direction = "down")
        
        
        plotDf7day <- plotdf %>%  
          mutate(SevenDayAvg = slide_index_dbl(.x = metric,
                                              .i = date,
                                              .f = mean,
                                              .before = 6))
        
        p <- p %>% add_trace(data = plotDf7day,
                             y = ~SevenDayAvg,
                             x = ~date,
                             name = state)
        
      }
      
      return(p)
      
    }
    
  })
  
  
  output$totals <- renderTable({
    
    
    switch (input$metric,
      'people_vaccinated' = {
        
        totalsByState <- 
          df() %>% 
          as_tibble() %>%  
          dplyr::group_by(location) %>% 
          select(location, people_vaccinated) %>% 
          dplyr::summarise(total=max(people_vaccinated, na.rm = TRUE))
        
        initdf <- totalsByState %>% filter(location==input$state[1])
        
        tabledf = tibble::tibble(State = initdf$location[1], 
                               "Current Total"=format(initdf$total[1], big.mark=','))
        
        for (state in input$state[-1]){
          
          addDf <- totalsByState %>% filter(location==state)
          
          tabledf <- tabledf %>% dplyr::add_row(State=state,
                                                "Current Total"= format(addDf$total[1], big.mark=','))
          
        }
        
        return(tabledf)
        
      },
      'people_fully_vaccinated' = {
        
        totalsByState <- 
          df() %>% 
          as_tibble() %>%  
          dplyr::group_by(location) %>% 
          select(location, people_fully_vaccinated) %>% 
          dplyr::summarise(total=max(people_fully_vaccinated, na.rm = TRUE))
        
        initdf <- totalsByState %>% filter(location==input$state[1])
        
        tabledf = tibble::tibble(State = initdf$location[1], 
                                 "Current Total"=format(initdf$total[1], big.mark=','))
        
        for (state in input$state[-1]){
          
          addDf <- totalsByState %>% filter(location==state)
          
          tabledf <- tabledf %>% dplyr::add_row(State=state,
                                                "Current Total"= format(addDf$total[1], big.mark=','))
          
        }
        
        return(tabledf)
        
      }, 
      'daily_vaccinations' = {
        
        avgByState <- 
          df() %>% 
          as_tibble() %>%  
          dplyr::group_by(location) %>% 
          select(location, daily_vaccinations) %>% 
          dplyr::summarise(avg=mean(daily_vaccinations, na.rm = TRUE))
        
        initdf <- avgByState %>% filter(location==input$state[1])
        
        tabledf = tibble::tibble(State = initdf$location[1], 
                                 "Average"=format(initdf$avg[1], big.mark=','))
        
        for (state in input$state[-1]){
          
          addDf <- avgByState %>% filter(location==state)
          
          tabledf <- tabledf %>% dplyr::add_row(State=state,
                                                "Average"= format(addDf$avg[1], big.mark=','))
          
        }
        
        return(tabledf)
        
      }, 
      'total_distributed' = {
        
        totalsByState <- 
          df() %>% 
          as_tibble() %>%  
          dplyr::group_by(location) %>% 
          select(location, total_distributed) %>% 
          dplyr::summarise(total=max(total_distributed, na.rm = TRUE))
        
        initdf <- totalsByState %>% filter(location==input$state[1])
        
        tabledf = tibble::tibble(State = initdf$location[1], 
                                 "Current Total"=format(initdf$total[1], big.mark=','))
        
        for (state in input$state[-1]){
          
          addDf <- totalsByState %>% filter(location==state)
          
          tabledf <- tabledf %>% dplyr::add_row(State=state,
                                                "Current Total"= format(addDf$total[1], big.mark=','))
          
        }
        
        return(tabledf)
        
      }, 
      'ratio' = {
        
        
        avgByState <- 
          df() %>% 
          as_tibble() %>%  
          dplyr::group_by(location) %>% 
          select(location, total_vaccinations, total_distributed) %>% 
          dplyr::mutate(ratio = total_vaccinations/total_distributed) %>% 
          dplyr::summarise(avg = mean(ratio, na.rm=TRUE))
        
        initdf <- avgByState %>% filter(location==input$state[1])
        
        tabledf = tibble::tibble(State = initdf$location[1], 
                                 "Average"= paste0(round(initdf$avg[1],3)*100,"%"))
        
        for (state in input$state[-1]){
          
          addDf <- avgByState %>% filter(location==state)
          
          tabledf <- tabledf %>% dplyr::add_row(State=state,
                                                "Average"= paste0(round(addDf$avg[1],3)*100, '%'))
          
        }
        
        return(tabledf)
        
      }, 
      'fpratio' = {
        
        
        avgByState <- 
          df() %>% 
          as_tibble() %>%  
          dplyr::group_by(location) %>% 
          select(location, people_vaccinated, people_fully_vaccinated) %>% 
          dplyr::mutate(ratio = people_fully_vaccinated/people_vaccinated) %>% 
          dplyr::summarise(avg = mean(ratio, na.rm=TRUE))
        
        initdf <- avgByState %>% filter(location==input$state[1])
        
        tabledf = tibble::tibble(State = initdf$location[1], 
                                 "Average"= paste0(round(initdf$avg[1],3)*100,"%"))
        
        for (state in input$state[-1]){
          
          addDf <- avgByState %>% filter(location==state)
          
          tabledf <- tabledf %>% dplyr::add_row(State=state,
                                                "Average"= paste0(round(addDf$avg[1],3)*100, '%'))
          
        }
        
        return(tabledf)
        
      }
    )
    
  })
  
  
  
  
  output$info <- renderText({
    switch (input$metric,
            'people_vaccinated' = "This is the total number of people who received at least one vaccine dose averaged over a rolling 7-day window. If a person receives the first dose of a 2-dose vaccine, this metric goes up by 1. If they receive the second dose, the metric stays the same.",
            "people_fully_vaccinated" = "This is the total number of people who received all doses prescribed by the vaccination protocol averaged over a rolling 7-day window. If a person receives the first dose of a 2-dose vaccine, this metric stays the same. If they receive the second dose, the metric goes up by 1.",
            "daily_vaccinations" = "New doses administered per day averaged over a rolling 7-day window.",
            "total_distributed" = "Cumulative counts of COVID-19 vaccine doses recorded as shipped in CDC's Vaccine Tracking System averaged over a rolling 7-day window.",
            "ratio" = "This is the proportion of state's total number of vaccinations versus the total vaccines distributed to the state averaged over a rolling 7-day window.",
            "fpratio" = "This is the proportion of individuals that received a full dosage of the vaccine versus those who only recieved a partial dose averaged over a rolling 7-day window")
  })
  
  output$total.vax <- renderValueBox({
    
    totalsByState <- 
      df() %>% 
      as_tibble() %>%  
      dplyr::group_by(location) %>% 
      select(location, people_vaccinated) %>% 
      dplyr::summarise(total=max(people_vaccinated, na.rm = TRUE))
    
    
    
    totalVax <- sum(totalsByState$total)
        
    valueBox(value = format(totalVax, big.mark=","),
             subtitle = HTML(paste0("Total People Vaccinated as of<br>",
                                    format(Sys.Date(), '%B %d %Y'),
                                    "<br>in the United States"
             )),
             icon = icon("syringe"),
             color = "orange",
             width = 6)
        
  })
  
})

